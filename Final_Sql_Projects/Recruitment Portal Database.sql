CREATE DATABASE recruitment_db;
USE recruitment_db;

CREATE TABLE jobs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  company VARCHAR(255) NOT NULL
);

CREATE TABLE candidates (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE applications (
  job_id INT NOT NULL,
  candidate_id INT NOT NULL,
  status ENUM('Applied', 'Interview', 'Offer', 'Rejected', 'Hired') DEFAULT 'Applied',
  applied_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (job_id, candidate_id),
  FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
  FOREIGN KEY (candidate_id) REFERENCES candidates(id) ON DELETE CASCADE
);

INSERT INTO jobs (title, company) VALUES
('Software Engineer', 'TechCorp'),
('Data Analyst', 'DataWorks'),
('Project Manager', 'ManageIt'),
('UI/UX Designer', 'DesignStudio'),
('DevOps Engineer', 'CloudSolutions');

INSERT INTO candidates (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve'),
('Frank'),
('Grace'),
('Heidi'),
('Ivan'),
('Judy'),
('Karl'),
('Liam'),
('Mallory'),
('Nina'),
('Oscar'),
('Peggy'),
('Quinn'),
('Rupert'),
('Sybil'),
('Trent'),
('Uma'),
('Victor'),
('Walter');

INSERT INTO applications (job_id, candidate_id, status, applied_at) VALUES
(1, 1, 'Applied', '2025-07-01 09:00:00'),
(1, 2, 'Interview', '2025-07-01 10:00:00'),
(1, 3, 'Offer', '2025-07-02 11:00:00'),
(1, 4, 'Rejected', '2025-07-02 12:00:00'),
(1, 5, 'Hired', '2025-07-02 13:00:00'),
(2, 6, 'Applied', '2025-07-03 09:00:00'),
(2, 7, 'Interview', '2025-07-03 10:00:00'),
(2, 8, 'Offer', '2025-07-03 11:00:00'),
(2, 9, 'Rejected', '2025-07-03 12:00:00'),
(2,10, 'Hired', '2025-07-03 13:00:00'),
(3,11, 'Applied', '2025-07-04 09:00:00'),
(3,12, 'Interview', '2025-07-04 10:00:00'),
(3,13, 'Offer', '2025-07-04 11:00:00'),
(3,14, 'Rejected', '2025-07-04 12:00:00'),
(3,15, 'Hired', '2025-07-04 13:00:00'),
(4,16, 'Applied', '2025-07-05 09:00:00'),
(4,17, 'Interview', '2025-07-05 10:00:00'),
(4,18, 'Offer', '2025-07-05 11:00:00'),
(4,19, 'Rejected', '2025-07-05 12:00:00'),
(4,20, 'Hired', '2025-07-05 13:00:00'),
(5,21, 'Applied', '2025-07-06 09:00:00'),
(5,22, 'Interview', '2025-07-06 10:00:00'),
(5,23, 'Offer', '2025-07-06 11:00:00');

--  Query: Get candidates by status ('Interview')
SELECT
  c.name AS candidate_name,
  j.title AS job_title,
  j.company,
  a.status,
  a.applied_at
FROM
  applications a
JOIN candidates c ON a.candidate_id = c.id
JOIN jobs j ON a.job_id = j.id
WHERE a.status = 'Interview'
ORDER BY a.applied_at;

--  Query: Job-wise applicant count
SELECT
  j.title AS job_title,
  j.company,
  COUNT(a.candidate_id) AS total_applicants
FROM
  jobs j
LEFT JOIN applications a ON j.id = a.job_id
GROUP BY j.id
ORDER BY total_applicants DESC;

-- See all applications
SELECT
  c.name AS candidate_name,
  j.title AS job_title,
  j.company,
  a.status,
  a.applied_at
FROM
  applications a
JOIN candidates c ON a.candidate_id = c.id
JOIN jobs j ON a.job_id = j.id
ORDER BY a.applied_at;

-- Check structure
SHOW TABLES;
DESCRIBE jobs;
DESCRIBE candidates;
DESCRIBE applications;
