CREATE DATABASE course_progress_db;
USE course_progress_db;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE lessons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE progress (
  student_id INT NOT NULL,
  lesson_id INT NOT NULL,
  completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (student_id, lesson_id),
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE
);

INSERT INTO students (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO courses (name) VALUES
('Python Basics'),
('Web Development');

INSERT INTO lessons (course_id, title) VALUES
(1, 'Introduction to Python'),
(1, 'Variables and Data Types'),
(1, 'Control Structures'),
(1, 'Functions'),
(1, 'Modules and Packages'),
(2, 'HTML Basics'),
(2, 'CSS Styling'),
(2, 'JavaScript Essentials'),
(2, 'Backend Concepts'),
(2, 'Deploying a Website');

INSERT INTO progress (student_id, lesson_id, completed_at) VALUES
(1, 1, '2025-07-01 10:00:00'),
(1, 2, '2025-07-01 11:00:00'),
(1, 3, '2025-07-02 09:00:00'),
(1, 4, '2025-07-02 10:00:00'),
(1, 5, '2025-07-02 11:00:00'),
(1, 6, '2025-07-03 10:00:00'),
(1, 7, '2025-07-03 11:00:00'),
(1, 8, '2025-07-04 09:00:00'),
(1, 9, '2025-07-04 10:00:00'),
(1,10, '2025-07-04 11:00:00'),
(2, 1, '2025-07-01 10:00:00'),
(2, 2, '2025-07-01 11:00:00'),
(2, 3, '2025-07-02 09:00:00'),
(2, 4, '2025-07-02 10:00:00'),
(2, 5, '2025-07-02 11:00:00'),
(2, 6, '2025-07-03 10:00:00'),
(2, 7, '2025-07-03 11:00:00'),
(2, 8, '2025-07-04 09:00:00'),
(3, 1, '2025-07-01 10:00:00'),
(3, 2, '2025-07-01 11:00:00'),
(3, 6, '2025-07-03 10:00:00'),
(3, 7, '2025-07-03 11:00:00'),
(3, 8, '2025-07-04 09:00:00');

-- Calculate completion % per student per course
SELECT
  s.name AS student_name,
  c.name AS course_name,
  COUNT(DISTINCT p.lesson_id) AS lessons_completed,
  COUNT(DISTINCT l.id) AS total_lessons,
  ROUND((COUNT(DISTINCT p.lesson_id) / COUNT(DISTINCT l.id)) * 100, 2) AS completion_percentage
FROM
  students s
JOIN progress p ON s.id = p.student_id
JOIN lessons l ON p.lesson_id = l.id
JOIN courses c ON l.course_id = c.id
GROUP BY s.id, c.id
ORDER BY s.name, c.name;

--  Get detailed progress for one student
SELECT
  s.name AS student_name,
  c.name AS course_name,
  l.title AS lesson_title,
  p.completed_at
FROM
  progress p
JOIN students s ON p.student_id = s.id
JOIN lessons l ON p.lesson_id = l.id
JOIN courses c ON l.course_id = c.id
WHERE s.name = 'Alice'
ORDER BY c.name, l.id;

-- Check structure
SHOW TABLES;
DESCRIBE students;
DESCRIBE courses;
DESCRIBE lessons;
DESCRIBE progress;
