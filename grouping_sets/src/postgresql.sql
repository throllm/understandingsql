-- Sourcecode for PostgreSQL


CREATE DATABASE UnderstandingSQL;
USE UnderstandingSQL
CREATE SCHEMA Groupingsets;

CREATE TABLE Groupingsets.employee
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    role VARCHAR(255),
    department VARCHAR(255),
    gender VARCHAR(20),
    salary INT
);

INSERT INTO Groupingsets.employee
    (name, role, department, gender, salary)
VALUES
    ('Mike', 'Manager', 'Finance', 'Male', 3000),
    ('Thomas', 'Manager', 'Sales', 'Male', 3500),
    ('Sophia', 'Manager', 'Sales', 'Male', 3600),    
    ('Susan', 'Office Staff', 'Finance', 'Female', 3000),
    ('Tom', 'Driver', 'Finance', 'Male', 2800),
    ('Andrew', 'Driver', 'Sales', 'Male', 2600);

SELECT * FROM Groupingsets.employee;

SELECT department, role, gender, count(*) as count, round(avg(salary),0) AS average_salary
 FROM Groupingsets.employee
 GROUP BY GROUPING SETS (department, role, gender, ()) ORDER BY department NULLS LAST, role;

SELECT department, role, gender, count(*), round(avg(salary),0) AS average_salary
 FROM Groupingsets.employee
 GROUP BY CUBE (department, role, gender) order by department NULLS last, role NULLS LAST;
 
SELECT department, role, gender, count(*), round(avg(salary),0) AS average_salary
 FROM Groupingsets.employee
 GROUP BY ROLLUP (department, role, gender);
