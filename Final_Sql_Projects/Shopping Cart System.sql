CREATE DATABASE shopping_cart_db;
USE shopping_cart_db;


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
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255)
);

CREATE TABLE carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Cart Items table with composite primary key
CREATE TABLE cart_items (
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO users (name, email) VALUES ('Alice', 'alice@example.com');
INSERT INTO users (name, email) VALUES ('Bob', 'bob@example.com');

INSERT INTO products (name, description, price, stock, image_url) VALUES
('Laptop', 'High performance laptop', 1200.00, 10, 'https://example.com/laptop.jpg'),
('Headphones', 'Noise cancelling headphones', 250.00, 50, 'https://example.com/headphones.jpg'),
('Smartwatch', 'Smartwatch with fitness tracking', 199.99, 30, 'https://example.com/smartwatch.jpg');


INSERT INTO carts (user_id) VALUES (1), (2);

-- Add items to cart: Alice adds 1 Laptop, 2 Headphones
INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 2, 2);

INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(2, 3, 1);

--  Retrieve full cart details for Alice
SELECT 
    ci.cart_id,
    p.name AS product_name,
    p.price,
    ci.quantity,
    (p.price * ci.quantity) AS item_total
FROM 
    cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.cart_id = 1;

-- Calculate total cart value for Alice
SELECT 
    SUM(p.price * ci.quantity) AS total_cart_value
FROM 
    cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.cart_id = 1;

-- Update quantity of an item (e.g., Alice wants 3 Headphones)
UPDATE cart_items
SET quantity = 3
WHERE cart_id = 1 AND product_id = 2;

-- Remove an item from cart (e.g., Alice removes the Laptop)
DELETE FROM cart_items
WHERE cart_id = 1 AND product_id = 1;

-- view all tables
SHOW TABLES;

-- Check structure
DESCRIBE users;
DESCRIBE products;
DESCRIBE carts;
DESCRIBE cart_items;
