CREATE DATABASE project_manage_db;
USE project_manage_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(200) NOT NULL
);

CREATE TABLE tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  project_id INT NOT NULL,
  name VARCHAR(200) NOT NULL,
  status ENUM('Pending', 'In Progress', 'Done') DEFAULT 'Pending',
  FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE
);

CREATE TABLE task_assignments (
  task_id INT NOT NULL,
  user_id INT NOT NULL,
  PRIMARY KEY (task_id, user_id),
  FOREIGN KEY (task_id) REFERENCES tasks(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve');

INSERT INTO projects (name) VALUES
('Website Redesign'),
('Mobile App Development'),
('Marketing Campaign'),
('Internal Tools Upgrade');

INSERT INTO tasks (project_id, name, status) VALUES
(1, 'Design homepage', 'Done'),
(1, 'Update logo', 'In Progress'),
(1, 'Test site on mobile', 'Pending'),
(1, 'Create contact form', 'Done'),
(1, 'Fix broken links', 'In Progress'),
(2, 'Develop login feature', 'In Progress'),
(2, 'Implement push notifications', 'Pending'),
(2, 'Integrate payment gateway', 'Pending'),
(2, 'Set up CI/CD pipeline', 'Done'),
(2, 'Write unit tests', 'In Progress'),
(3, 'Draft ad copy', 'Done'),
(3, 'Design social posts', 'In Progress'),
(3, 'Plan email campaign', 'Pending'),
(3, 'Schedule influencer posts', 'Pending'),
(3, 'Analyze engagement metrics', 'Done'),
(4, 'Upgrade database server', 'Pending'),
(4, 'Add monitoring tools', 'In Progress'),
(4, 'Refactor legacy code', 'In Progress'),
(4, 'Train team on new tools', 'Pending'),
(4, 'Document processes', 'Pending'),
(4, 'Run security audit', 'Pending');

INSERT INTO task_assignments (task_id, user_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 1), (7, 2), (8, 3), (9, 4), (10, 5),
(11, 1), (12, 2), (13, 3), (14, 4), (15, 5),
(16, 1), (17, 2), (18, 3), (19, 4), (20, 5), (21, 1);

-- Query: Tasks per project by status
SELECT 
  p.name AS project_name,
  t.status,
  COUNT(*) AS task_count
FROM 
  tasks t
JOIN projects p ON t.project_id = p.id
GROUP BY 
  p.name, t.status
ORDER BY 
  p.name, t.status;

--  Query: Show all tasks with assigned users
SELECT 
  t.id AS task_id,
  t.name AS task_name,
  t.status,
  p.name AS project_name,
  u.name AS assigned_user
FROM 
  tasks t
JOIN projects p ON t.project_id = p.id
JOIN task_assignments ta ON t.id = ta.task_id
JOIN users u ON ta.user_id = u.id
ORDER BY 
  p.name, t.name;

--  Query: Get all tasks for a specific user
SELECT 
  u.name AS user_name,
  p.name AS project_name,
  t.name AS task_name,
  t.status
FROM 
  task_assignments ta
JOIN tasks t ON ta.task_id = t.id
JOIN projects p ON t.project_id = p.id
JOIN users u ON ta.user_id = u.id
WHERE u.name = 'Alice'
ORDER BY p.name, t.name;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE projects;
DESCRIBE tasks;
DESCRIBE task_assignments;
