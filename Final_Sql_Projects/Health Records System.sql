CREATE DATABASE health_records_db;
USE health_records_db;

CREATE TABLE patients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dob DATE NOT NULL
);

CREATE TABLE medications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE prescriptions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE
);

CREATE TABLE prescription_details (
  prescription_id INT NOT NULL,
  medication_id INT NOT NULL,
  dosage VARCHAR(50) NOT NULL,
  PRIMARY KEY (prescription_id, medication_id),
  FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE,
  FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE
);

INSERT INTO patients (name, dob) VALUES
('Alice Smith', '1980-02-10'),
('Bob Jones', '1975-06-25'),
('Charlie Brown', '1990-12-01');

INSERT INTO medications (name) VALUES
('Amoxicillin'),
('Ibuprofen'),
('Metformin'),
('Lisinopril'),
('Atorvastatin');

INSERT INTO prescriptions (patient_id, date) VALUES
(1, '2025-07-10'),
(1, '2025-07-15'),
(2, '2025-07-12'),
(3, '2025-07-13');

INSERT INTO prescription_details (prescription_id, medication_id, dosage) VALUES
(1, 1, '500mg twice daily'),
(1, 2, '200mg as needed'),
(2, 3, '1000mg daily'),
(2, 4, '10mg daily'),
(3, 2, '400mg twice daily'),
(3, 5, '20mg daily'),
(4, 1, '250mg twice daily'),
(4, 4, '5mg daily');

-- JOIN: View full prescriptions for a patient
SELECT
  p.name AS patient_name,
  pr.id AS prescription_id,
  pr.date,
  m.name AS medication,
  pd.dosage
FROM
  prescriptions pr
JOIN patients p ON pr.patient_id = p.id
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
WHERE p.name = 'Alice Smith'
ORDER BY pr.date;

--  Filter: Get all prescriptions for a patient within date range
SELECT
  p.name AS patient_name,
  pr.id AS prescription_id,
  pr.date,
  m.name AS medication,
  pd.dosage
FROM
  prescriptions pr
JOIN patients p ON pr.patient_id = p.id
JOIN prescription_details pd ON pr.id = pd.prescription_id
JOIN medications m ON pd.medication_id = m.id
WHERE p.name = 'Alice Smith'
  AND pr.date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY pr.date;

-- Check structure
SHOW TABLES;
DESCRIBE patients;
DESCRIBE prescriptions;
DESCRIBE medications;
DESCRIBE prescription_details;
