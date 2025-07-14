CREATE DATABASE freelance_project_db;
USE freelance_project_db;

CREATE TABLE freelancers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    skill VARCHAR(100) NOT NULL
);

CREATE TABLE projects (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_name VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL
);

CREATE TABLE proposals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    freelancer_id INT,
    project_id INT,
    bid_amount DECIMAL(10,2),
    status VARCHAR(50),  -- e.g., Pending, Accepted, Rejected
    FOREIGN KEY (freelancer_id) REFERENCES freelancers(id),
    FOREIGN KEY (project_id) REFERENCES projects(id)
);

INSERT INTO freelancers (name, skill) VALUES
('Alice', 'Web Development'),
('Bob', 'Graphic Design'),
('Charlie', 'Mobile App Development'),
('David', 'Content Writing'),
('Eve', 'SEO Specialist');

INSERT INTO projects (client_name, title) VALUES
('Client A', 'Website Redesign'),
('Client B', 'Logo Design'),
('Client C', 'Mobile App Revamp'),
('Client D', 'Blog Articles'),
('Client E', 'SEO Optimization'),
('Client F', 'E-commerce Platform'),
('Client G', 'Brand Identity'),
('Client H', 'Landing Page Design'),
('Client I', 'Product Brochure'),
('Client J', 'Social Media Campaign');

INSERT INTO proposals (freelancer_id, project_id, bid_amount, status) VALUES
(1, 1, 1500.00, 'Accepted'),
(2, 2, 500.00, 'Accepted'),
(3, 3, 2000.00, 'Pending'),
(4, 4, 300.00, 'Accepted'),
(5, 5, 700.00, 'Pending'),
(1, 6, 2500.00, 'Pending'),
(2, 7, 800.00, 'Rejected'),
(3, 8, 1200.00, 'Accepted'),
(4, 9, 400.00, 'Accepted'),
(5, 10, 900.00, 'Pending'),
(1, 2, 550.00, 'Rejected'),
(2, 3, 1800.00, 'Pending'),
(3, 4, 350.00, 'Accepted'),
(4, 5, 750.00, 'Accepted'),
(5, 6, 2600.00, 'Rejected'),
(1, 7, 900.00, 'Pending'),
(2, 8, 1100.00, 'Accepted'),
(3, 9, 450.00, 'Pending'),
(4, 10, 950.00, 'Accepted'),
(5, 1, 1600.00, 'Pending'),
(1, 3, 1900.00, 'Accepted'),
(2, 5, 600.00, 'Pending');

-- Count of unique projects per freelancer (accepted proposals)
SELECT 
    f.name AS freelancer_name,
    COUNT(DISTINCT p.project_id) AS projects_count
FROM 
    freelancers f
JOIN 
    proposals p ON f.id = p.freelancer_id
WHERE 
    p.status = 'Accepted'
GROUP BY 
    f.id, f.name
ORDER BY 
    projects_count DESC;

-- Show all proposals with status
SELECT 
    f.name AS freelancer_name,
    f.skill,
    pr.client_name,
    p.title AS project_title,
    prop.bid_amount,
    prop.status
FROM 
    proposals prop
JOIN 
    freelancers f ON prop.freelancer_id = f.id
JOIN 
    projects p ON prop.project_id = p.id
JOIN 
    projects pr ON p.id = pr.id
ORDER BY 
    f.name;

-- Total bid amount per freelancer for accepted proposals
SELECT 
    f.name AS freelancer_name,
    SUM(prop.bid_amount) AS total_earned
FROM 
    freelancers f
JOIN 
    proposals prop ON f.id = prop.freelancer_id
WHERE 
    prop.status = 'Accepted'
GROUP BY 
    f.id, f.name
ORDER BY 
    total_earned DESC;

-- Proposals pending review
SELECT 
    f.name AS freelancer_name,
    p.title AS project_title,
    prop.bid_amount
FROM 
    proposals prop
JOIN 
    freelancers f ON prop.freelancer_id = f.id
JOIN 
    projects p ON prop.project_id = p.id
WHERE 
    prop.status = 'Pending'
ORDER BY 
    prop.bid_amount DESC;

