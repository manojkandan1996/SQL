CREATE DATABASE course_feedback_db;
USE course_feedback_db;

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE feedback (
    id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    user_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments VARCHAR(500),
    FOREIGN KEY (course_id) REFERENCES courses(id)
);

INSERT INTO courses (title) VALUES
('Intro to Python'),
('Advanced SQL'),
('Web Development Basics'),
('Data Science Fundamentals'),
('Machine Learning 101');

INSERT INTO feedback (course_id, user_id, rating, comments) VALUES
(1, 1, 5, 'Excellent course, very informative!'),
(1, 2, 4, 'Good content, but could use more examples.'),
(1, 3, 3, 'Average, expected more depth.'),
(1, 4, 5, 'Loved it! Well explained.'),
(1, 5, 4, 'Very good for beginners.'),
(2, 1, 4, 'Detailed and practical.'),
(2, 2, 2, 'Too complex for me.'),
(2, 3, 3, 'Decent, but needs more exercises.'),
(2, 4, 5, 'Perfect for advanced users!'),
(2, 5, 4, 'Good course overall.'),
(3, 1, 5, 'Amazing introduction to web dev!'),
(3, 2, 4, 'Helpful content.'),
(3, 3, 4, 'Good pace and topics.'),
(3, 4, 5, 'Loved the examples.'),
(3, 5, 5, 'Highly recommend this course.'),
(4, 1, 3, 'Okay, but could be better.'),
(4, 2, 4, 'Good overview.'),
(4, 3, 2, 'Not detailed enough.'),
(4, 4, 5, 'Great course, learned a lot!'),
(4, 5, 3, 'It was fine, but not great.'),
(5, 1, 5, 'Excellent introduction to ML!'),
(5, 2, 4, 'Very useful content.'),
(5, 3, 3, 'Average course.'),
(5, 4, 5, 'Great explanations and examples.');

--  Average rating per course
SELECT 
    c.title AS course_title,
    ROUND(AVG(f.rating), 2) AS average_rating,
    COUNT(f.id) AS total_reviews
FROM 
    courses c
LEFT JOIN 
    feedback f ON c.id = f.course_id
GROUP BY 
    c.id, c.title
ORDER BY 
    average_rating DESC;

--  Basic sentiment tracking (positive vs negative comments)
SELECT 
    c.title AS course_title,
    SUM(CASE 
            WHEN LOWER(f.comments) LIKE '%good%' 
              OR LOWER(f.comments) LIKE '%great%' 
              OR LOWER(f.comments) LIKE '%excellent%' 
              OR LOWER(f.comments) LIKE '%love%' 
            THEN 1 ELSE 0 END) AS positive_feedback,
    SUM(CASE 
            WHEN LOWER(f.comments) LIKE '%bad%' 
              OR LOWER(f.comments) LIKE '%poor%' 
              OR LOWER(f.comments) LIKE '%terrible%' 
            THEN 1 ELSE 0 END) AS negative_feedback
FROM 
    courses c
LEFT JOIN 
    feedback f ON c.id = f.course_id
GROUP BY 
    c.id, c.title
ORDER BY 
    positive_feedback DESC;

--  Show all feedback for a specific course
SELECT 
    f.id,
    c.title AS course_title,
    f.user_id,
    f.rating,
    f.comments
FROM 
    feedback f
JOIN 
    courses c ON f.course_id = c.id
WHERE 
    c.title = 'Intro to Python'
ORDER BY 
    f.rating DESC;

