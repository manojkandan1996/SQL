CREATE DATABASE multi_tenant_saas_db;
USE multi_tenant_saas_db;

CREATE TABLE tenants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    tenant_id INT,
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

CREATE TABLE data (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tenant_id INT,
    content VARCHAR(255),
    FOREIGN KEY (tenant_id) REFERENCES tenants(id)
);

INSERT INTO tenants (name) VALUES
('Tenant A'),
('Tenant B'),
('Tenant C');

INSERT INTO users (name, tenant_id) VALUES
('Alice', 1),
('Bob', 1),
('Charlie', 1),
('David', 1),
('Eve', 1),
('Frank', 2),
('Grace', 2),
('Hannah', 2),
('Ivy', 2),
('Jack', 2),
('Karen', 3),
('Leo', 3),
('Mona', 3),
('Nina', 3),
('Oscar', 3);

INSERT INTO data (tenant_id, content) VALUES
(1, 'Tenant A Data 1'),
(1, 'Tenant A Data 2'),
(1, 'Tenant A Data 3'),
(1, 'Tenant A Data 4'),
(1, 'Tenant A Data 5'),
(2, 'Tenant B Data 1'),
(2, 'Tenant B Data 2'),
(2, 'Tenant B Data 3'),
(2, 'Tenant B Data 4'),
(2, 'Tenant B Data 5'),
(2, 'Tenant B Data 6'),
(3, 'Tenant C Data 1'),
(3, 'Tenant C Data 2'),
(3, 'Tenant C Data 3'),
(3, 'Tenant C Data 4'),
(3, 'Tenant C Data 5'),
(3, 'Tenant C Data 6'),
(3, 'Tenant C Data 7'),
(3, 'Tenant C Data 8'),
(3, 'Tenant C Data 9'),
(3, 'Tenant C Data 10'),
(3, 'Tenant C Data 11'),
(3, 'Tenant C Data 12'),
(3, 'Tenant C Data 13');

--  Isolate data for a given tenant (e.g., Tenant B)
SELECT 
    d.id AS data_id,
    t.name AS tenant_name,
    d.content
FROM 
    data d
JOIN 
    tenants t ON d.tenant_id = t.id
WHERE 
    t.name = 'Tenant B'
ORDER BY 
    d.id;

--  Show all users grouped by tenant
SELECT 
    t.name AS tenant_name,
    u.name AS user_name
FROM 
    users u
JOIN 
    tenants t ON u.tenant_id = t.id
ORDER BY 
    t.name, u.name;

--  Count total data rows per tenant
SELECT 
    t.name AS tenant_name,
    COUNT(d.id) AS total_data_entries
FROM 
    tenants t
LEFT JOIN 
    data d ON t.id = d.tenant_id
GROUP BY 
    t.id, t.name
ORDER BY 
    total_data_entries DESC;

