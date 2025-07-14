CREATE DATABASE appointment_scheduler_db;
USE appointment_scheduler_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE services (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE appointments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  service_id INT NOT NULL,
  appointment_time DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES 
('Alice'), ('Bob'), ('Charlie'), ('David'), ('Eve');

INSERT INTO services (name) VALUES
('Haircut'), ('Dental Checkup'), ('Massage Therapy'), ('Consultation');


INSERT INTO appointments (user_id, service_id, appointment_time) VALUES
(1, 1, '2025-07-15 09:00:00'),
(2, 1, '2025-07-15 10:00:00'),
(3, 2, '2025-07-15 09:30:00'),
(4, 2, '2025-07-15 10:30:00'),
(5, 3, '2025-07-15 11:00:00'),
(1, 4, '2025-07-16 09:00:00'),
(2, 4, '2025-07-16 10:00:00'),
(3, 1, '2025-07-16 11:00:00'),
(4, 3, '2025-07-16 12:00:00'),
(5, 2, '2025-07-16 13:00:00'),
(1, 1, '2025-07-17 09:00:00'),
(2, 2, '2025-07-17 10:00:00'),
(3, 3, '2025-07-17 11:00:00'),
(4, 4, '2025-07-17 12:00:00'),
(5, 1, '2025-07-17 13:00:00'),
(1, 2, '2025-07-18 09:00:00'),
(2, 3, '2025-07-18 10:00:00'),
(3, 4, '2025-07-18 11:00:00'),
(4, 1, '2025-07-18 12:00:00'),
(5, 2, '2025-07-18 13:00:00'),
(1, 3, '2025-07-19 09:00:00'),
(2, 4, '2025-07-19 10:00:00');

--  Prevent overlapping appointments per user (example BEFORE INSERT trigger)
DELIMITER $$

CREATE TRIGGER prevent_time_clash
BEFORE INSERT ON appointments
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM appointments
    WHERE user_id = NEW.user_id
      AND TIMESTAMPDIFF(MINUTE, appointment_time, NEW.appointment_time) BETWEEN -59 AND 59
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'User already has an appointment within the same time slot!';
  END IF;
END$$

DELIMITER ;

--  Filter: Get all appointments on a specific date
SELECT 
  a.id,
  u.name AS user_name,
  s.name AS service_name,
  a.appointment_time
FROM 
  appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE DATE(a.appointment_time) = '2025-07-17'
ORDER BY a.appointment_time;

-- Filter: Get all appointments for a specific service
SELECT 
  a.id,
  u.name AS user_name,
  s.name AS service_name,
  a.appointment_time
FROM 
  appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
WHERE s.name = 'Haircut'
ORDER BY a.appointment_time;

--  See full appointment schedule
SELECT 
  a.id,
  u.name AS user_name,
  s.name AS service_name,
  a.appointment_time
FROM 
  appointments a
JOIN users u ON a.user_id = u.id
JOIN services s ON a.service_id = s.id
ORDER BY a.appointment_time;

-- Verify tables
SHOW TABLES;
DESCRIBE users;
DESCRIBE services;
DESCRIBE appointments;
