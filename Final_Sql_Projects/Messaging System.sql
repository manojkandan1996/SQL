CREATE DATABASE messaging_db;
USE messaging_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE conversations (
  id INT AUTO_INCREMENT PRIMARY KEY
  -- Optionally, add other metadata like last_activity
);

CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  conversation_id INT NOT NULL,
  sender_id INT NOT NULL,
  message_text TEXT NOT NULL,
  sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO conversations (id) VALUES (1), (2);

INSERT INTO messages (conversation_id, sender_id, message_text, sent_at) VALUES
(1, 1, 'Hey Bob, how are you?', '2025-07-01 09:00:00'),
(1, 2, 'I am good, Alice! How about you?', '2025-07-01 09:05:00'),
(1, 1, 'Doing well, thanks!', '2025-07-01 09:10:00'),
(2, 2, 'Hey Charlie, are we still on for lunch?', '2025-07-01 12:00:00'),
(2, 3, 'Sure Bob, see you at 1 PM.', '2025-07-01 12:05:00');

--  Retrieve all messages in a conversation (thread view)
SELECT 
  c.id AS conversation_id,
  u.name AS sender_name,
  m.message_text,
  m.sent_at
FROM 
  messages m
JOIN conversations c ON m.conversation_id = c.id
JOIN users u ON m.sender_id = u.id
WHERE c.id = 1
ORDER BY m.sent_at;

--  Get latest message for each conversation (recent threads)
SELECT 
  c.id AS conversation_id,
  u.name AS sender_name,
  m.message_text,
  m.sent_at
FROM 
  messages m
JOIN conversations c ON m.conversation_id = c.id
JOIN users u ON m.sender_id = u.id
WHERE m.id IN (
  SELECT sub.id
  FROM (
    SELECT 
      id,
      ROW_NUMBER() OVER (PARTITION BY conversation_id ORDER BY sent_at DESC) AS rn
    FROM messages
  ) AS sub
  WHERE sub.rn = 1
)
ORDER BY m.sent_at DESC;

-- Or get latest messages with a JOIN + subquery (MySQL 5.x style)
SELECT 
  m1.conversation_id,
  u.name AS sender_name,
  m1.message_text,
  m1.sent_at
FROM 
  messages m1
JOIN users u ON m1.sender_id = u.id
JOIN (
  SELECT 
    conversation_id,
    MAX(sent_at) AS max_sent_at
  FROM 
    messages
  GROUP BY 
    conversation_id
) AS latest ON m1.conversation_id = latest.conversation_id AND m1.sent_at = latest.max_sent_at
ORDER BY m1.sent_at DESC;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE conversations;
DESCRIBE messages;
