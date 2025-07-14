CREATE DATABASE product_return_db;
USE product_return_db;

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT
);

CREATE TABLE returns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    reason VARCHAR(255),
    status VARCHAR(50), -- e.g., Pending, Approved, Rejected, Completed
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

INSERT INTO orders (user_id, product_id) VALUES
(1, 101),
(2, 102),
(3, 103),
(4, 104),
(5, 105),
(1, 106),
(2, 107),
(3, 108),
(4, 109),
(5, 110),
(1, 111),
(2, 112),
(3, 113),
(4, 114),
(5, 115),
(1, 116),
(2, 117),
(3, 118),
(4, 119),
(5, 120);

INSERT INTO returns (order_id, reason, status) VALUES
(1, 'Defective product', 'Approved'),
(3, 'Wrong item delivered', 'Pending'),
(5, 'Not as described', 'Rejected'),
(7, 'Product damaged', 'Approved'),
(9, 'Late delivery', 'Pending'),
(11, 'Changed mind', 'Rejected'),
(13, 'Defective product', 'Completed'),
(15, 'Wrong item delivered', 'Approved'),
(17, 'Not as described', 'Pending'),
(19, 'Product damaged', 'Completed');

-- JOIN orders with returns: show all orders and any return info
SELECT 
    o.id AS order_id,
    o.user_id,
    o.product_id,
    r.id AS return_id,
    r.reason,
    r.status
FROM 
    orders o
LEFT JOIN 
    returns r ON o.id = r.order_id
ORDER BY 
    o.id;

-- Show return requests by status
SELECT 
    status,
    COUNT(*) AS total_requests
FROM 
    returns
GROUP BY 
    status;

-- Show all orders with no returns
SELECT 
    o.id AS order_id,
    o.user_id,
    o.product_id
FROM 
    orders o
LEFT JOIN 
    returns r ON o.id = r.order_id
WHERE 
    r.id IS NULL;

-- Return requests with details
SELECT 
    o.id AS order_id,
    o.user_id,
    o.product_id,
    r.reason,
    r.status
FROM 
    orders o
JOIN 
    returns r ON o.id = r.order_id
ORDER BY 
    r.status;

