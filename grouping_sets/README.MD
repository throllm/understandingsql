# SQL GROUPING SETS, CUBE, ROLLUP

Advance:
* simplify your code (instead of UNION ALL)
* improve the performance 

SQL Feature | Postgresql | MS SQL Server | MySQL | SQLite |
------------|:----------:|:----------:|:----------:|:----------:|
GROUPING SETS | [>9.5](https://www.postgresql.org/docs/current/static/queries-table-expressions.html#QUERIES-GROUPING-SETS) | [X](https://technet.microsoft.com/en-us/library/bb522495(v=sql.105).aspx) |  - | - |
CUBE | [>9.5](https://www.postgresql.org/docs/current/static/queries-table-expressions.html#QUERIES-GROUPING-SETS) | [X](https://technet.microsoft.com/en-us/library/bb522495(v=sql.105).aspx) |  - | - | 
ROLLUP | [>9.5](https://www.postgresql.org/docs/current/static/queries-table-expressions.html#QUERIES-GROUPING-SETS) | [X](https://technet.microsoft.com/en-us/library/bb522495(v=sql.105).aspx) |  - | - | 


## Base Table
| id | name   | role         | department | gender | 
|----|--------|--------------|------------|--------| 
| 1  | Mike   | Manager      | Finance    | Male   | 
| 2  | Thomas | Manager      | Sales      | Male   | 
| 3  | Susan  | Office Staff | Finance    | Female | 
| 4  | Tom    | Driver       | Finance    | Male   | 


## GROUPING SETS
    (TSQL)
    SELECT department, role, gender, count(*) as count, avg(salary) AS average_salary
     FROM Groupingsets.employee
     GROUP BY GROUPING SETS (department, role, gender, ()) ORDER BY case when department is null then 1 else 0
         end, department, case when role is null then 1 else 0 end, role;

| department | role         | gender | count | average_salary | 
|------------|--------------|--------|-------|----------------| 
| Finance    | NULL         | NULL   | 3     | 2933           | 
| Sales      | NULL         | NULL   | 3     | 3233           | 
| NULL       | Driver       | NULL   | 2     | 2700           | 
| NULL       | Manager      | NULL   | 3     | 3366           | 
| NULL       | Office Staff | NULL   | 1     | 3000           | 
| NULL       | NULL         | Female | 1     | 3000           | 
| NULL       | NULL         | Male   | 5     | 3100           | 
| NULL       | NULL         | NULL   | 6     | 3083           | 


## CUBE

CUBE generates a result set that aggregates all combinations of values in the selected columns.

    (TSQL)
    SELECT department, role, gender, count(*), avg(salary) AS average_salary
     FROM Groupingsets.employee
     GROUP BY CUBE (department, role, gender);

| department | role         | gender | count            | average_salary | 
|------------|--------------|--------|------------------|----------------| 
| Finance    | Office Staff | Female | 1                | 3000           | 
| NULL       | Office Staff | Female | 1                | 3000           | 
| NULL       | NULL         | Female | 1                | 3000           | 
| Finance    | Driver       | Male   | 1                | 2800           | 
| Sales      | Driver       | Male   | 1                | 2600           | 
| NULL       | Driver       | Male   | 2                | 2700           | 
| Finance    | Manager      | Male   | 1                | 3000           | 
| Sales      | Manager      | Male   | 2                | 3550           | 
| NULL       | Manager      | Male   | 3                | 3366           | 
| NULL       | NULL         | Male   | 5                | 3100           | 
| NULL       | NULL         | NULL   | 6                | 3083           | 
| Finance    | NULL         | Female | 1                | 3000           | 
| Finance    | NULL         | Male   | 2                | 2900           | 
| Finance    | NULL         | NULL   | 3                | 2933           | 
| Sales      | NULL         | Male   | 3                | 3233           | 
| Sales      | NULL         | NULL   | 3                | 3233           | 
| Finance    | Driver       | NULL   | 1                | 2800           | 
| Sales      | Driver       | NULL   | 1                | 2600           | 
| NULL       | Driver       | NULL   | 2                | 2700           | 
| Finance    | Manager      | NULL   | 1                | 3000           | 
| Sales      | Manager      | NULL   | 2                | 3550           | 
| NULL       | Manager      | NULL   | 3                | 3366           | 
| Finance    | Office Staff | NULL   | 1                | 3000           | 
| NULL       | Office Staff | NULL   | 1                | 3000           | 


## ROLLUP

ROLLUP generates a result set that aggregates a hierarchy of values.

    SELECT department, role, gender, count(*), avg(salary) AS average_salary, sum (salary)
      FROM Groupingsets.employee
      GROUP BY ROLLUP (department, role, gender);


| department | role         | gender | count | average_salary | sum              | 
|------------|--------------|--------|-------|----------------|------------------| 
| Finance    | Driver       | Male   | 1     | 2800           | 2800             | 
| Finance    | Driver       | NULL   | 1     | 2800           | 2800             | 
| Finance    | Manager      | Male   | 1     | 3000           | 3000             | 
| Finance    | Manager      | NULL   | 1     | 3000           | 3000             | 
| Finance    | Office Staff | Female | 1     | 3000           | 3000             | 
| Finance    | Office Staff | NULL   | 1     | 3000           | 3000             | 
| Finance    | NULL         | NULL   | 3     | 2933           | 8800             | 
| Sales      | Driver       | Male   | 1     | 2600           | 2600             | 
| Sales      | Driver       | NULL   | 1     | 2600           | 2600             | 
| Sales      | Manager      | Male   | 2     | 3550           | 7100             | 
| Sales      | Manager      | NULL   | 2     | 3550           | 7100             | 
| Sales      | NULL         | NULL   | 3     | 3233           | 9700             | 
| **NULL**       | NULL         | NULL   | 6     | 3083           | **18500**            | 
