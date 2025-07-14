-- ========================================
-- 1️⃣ Create Database
-- ========================================
CREATE DATABASE forum_db;
USE forum_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL
);

CREATE TABLE threads (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    thread_id INT,
    user_id INT,
    content TEXT,
    parent_post_id INT NULL,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (thread_id) REFERENCES threads(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (parent_post_id) REFERENCES posts(id)
);

INSERT INTO users (username) VALUES
('alice'),
('bob'),
('charlie');

INSERT INTO threads (title, user_id) VALUES
('How to learn SQL?', 1),
('Favorite programming languages', 2);

INSERT INTO posts (thread_id, user_id, content) VALUES
(1, 1, 'I want to learn SQL. Any tips?');

INSERT INTO posts (thread_id, user_id, content, parent_post_id) VALUES
(1, 2, 'Start with SELECT queries!', 1),
(1, 3, 'Practice with real datasets.', 1);

INSERT INTO posts (thread_id, user_id, content, parent_post_id) VALUES
(1, 1, 'Thanks! Any good practice sites?', 2);

INSERT INTO posts (thread_id, user_id, content) VALUES
(2, 2, 'What programming languages do you love?');

INSERT INTO posts (thread_id, user_id, content, parent_post_id) VALUES
(2, 1, 'I like Python and SQL.', 5);


--  Self-join: Show posts and their replies
SELECT 
    p1.id AS post_id,
    p1.content AS post_content,
    p2.id AS reply_id,
    p2.content AS reply_content
FROM 
    posts p1
LEFT JOIN 
    posts p2 ON p1.id = p2.parent_post_id
ORDER BY 
    p1.id, p2.id;

--  Thread view: Count posts per thread
SELECT 
    t.id AS thread_id,
    t.title,
    COUNT(p.id) AS total_posts
FROM 
    threads t
LEFT JOIN 
    posts p ON t.id = p.thread_id
GROUP BY 
    t.id, t.title;

--  Get full post chain for one thread
SELECT 
    t.title AS thread_title,
    p.id AS post_id,
    p.content AS post_content,
    p.parent_post_id,
    p.posted_at,
    u.username
FROM 
    threads t
JOIN 
    posts p ON t.id = p.thread_id
JOIN 
    users u ON p.user_id = u.id
WHERE 
    t.id = 1
ORDER BY 
    p.posted_at;
