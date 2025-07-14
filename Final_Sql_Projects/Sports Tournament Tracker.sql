CREATE DATABASE tournament_db;
USE tournament_db;

CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE matches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    team1_id INT,
    team2_id INT,
    match_date DATE,
    FOREIGN KEY (team1_id) REFERENCES teams(id),
    FOREIGN KEY (team2_id) REFERENCES teams(id)
);

CREATE TABLE scores (
    match_id INT,
    team_id INT,
    score INT,
    PRIMARY KEY (match_id, team_id),
    FOREIGN KEY (match_id) REFERENCES matches(id),
    FOREIGN KEY (team_id) REFERENCES teams(id)
);

INSERT INTO teams (name) VALUES
('Lions'),
('Tigers'),
('Bears'),
('Wolves'),
('Eagles'),
('Sharks'),
('Panthers'),
('Rhinos');

INSERT INTO matches (team1_id, team2_id, match_date) VALUES
(1, 2, '2025-07-01'),
(3, 4, '2025-07-01'),
(5, 6, '2025-07-02'),
(7, 8, '2025-07-02'),
(1, 3, '2025-07-03'),
(2, 4, '2025-07-03'),
(5, 7, '2025-07-04'),
(6, 8, '2025-07-04'),
(1, 4, '2025-07-05'),
(2, 3, '2025-07-05'),
(5, 8, '2025-07-06'),
(6, 7, '2025-07-06');

INSERT INTO scores (match_id, team_id, score) VALUES
(1, 1, 21), (1, 2, 14),
(2, 3, 10), (2, 4, 10),
(3, 5, 17), (3, 6, 20),
(4, 7, 22), (4, 8, 18),
(5, 1, 19), (5, 3, 17),
(6, 2, 25), (6, 4, 20),
(7, 5, 15), (7, 7, 21),
(8, 6, 13), (8, 8, 15),
(9, 1, 18), (9, 4, 22),
(10, 2, 20), (10, 3, 23),
(11, 5, 19), (11, 8, 21),
(12, 6, 22), (12, 7, 24);

--  Win/Loss stats for each team
SELECT
    t.id AS team_id,
    t.name AS team_name,
    SUM(
        CASE 
            WHEN s.score > opp.score THEN 1
            ELSE 0
        END
    ) AS wins,
    SUM(
        CASE 
            WHEN s.score < opp.score THEN 1
            ELSE 0
        END
    ) AS losses,
    SUM(
        CASE 
            WHEN s.score = opp.score THEN 1
            ELSE 0
        END
    ) AS draws
FROM
    teams t
JOIN
    scores s ON t.id = s.team_id
JOIN
    scores opp ON s.match_id = opp.match_id AND s.team_id != opp.team_id
GROUP BY
    t.id, t.name
ORDER BY
    wins DESC;

--  Leaderboard: teams ranked by number of wins
SELECT
    t.name AS team_name,
    COUNT(*) AS total_wins
FROM
    teams t
JOIN
    scores s ON t.id = s.team_id
JOIN
    scores opp ON s.match_id = opp.match_id AND s.team_id != opp.team_id
WHERE
    s.score > opp.score
GROUP BY
    t.id, t.name
ORDER BY
    total_wins DESC;

--  Full match results with winner
SELECT
    m.id AS match_id,
    t1.name AS team1,
    s1.score AS team1_score,
    t2.name AS team2,
    s2.score AS team2_score,
    CASE
        WHEN s1.score > s2.score THEN t1.name
        WHEN s2.score > s1.score THEN t2.name
        ELSE 'Draw'
    END AS winner
FROM
    matches m
JOIN
    scores s1 ON m.id = s1.match_id AND m.team1_id = s1.team_id
JOIN
    scores s2 ON m.id = s2.match_id AND m.team2_id = s2.team_id
JOIN
    teams t1 ON m.team1_id = t1.id
JOIN
    teams t2 ON m.team2_id = t2.id
ORDER BY
    m.id;
