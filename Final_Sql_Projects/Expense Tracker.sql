CREATE DATABASE expense_tracker_db;
USE expense_tracker_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE expenses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  category_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO categories (name) VALUES
('Food'),
('Transport'),
('Entertainment'),
('Utilities'),
('Healthcare'),
('Education');

INSERT INTO expenses (user_id, category_id, amount, date) VALUES
(1, 1, 50.75, '2025-07-01'),
(1, 2, 15.00, '2025-07-02'),
(1, 1, 30.00, '2025-07-03'),
(1, 3, 100.00, '2025-07-05'),
(1, 4, 200.00, '2025-07-07'),
(2, 1, 60.00, '2025-07-01'),
(2, 2, 25.50, '2025-07-02'),
(2, 5, 75.00, '2025-07-04'),
(2, 6, 150.00, '2025-07-06'),
(3, 1, 40.00, '2025-07-01'),
(3, 3, 80.00, '2025-07-03'),
(3, 4, 120.00, '2025-07-05'),
(3, 5, 50.00, '2025-07-07'),
(3, 2, 35.00, '2025-07-08');

--  Aggregate: Total expenses by category for each user
SELECT 
  u.name AS user_name,
  c.name AS category_name,
  SUM(e.amount) AS total_spent
FROM 
  expenses e
JOIN users u ON e.user_id = u.id
JOIN categories c ON e.category_id = c.id
GROUP BY u.id, c.id
ORDER BY u.name, total_spent DESC;

--  Aggregate: Monthly expenses by user
SELECT 
  u.name AS user_name,
  DATE_FORMAT(e.date, '%Y-%m') AS month,
  SUM(e.amount) AS total_spent
FROM 
  expenses e
JOIN users u ON e.user_id = u.id
GROUP BY u.id, month
ORDER BY user_name, month;

-- Filter: Expenses within a specific amount range
SELECT 
  u.name AS user_name,
  c.name AS category_name,
  e.amount,
  e.date
FROM 
  expenses e
JOIN users u ON e.user_id = u.id
JOIN categories c ON e.category_id = c.id
WHERE e.amount BETWEEN 30 AND 100
ORDER BY e.amount DESC;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE categories;
DESCRIBE expenses;
