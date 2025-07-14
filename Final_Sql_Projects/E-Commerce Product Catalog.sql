CREATE DATABASE ecommerce_catalog;
USE ecommerce_catalog;

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE brands (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255),
    category_id INT,
    brand_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Add indexes for performance
CREATE INDEX idx_products_category ON products (category_id);
CREATE INDEX idx_products_brand ON products (brand_id);
CREATE INDEX idx_products_price ON products (price);

INSERT INTO categories (name) VALUES ('Electronics'), ('Apparel'), ('Home Appliances');
INSERT INTO brands (name) VALUES ('Apple'), ('Nike'), ('Samsung');

INSERT INTO products (name, description, price, stock, image_url, category_id, brand_id) VALUES
('iPhone 14', 'Latest iPhone model', 999.99, 50, 'https://example.com/iphone14.jpg', 1, 1),
('Nike Running Shoes', 'Comfortable running shoes', 120.00, 100, 'https://example.com/nike_shoes.jpg', 2, 2),
('Samsung TV', '55-inch 4K UHD TV', 599.99, 20, 'https://example.com/samsung_tv.jpg', 1, 3);

-- List all products in a given category (e.g., Electronics)
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electronics';

-- List all products for a given brand (e.g., Nike)
SELECT p.*
FROM products p
JOIN brands b ON p.brand_id = b.id
WHERE b.name = 'Nike';

-- Filter products by price range (e.g., $100 to $600)
SELECT *
FROM products
WHERE price BETWEEN 100 AND 600;

-- Filter products by category and brand
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
JOIN brands b ON p.brand_id = b.id
WHERE c.name = 'Electronics' AND b.name = 'Samsung';

-- Show all products with low stock (e.g., stock < 30)
SELECT *
FROM products
WHERE stock < 30;

-- Verify the structure
SHOW TABLES;
DESCRIBE categories;
DESCRIBE brands;
DESCRIBE products;
