CREATE DATABASE qr_entry_log_db;
USE qr_entry_log_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE locations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE entry_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    location_id INT,
    entry_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (location_id) REFERENCES locations(id)
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve');

INSERT INTO locations (name) VALUES
('Main Office'),
('R&D Lab'),
('Server Room'),
('Warehouse'),
('Conference Hall');

INSERT INTO entry_logs (user_id, location_id, entry_time) VALUES
(1, 1, '2025-07-10 08:00:00'),
(2, 1, '2025-07-10 08:15:00'),
(3, 2, '2025-07-10 08:30:00'),
(4, 3, '2025-07-10 08:45:00'),
(5, 4, '2025-07-10 09:00:00'),
(1, 5, '2025-07-10 09:15:00'),
(2, 2, '2025-07-10 09:30:00'),
(3, 1, '2025-07-10 09:45:00'),
(4, 4, '2025-07-10 10:00:00'),
(5, 3, '2025-07-10 10:15:00'),
(1, 2, '2025-07-10 10:30:00'),
(2, 5, '2025-07-10 10:45:00'),
(3, 3, '2025-07-10 11:00:00'),
(4, 1, '2025-07-10 11:15:00'),
(5, 5, '2025-07-10 11:30:00'),
(1, 4, '2025-07-10 11:45:00'),
(2, 3, '2025-07-10 12:00:00'),
(3, 5, '2025-07-10 12:15:00'),
(4, 2, '2025-07-10 12:30:00'),
(5, 1, '2025-07-10 12:45:00'),
(1, 1, '2025-07-10 13:00:00'),
(2, 2, '2025-07-10 13:15:00'),
(3, 3, '2025-07-10 13:30:00'),
(4, 4, '2025-07-10 13:45:00');

-- Count entries per location
SELECT 
    l.name AS location_name,
    COUNT(*) AS total_entries
FROM 
    entry_logs el
JOIN 
    locations l ON el.location_id = l.id
GROUP BY 
    l.id, l.name
ORDER BY 
    total_entries DESC;

-- Show all entries for a specific date
SELECT 
    u.name AS user_name,
    l.name AS location_name,
    el.entry_time
FROM 
    entry_logs el
JOIN 
    users u ON el.user_id = u.id
JOIN 
    locations l ON el.location_id = l.id
WHERE 
    DATE(el.entry_time) = '2025-07-10'
ORDER BY 
    el.entry_time;

-- Filter logs between two times
SELECT 
    u.name AS user_name,
    l.name AS location_name,
    el.entry_time
FROM 
    entry_logs el
JOIN 
    users u ON el.user_id = u.id
JOIN 
    locations l ON el.location_id = l.id
WHERE 
    el.entry_time BETWEEN '2025-07-10 09:00:00' AND '2025-07-10 12:00:00'
ORDER BY 
    el.entry_time;

-- Count entries per user for a specific location
SELECT 
    u.name AS user_name,
    COUNT(*) AS entry_count
FROM 
    entry_logs el
JOIN 
    users u ON el.user_id = u.id
WHERE 
    el.location_id = 1  -- Main Office
GROUP BY 
    u.id, u.name
ORDER BY 
    entry_count DESC;
