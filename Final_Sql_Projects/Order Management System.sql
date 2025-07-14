CREATE DATABASE order_management_db;
USE order_management_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL, -- Snapshot of price at order time
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Insert sample data
INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com'), ('Bob', 'bob@example.com');

INSERT INTO products (name, description, price, stock) VALUES
('Laptop', 'High performance laptop', 1200.00, 10),
('Headphones', 'Noise cancelling headphones', 250.00, 50),
('Smartwatch', 'Smartwatch with fitness tracking', 199.99, 30);

--  Place an order (use a transaction)
START TRANSACTION;

INSERT INTO orders (user_id, status) VALUES (1, 'Pending');
SET @order_id = LAST_INSERT_ID();

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(@order_id, 1, 1, 1200.00),
(@order_id, 2, 2, 250.00);

UPDATE products SET stock = stock - 1 WHERE id = 1;
UPDATE products SET stock = stock - 2 WHERE id = 2;

COMMIT;

--  Get order history for Alice
SELECT 
    o.id AS order_id,
    o.status,
    o.created_at,
    p.name AS product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS item_total
FROM 
    orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.user_id = 1
ORDER BY o.created_at DESC;

--  Get total order value per order for Alice
SELECT 
    o.id AS order_id,
    o.status,
    o.created_at,
    SUM(oi.quantity * oi.price) AS order_total
FROM 
    orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.user_id = 1
GROUP BY o.id, o.status, o.created_at
ORDER BY o.created_at DESC;

-- ️ Update an order status (e.g., mark as Shipped)
UPDATE orders
SET status = 'Shipped'
WHERE id = @order_id;

-- Check structures
SHOW TABLES;
DESCRIBE users;
DESCRIBE products;
DESCRIBE orders;
DESCRIBE order_items;
