-- Sourcecode for MS SQL SERVER
-- SQL PIVOT

CREATE TABLE #sales
(
    id INTEGER IDENTITY (1,1) PRIMARY KEY,
    name VARCHAR(255),
	brand VARCHAR(255),
	sales INT,
	stock INT,
    purchaseprice DECIMAL(18,2),
    salesprice DECIMAL(18,2),
    category VARCHAR(255)
);

--sample data
INSERT INTO #sales
    (name, brand, sales, stock, purchaseprice, salesprice, category)
VALUES
    ('C9397A HP72', 'HP', 170, 12, '27.10', '44.90', 'Toner'),
    ('HP CF411X', 'HP', 210, 50 ,'132.00', '196.00', 'Toner'),
	('HP Ultra White 5000 Sheets, 80 g ', 'HP', 7200, 500 ,'2.20', '3.49', 'Paper items'),
	('106R02775, 80 g ', 'Xerox', 8, 17 ,'28.00', '53.00', 'Paper items'),
	('Edding Permanent-Marker 3000', 'Edding', 1685, 320, '0.68', '1.19', 'Stationery'),
    ('A4 Xerox Business - 5000 80 g', 'Xerox', 4300, 1200, '1.95', '2.85', 'Paper items')

SELECT 
SUM(CASE WHEN Category = 'Toner' THEN (sales*salesprice) END) [Toner],
    SUM(CASE WHEN Category = 'Paper items' THEN (sales*salesprice) END) [Paper items],
    SUM(CASE WHEN Category = 'Stationery' THEN (sales*salesprice) END) [Stationery]
    FROM #sales;

SELECT 
brand,
SUM(CASE WHEN Category = 'Toner' THEN (sales*salesprice) END) [Toner],
SUM(CASE WHEN Category = 'Paper items' THEN (sales*salesprice) END) [Paper items],
SUM(CASE WHEN Category = 'Stationery' THEN (sales*salesprice) END) [Stationery]
FROM #sales
GROUP BY brand

-- TSQL Pivot
SELECT [Toner],[Paper items],[Stationery] FROM
(SELECT (sales * salesprice) as turnover, category FROM #sales) as Sourcetable
PIVOT 
(
sum(turnover)
FOR category IN ([Toner],[Paper items],[Stationery])
)  AS PivotTable;


SELECT brand, [Toner],[Paper items],[Stationery] FROM
(SELECT brand, (sales * salesprice) as turnover, category FROM #sales) as Sourcetable
PIVOT 
(
sum(turnover)
FOR category IN ([Toner],[Paper items],[Stationery])
)  AS PivotTable;


-- Add a new row with new category
INSERT INTO #sales
    (name, brand, sales, stock, purchaseprice, salesprice, category)
VALUES
    ('HP 7100', 'HP', 65, 9, '227.10', '317.90', 'Printer')
   
----
DECLARE @DynamicPivot AS NVARCHAR(MAX) 
DECLARE @ColumnNames AS NVARCHAR(MAX) --Get distinct values

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
         --execute( @DynamicPivot)
		  EXEC sp_executesql @DynamicPivot



