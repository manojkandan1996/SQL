CREATE DATABASE DBattendance_db;
USE DBattendance_db;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE attendance (
  student_id INT NOT NULL,
  course_id INT NOT NULL,
  date DATE NOT NULL,
  status ENUM('Present', 'Absent', 'Excused') NOT NULL,
  PRIMARY KEY (student_id, course_id, date),
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

INSERT INTO students (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO courses (name) VALUES
('Math'),
('Science');

INSERT INTO attendance (student_id, course_id, date, status) VALUES
(1, 1, '2025-07-01', 'Present'),
(1, 1, '2025-07-02', 'Absent'),
(1, 2, '2025-07-01', 'Present'),
(2, 1, '2025-07-01', 'Present'),
(2, 1, '2025-07-02', 'Present'),
(3, 1, '2025-07-01', 'Absent'),
(3, 2, '2025-07-01', 'Excused');

--  Get detailed attendance records
SELECT 
  s.name AS student_name,
  c.name AS course_name,
  a.date,
  a.status
FROM 
  attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
ORDER BY s.name, c.name, a.date;

--  Get attendance summary per student per course
SELECT
  s.name AS student_name,
  c.name AS course_name,
  COUNT(*) AS total_days,
  SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
  SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absent_days,
  SUM(CASE WHEN a.status = 'Excused' THEN 1 ELSE 0 END) AS excused_days
FROM 
  attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
GROUP BY a.student_id, a.course_id
ORDER BY s.name, c.name;

-- Get attendance for a specific date
SELECT
  s.name AS student_name,
  c.name AS course_name,
  a.status
FROM 
  attendance a
JOIN students s ON a.student_id = s.id
JOIN courses c ON a.course_id = c.id
WHERE a.date = '2025-07-01';

-- Check structure
SHOW TABLES;
DESCRIBE students;
DESCRIBE courses;
DESCRIBE attendance;
