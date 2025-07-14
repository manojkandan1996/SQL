CREATE DATABASE  DBhotel_db;
USE DBhotel_db;

CREATE TABLE rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  number VARCHAR(10) NOT NULL UNIQUE,
  type ENUM('Single', 'Double', 'Suite') NOT NULL
);

CREATE TABLE guests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_id INT NOT NULL,
  guest_id INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
  FOREIGN KEY (guest_id) REFERENCES guests(id) ON DELETE CASCADE
);

INSERT INTO rooms (number, type) VALUES
('101', 'Single'),
('102', 'Single'),
('103', 'Double'),
('104', 'Double'),
('201', 'Suite'),
('202', 'Suite');

INSERT INTO guests (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve'),
('Frank'),
('Grace'),
('Heidi'),
('Ivan'),
('Judy');

INSERT INTO bookings (room_id, guest_id, from_date, to_date) VALUES
(1, 1, '2025-07-01', '2025-07-03'),
(1, 2, '2025-07-04', '2025-07-06'),
(1, 3, '2025-07-07', '2025-07-10'),
(1, 4, '2025-07-11', '2025-07-13'),
(2, 5, '2025-07-01', '2025-07-05'),
(2, 6, '2025-07-06', '2025-07-09'),
(2, 7, '2025-07-10', '2025-07-12'),
(2, 8, '2025-07-13', '2025-07-15'),
(3, 1, '2025-07-01', '2025-07-04'),
(3, 2, '2025-07-05', '2025-07-08'),
(3, 3, '2025-07-09', '2025-07-11'),
(3, 4, '2025-07-12', '2025-07-14'),
(4, 5, '2025-07-01', '2025-07-03'),
(4, 6, '2025-07-04', '2025-07-07'),
(4, 7, '2025-07-08', '2025-07-10'),
(4, 8, '2025-07-11', '2025-07-13'),
(5, 9, '2025-07-01', '2025-07-04'),
(5,10, '2025-07-05', '2025-07-08'),
(6, 1, '2025-07-01', '2025-07-03'),
(6, 2, '2025-07-04', '2025-07-06'),
(6, 3, '2025-07-07', '2025-07-10');

--  Query: Find available rooms for given date range ('2025-07-05' to '2025-07-07')
SELECT 
  r.id,
  r.number,
  r.type
FROM 
  rooms r
WHERE NOT EXISTS (
  SELECT 1 FROM bookings b
  WHERE 
    b.room_id = r.id
    AND NOT (
      b.to_date < '2025-07-05' OR b.from_date > '2025-07-07'
    )
);

--  Show all bookings with guest and room details
SELECT 
  b.id,
  g.name AS guest_name,
  r.number AS room_number,
  r.type AS room_type,
  b.from_date,
  b.to_date
FROM 
  bookings b
JOIN guests g ON b.guest_id = g.id
JOIN rooms r ON b.room_id = r.id
ORDER BY b.from_date;

-- Check structure
SHOW TABLES;
DESCRIBE rooms;
DESCRIBE guests;
DESCRIBE bookings;
