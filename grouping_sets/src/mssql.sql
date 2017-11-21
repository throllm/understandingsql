-- Sourcecode for MS SQL SERVER

CREATE SCHEMA Groupingsets;


CREATE TABLE Groupingsets.employee
(
    id INTEGER IDENTITY (1,1) PRIMARY KEY,
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

SELECT department, role, gender, count(*) as count, avg(salary) AS average_salary
 FROM Groupingsets.employee
 GROUP BY GROUPING SETS (department, role, gender, ()) ORDER BY case when department is null then 1 else 0
end, department, case when role is null then 1 else 0
end, role;

SELECT department, role, gender, count(*), avg(salary) AS average_salary, sum(salary)
 FROM Groupingsets.employee
 GROUP BY CUBE (department, role, gender) ORDER BY case when department is null then 1 else 0
end, department, case when role is null then 1 else 0
end, role;
 
SELECT department, role, gender, count(*), avg(salary) AS average_salary, sum (salary)
 FROM Groupingsets.employee
 GROUP BY ROLLUP (department, role, gender);