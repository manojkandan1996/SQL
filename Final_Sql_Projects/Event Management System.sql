CREATE DATABASE event_management_db;
USE event_management_db;

CREATE TABLE events (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    max_capacity INT NOT NULL
);

CREATE TABLE attendees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    user_id INT,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id)
);
INSERT INTO events (title, max_capacity) VALUES
('Tech Conference 2025', 100),
('Music Festival', 200),
('Business Workshop', 50),
('Startup Pitch Night', 30),
('Art Exhibition', 75);

INSERT INTO attendees (event_id, user_id) VALUES
(1, 101), (1, 102), (1, 103), (1, 104), (1, 105),
(1, 106), (1, 107), (1, 108), (1, 109), (1, 110),
(2, 201), (2, 202), (2, 203), (2, 204), (2, 205),
(2, 206), (2, 207), (2, 208), (3, 301), (3, 302),
(3, 303), (4, 401), (4, 402), (5, 501), (5, 502);

-- Event-wise participant count
SELECT 
    e.title AS event_title,
    COUNT(a.id) AS participant_count
FROM 
    events e
LEFT JOIN 
    attendees a ON e.id = a.event_id
GROUP BY 
    e.id, e.title
ORDER BY 
    participant_count DESC;

-- Capacity alerts: events that are full or overbooked
SELECT 
    e.title AS event_title,
    e.max_capacity,
    COUNT(a.id) AS participant_count,
    CASE 
        WHEN COUNT(a.id) > e.max_capacity THEN 'Overbooked'
        WHEN COUNT(a.id) = e.max_capacity THEN 'Full'
        WHEN COUNT(a.id) >= e.max_capacity * 0.8 THEN 'Near Capacity'
        ELSE 'Available'
    END AS capacity_status
FROM 
    events e
LEFT JOIN 
    attendees a ON e.id = a.event_id
GROUP BY 
    e.id, e.title, e.max_capacity
ORDER BY 
    participant_count DESC;

-- Show attendees for a given event (e.g., 'Tech Conference 2025')
SELECT 
    e.title AS event_title,
    a.user_id,
    a.registered_at
FROM 
    attendees a
JOIN 
    events e ON a.event_id = e.id
WHERE 
    e.title = 'Tech Conference 2025'
ORDER BY 
    a.registered_at;

