CREATE DATABASE salarydb_db;
USE salarydb_db;

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE salaries (
  id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT NOT NULL,
  month DATE NOT NULL,  -- Use first day of month for consistency
  base DECIMAL(12,2) NOT NULL,
  bonus DECIMAL(12,2) DEFAULT 0.00,
  FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE TABLE deductions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT NOT NULL,
  month DATE NOT NULL,
  reason VARCHAR(255),
  amount DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE
);

INSERT INTO employees (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO salaries (emp_id, month, base, bonus) VALUES
(1, '2025-07-01', 4000.00, 500.00),
(1, '2025-08-01', 4000.00, 0.00),
(2, '2025-07-01', 4500.00, 250.00),
(3, '2025-07-01', 5000.00, 0.00);

INSERT INTO deductions (emp_id, month, reason, amount) VALUES
(1, '2025-07-01', 'Late fee', 50.00),
(1, '2025-07-01', 'Tax', 300.00),
(2, '2025-07-01', 'Tax', 350.00),
(3, '2025-07-01', 'Tax', 400.00);

--  Calculate monthly net salary with deductions
SELECT
  e.name AS employee_name,
  s.month,
  s.base,
  s.bonus,
  IFNULL(SUM(d.amount), 0) AS total_deductions,
  (s.base + s.bonus - IFNULL(SUM(d.amount), 0)) AS net_salary
FROM 
  salaries s
JOIN employees e ON s.emp_id = e.id
LEFT JOIN deductions d 
  ON s.emp_id = d.emp_id AND s.month = d.month
GROUP BY 
  s.emp_id, s.month;

--  Example: Conditional bonus report (bonus only if base > 4000)
SELECT
  e.name AS employee_name,
  s.month,
  s.base,
  CASE 
    WHEN s.base > 4000 THEN 500.00
    ELSE 0.00
  END AS conditional_bonus
FROM 
  salaries s
JOIN employees e ON s.emp_id = e.id;

-- Check structure
SHOW TABLES;
DESCRIBE employees;
DESCRIBE salaries;
DESCRIBE deductions;
