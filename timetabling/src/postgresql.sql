-- Sourcecode for PostgreSQL


CREATE DATABASE UnderstandingSQL;
USE UnderstandingSQL
CREATE SCHEMA timetabling;

CREATE TABLE timetabling.customer
(
    id SERIAL PRIMARY KEY,
    lastname VARCHAR(255),
    firstname VARCHAR(255)
);

CREATE TABLE timetabling.trainer
(
    id SERIAL PRIMARY KEY,
    lastname VARCHAR(255),
    firstname VARCHAR(255)
);

CREATE TABLE timetabling.booking
(
    id SERIAL PRIMARY KEY,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    trainer_id INT,
    customer_id INT,
    FOREIGN KEY (trainer_id) REFERENCES Timetabling.trainer(id),
    FOREIGN KEY (customer_id) REFERENCES Timetabling.customer(id)
);

-- Timeslot trainer
CREATE TABLE timetabling.timeslots
(
    id SERIAL PRIMARY KEY,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    trainer_id INT,
    FOREIGN KEY (trainer_id) REFERENCES Timetabling.trainer(id)
)

--Some data
INSERT INTO timetabling.customer
    (lastname, firstname)
VALUES
    ('White', 'Jack'),
    ('Black', 'Emily'),
    ('Cook', 'Thomas'),
    ('Day', 'Oscar');

INSERT INTO timetabling.trainer (lastname, firstname)
VALUES
('Mills', 'Daniel'),
('Thompason', 'Harry'),
('Watts', 'Jessica'),
('McNab', 'Mia');

-- Generate Timeslot for trainer
;WITH RECURSIVE
    cte
    AS
    (
        SELECT
                date_trunc('hour',now()) AS StartRange,
                date_trunc('hour', now() + INTERVAL '1 hour') AS EndRange
        UNION ALL
            SELECT
                EndRange,
                EndRange + INTERVAL '1 hour'
        FROM cte
            WHERE EndRange <  now() + INTERVAL '30 days'
    )
INSERT INTO Timetabling.timeslots
    (start_date, end_date, trainer_id)
SELECT StartRange, EndRange, round(random()*(4-1)+1)
FROM cte
WHERE EXTRACT(DOW FROM StartRange) NOT IN (0, 6)
    AND EXTRACT(HOUR FROM StartRange) >= 8
    AND EXTRACT(HOUR FROM StartRange) <= 19
ORDER BY RANDOM()
LIMIT 100



-- Generate random bookings
;WITH RECURSIVE
    cte
    AS
(
        SELECT
    date_trunc('hour',now()) AS StartRange,
    date_trunc('hour', now() + INTERVAL '1 hour')
AS EndRange
        UNION ALL
SELECT
    EndRange,
    EndRange + INTERVAL '1 hour'
FROM cte
WHERE EndRange <  now() + INTERVAL '30 days'
    )
INSERT INTO Timetabling.booking
    (start_date, end_date, trainer_id, customer_id)
SELECT StartRange, EndRange, round(random()*(4-1)+1), round(random()*(4-1)+1)
FROM cte
WHERE EXTRACT(DOW FROM StartRange) NOT IN (0, 6)
    AND EXTRACT(HOUR FROM StartRange) >= 8
    AND EXTRACT(HOUR FROM StartRange) <= 19
ORDER BY RANDOM()
LIMIT 100