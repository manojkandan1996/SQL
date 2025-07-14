CREATE DATABASE subscription_tracker_db;
USE subscription_tracker_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE subscriptions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    plan_name VARCHAR(100),
    start_date DATE,
    renewal_cycle VARCHAR(20), -- e.g., 'Monthly', 'Yearly'
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve'),
('Frank'),
('Grace'),
('Hannah'),
('Ivy'),
('Jack');

INSERT INTO subscriptions (user_id, plan_name, start_date, renewal_cycle) VALUES
(1, 'Basic Plan', '2025-06-01', 'Monthly'),
(1, 'Premium Plan', '2025-01-01', 'Yearly'),
(2, 'Basic Plan', '2025-07-01', 'Monthly'),
(2, 'Pro Plan', '2024-08-15', 'Yearly'),
(3, 'Premium Plan', '2025-06-15', 'Monthly'),
(3, 'Basic Plan', '2024-05-01', 'Yearly'),
(4, 'Pro Plan', '2025-06-20', 'Monthly'),
(4, 'Basic Plan', '2023-07-01', 'Yearly'),
(5, 'Basic Plan', '2025-07-05', 'Monthly'),
(5, 'Pro Plan', '2025-02-10', 'Yearly'),
(6, 'Basic Plan', '2025-07-07', 'Monthly'),
(7, 'Pro Plan', '2025-06-28', 'Monthly'),
(8, 'Premium Plan', '2025-07-01', 'Monthly'),
(9, 'Basic Plan', '2025-06-15', 'Monthly'),
(10, 'Pro Plan', '2024-12-01', 'Yearly'),
(1, 'Pro Plan', '2024-10-10', 'Yearly'),
(2, 'Basic Plan', '2025-05-05', 'Monthly'),
(3, 'Premium Plan', '2025-04-04', 'Monthly'),
(4, 'Basic Plan', '2024-07-07', 'Yearly'),
(5, 'Premium Plan', '2025-06-30', 'Monthly'),
(6, 'Pro Plan', '2024-07-01', 'Yearly'),
(7, 'Basic Plan', '2025-07-12', 'Monthly');

--  Calculate next renewal date for each subscription
SELECT 
    s.id AS subscription_id,
    u.name AS user_name,
    s.plan_name,
    s.start_date,
    s.renewal_cycle,
    CASE 
        WHEN s.renewal_cycle = 'Monthly' THEN DATE_ADD(s.start_date, INTERVAL TIMESTAMPDIFF(MONTH, s.start_date, CURDATE()) + 1 MONTH)
        WHEN s.renewal_cycle = 'Yearly' THEN DATE_ADD(s.start_date, INTERVAL TIMESTAMPDIFF(YEAR, s.start_date, CURDATE()) + 1 YEAR)
        ELSE NULL
    END AS next_renewal_date
FROM 
    subscriptions s
JOIN 
    users u ON s.user_id = u.id
ORDER BY 
    next_renewal_date;

--  Find expired subscriptions (next renewal date in the past)
SELECT 
    s.id AS subscription_id,
    u.name AS user_name,
    s.plan_name,
    s.start_date,
    s.renewal_cycle,
    CASE 
        WHEN s.renewal_cycle = 'Monthly' THEN DATE_ADD(s.start_date, INTERVAL TIMESTAMPDIFF(MONTH, s.start_date, CURDATE()) MONTH)
        WHEN s.renewal_cycle = 'Yearly' THEN DATE_ADD(s.start_date, INTERVAL TIMESTAMPDIFF(YEAR, s.start_date, CURDATE()) YEAR)
        ELSE NULL
    END AS last_renewal_date
FROM 
    subscriptions s
JOIN 
    users u ON s.user_id = u.id
WHERE 
    (
        (s.renewal_cycle = 'Monthly' AND DATE_ADD(s.start_date, INTERVAL TIMESTAMPDIFF(MONTH, s.start_date, CURDATE()) MONTH) < CURDATE()) OR
        (s.renewal_cycle = 'Yearly' AND DATE_ADD(s.start_date, INTERVAL TIMESTAMPDIFF(YEAR, s.start_date, CURDATE()) YEAR) < CURDATE())
    )
ORDER BY 
    last_renewal_date;

--  Count active subscriptions per plan
SELECT 
    plan_name,
    COUNT(*) AS total_subscriptions
FROM 
    subscriptions
GROUP BY 
    plan_name
ORDER BY 
    total_subscriptions DESC;

-- Show all subscriptions for a user (example: Alice)
SELECT 
    s.id AS subscription_id,
    u.name AS user_name,
    s.plan_name,
    s.start_date,
    s.renewal_cycle
FROM 
    subscriptions s
JOIN 
    users u ON s.user_id = u.id
WHERE 
    u.name = 'Alice'
ORDER BY 
    s.start_date;

