CREATE DATABASE product_review_db;
USE product_review_db;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY uq_user_product (user_id, product_id) -- prevents duplicate reviews
);


INSERT INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie');

INSERT INTO products (name) VALUES ('Laptop'), ('Headphones'), ('Smartwatch');

INSERT INTO reviews (user_id, product_id, rating, review) VALUES
(1, 1, 5, 'Amazing laptop!'),
(2, 1, 4, 'Pretty good, but could be cheaper.'),
(1, 2, 3, 'Average headphones.'),
(3, 1, 5, 'Best laptop I have ever used.');

--  Try to insert a duplicate review by same user for same product (will fail!)
INSERT INTO reviews (user_id, product_id, rating, review) VALUES
 (1, 1, 4, 'Another review for same product by Alice');

--  Get average rating per product
SELECT 
    p.id,
    p.name,
    AVG(r.rating) AS avg_rating,
    COUNT(r.id) AS total_reviews
FROM 
    products p
LEFT JOIN reviews r ON p.id = r.product_id
GROUP BY 
    p.id, p.name;

--  Get top 2 highest-rated products (minimum 1 review)
SELECT 
    p.id,
    p.name,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.id) AS total_reviews
FROM 
    products p
JOIN reviews r ON p.id = r.product_id
GROUP BY 
    p.id, p.name
HAVING total_reviews >= 1
ORDER BY avg_rating DESC, total_reviews DESC
LIMIT 2;

-- Get all reviews for a product with user info
SELECT 
    r.id,
    u.name AS user_name,
    p.name AS product_name,
    r.rating,
    r.review,
    r.created_at
FROM 
    reviews r
JOIN users u ON r.user_id = u.id
JOIN products p ON r.product_id = p.id
WHERE p.id = 1; -- reviews for Laptop

-- Verify
SHOW TABLES;
DESCRIBE users;
DESCRIBE products;
DESCRIBE reviews;
