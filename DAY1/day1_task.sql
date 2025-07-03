SHOW DATABASES;

-- 07
create database school;
USE school;
-- 08
CREATE TABLE Students (
  StudentID INT PRIMARY KEY,
  Name VARCHAR(50),
  Age INT,
  Department VARCHAR(50)
);
SHOW TABLES;
-- 09
USE SchoolDB;
CREATE TABLE Courses (
  CourseID INT PRIMARY KEY,
  Title VARCHAR(100),
  Credits INT
);
-- 10
INSERT INTO Students (StudentID,Name, Age, Department) 
VALUES (1,'ARUN', 20, 'Computer Science');
INSERT INTO Students (StudentID,Name, Age, Department) 
VALUES (2,'MANOJ', 22, 'Mathematics');
INSERT INTO Students (StudentID,Name, Age, Department) 
VALUES (3,'RAJA', 19, 'Physics');
-- 11       
INSERT INTO Courses (CourseID,Title, Credits)
VALUES (01,'Python', 4);
INSERT INTO Courses (CourseID,Title, Credits)
VALUES (02,'JAVA', 3);
-- 12       
INSERT INTO Students (StudentID,Name, Age, Department) 
VALUES 
  (004,'sanjay', 21, 'Biology'),
  (005,'karthi', 23, 'Chemistry'),
  (006,'kathir', 18, 'Physics');
 -- 13 
SELECT * FROM Students;
-- 14
SELECT Name, Age FROM Students;
-- 15
SELECT * FROM Courses;
-- 16
SELECT DISTINCT Department FROM Students;
-- 17
SELECT * FROM Students WHERE Age > 20;
-- 18
SELECT * FROM Courses WHERE Credits > 3;
-- 19
SELECT * FROM Students WHERE Department = 'Computer Science';
-- 20
SELECT * FROM Students WHERE Age != 18;
-- 21
SELECT * FROM Students WHERE Name LIKE 'A%';
-- 22
SELECT * FROM Students WHERE Name LIKE '%n%';
-- 23
SELECT * FROM Students WHERE Name LIKE '____';
-- 24
SELECT * FROM Students WHERE Age BETWEEN 18 AND 22;
-- 25
SELECT * FROM Courses WHERE CourseID IN (101, 102, 105);
-- 26
SELECT * FROM Students WHERE Department != 'Physics';
-- 27
SELECT * FROM Students WHERE Department IS NULL;
-- 28
SELECT * FROM Students WHERE Department IS NOT NULL;
-- 29
SELECT * FROM Students WHERE Age > 18 AND Department = 'Mathematics';
-- 30
SELECT * FROM Students WHERE Department = 'Biology' OR Department = 'Chemistry';
-- 31
SELECT * FROM Students WHERE Department != 'History' AND Age < 21;
-- 32
SELECT * FROM Students ORDER BY Name ASC;
-- 33
SELECT * FROM Courses ORDER BY Credits DESC;
-- 34
SELECT * FROM Students ORDER BY Department ASC, Age DESC;
-- 35
SELECT * FROM Students LIMIT 5;
-- 36
SELECT * FROM Courses ORDER BY Credits DESC LIMIT 3;
-- 37
ALTER TABLE Students ADD COLUMN Email VARCHAR(100);
-- 38
UPDATE Students SET Email = 'manoj@example.com' WHERE Name = 'MANOJ';
-- 39
DELETE FROM Students WHERE Age > 25;
-- 40
DELETE FROM Courses WHERE CourseID = 2;
-- 41
INSERT INTO Students (StudentID,Name, Age) VALUES (007,'elango', 20);
-- 42
SELECT * FROM Students WHERE Department IS NULL;
-- 43
UPDATE Students SET Department = 'Engineering' WHERE Name = 'Alex';
-- 44
UPDATE Students SET Age = Age + 1;
-- 45
SELECT * FROM Students WHERE Name LIKE '%a';
-- 46
SELECT * FROM Students WHERE Name LIKE '%ar%';
-- 47
SELECT Name FROM Students WHERE Department IN ('Physics', 'Mathematics') ORDER BY Age DESC;
-- 48
SELECT DISTINCT Age FROM Students WHERE Department IS NOT NULL;
-- 49
SELECT * FROM Students ORDER BY Name ASC LIMIT 3;
-- 50
DELETE FROM Students WHERE Department IS NULL;
