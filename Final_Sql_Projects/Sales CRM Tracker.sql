CREATE DATABASE sales_crm_db;
USE sales_crm_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE leads (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  source VARCHAR(100) NOT NULL
);

CREATE TABLE deals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  lead_id INT NOT NULL,
  user_id INT NOT NULL,
  stage ENUM('New', 'Contacted', 'Qualified', 'Proposal', 'Won', 'Lost') DEFAULT 'New',
  amount DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  created_at DATE NOT NULL,
  FOREIGN KEY (lead_id) REFERENCES leads(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'), ('Bob'), ('Charlie');

INSERT INTO leads (name, source) VALUES
('Acme Corp', 'Website'),
('Beta Inc', 'Referral'),
('Gamma LLC', 'Cold Call'),
('Delta Co', 'Website'),
('Echo Ltd', 'Social Media'),
('Foxtrot Solutions', 'Website'),
('Golf Industries', 'Cold Call'),
('Hotel Group', 'Referral'),
('India Tech', 'Trade Show'),
('Juliet Partners', 'Social Media');

INSERT INTO deals (lead_id, user_id, stage, amount, created_at) VALUES
(1, 1, 'New', 5000, '2025-07-01'),
(2, 1, 'Contacted', 7500, '2025-07-02'),
(3, 2, 'Qualified', 12000, '2025-07-03'),
(4, 2, 'Proposal', 15000, '2025-07-04'),
(5, 3, 'Won', 20000, '2025-07-05'),
(6, 3, 'Lost', 8000, '2025-07-06'),
(7, 1, 'New', 6000, '2025-07-07'),
(8, 1, 'Contacted', 7000, '2025-07-08'),
(9, 2, 'Qualified', 10000, '2025-07-09'),
(10, 3, 'Proposal', 14000, '2025-07-10'),
(1, 2, 'Won', 25000, '2025-07-11'),
(2, 3, 'Lost', 5000, '2025-07-12'),
(3, 1, 'New', 4000, '2025-07-13'),
(4, 2, 'Contacted', 6000, '2025-07-14'),
(5, 3, 'Qualified', 11000, '2025-07-15'),
(6, 1, 'Proposal', 9000, '2025-07-16'),
(7, 2, 'Won', 30000, '2025-07-17'),
(8, 3, 'Lost', 2000, '2025-07-18'),
(9, 1, 'New', 5000, '2025-07-19'),
(10, 2, 'Contacted', 5500, '2025-07-20'),
(1, 3, 'Qualified', 8000, '2025-07-21'),
(2, 1, 'Proposal', 13000, '2025-07-22'),
(3, 2, 'Won', 22000, '2025-07-23');

--  Example: Use CTE & window function to track deal progression per user

WITH deal_progress AS (
  SELECT 
    d.id AS deal_id,
    u.name AS sales_rep,
    l.name AS lead_name,
    d.stage,
    d.amount,
    d.created_at,
    ROW_NUMBER() OVER (PARTITION BY d.user_id ORDER BY d.created_at) AS deal_sequence
  FROM 
    deals d
    JOIN users u ON d.user_id = u.id
    JOIN leads l ON d.lead_id = l.id
)
SELECT * FROM deal_progress
ORDER BY sales_rep, deal_sequence;

--  Pipeline summary: total amount per stage
SELECT 
  stage,
  COUNT(*) AS deal_count,
  SUM(amount) AS total_pipeline
FROM deals
GROUP BY stage
ORDER BY FIELD(stage, 'New', 'Contacted', 'Qualified', 'Proposal', 'Won', 'Lost');

--  Filter deals by stage and date range (e.g., active pipeline in July)
SELECT 
  d.id,
  l.name AS lead_name,
  u.name AS sales_rep,
  d.stage,
  d.amount,
  d.created_at
FROM 
  deals d
  JOIN leads l ON d.lead_id = l.id
  JOIN users u ON d.user_id = u.id
WHERE 
  d.stage NOT IN ('Won', 'Lost') -- Active deals only
  AND d.created_at BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY d.created_at;

--  Verify structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE leads;
DESCRIBE deals;
