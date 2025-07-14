CREATE DATABASE job_scheduling_db;
USE job_scheduling_db;

CREATE TABLE jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    frequency VARCHAR(50) NOT NULL -- e.g., 'Daily', 'Weekly'
);

CREATE TABLE job_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT,
    run_time DATETIME,
    status VARCHAR(50), -- e.g., 'Success', 'Failed'
    FOREIGN KEY (job_id) REFERENCES jobs(id)
);

INSERT INTO jobs (name, frequency) VALUES
('Backup Database', 'Daily'),
('Generate Reports', 'Daily'),
('Clean Temp Files', 'Weekly'),
('Send Email Notifications', 'Daily'),
('Sync External Data', 'Weekly');

INSERT INTO job_logs (job_id, run_time, status) VALUES
(1, '2025-07-12 02:00:00', 'Success'),
(1, '2025-07-11 02:00:00', 'Success'),
(1, '2025-07-10 02:00:00', 'Failed'),
(1, '2025-07-09 02:00:00', 'Success'),
(2, '2025-07-12 03:00:00', 'Failed'),
(2, '2025-07-11 03:00:00', 'Success'),
(2, '2025-07-10 03:00:00', 'Success'),
(2, '2025-07-09 03:00:00', 'Success'),
(3, '2025-07-06 04:00:00', 'Success'),
(3, '2025-06-29 04:00:00', 'Failed'),
(3, '2025-06-22 04:00:00', 'Success'),
(4, '2025-07-12 05:00:00', 'Success'),
(4, '2025-07-11 05:00:00', 'Failed'),
(4, '2025-07-10 05:00:00', 'Success'),
(4, '2025-07-09 05:00:00', 'Success'),
(5, '2025-07-06 06:00:00', 'Failed'),
(5, '2025-06-29 06:00:00', 'Success'),
(5, '2025-06-22 06:00:00', 'Success'),
(5, '2025-06-15 06:00:00', 'Failed'),
(5, '2025-06-08 06:00:00', 'Success'),
(1, '2025-07-08 02:00:00', 'Success'),
(2, '2025-07-08 03:00:00', 'Failed'),
(4, '2025-07-08 05:00:00', 'Success'),
(3, '2025-06-15 04:00:00', 'Failed'),
(5, '2025-06-01 06:00:00', 'Success');

--  Last run and next run estimation
SELECT 
    j.name AS job_name,
    j.frequency,
    MAX(l.run_time) AS last_run,
    CASE 
        WHEN j.frequency = 'Daily' THEN DATE_ADD(MAX(l.run_time), INTERVAL 1 DAY)
        WHEN j.frequency = 'Weekly' THEN DATE_ADD(MAX(l.run_time), INTERVAL 1 WEEK)
        ELSE NULL
    END AS next_run_estimated
FROM 
    jobs j
LEFT JOIN 
    job_logs l ON j.id = l.job_id
GROUP BY 
    j.id, j.name, j.frequency
ORDER BY 
    j.name;

--  Status count by job
SELECT 
    j.name AS job_name,
    l.status,
    COUNT(*) AS count
FROM 
    jobs j
JOIN 
    job_logs l ON j.id = l.job_id
GROUP BY 
    j.name, l.status
ORDER BY 
    j.name, l.status;

--  All logs for a given job (e.g., Backup Database)
SELECT 
    j.name AS job_name,
    l.run_time,
    l.status
FROM 
    job_logs l
JOIN 
    jobs j ON l.job_id = j.id
WHERE 
    j.name = 'Backup Database'
ORDER BY 
    l.run_time DESC;

