CREATE DATABASE inventory_expiry_db;
USE inventory_expiry_db;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE batches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    quantity INT,
    expiry_date DATE,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO products (name) VALUES
('Milk'),
('Bread'),
('Cheese'),
('Yogurt'),
('Butter');

INSERT INTO batches (product_id, quantity, expiry_date) VALUES
(1, 100, '2025-07-10'),
(1, 50,  '2025-07-15'),
(1, 30,  '2025-07-20'),
(1, 20,  '2025-06-30'),
(1, 80,  '2025-07-05'),
(2, 60,  '2025-07-09'),
(2, 40,  '2025-07-11'),
(2, 50,  '2025-06-29'),
(2, 30,  '2025-07-14'),
(3, 25,  '2025-08-01'),
(3, 35,  '2025-07-07'),
(3, 45,  '2025-07-15'),
(3, 55,  '2025-06-28'),
(3, 20,  '2025-07-02'),
(4, 60,  '2025-07-08'),
(4, 70,  '2025-07-13'),
(4, 30,  '2025-06-27'),
(4, 40,  '2025-07-01'),
(4, 20,  '2025-07-05'),
(5, 50,  '2025-07-09'),
(5, 60,  '2025-07-12'),
(5, 35,  '2025-06-30'),
(5, 45,  '2025-07-03'),
(5, 25,  '2025-07-06');

--  Show expired stock as of today
SELECT 
    p.name AS product_name,
    b.id AS batch_id,
    b.quantity,
    b.expiry_date
FROM 
    batches b
JOIN 
    products p ON b.product_id = p.id
WHERE 
    b.expiry_date < CURDATE()
ORDER BY 
    b.expiry_date;

--  Show stock expiring within next 7 days
SELECT 
    p.name AS product_name,
    b.id AS batch_id,
    b.quantity,
    b.expiry_date
FROM 
    batches b
JOIN 
    products p ON b.product_id = p.id
WHERE 
    b.expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
ORDER BY 
    b.expiry_date;

--  Remaining stock per product (not expired)
SELECT 
    p.name AS product_name,
    SUM(b.quantity) AS total_available_quantity
FROM 
    products p
JOIN 
    batches b ON p.id = b.product_id
WHERE 
    b.expiry_date >= CURDATE()
GROUP BY 
    p.id, p.name
ORDER BY 
    total_available_quantity DESC;

--  Detailed view of all batches by product
SELECT 
    p.name AS product_name,
    b.id AS batch_id,
    b.quantity,
    b.expiry_date
FROM 
    batches b
JOIN 
    products p ON b.product_id = p.id
ORDER BY 
    p.name, b.expiry_date;

