CREATE DATABASE notification_db;
USE notification_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  message VARCHAR(255) NOT NULL,
  status ENUM('Unread', 'Read') DEFAULT 'Unread',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO notifications (user_id, message, status, created_at) VALUES
(1, 'Welcome to our platform!', 'Unread', '2025-07-01 08:00:00'),
(1, 'Your profile was viewed.', 'Unread', '2025-07-01 09:00:00'),
(1, 'You have a new follower.', 'Read', '2025-07-01 10:00:00'),
(1, 'Your password was changed.', 'Read', '2025-07-02 11:00:00'),
(1, 'Weekly summary is ready.', 'Unread', '2025-07-03 12:00:00'),
(1, 'Your subscription is expiring.', 'Unread', '2025-07-04 13:00:00'),
(2, 'Welcome Bob!', 'Unread', '2025-07-01 08:00:00'),
(2, 'New comment on your post.', 'Unread', '2025-07-02 09:30:00'),
(2, 'Friend request accepted.', 'Read', '2025-07-03 10:00:00'),
(2, 'Your settings were updated.', 'Read', '2025-07-04 11:00:00'),
(2, 'Monthly report available.', 'Unread', '2025-07-05 12:00:00'),
(2, 'New login detected.', 'Unread', '2025-07-06 13:00:00'),
(3, 'Welcome Charlie!', 'Unread', '2025-07-01 08:00:00'),
(3, 'System maintenance scheduled.', 'Unread', '2025-07-01 09:00:00'),
(3, 'New message received.', 'Unread', '2025-07-01 10:00:00'),
(3, 'Profile update successful.', 'Read', '2025-07-02 11:00:00'),
(3, 'Security alert.', 'Unread', '2025-07-03 12:00:00'),
(3, 'Weekly insights ready.', 'Unread', '2025-07-04 13:00:00'),
(1, 'You have been mentioned.', 'Unread', '2025-07-05 14:00:00'),
(1, 'A new badge unlocked.', 'Unread', '2025-07-06 15:00:00'),
(2, 'System update complete.', 'Unread', '2025-07-07 16:00:00'),
(2, 'Upcoming event reminder.', 'Unread', '2025-07-08 17:00:00'),
(3, 'Survey invitation.', 'Unread', '2025-07-09 18:00:00'),
(3, 'Team meeting at 3 PM.', 'Unread', '2025-07-10 19:00:00');

--  Query: Get unread count per user
SELECT
  u.name AS user_name,
  COUNT(n.id) AS unread_count
FROM 
  users u
LEFT JOIN notifications n ON u.id = n.user_id AND n.status = 'Unread'
GROUP BY u.id;

--  Mark all notifications as read for a user (example: Alice)
UPDATE notifications
SET status = 'Read'
WHERE user_id = 1 AND status = 'Unread';

--  Get latest notifications for a user (example: Bob)
SELECT
  n.id,
  u.name AS user_name,
  n.message,
  n.status,
  n.created_at
FROM 
  notifications n
JOIN users u ON n.user_id = u.id
WHERE u.name = 'Bob'
ORDER BY n.created_at DESC
LIMIT 10;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE notifications;
