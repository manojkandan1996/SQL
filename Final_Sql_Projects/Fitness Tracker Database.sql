CREATE DATABASE fitness_tracker_db;
USE fitness_tracker_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE workouts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL  -- e.g., Cardio, Strength, Flexibility
);

CREATE TABLE workout_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    workout_id INT,
    duration INT, -- in minutes
    log_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (workout_id) REFERENCES workouts(id)
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve');

INSERT INTO workouts (name, type) VALUES
('Running', 'Cardio'),
('Cycling', 'Cardio'),
('Yoga', 'Flexibility'),
('Weight Lifting', 'Strength'),
('Swimming', 'Cardio');

INSERT INTO workout_logs (user_id, workout_id, duration, log_date) VALUES
(1, 1, 30, '2025-07-07'),
(1, 2, 45, '2025-07-08'),
(1, 3, 60, '2025-07-09'),
(1, 4, 40, '2025-07-10'),
(1, 5, 50, '2025-07-11'),
(2, 1, 25, '2025-07-07'),
(2, 2, 35, '2025-07-08'),
(2, 4, 40, '2025-07-09'),
(2, 5, 55, '2025-07-10'),
(2, 3, 30, '2025-07-11'),
(3, 1, 20, '2025-07-07'),
(3, 3, 45, '2025-07-08'),
(3, 4, 35, '2025-07-09'),
(3, 2, 50, '2025-07-10'),
(3, 5, 40, '2025-07-11'),
(4, 2, 30, '2025-07-07'),
(4, 1, 40, '2025-07-08'),
(4, 4, 55, '2025-07-09'),
(4, 3, 60, '2025-07-10'),
(4, 5, 45, '2025-07-11'),
(5, 5, 35, '2025-07-07'),
(5, 2, 25, '2025-07-08'),
(5, 3, 40, '2025-07-09'),
(5, 1, 30, '2025-07-10');

-- Weekly summary: total duration per user for the week of 2025-07-07 to 2025-07-13
SELECT 
    u.name AS user_name,
    SUM(wl.duration) AS total_minutes
FROM 
    workout_logs wl
JOIN 
    users u ON wl.user_id = u.id
WHERE 
    wl.log_date BETWEEN '2025-07-07' AND '2025-07-13'
GROUP BY 
    u.id, u.name
ORDER BY 
    total_minutes DESC;

-- Weekly summary: total duration per user per workout type
SELECT 
    u.name AS user_name,
    w.type AS workout_type,
    SUM(wl.duration) AS total_minutes
FROM 
    workout_logs wl
JOIN 
    users u ON wl.user_id = u.id
JOIN 
    workouts w ON wl.workout_id = w.id
WHERE 
    wl.log_date BETWEEN '2025-07-07' AND '2025-07-13'
GROUP BY 
    u.id, u.name, w.type
ORDER BY 
    u.name, workout_type;

-- Full workout log with details
SELECT 
    u.name AS user_name,
    w.name AS workout_name,
    w.type AS workout_type,
    wl.duration,
    wl.log_date
FROM 
    workout_logs wl
JOIN 
    users u ON wl.user_id = u.id
JOIN 
    workouts w ON wl.workout_id = w.id
ORDER BY 
    wl.log_date, u.name;

