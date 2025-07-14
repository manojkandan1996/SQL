CREATE DATABASE vehicle_rental_db;
USE vehicle_rental_db;

CREATE TABLE vehicles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(50) NOT NULL,  -- e.g., Car, Bike, Van
    plate_number VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE rentals (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT,
    customer_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

INSERT INTO vehicles (type, plate_number) VALUES
('Car', 'ABC-123'),
('Car', 'XYZ-789'),
('Car', 'DEF-456'),
('Bike', 'BIKE-001'),
('Bike', 'BIKE-002'),
('Van', 'VAN-101'),
('Van', 'VAN-202');

INSERT INTO customers (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve');

INSERT INTO rentals (vehicle_id, customer_id, start_date, end_date) VALUES
(1, 1, '2025-07-10', '2025-07-12'),
(2, 2, '2025-07-11', '2025-07-13'),
(3, 3, '2025-07-12', '2025-07-15'),
(4, 4, '2025-07-10', '2025-07-11'),
(5, 5, '2025-07-10', '2025-07-12'),
(6, 1, '2025-07-11', '2025-07-13'),
(7, 2, '2025-07-11', '2025-07-14'),
(1, 3, '2025-07-15', '2025-07-17'),
(2, 4, '2025-07-14', '2025-07-16'),
(3, 5, '2025-07-16', '2025-07-18'),
(4, 1, '2025-07-12', '2025-07-14'),
(5, 2, '2025-07-13', '2025-07-15'),
(6, 3, '2025-07-14', '2025-07-17'),
(7, 4, '2025-07-15', '2025-07-19'),
(1, 5, '2025-07-17', '2025-07-19'),
(2, 1, '2025-07-18', '2025-07-20'),
(3, 2, '2025-07-19', '2025-07-21'),
(4, 3, '2025-07-20', '2025-07-22'),
(5, 4, '2025-07-21', '2025-07-23'),
(6, 5, '2025-07-22', '2025-07-24'),
(7, 1, '2025-07-23', '2025-07-25'),
(1, 2, '2025-07-24', '2025-07-26'),
(2, 3, '2025-07-25', '2025-07-27'),
(3, 4, '2025-07-26', '2025-07-28');

--  Duration-based charge calculation
SELECT 
    c.name AS customer_name,
    v.plate_number,
    v.type,
    r.start_date,
    r.end_date,
    DATEDIFF(r.end_date, r.start_date) + 1 AS rental_days,
    CASE 
        WHEN v.type = 'Car' THEN (DATEDIFF(r.end_date, r.start_date) + 1) * 50
        WHEN v.type = 'Bike' THEN (DATEDIFF(r.end_date, r.start_date) + 1) * 20
        WHEN v.type = 'Van' THEN (DATEDIFF(r.end_date, r.start_date) + 1) * 70
        ELSE 0
    END AS total_charge
FROM 
    rentals r
JOIN 
    vehicles v ON r.vehicle_id = v.id
JOIN 
    customers c ON r.customer_id = c.id
ORDER BY 
    r.start_date;

-- Check available vehicles for a given date range
SELECT 
    v.id,
    v.type,
    v.plate_number
FROM 
    vehicles v
WHERE NOT EXISTS (
    SELECT 1 
    FROM rentals r 
    WHERE r.vehicle_id = v.id
      AND (
            r.start_date <= '2025-07-14' AND r.end_date >= '2025-07-12'
          )
)
ORDER BY 
    v.type;

-- Show all rentals with vehicle and customer details
SELECT 
    c.name AS customer_name,
    v.plate_number,
    v.type,
    r.start_date,
    r.end_date
FROM 
    rentals r
JOIN 
    vehicles v ON r.vehicle_id = v.id
JOIN 
    customers c ON r.customer_id = c.id
ORDER BY 
    r.start_date;

