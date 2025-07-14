CREATE DATABASE invoice_db;
USE invoice_db;

CREATE TABLE clients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE invoices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL,
  date DATE NOT NULL,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

CREATE TABLE invoice_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  invoice_id INT NOT NULL,
  description VARCHAR(255) NOT NULL,
  quantity INT NOT NULL,
  rate DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
);

INSERT INTO clients (name) VALUES
('Acme Corp'),
('Beta Ltd'),
('Gamma Inc');

INSERT INTO invoices (client_id, date) VALUES
(1, '2025-07-10'),
(1, '2025-07-15'),
(2, '2025-07-12');

INSERT INTO invoice_items (invoice_id, description, quantity, rate) VALUES
(1, 'Website Design', 1, 1200.00),
(1, 'Hosting (12 months)', 12, 10.00),
(1, 'Domain Registration', 1, 15.00),
(2, 'SEO Optimization', 1, 500.00),
(2, 'Maintenance (6 months)', 6, 50.00),
(3, 'Consulting Hours', 10, 75.00),
(3, 'Custom Report', 1, 200.00);

--  JOIN: View invoice with items and subtotal per item
SELECT 
  i.id AS invoice_id,
  c.name AS client_name,
  i.date,
  ii.description,
  ii.quantity,
  ii.rate,
  (ii.quantity * ii.rate) AS line_subtotal
FROM 
  invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
ORDER BY i.id, ii.id;

--  Calculate invoice total amount
SELECT
  i.id AS invoice_id,
  c.name AS client_name,
  i.date,
  SUM(ii.quantity * ii.rate) AS invoice_total
FROM
  invoices i
JOIN clients c ON i.client_id = c.id
JOIN invoice_items ii ON i.id = ii.invoice_id
GROUP BY i.id, c.name, i.date
ORDER BY i.id;

-- Check structure
SHOW TABLES;
DESCRIBE clients;
DESCRIBE invoices;
DESCRIBE invoice_items;
