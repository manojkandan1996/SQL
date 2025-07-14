CREATE DATABASE hospitaldb_db;
USE hospitaldb_db;

CREATE TABLE patients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dob DATE NOT NULL
);

CREATE TABLE doctors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  specialization VARCHAR(100) NOT NULL
);

CREATE TABLE visits (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  doctor_id INT NOT NULL,
  visit_time DATETIME NOT NULL,
  FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
  FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
);

INSERT INTO patients (name, dob) VALUES
('Alice Smith', '1980-02-10'),
('Bob Jones', '1975-06-25'),
('Charlie Brown', '1990-12-01'),
('David White', '1985-03-15'),
('Eve Black', '2000-09-09');

INSERT INTO doctors (name, specialization) VALUES
('Dr. Adams', 'Cardiology'),
('Dr. Baker', 'Pediatrics'),
('Dr. Clark', 'Neurology'),
('Dr. Davis', 'Orthopedics');

INSERT INTO visits (patient_id, doctor_id, visit_time) VALUES
(1, 1, '2025-07-20 09:00:00'),
(2, 1, '2025-07-20 09:30:00'),
(3, 2, '2025-07-20 10:00:00'),
(4, 2, '2025-07-20 10:30:00'),
(5, 3, '2025-07-20 11:00:00'),
(1, 3, '2025-07-20 11:30:00'),
(2, 4, '2025-07-20 12:00:00');

--  Query: Get all patients for a specific doctor on a specific date
SELECT 
  d.name AS doctor_name,
  p.name AS patient_name,
  p.dob,
  v.visit_time
FROM 
  visits v
JOIN patients p ON v.patient_id = p.id
JOIN doctors d ON v.doctor_id = d.id
WHERE 
  d.id = 1 AND DATE(v.visit_time) = '2025-07-20'
ORDER BY 
  v.visit_time;

--  Prevent overlapping visits for the same patient and doctor at the same time
DELIMITER $$

CREATE TRIGGER prevent_overlapping_visits
BEFORE INSERT ON visits
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM visits
    WHERE 
      patient_id = NEW.patient_id
      AND doctor_id = NEW.doctor_id
      AND TIMESTAMPDIFF(MINUTE, visit_time, NEW.visit_time) BETWEEN -29 AND 29
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Patient already has an overlapping visit with this doctor!';
  END IF;
END$$

DELIMITER ;

-- Show full visit schedule
SELECT 
  v.id,
  p.name AS patient_name,
  d.name AS doctor_name,
  d.specialization,
  v.visit_time
FROM 
  visits v
JOIN patients p ON v.patient_id = p.id
JOIN doctors d ON v.doctor_id = d.id
ORDER BY 
  v.visit_time;

--  Check structure
SHOW TABLES;
DESCRIBE patients;
DESCRIBE doctors;
DESCRIBE visits;
