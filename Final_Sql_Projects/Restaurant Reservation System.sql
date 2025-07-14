CREATE DATABASE restaurant_reservation_db;
USE restaurant_reservation_db;

CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_number INT NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE guests (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE reservations (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    table_id INT,
    date DATE,
    time_slot VARCHAR(50), -- e.g., '18:00-20:00'
    FOREIGN KEY (guest_id) REFERENCES guests(id),
    FOREIGN KEY (table_id) REFERENCES tables(id)
);

INSERT INTO tables (table_number, capacity) VALUES
(1, 2),
(2, 2),
(3, 4),
(4, 4),
(5, 6);

INSERT INTO guests (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve');

INSERT INTO reservations (guest_id, table_id, date, time_slot) VALUES
(1, 1, '2025-07-13', '18:00-20:00'),
(2, 2, '2025-07-13', '18:00-20:00'),
(3, 3, '2025-07-13', '18:00-20:00'),
(4, 4, '2025-07-13', '18:00-20:00'),
(5, 5, '2025-07-13', '18:00-20:00'),
(1, 1, '2025-07-13', '20:00-22:00'),
(2, 2, '2025-07-13', '20:00-22:00'),
(3, 3, '2025-07-13', '20:00-22:00'),
(4, 4, '2025-07-13', '20:00-22:00'),
(5, 5, '2025-07-13', '20:00-22:00'),
(1, 1, '2025-07-14', '18:00-20:00'),
(2, 2, '2025-07-14', '18:00-20:00'),
(3, 3, '2025-07-14', '18:00-20:00'),
(4, 4, '2025-07-14', '18:00-20:00'),
(5, 5, '2025-07-14', '18:00-20:00'),
(1, 1, '2025-07-14', '20:00-22:00'),
(2, 2, '2025-07-14', '20:00-22:00'),
(3, 3, '2025-07-14', '20:00-22:00'),
(4, 4, '2025-07-14', '20:00-22:00'),
(5, 5, '2025-07-14', '20:00-22:00'),
(1, 1, '2025-07-15', '18:00-20:00'),
(2, 2, '2025-07-15', '18:00-20:00'),
(3, 3, '2025-07-15', '18:00-20:00'),
(4, 4, '2025-07-15', '18:00-20:00');

-- Detect overlapping reservations for a table
SELECT 
    r1.id AS reservation_id_1,
    r2.id AS reservation_id_2,
    t.table_number,
    r1.date,
    r1.time_slot AS slot_1,
    r2.time_slot AS slot_2
FROM 
    reservations r1
JOIN 
    reservations r2 ON r1.table_id = r2.table_id 
    AND r1.id < r2.id 
    AND r1.date = r2.date
    AND r1.time_slot = r2.time_slot  -- simple overlap detection for exact same slot
JOIN 
    tables t ON r1.table_id = t.id
WHERE 
    r1.table_id = 1 AND r1.date = '2025-07-13';

--  Daily summary: how many reservations per day
SELECT 
    date,
    COUNT(*) AS total_reservations
FROM 
    reservations
GROUP BY 
    date
ORDER BY 
    date;

-- Reservation details for a date
SELECT 
    g.name AS guest_name,
    t.table_number,
    t.capacity,
    r.date,
    r.time_slot
FROM 
    reservations r
JOIN 
    guests g ON r.guest_id = g.id
JOIN 
    tables t ON r.table_id = t.id
WHERE 
    r.date = '2025-07-13'
ORDER BY 
    r.time_slot, t.table_number;

