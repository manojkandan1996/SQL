CREATE DATABASE inventory_tracking_db;
USE inventory_tracking_db;


CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 5 -- Minimum desired stock level
);


CREATE TABLE suppliers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);


CREATE TABLE inventory_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    supplier_id INT,
    action ENUM('IN', 'OUT') NOT NULL,
    qty INT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(id) ON DELETE SET NULL
);

INSERT INTO products (name, stock, reorder_level) VALUES
('Laptop', 10, 5),
('Headphones', 25, 10),
('Smartwatch', 2, 5);

INSERT INTO suppliers (name) VALUES ('Tech Supplies Inc'), ('Gadget Wholesale Ltd');

--  Trigger: Automatically update stock on log insert
DELIMITER $$

CREATE TRIGGER trg_update_stock_after_log
AFTER INSERT ON inventory_logs
FOR EACH ROW
BEGIN
    IF NEW.action = 'IN' THEN
        UPDATE products SET stock = stock + NEW.qty WHERE id = NEW.product_id;
    ELSEIF NEW.action = 'OUT' THEN
        UPDATE products SET stock = stock - NEW.qty WHERE id = NEW.product_id;
    END IF;
END$$

DELIMITER ;

--  Log some inventory movements
-- Supplier delivers 20 more headphones
INSERT INTO inventory_logs (product_id, supplier_id, action, qty) VALUES (2, 1, 'IN', 20);

--  smartwatches sold
INSERT INTO inventory_logs (product_id, action, qty) VALUES (3, NULL, 'OUT', 5);

--  Query to get current stock status with reorder suggestion
SELECT 
    p.id,
    p.name,
    p.stock,
    p.reorder_level,
    CASE 
        WHEN p.stock < p.reorder_level THEN 'Reorder Needed'
        ELSE 'Stock OK'
    END AS status
FROM 
    products p;

--  View full inventory log with product and supplier info
SELECT 
    il.id,
    p.name AS product_name,
    s.name AS supplier_name,
    il.action,
    il.qty,
    il.timestamp
FROM 
    inventory_logs il
    JOIN products p ON il.product_id = p.id
    LEFT JOIN suppliers s ON il.supplier_id = s.id
ORDER BY il.timestamp DESC;

--  Verify
SHOW TABLES;
DESCRIBE products;
DESCRIBE suppliers;
DESCRIBE inventory_logs;
