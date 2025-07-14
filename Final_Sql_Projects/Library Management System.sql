CREATE DATABASE librarydb_db;
USE librarydb_db;

CREATE TABLE books (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  author VARCHAR(100) NOT NULL
);

CREATE TABLE members (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

CREATE TABLE borrows (
  id INT AUTO_INCREMENT PRIMARY KEY,
  member_id INT NOT NULL,
  book_id INT NOT NULL,
  borrow_date DATE NOT NULL,
  return_date DATE DEFAULT NULL,
  FOREIGN KEY (member_id) REFERENCES members(id) ON DELETE CASCADE,
  FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

INSERT INTO books (title, author) VALUES
('The Great Gatsby', 'F. Scott Fitzgerald'),
('1984', 'George Orwell'),
('To Kill a Mockingbird', 'Harper Lee'),
('Pride and Prejudice', 'Jane Austen'),
('Moby Dick', 'Herman Melville');

INSERT INTO members (name) VALUES
('Alice'),
('Bob'),
('Charlie'),
('David'),
('Eve');

--  Insert borrow transactions
INSERT INTO borrows (member_id, book_id, borrow_date, return_date) VALUES
(1, 1, '2025-07-01', '2025-07-10'),
(1, 2, '2025-07-05', NULL),
(2, 3, '2025-07-02', '2025-07-15'),
(2, 4, '2025-07-08', NULL),
(3, 5, '2025-07-03', '2025-07-12'),
(4, 1, '2025-07-04', NULL),
(5, 2, '2025-07-05', NULL);

--  JOIN: List all current borrowed books (not yet returned)
SELECT 
  b.id AS borrow_id,
  m.name AS member_name,
  bk.title AS book_title,
  bk.author,
  b.borrow_date,
  b.return_date
FROM 
  borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id
WHERE b.return_date IS NULL;

--  Calculate borrow duration & fine

SELECT 
  b.id AS borrow_id,
  m.name AS member_name,
  bk.title AS book_title,
  b.borrow_date,
  b.return_date,
  DATEDIFF(COALESCE(b.return_date, CURDATE()), b.borrow_date) AS days_borrowed,
  CASE
    WHEN DATEDIFF(COALESCE(b.return_date, CURDATE()), b.borrow_date) > 7
    THEN (DATEDIFF(COALESCE(b.return_date, CURDATE()), b.borrow_date) - 7) * 1
    ELSE 0
  END AS fine_amount
FROM 
  borrows b
JOIN members m ON b.member_id = m.id
JOIN books bk ON b.book_id = bk.id
ORDER BY b.borrow_date;

-- Who borrowed a specific book?
SELECT 
  bk.title,
  m.name AS member_name,
  b.borrow_date,
  b.return_date
FROM 
  borrows b
JOIN books bk ON b.book_id = bk.id
JOIN members m ON b.member_id = m.id
WHERE bk.title = '1984';

-- Check structure
SHOW TABLES;
DESCRIBE books;
DESCRIBE members;
DESCRIBE borrows;
