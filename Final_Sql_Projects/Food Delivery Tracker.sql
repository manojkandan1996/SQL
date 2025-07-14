CREATE DATABASE food_delivery_db;
USE food_delivery_db;

CREATE TABLE restaurants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    restaurant_id INT,
    user_id INT,
    placed_at DATETIME,
    delivered_at DATETIME,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

CREATE TABLE delivery_agents (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);
CREATE TABLE deliveries (
    order_id INT,
    agent_id INT,
    PRIMARY KEY (order_id, agent_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (agent_id) REFERENCES delivery_agents(id)
);

INSERT INTO restaurants (name) VALUES
('Pizza Palace'),
('Sushi Spot'),
('Burger Barn'),
('Taco Town'),
('Pasta Place');

INSERT INTO delivery_agents (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David');

INSERT INTO orders (restaurant_id, user_id, placed_at, delivered_at) VALUES
(1, 101, '2025-07-10 12:00:00', '2025-07-10 12:30:00'),
(2, 102, '2025-07-10 12:10:00', '2025-07-10 12:50:00'),
(3, 103, '2025-07-10 12:15:00', '2025-07-10 12:45:00'),
(4, 104, '2025-07-10 12:20:00', '2025-07-10 12:55:00'),
(5, 105, '2025-07-10 12:25:00', '2025-07-10 12:55:00'),
(1, 106, '2025-07-10 13:00:00', '2025-07-10 13:40:00'),
(2, 107, '2025-07-10 13:05:00', '2025-07-10 13:45:00'),
(3, 108, '2025-07-10 13:10:00', '2025-07-10 13:40:00'),
(4, 109, '2025-07-10 13:15:00', '2025-07-10 13:50:00'),
(5, 110, '2025-07-10 13:20:00', '2025-07-10 13:50:00'),
(1, 111, '2025-07-10 14:00:00', '2025-07-10 14:30:00'),
(2, 112, '2025-07-10 14:10:00', '2025-07-10 14:40:00'),
(3, 113, '2025-07-10 14:15:00', '2025-07-10 14:45:00'),
(4, 114, '2025-07-10 14:20:00', '2025-07-10 14:55:00'),
(5, 115, '2025-07-10 14:25:00', '2025-07-10 14:55:00'),
(1, 116, '2025-07-10 15:00:00', '2025-07-10 15:30:00'),
(2, 117, '2025-07-10 15:05:00', '2025-07-10 15:35:00'),
(3, 118, '2025-07-10 15:10:00', '2025-07-10 15:40:00'),
(4, 119, '2025-07-10 15:15:00', '2025-07-10 15:50:00'),
(5, 120, '2025-07-10 15:20:00', '2025-07-10 15:50:00'),
(1, 121, '2025-07-10 16:00:00', '2025-07-10 16:40:00'),
(2, 122, '2025-07-10 16:05:00', '2025-07-10 16:45:00');

INSERT INTO deliveries (order_id, agent_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 1),
(6, 2),
(7, 3),
(8, 4),
(9, 1),
(10, 2),
(11, 3),
(12, 4),
(13, 1),
(14, 2),
(15, 3),
(16, 4),
(17, 1),
(18, 2),
(19, 3),
(20, 4),
(21, 1),
(22, 2);

--  Average delivery time for all orders (in minutes)
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, placed_at, delivered_at)), 2) AS avg_delivery_time_mins
FROM 
    orders;

--  Average delivery time per restaurant
SELECT 
    r.name AS restaurant_name,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, o.placed_at, o.delivered_at)), 2) AS avg_delivery_time_mins
FROM 
    restaurants r
JOIN 
    orders o ON r.id = o.restaurant_id
GROUP BY 
    r.id, r.name
ORDER BY 
    avg_delivery_time_mins;

--  Deliveries per agent (workload)
SELECT 
    da.name AS agent_name,
    COUNT(*) AS total_deliveries
FROM 
    delivery_agents da
JOIN 
    deliveries d ON da.id = d.agent_id
GROUP BY 
    da.id, da.name
ORDER BY 
    total_deliveries DESC;

--  Orders with delivery agent and time taken
SELECT 
    o.id AS order_id,
    r.name AS restaurant_name,
    da.name AS agent_name,
    TIMESTAMPDIFF(MINUTE, o.placed_at, o.delivered_at) AS delivery_time_mins
FROM 
    orders o
JOIN 
    restaurants r ON o.restaurant_id = r.id
JOIN 
    deliveries d ON o.id = d.order_id
JOIN 
    delivery_agents da ON d.agent_id = da.id
ORDER BY 
    o.id;
