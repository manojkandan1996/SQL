CREATE DATABASE IF NOT EXISTS online_exam_db;
USE online_exam_db;

CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL
);

CREATE TABLE exams (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  exam_date DATE NOT NULL,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

CREATE TABLE questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  exam_id INT NOT NULL,
  text VARCHAR(500) NOT NULL,
  correct_option CHAR(1) NOT NULL,
  FOREIGN KEY (exam_id) REFERENCES exams(id) ON DELETE CASCADE
);

CREATE TABLE student_answers (
  student_id INT NOT NULL,
  question_id INT NOT NULL,
  selected_option CHAR(1) NOT NULL,
  PRIMARY KEY (student_id, question_id),
  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

INSERT INTO courses (title) VALUES 
('Database Fundamentals'),
('Web Development'),
('Data Science Basics');

INSERT INTO exams (course_id, exam_date) VALUES 
(1, '2025-07-20');

INSERT INTO questions (exam_id, text, correct_option) VALUES
(1, 'What is SQL?', 'A'),
(1, 'Which keyword is used to retrieve data?', 'B'),
(1, 'What is a primary key?', 'C'),
(1, 'Which JOIN returns all rows from both tables?', 'D'),
(1, 'Which is NOT a SQL command?', 'A'),
(1, 'What does ACID stand for?', 'B'),
(1, 'Which is used to create a table?', 'C'),
(1, 'Which function returns the number of rows?', 'D'),
(1, 'What is normalization?', 'A'),
(1, 'Which SQL clause groups records?', 'B'),
(1, 'What does DDL stand for?', 'C'),
(1, 'What does DML stand for?', 'D'),
(1, 'Which keyword deletes a table?', 'A'),
(1, 'Which is used for constraints?', 'B'),
(1, 'Which statement adds data?', 'C'),
(1, 'What is a foreign key?', 'D'),
(1, 'What does SELECT * do?', 'A'),
(1, 'Which keyword updates data?', 'B'),
(1, 'Which is a non-clustered index?', 'C'),
(1, 'Which type is best for unique IDs?', 'D'),
(1, 'Which keyword limits results?', 'A');

INSERT INTO students (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO student_answers (student_id, question_id, selected_option) VALUES
(1, 1, 'A'),  
(1, 2, 'B'),  
(1, 3, 'A'),  
(1, 4, 'D'),  
(1, 5, 'B'),  
(1, 6, 'B'),  
(1, 7, 'C'),  
(1, 8, 'C'),  
(1, 9, 'A'),  
(1,10, 'B'),  
(1,11, 'C'),  
(1,12, 'A'),  
(1,13, 'A'),  
(1,14, 'B'),  
(1,15, 'C'),  
(1,16, 'D'),  
(1,17, 'A'),
(1,18, 'C'),
(1,19, 'C'),
(1,20, 'D'),
(1,21, 'A'),
(2, 1, 'B'),
(2, 2, 'B'),
(2, 3, 'C');

--  Calculate student score by comparing answers
SELECT
  s.name AS student_name,
  COUNT(*) AS total_answered,
  SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END) AS correct_answers,
  CONCAT(ROUND(SUM(CASE WHEN sa.selected_option = q.correct_option THEN 1 ELSE 0 END)/COUNT(*)*100, 2), '%') AS score_percentage
FROM 
  student_answers sa
JOIN questions q ON sa.question_id = q.id
JOIN students s ON sa.student_id = s.id
WHERE q.exam_id = 1
GROUP BY sa.student_id;

--  Join: see answers with question text & correct answers
SELECT 
  s.name AS student_name,
  q.text AS question_text,
  q.correct_option,
  sa.selected_option,
  CASE WHEN sa.selected_option = q.correct_option THEN 'Correct' ELSE 'Incorrect' END AS result
FROM 
  student_answers sa
JOIN questions q ON sa.question_id = q.id
JOIN students s ON sa.student_id = s.id
WHERE sa.student_id = 1;

-- Check structure
SHOW TABLES;
DESCRIBE courses;
DESCRIBE exams;
DESCRIBE questions;
DESCRIBE student_answers;
DESCRIBE students;
