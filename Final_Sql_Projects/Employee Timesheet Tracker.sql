CREATE DATABASE timesheet_tracker_db;
USE timesheet_tracker_db;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dept VARCHAR(100) NOT NULL
);

CREATE TABLE projects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE timesheets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    project_id INT NOT NULL,
    hours DECIMAL(5,2) NOT NULL CHECK (hours >= 0),
    date DATE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

INSERT INTO employees (name, dept) VALUES 
('Alice', 'Engineering'),
('Bob', 'Marketing'),
('Charlie', 'Engineering');

INSERT INTO projects (name) VALUES 
('Website Redesign'),
('Mobile App Development'),
('Marketing Campaign');

INSERT INTO timesheets (emp_id, project_id, hours, date) VALUES
(1, 1, 8.0, '2025-07-01'),
(1, 2, 4.5, '2025-07-02'),
(2, 3, 7.0, '2025-07-01'),
(3, 1, 6.0, '2025-07-02'),
(1, 1, 8.0, '2025-07-03'),
(3, 2, 5.5, '2025-07-03');

--  Get total hours per employee per project
SELECT 
    e.name AS employee_name,
    p.name AS project_name,
    SUM(t.hours) AS total_hours
FROM 
    timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
GROUP BY 
    e.id, p.id
ORDER BY 
    employee_name, project_name;

--  Get weekly hours for each employee (last 7 days)
SELECT 
    e.name AS employee_name,
    SUM(t.hours) AS weekly_hours
FROM 
    timesheets t
JOIN employees e ON t.emp_id = e.id
WHERE t.date >= CURDATE() - INTERVAL 7 DAY
GROUP BY 
    e.id
ORDER BY 
    weekly_hours DESC;

--  Get total hours per project for a given month (e.g., July 2025)
SELECT 
    p.name AS project_name,
    SUM(t.hours) AS monthly_hours
FROM 
    timesheets t
JOIN projects p ON t.project_id = p.id
WHERE MONTH(t.date) = 7 AND YEAR(t.date) = 2025
GROUP BY 
    p.id
ORDER BY 
    monthly_hours DESC;

--  Get all timesheet entries with details
SELECT 
    t.id,
    e.name AS employee_name,
    e.dept,
    p.name AS project_name,
    t.hours,
    t.date
FROM 
    timesheets t
JOIN employees e ON t.emp_id = e.id
JOIN projects p ON t.project_id = p.id
ORDER BY 
    t.date DESC;

-- Check table structure
SHOW TABLES;
DESCRIBE employees;
DESCRIBE projects;
DESCRIBE timesheets;
