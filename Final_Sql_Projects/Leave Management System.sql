CREATE DATABASE leave_management_db;
USE leave_management_db;

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE leave_types (
  id INT AUTO_INCREMENT PRIMARY KEY,
  type_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE leave_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  emp_id INT NOT NULL,
  leave_type_id INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
  FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE,
  FOREIGN KEY (leave_type_id) REFERENCES leave_types(id) ON DELETE CASCADE,
  CHECK (from_date <= to_date)
);

INSERT INTO employees (name) VALUES
('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve'),
('Frank'), ('Grace'), ('Henry'), ('Ivy'), ('Jack'),
('Karen'), ('Leo');

INSERT INTO leave_types (type_name) VALUES
('Sick Leave'), ('Annual Leave'), ('Casual Leave'), ('Maternity Leave');

INSERT INTO leave_requests (emp_id, leave_type_id, from_date, to_date, status) VALUES
(1, 1, '2025-07-01', '2025-07-02', 'Approved'),
(1, 2, '2025-08-10', '2025-08-12', 'Pending'),
(2, 2, '2025-07-15', '2025-07-17', 'Approved'),
(2, 3, '2025-08-01', '2025-08-03', 'Approved'),
(3, 1, '2025-07-05', '2025-07-06', 'Pending'),
(3, 2, '2025-09-01', '2025-09-05', 'Approved'),
(4, 2, '2025-07-20', '2025-07-22', 'Rejected'),
(4, 1, '2025-08-15', '2025-08-16', 'Approved'),
(5, 1, '2025-07-08', '2025-07-09', 'Approved'),
(5, 3, '2025-07-25', '2025-07-27', 'Pending'),
(6, 2, '2025-07-01', '2025-07-04', 'Approved'),
(6, 3, '2025-08-05', '2025-08-06', 'Approved'),
(7, 1, '2025-07-12', '2025-07-13', 'Pending'),
(7, 2, '2025-09-10', '2025-09-12', 'Approved'),
(8, 2, '2025-07-20', '2025-07-21', 'Approved'),
(8, 3, '2025-08-15', '2025-08-17', 'Pending'),
(9, 1, '2025-07-01', '2025-07-02', 'Approved'),
(9, 3, '2025-07-10', '2025-07-12', 'Approved'),
(10, 2, '2025-08-01', '2025-08-03', 'Approved'),
(10, 1, '2025-07-14', '2025-07-16', 'Approved'),
(11, 2, '2025-07-18', '2025-07-19', 'Pending'),
(12, 1, '2025-07-22', '2025-07-23', 'Approved');

--  Example: Prevent overlapping leave requests for the same employee (BEFORE INSERT TRIGGER)
DELIMITER $$

CREATE TRIGGER check_overlapping_leaves
BEFORE INSERT ON leave_requests
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM leave_requests
    WHERE emp_id = NEW.emp_id
      AND status IN ('Pending', 'Approved')
      AND (
        (NEW.from_date BETWEEN from_date AND to_date)
        OR
        (NEW.to_date BETWEEN from_date AND to_date)
        OR
        (from_date BETWEEN NEW.from_date AND NEW.to_date)
      )
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Overlapping leave request detected for this employee!';
  END IF;
END$$

DELIMITER ;

--  Aggregate leaves taken by employee
SELECT 
  e.name AS employee_name,
  lt.type_name,
  COUNT(lr.id) AS total_requests,
  SUM(DATEDIFF(lr.to_date, lr.from_date) + 1) AS total_days
FROM 
  leave_requests lr
JOIN employees e ON lr.emp_id = e.id
JOIN leave_types lt ON lr.leave_type_id = lt.id
WHERE lr.status = 'Approved'
GROUP BY e.id, lt.id
ORDER BY employee_name, lt.type_name;

-- Get all leave requests for an employee with status
SELECT 
  e.name AS employee_name,
  lt.type_name,
  lr.from_date,
  lr.to_date,
  lr.status
FROM 
  leave_requests lr
JOIN employees e ON lr.emp_id = e.id
JOIN leave_types lt ON lr.leave_type_id = lt.id
WHERE e.id = 1
ORDER BY lr.from_date;

-- Verify structure
SHOW TABLES;
DESCRIBE employees;
DESCRIBE leave_types;
DESCRIBE leave_requests;
