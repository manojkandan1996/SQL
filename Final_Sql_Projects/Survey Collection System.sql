CREATE DATABASE DBsurvey_db;
USE DBsurvey_db;

CREATE TABLE surveys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    survey_id INT,
    question_text VARCHAR(500) NOT NULL,
    FOREIGN KEY (survey_id) REFERENCES surveys(id)
);

CREATE TABLE responses (
    user_id INT,
    question_id INT,
    answer_text VARCHAR(255),
    PRIMARY KEY (user_id, question_id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO surveys (title) VALUES
('Customer Satisfaction Survey'),
('Employee Feedback Survey');

INSERT INTO questions (survey_id, question_text) VALUES
(1, 'How satisfied are you with our service?'),
(1, 'Would you recommend us to a friend?'),
(1, 'What can we improve?'),
(2, 'How do you rate the work environment?'),
(2, 'Are you satisfied with management support?'),
(2, 'Would you stay with the company for 2+ years?');

INSERT INTO responses (user_id, question_id, answer_text) VALUES
(1, 1, 'Very Satisfied'),
(1, 2, 'Yes'),
(1, 3, 'More payment options'),

(2, 1, 'Satisfied'),
(2, 2, 'Yes'),
(2, 3, 'Faster delivery'),

(3, 1, 'Neutral'),
(3, 2, 'No'),
(3, 3, 'Better support'),

(4, 1, 'Very Satisfied'),
(4, 2, 'Yes'),
(4, 3, 'Add loyalty program'),

(5, 1, 'Dissatisfied'),
(5, 2, 'No'),
(5, 3, 'Lower prices'),

(6, 4, 'Excellent'),
(6, 5, 'Yes'),
(6, 6, 'Yes'),

(7, 4, 'Good'),
(7, 5, 'No'),
(7, 6, 'No'),

(8, 4, 'Average'),
(8, 5, 'Yes'),
(8, 6, 'No'),

(9, 4, 'Good'),
(9, 5, 'Yes'),
(9, 6, 'Yes'),

(10, 4, 'Poor'),
(10, 5, 'No'),
(10, 6, 'No');

-- Count answers by question (e.g., satisfaction levels)
SELECT 
    q.question_text,
    r.answer_text,
    COUNT(*) AS response_count
FROM 
    questions q
JOIN 
    responses r ON q.id = r.question_id
WHERE 
    q.id = 1
GROUP BY 
    q.question_text, r.answer_text;

--  Count yes/no answers for 'Would you recommend us?'
SELECT 
    r.answer_text,
    COUNT(*) AS total
FROM 
    responses r
WHERE 
    r.question_id = 2
GROUP BY 
    r.answer_text;

--  Pivot-style summary: How many said Yes/No for each Yes/No question
SELECT 
    q.id AS question_id,
    q.question_text,
    SUM(CASE WHEN r.answer_text = 'Yes' THEN 1 ELSE 0 END) AS yes_count,
    SUM(CASE WHEN r.answer_text = 'No' THEN 1 ELSE 0 END) AS no_count
FROM 
    questions q
JOIN 
    responses r ON q.id = r.question_id
WHERE 
    q.question_text LIKE 'Would%'
    OR q.question_text LIKE 'Are%'
GROUP BY 
    q.id, q.question_text;

--  Full survey results for a given survey (Customer Satisfaction Survey)
SELECT
    s.title AS survey_title,
    q.question_text,
    r.user_id,
    r.answer_text
FROM
    surveys s
JOIN
    questions q ON s.id = q.survey_id
JOIN
    responses r ON q.id = r.question_id
WHERE
    s.id = 1
ORDER BY
    r.user_id, q.id;
