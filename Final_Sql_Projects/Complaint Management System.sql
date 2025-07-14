CREATE DATABASE complaint_management_db;
USE complaint_management_db;

CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE complaints (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    department_id INT,
    status VARCHAR(50), -- e.g., Open, In Progress, Resolved, Closed
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

CREATE TABLE responses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    complaint_id INT,
    responder_id INT,  -- could link to a staff/users table
    message VARCHAR(500),
    FOREIGN KEY (complaint_id) REFERENCES complaints(id)
);

INSERT INTO departments (name) VALUES
('Public Works'),
('Health Department'),
('Education Department'),
('Transportation'),
('Sanitation');

INSERT INTO complaints (title, department_id, status) VALUES
('Pothole on Main St.', 1, 'Open'),
('Broken streetlight', 1, 'In Progress'),
('Overflowing garbage bin', 5, 'Resolved'),
('Uncollected trash', 5, 'Open'),
('Water leakage', 1, 'Closed'),
('Food safety issue at restaurant', 2, 'In Progress'),
('Health code violation', 2, 'Resolved'),
('School building repairs', 3, 'Open'),
('Bus route delay', 4, 'In Progress'),
('Traffic light malfunction', 4, 'Resolved'),
('Sidewalk repair needed', 1, 'Open'),
('Blocked drainage', 1, 'Resolved'),
('Unhygienic public restroom', 2, 'Closed'),
('Noisy construction at night', 1, 'Open'),
('Air pollution complaint', 2, 'Open'),
('School cleanliness issue', 3, 'In Progress'),
('Road signage missing', 4, 'Closed'),
('Pest control needed', 5, 'In Progress'),
('Illegal dumping', 5, 'Resolved'),
('School transport problem', 3, 'Open'),
('Traffic congestion', 4, 'In Progress'),
('Street flooding', 1, 'Open'),
('Noise complaint', 1, 'Open'),
('Improper waste disposal', 5, 'Resolved');

INSERT INTO responses (complaint_id, responder_id, message) VALUES
(1, 101, 'Scheduled for repair next week.'),
(2, 102, 'Technician assigned.'),
(3, 103, 'Issue resolved.'),
(6, 104, 'Inspection completed, further action required.'),
(8, 105, 'Maintenance request sent.'),
(10, 106, 'Fixed and monitored.'),
(12, 107, 'Drainage cleared.'),
(14, 108, 'Noise monitoring ongoing.'),
(16, 109, 'Cleaning team dispatched.'),
(18, 110, 'Pest control visit scheduled.'),
(20, 111, 'School notified about the issue.');

--  Complaint status summary
SELECT 
    status,
    COUNT(*) AS total_complaints
FROM 
    complaints
GROUP BY 
    status
ORDER BY 
    total_complaints DESC;

--  Department workload: number of complaints per department
SELECT 
    d.name AS department_name,
    COUNT(c.id) AS total_complaints
FROM 
    departments d
LEFT JOIN 
    complaints c ON d.id = c.department_id
GROUP BY 
    d.id, d.name
ORDER BY 
    total_complaints DESC;

--  All complaints with their responses
SELECT 
    c.id AS complaint_id,
    c.title,
    d.name AS department_name,
    c.status,
    r.message AS response_message
FROM 
    complaints c
JOIN 
    departments d ON c.department_id = d.id
LEFT JOIN 
    responses r ON c.id = r.complaint_id
ORDER BY 
    c.id;

--  Complaints with no responses yet
SELECT 
    c.id AS complaint_id,
    c.title,
    d.name AS department_name,
    c.status
FROM 
    complaints c
JOIN 
    departments d ON c.department_id = d.id
LEFT JOIN 
    responses r ON c.id = r.complaint_id
WHERE 
    r.id IS NULL
ORDER BY 
    c.id;

