CREATE DATABASE donation_db;
USE donation_db;

CREATE TABLE donors (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE causes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL
);

CREATE TABLE donations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  donor_id INT NOT NULL,
  cause_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),
  donated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (donor_id) REFERENCES donors(id) ON DELETE CASCADE,
  FOREIGN KEY (cause_id) REFERENCES causes(id) ON DELETE CASCADE
);

INSERT INTO donors (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO causes (title) VALUES
('Education Fund'),
('Medical Aid'),
('Disaster Relief'),
('Environmental Protection');

INSERT INTO donations (donor_id, cause_id, amount, donated_at) VALUES
(1, 1, 100.00, '2025-07-01 10:00:00'),
(2, 1, 200.00, '2025-07-01 11:00:00'),
(3, 2, 150.00, '2025-07-02 09:00:00'),
(1, 3, 250.00, '2025-07-02 10:00:00'),
(2, 3, 300.00, '2025-07-02 11:00:00'),
(3, 4, 50.00,  '2025-07-03 12:00:00');

--  Get total donations per cause
SELECT
  c.title AS cause_title,
  SUM(d.amount) AS total_donated
FROM
  donations d
JOIN causes c ON d.cause_id = c.id
GROUP BY c.id
ORDER BY c.title;

--  Rank causes by total funds raised (descending)
SELECT
  c.title AS cause_title,
  SUM(d.amount) AS total_donated,
  RANK() OVER (ORDER BY SUM(d.amount) DESC) AS cause_rank
FROM
  donations d
JOIN causes c ON d.cause_id = c.id
GROUP BY c.id
ORDER BY total_donated DESC;

-- See all donations with donor, cause, and date
SELECT
  dn.name AS donor_name,
  cs.title AS cause_title,
  d.amount,
  d.donated_at
FROM
  donations d
JOIN donors dn ON d.donor_id = dn.id
JOIN causes cs ON d.cause_id = cs.id
ORDER BY d.donated_at;

-- Check structure
SHOW TABLES;
DESCRIBE donors;
DESCRIBE causes;
DESCRIBE donations;
