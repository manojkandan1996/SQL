CREATE DATABASE wishlist_db;
USE wishlist_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE wishlist (
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  added_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, product_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO products (name) VALUES
('Smartphone'),
('Laptop'),
('Headphones'),
('Camera');

INSERT INTO wishlist (user_id, product_id) VALUES
(1, 1),  
(1, 2),  
(2, 2),  
(2, 3),  
(3, 1),  
(3, 4);  

--  Get each user's wishlist
SELECT 
  u.name AS user_name,
  p.name AS product_name,
  w.added_at
FROM 
  wishlist w
JOIN users u ON w.user_id = u.id
JOIN products p ON w.product_id = p.id
ORDER BY u.name, w.added_at;

--  Query: Find most wishlisted products
SELECT 
  p.name AS product_name,
  COUNT(w.user_id) AS wishlist_count
FROM 
  wishlist w
JOIN products p ON w.product_id = p.id
GROUP BY w.product_id
ORDER BY wishlist_count DESC;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE products;
DESCRIBE wishlist;
