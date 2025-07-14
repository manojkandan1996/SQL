CREATE DATABASE DBmovie_db;
USE DBmovie_db;

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    release_year INT,
    genre_id INT,
    FOREIGN KEY (genre_id) REFERENCES genres(id)
);

CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    score DECIMAL(3,1),
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

INSERT INTO genres (name) VALUES 
('Action'),
('Drama'),
('Comedy'),
('Sci-Fi');


INSERT INTO movies (title, release_year, genre_id) VALUES
('Inception', 2010, 4),   
('The Dark Knight', 2008, 1), 
('Forrest Gump', 1994, 2), 
('The Hangover', 2009, 3); 


INSERT INTO ratings (user_id, movie_id, score) VALUES
(1, 1, 9.0),
(2, 1, 8.5),
(3, 1, 9.5),
(1, 2, 9.7),
(2, 2, 9.0),
(3, 2, 9.2),
(1, 3, 8.0),
(2, 3, 8.5),
(1, 4, 7.5);

-- Average rating per movie
SELECT 
    m.id,
    m.title,
    ROUND(AVG(r.score), 2) AS avg_rating
FROM 
    movies m
JOIN 
    ratings r ON m.id = r.movie_id
GROUP BY 
    m.id, m.title
ORDER BY 
    avg_rating DESC;

-- Movies with genre and average rating
SELECT 
    m.title,
    g.name AS genre,
    ROUND(AVG(r.score), 2) AS avg_rating
FROM 
    movies m
JOIN 
    genres g ON m.genre_id = g.id
LEFT JOIN 
    ratings r ON m.id = r.movie_id
GROUP BY 
    m.id, m.title, g.name
ORDER BY 
    avg_rating DESC;

-- Top-rated movies in 'Action' genre
SELECT 
    m.title,
    g.name AS genre,
    ROUND(AVG(r.score), 2) AS avg_rating
FROM 
    movies m
JOIN 
    genres g ON m.genre_id = g.id
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    g.name = 'Action'
GROUP BY 
    m.id, m.title, g.name
ORDER BY 
    avg_rating DESC;
