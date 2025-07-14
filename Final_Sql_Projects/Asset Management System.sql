CREATE DATABASE asset_management_db;
USE asset_management_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE assets (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(100)
);

CREATE TABLE assignments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    asset_id INT,
    user_id INT,
    assigned_date DATE,
    returned_date DATE NULL,
    FOREIGN KEY (asset_id) REFERENCES assets(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO users (name) VALUES
('Alice'),
('Bob'),
('Charlie');

INSERT INTO assets (name, category) VALUES
('Laptop Dell XPS', 'Laptop'),
('Monitor Samsung', 'Monitor'),
('Keyboard Logitech', 'Peripheral'),
('Laptop MacBook Pro', 'Laptop');

INSERT INTO assignments (asset_id, user_id, assigned_date, returned_date)
VALUES (1, 1, '2025-07-01', NULL);

INSERT INTO assignments (asset_id, user_id, assigned_date, returned_date)
VALUES (2, 2, '2025-06-15', '2025-07-01');

INSERT INTO assignments (asset_id, user_id, assigned_date, returned_date)
VALUES (3, 3, '2025-07-05', NULL);

INSERT INTO assignments (asset_id, user_id, assigned_date, returned_date)
VALUES (4, 1, '2025-06-01', '2025-07-01');

--  Assets currently assigned (not returned yet)
SELECT 
    a.id AS asset_id,
    a.name AS asset_name,
    u.name AS assigned_to,
    assign.assigned_date
FROM 
    assets a
JOIN 
    assignments assign ON a.id = assign.asset_id
JOIN 
    users u ON assign.user_id = u.id
WHERE 
    assign.returned_date IS NULL;

--  Assets currently available (not assigned or returned)
SELECT 
    a.id AS asset_id,
    a.name AS asset_name,
    a.category
FROM 
    assets a
LEFT JOIN (
    SELECT asset_id 
    FROM assignments 
    WHERE returned_date IS NULL
) AS active_assignments ON a.id = active_assignments.asset_id
WHERE 
    active_assignments.asset_id IS NULL;

--  Full assignment history for all assets
SELECT 
    a.name AS asset_name,
    u.name AS user_name,
    assign.assigned_date,
    assign.returned_date
FROM 
    assignments assign
JOIN 
    assets a ON assign.asset_id = a.id
JOIN 
    users u ON assign.user_id = u.id
ORDER BY 
    a.id, assign.assigned_date;

--  Current holder of a specific asset (e.g., Laptop Dell XPS)
SELECT 
    a.name AS asset_name,
    u.name AS `current_user`,
    assign.assigned_date
FROM 
    assets a
JOIN 
    assignments assign ON a.id = assign.asset_id
JOIN 
    users u ON assign.user_id = u.id
WHERE 
    assign.returned_date IS NULL
    AND a.name = 'Laptop Dell XPS';
