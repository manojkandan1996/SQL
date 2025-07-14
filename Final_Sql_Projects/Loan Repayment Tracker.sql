CREATE DATABASE loandb_db;
USE loandb_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE loans (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  principal DECIMAL(12,2) NOT NULL,
  interest_rate DECIMAL(5,2) NOT NULL, -- in percent
  term_months INT NOT NULL, -- optional
  start_date DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE payments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  loan_id INT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  paid_on DATE NOT NULL,
  FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO loans (user_id, principal, interest_rate, term_months, start_date) VALUES
(1, 10000.00, 5.0, 12, '2025-07-01'),
(2, 15000.00, 6.5, 24, '2025-07-01'),
(3, 20000.00, 7.0, 18, '2025-07-01');

INSERT INTO payments (loan_id, amount, paid_on) VALUES
(1, 1000.00, '2025-07-10'),
(1, 1000.00, '2025-08-10'),
(2, 750.00, '2025-07-15'),
(2, 750.00, '2025-08-15'),
(2, 750.00, '2025-09-15'),
(3, 1500.00, '2025-07-20');

--  Calculate total due (simple interest) vs total paid
SELECT 
  u.name AS borrower,
  l.id AS loan_id,
  l.principal,
  l.interest_rate,
  (l.principal * (1 + (l.interest_rate/100))) AS total_due_simple, -- Simple interest for illustration
  IFNULL(SUM(p.amount),0) AS total_paid,
  (l.principal * (1 + (l.interest_rate/100))) - IFNULL(SUM(p.amount),0) AS balance_remaining
FROM 
  loans l
JOIN users u ON l.user_id = u.id
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;

--  Due date logic: Next due date for each loan
SELECT 
  l.id AS loan_id,
  u.name AS borrower,
  l.start_date,
  l.term_months,
  DATE_ADD(l.start_date, INTERVAL COUNT(p.id) MONTH) AS next_due_date,
  l.term_months - COUNT(p.id) AS payments_remaining
FROM 
  loans l
JOIN users u ON l.user_id = u.id
LEFT JOIN payments p ON l.id = p.loan_id
GROUP BY l.id;

-- Full payment history
SELECT 
  u.name AS borrower,
  l.id AS loan_id,
  p.amount,
  p.paid_on
FROM 
  payments p
JOIN loans l ON p.loan_id = l.id
JOIN users u ON l.user_id = u.id
ORDER BY l.id, p.paid_on;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE loans;
DESCRIBE payments;
