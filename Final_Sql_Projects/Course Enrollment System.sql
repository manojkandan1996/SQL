CREATE DATABASE course_enrollment_db;
USE course_enrollment_db;

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  instructor VARCHAR(100) NOT NULL
);

CREATE TABLE enrollments (
  course_id INT NOT NULL,
  student_id INT NOT NULL,
  enroll_date DATE NOT NULL,
  PRIMARY KEY (course_id, student_id),
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

INSERT INTO students (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com'),
('David', 'david@example.com'),
('Eve', 'eve@example.com'),
('Frank', 'frank@example.com'),
('Grace', 'grace@example.com'),
('Hank', 'hank@example.com'),
('Ivy', 'ivy@example.com'),
('Jack', 'jack@example.com');

INSERT INTO courses (title, instructor) VALUES
('Introduction to SQL', 'Prof. Smith'),
('Web Development Basics', 'Prof. Johnson'),
('Data Science 101', 'Prof. Lee'),
('Project Management', 'Prof. Brown');


INSERT INTO enrollments (course_id, student_id, enroll_date) VALUES
(1, 1, '2025-07-01'),
(1, 2, '2025-07-01'),
(1, 3, '2025-07-01'),
(1, 4, '2025-07-01'),
(1, 5, '2025-07-02'),
(2, 1, '2025-07-02'),
(2, 2, '2025-07-02'),
(2, 6, '2025-07-02'),
(2, 7, '2025-07-02'),
(2, 8, '2025-07-03'),
(3, 2, '2025-07-03'),
(3, 3, '2025-07-03'),
(3, 4, '2025-07-03'),
(3, 5, '2025-07-03'),
(3, 6, '2025-07-04'),
(3, 7, '2025-07-04'),
(4, 1, '2025-07-04'),
(4, 8, '2025-07-04'),
(4, 9, '2025-07-05'),
(4, 10, '2025-07-05'),
(4, 3, '2025-07-05'),
(4, 5, '2025-07-05');

--  Query: List students in a specific course
SELECT 
  c.title AS course_title,
  s.name AS student_name,
  s.email,
  e.enroll_date
FROM 
  enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.id
WHERE c.id = 1
ORDER BY s.name;

--  Query: Count enrolled students per course
SELECT 
  c.title AS course_title,
  COUNT(e.student_id) AS total_students
FROM 
  courses c
LEFT JOIN enrollments e ON c.id = e.course_id
GROUP BY c.id, c.title
ORDER BY total_students DESC;

--  Query: Show all enrollments with student & course info
SELECT 
  s.name AS student_name,
  s.email,
  c.title AS course_title,
  c.instructor,
  e.enroll_date
FROM 
  enrollments e
JOIN students s ON e.student_id = s.id
JOIN courses c ON e.course_id = c.id
ORDER BY c.title, s.name;

--  Verify tables
SHOW TABLES;
DESCRIBE students;
DESCRIBE courses;
DESCRIBE enrollments;
