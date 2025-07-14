CREATE DATABASE it_support_db;
USE it_support_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE support_staff (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE tickets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    issue VARCHAR(255) NOT NULL,
    status VARCHAR(50),
    created_at DATETIME,
    resolved_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE assignments (
    ticket_id INT,
    staff_id INT,
    PRIMARY KEY (ticket_id, staff_id),
    FOREIGN KEY (ticket_id) REFERENCES tickets(id),
    FOREIGN KEY (staff_id) REFERENCES support_staff(id)
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve');

INSERT INTO support_staff (name) VALUES
('John'),
('Mary'),
('Steve');

INSERT INTO tickets (user_id, issue, status, created_at, resolved_at) VALUES
(1, 'Email not working', 'Resolved', '2025-07-01 09:00:00', '2025-07-01 12:00:00'),
(2, 'Printer jam', 'Resolved', '2025-07-01 10:00:00', '2025-07-01 11:30:00'),
(3, 'Forgot password', 'Resolved', '2025-07-01 11:00:00', '2025-07-01 11:15:00'),
(4, 'Slow computer', 'In Progress', '2025-07-02 09:30:00', NULL),
(5, 'Software installation', 'Resolved', '2025-07-02 10:00:00', '2025-07-02 13:00:00'),
(1, 'VPN not connecting', 'Resolved', '2025-07-02 11:00:00', '2025-07-02 12:30:00'),
(2, 'Email not syncing', 'Resolved', '2025-07-03 09:00:00', '2025-07-03 11:00:00'),
(3, 'Monitor flickering', 'In Progress', '2025-07-03 10:00:00', NULL),
(4, 'Cannot access shared drive', 'Resolved', '2025-07-03 10:30:00', '2025-07-03 12:00:00'),
(5, 'Antivirus expired', 'Resolved', '2025-07-04 08:45:00', '2025-07-04 09:30:00'),
(1, 'New user setup', 'Resolved', '2025-07-04 09:15:00', '2025-07-04 10:45:00'),
(2, 'Printer toner replacement', 'Resolved', '2025-07-04 10:00:00', '2025-07-04 10:20:00'),
(3, 'Phone not working', 'Resolved', '2025-07-05 09:00:00', '2025-07-05 11:30:00'),
(4, 'Network outage', 'Resolved', '2025-07-05 09:30:00', '2025-07-05 14:00:00'),
(5, 'Email migration', 'Open', '2025-07-05 10:00:00', NULL),
(1, 'Password reset', 'Resolved', '2025-07-06 09:00:00', '2025-07-06 09:05:00'),
(2, 'System upgrade', 'Resolved', '2025-07-06 10:00:00', '2025-07-06 12:30:00'),
(3, 'Keyboard replacement', 'Resolved', '2025-07-06 11:00:00', '2025-07-06 11:45:00'),
(4, 'Mouse not working', 'In Progress', '2025-07-07 09:00:00', NULL),
(5, 'Wi-Fi issue', 'Resolved', '2025-07-07 10:00:00', '2025-07-07 10:20:00'),
(1, 'Laptop battery issue', 'Open', '2025-07-07 11:00:00', NULL),
(2, 'Projector setup', 'Resolved', '2025-07-07 11:30:00', '2025-07-07 12:00:00');

INSERT INTO assignments (ticket_id, staff_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2),
(6, 1),
(7, 3),
(8, 2),
(9, 1),
(10, 3),
(11, 1),
(12, 2),
(13, 1),
(14, 3),
(15, 2),
(16, 1),
(17, 3),
(18, 1),
(19, 2),
(20, 3),
(21, 1),
(22, 2);

--  Average resolution time (in hours) for resolved tickets
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, created_at, resolved_at)) / 60, 2) AS avg_resolution_hours
FROM 
    tickets
WHERE 
    resolved_at IS NOT NULL;

--  Ticket volume by issue category
SELECT 
    issue,
    COUNT(*) AS ticket_count
FROM 
    tickets
GROUP BY 
    issue
ORDER BY 
    ticket_count DESC;

--  Average resolution time by support staff
SELECT 
    s.name AS support_staff,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, t.created_at, t.resolved_at)) / 60, 2) AS avg_resolution_hours
FROM 
    support_staff s
JOIN 
    assignments a ON s.id = a.staff_id
JOIN 
    tickets t ON a.ticket_id = t.id
WHERE 
    t.resolved_at IS NOT NULL
GROUP BY 
    s.name
ORDER BY 
    avg_resolution_hours;

--  Open tickets with assigned support staff
SELECT 
    t.id AS ticket_id,
    t.issue,
    t.status,
    u.name AS user_name,
    s.name AS assigned_staff
FROM 
    tickets t
JOIN 
    users u ON t.user_id = u.id
JOIN 
    assignments a ON t.id = a.ticket_id
JOIN 
    support_staff s ON a.staff_id = s.id
WHERE 
    t.status != 'Resolved'
ORDER BY 
    t.id;
