CREATE DATABASE bankdb_db;
USE bankdb_db;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE accounts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT NOT NULL,
  type ENUM('deposit', 'withdrawal') NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO accounts (user_id, balance) VALUES
(1, 0.00),
(2, 0.00),
(3, 0.00);

INSERT INTO transactions (account_id, type, amount, timestamp) VALUES
(1, 'deposit', 1000.00, '2025-07-01 09:00:00'),
(1, 'withdrawal', 200.00, '2025-07-02 10:00:00'),
(1, 'deposit', 500.00, '2025-07-03 11:00:00'),
(2, 'deposit', 1500.00, '2025-07-01 09:30:00'),
(2, 'withdrawal', 300.00, '2025-07-02 10:30:00'),
(3, 'deposit', 2000.00, '2025-07-01 10:00:00'),
(3, 'withdrawal', 500.00, '2025-07-03 12:00:00');

--  CTE: Calculate running balance for each account
WITH tx AS (
  SELECT 
    t.account_id,
    t.id AS transaction_id,
    t.type,
    t.amount,
    t.timestamp,
    CASE WHEN t.type = 'deposit' THEN t.amount ELSE -t.amount END AS signed_amount
  FROM transactions t
),
tx_with_balance AS (
  SELECT
    tx.account_id,
    tx.transaction_id,
    tx.type,
    tx.amount,
    tx.timestamp,
    SUM(tx.signed_amount) OVER (
      PARTITION BY tx.account_id
      ORDER BY tx.timestamp, tx.transaction_id
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_balance
  FROM tx
)
SELECT 
  u.name AS user_name,
  a.id AS account_id,
  tx_with_balance.transaction_id,
  tx_with_balance.type,
  tx_with_balance.amount,
  tx_with_balance.timestamp,
  tx_with_balance.running_balance
FROM 
  tx_with_balance
JOIN accounts a ON tx_with_balance.account_id = a.id
JOIN users u ON a.user_id = u.id
ORDER BY 
  account_id, timestamp;

-- Update account balances with final totals
UPDATE accounts a
JOIN (
  SELECT 
    account_id, 
    SUM(CASE WHEN type = 'deposit' THEN amount ELSE -amount END) AS balance_calc
  FROM transactions
  GROUP BY account_id
) t ON a.id = t.account_id
SET a.balance = t.balance_calc;

-- Check final account balances
SELECT 
  u.name AS user_name,
  a.id AS account_id,
  a.balance AS current_balance
FROM 
  accounts a
JOIN users u ON a.user_id = u.id;

--  See full transaction log
SELECT 
  u.name AS user_name,
  a.id AS account_id,
  t.type,
  t.amount,
  t.timestamp
FROM 
  transactions t
JOIN accounts a ON t.account_id = a.id
JOIN users u ON a.user_id = u.id
ORDER BY 
  account_id, t.timestamp;

-- Check structure
SHOW TABLES;
DESCRIBE users;
DESCRIBE accounts;
DESCRIBE transactions;
