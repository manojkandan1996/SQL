CREATE DATABASE DBblog_db;
USE DBblog_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE posts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  published_date DATE NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  comment_text TEXT NOT NULL,
  commented_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO posts (user_id, title, content, published_date) VALUES
(1, 'First Post', 'This is the content of the first post.', '2025-07-01'),
(1, 'Second Post', 'More insights from Alice.', '2025-07-02'),
(2, 'Bob\'s Thoughts', 'Bob writes about tech.', '2025-07-03');

INSERT INTO comments (post_id, user_id, comment_text, commented_at) VALUES
(1, 2, 'Great post, Alice!', '2025-07-01 10:00:00'),
(1, 3, 'I agree with Bob.', '2025-07-01 11:00:00'),
(2, 3, 'Nice follow-up.', '2025-07-02 12:00:00'),
(3, 1, 'Interesting points, Bob.', '2025-07-03 13:00:00');

--  JOIN: Fetch posts with their comments and authors
SELECT 
  p.id AS post_id,
  p.title,
  p.content,
  p.published_date,
  u.name AS post_author,
  c.comment_text,
  cu.name AS comment_author,
  c.commented_at
FROM 
  posts p
JOIN users u ON p.user_id = u.id
LEFT JOIN comments c ON p.id = c.post_id
LEFT JOIN users cu ON c.user_id = cu.id
ORDER BY p.id, c.commented_at;

--  Filter: Get posts by a specific user
SELECT 
  p.id AS post_id,
  p.title,
  p.published_date,
  u.name AS author
FROM 
  posts p
JOIN users u ON p.user_id = u.id
WHERE u.name = 'Alice';

-- Filter: Get posts published within a date range
SELECT 
  p.id AS post_id,
  p.title,
  p.published_date,
  u.name AS author
FROM 
  posts p
JOIN users u ON p.user_id = u.id
WHERE p.published_date BETWEEN '2025-07-01' AND '2025-07-02';

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE posts;
DESCRIBE comments;
