# SQL PIVOT


* summarizes data often used in spreadsheets (and often requested by Superiors)
* could be realized in common SQL-Databases with CASE-Condition 
* some SQL-Database offer proprietary pivot functions


## Proprietary pivot functions

| Postgresql | MS SQL Server | MySQL | SQLite |MS Access
|:----------:|:----------:|:----------:|:----------:|:----------:|
|[crosstab](https://www.postgresql.org/docs/current/static/tablefunc.html)| [PIVOT](https://docs.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot) |-|-| [TRANSFORM](https://msdn.microsoft.com/library/office/ff192901.aspx)


## Base Table

Example: products in a sales table.

|  item                             |brand   |sales |stock | purchaseprice|salesprice|category| 
|-----------------------------------|--------|------|------|--------|--------|-------------| 
| C9397A HP72                       | HP     | 170  | 12   | 27.10  | 44.90  | Toner       | 
| HP CF411X                         | HP     | 210  | 50   | 132.00 | 196.00 | Toner       | 
| HP Ultra White 5000 Sheets, 80 g  | HP     | 7200 | 500  | 2.20   | 3.49   | Paper items | 
| 106R02775, 80 g                   | Xerox  | 8    | 17   | 28.00  | 53.00  | Paper items | 
| Edding Permanent-Marker 3000      | Edding | 1685 | 320  | 0.68   | 1.19   | Stationery  | 
| A4 Xerox Business - 5000 80 g     | Xerox  | 4300 | 1200 | 1.95   | 2.85   | Paper items | 

## CREATE PIVOT WITH A CONDITION

*Handicap: The content of grouping columns must be known

### EXAMPLE: Calculate turnover for product categories
    (TSQL)(1)
    SELECT 
    SUM(CASE WHEN Category = 'Toner' THEN (sales*salesprice) END) [Toner],
    SUM(CASE WHEN Category = 'Paper items' THEN (sales*salesprice) END) [Paper items],
    SUM(CASE WHEN Category = 'Stationery' THEN (sales*salesprice) END) [Stationery]
    FROM sales;


**Result**

| Toner    | Paper items | Stationery | 
|----------|-------------|------------| 
| 48793.00 | 37807.00    | 2005.15    | 

### Grouping by brands

    (TSQL)
    SELECT 
    brand,
    SUM(CASE WHEN Category = 'Toner' THEN (sales*salesprice) END) [Toner],
    SUM(CASE WHEN Category = 'Paper items' THEN (sales*salesprice) END) [Paper items],
    SUM(CASE WHEN Category = 'Stationery' THEN (sales*salesprice) END) [Stationery]
    FROM Pivotsql.sales
    GROUP BY brand;

**Result**

| brand  | Toner    | Paper items | Stationery | 
|--------|----------|-------------|------------| 
| Edding | NULL     | NULL        | 2005.15    | 
| HP     | 48793.00 | 25128.00    | NULL       | 
| Xerox  | NULL     | 12679.00    | NULL       |     


## CREATE PIVOT WITH A proprietary pivot functions

    (TSQL)
    SELECT [Toner],[Paper items],[Stationery] FROM
      (SELECT (sales * salesprice) as turnover, category FROM sales) as Sourcetable
      PIVOT 
      (
      sum(turnover)
      FOR category IN ([Toner],[Paper items],[Stationery])
      )  AS PivotTable;

**Result**

| Toner    | Paper items | Stationery | 
|----------|-------------|------------| 
| 48793.00 | 37807.00    | 2005.15    | 

### Grouping by brands

    (TSQL)

     SELECT brand, [Toner],[Paper items],[Stationery] FROM
     (SELECT brand, (sales * salesprice) as turnover, category FROM Pivotsql.sales) as Sourcetable
     PIVOT 
     (
     sum(turnover)
     FOR category IN ([Toner],[Paper items],[Stationery])
     )  AS PivotTable;

**Result**

| brand  | Toner    | Paper items | Stationery | 
|--------|----------|-------------|------------| 
| Edding | NULL     | NULL        | 2005.15    | 
| HP     | 48793.00 | 25128.00    | NULL       | 
| Xerox  | NULL     | 12679.00    | NULL       |     


## CREATE DYNAMIC PIVOT

The static definition of the grouping columns is less pratical. To create a dynamic pivot, the first step is to create a list of columnnames for use in the SELECT-statement.

    (TSQL)
    DECLARE @DynamicPivot AS NVARCHAR(MAX) 
    DECLARE @ColumnNames AS NVARCHAR(MAX) 
    
    SELECT
    @ColumnNames = ISNULL(@ColumnNames + ',', '') + QUOTENAME(category)
    FROM
    (
        SELECT DISTINCT category
        FROM #sales
    ) as sales
        SET @DynamicPivot = N'SELECT ' + @ColumnNames
		+ 'FROM (SELECT (sales * salesprice) as turnover, category FROM #sales) as Sourcetable
		PIVOT 
        (
        sum(turnover)
        FOR category IN (' + @ColumnNames + ')) AS PivotTable'

    --Execute the Dynamic Pivot Query
    EXEC sp_executesql @DynamicPivot

