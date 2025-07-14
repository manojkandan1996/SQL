CREATE DATABASE voting_db;
USE voting_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE polls (
  id INT AUTO_INCREMENT PRIMARY KEY,
  question VARCHAR(255) NOT NULL
);

CREATE TABLE options (
  id INT AUTO_INCREMENT PRIMARY KEY,
  poll_id INT NOT NULL,
  option_text VARCHAR(255) NOT NULL,
  FOREIGN KEY (poll_id) REFERENCES polls(id) ON DELETE CASCADE
);

CREATE TABLE votes (
  user_id INT NOT NULL,
  option_id INT NOT NULL,
  voted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, option_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (option_id) REFERENCES options(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO polls (question) VALUES
('What is your favorite programming language?');

INSERT INTO options (poll_id, option_text) VALUES
(1, 'Python'),
(1, 'JavaScript'),
(1, 'Java'),
(1, 'C++');

INSERT INTO votes (user_id, option_id) VALUES
(1, 1),
(2, 2),
(3, 1);

-- Count votes by option for a poll
SELECT 
  p.question,
  o.option_text,
  COUNT(v.user_id) AS vote_count
FROM 
  polls p
JOIN options o ON p.id = o.poll_id
LEFT JOIN votes v ON o.id = v.option_id
WHERE p.id = 1
GROUP BY o.id
ORDER BY vote_count DESC;

--  Show who voted for what
SELECT 
  u.name AS voter,
  p.question,
  o.option_text,
  v.voted_at
FROM 
  votes v
JOIN options o ON v.option_id = o.id
JOIN polls p ON o.poll_id = p.id
JOIN users u ON v.user_id = u.id
ORDER BY v.voted_at;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE polls;
DESCRIBE options;
DESCRIBE votes;
