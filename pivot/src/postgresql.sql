-- Sourcecode for PostgreSQL
-- SQL Pivot

-- CREATE EXTENSION tablefunc;

CREATE TEMPORARY TABLE sales(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    brand VARCHAR(255),
    sales INT,
    stock INT,
    purchaseprice DECIMAL(18, 2),
    salesprice DECIMAL(18, 2),
    category VARCHAR(255)
);

--sample data
INSERT INTO sales ( name, brand, sales, stock, purchaseprice, salesprice, category) 
VALUES 
( 'C9397A HP72', 'HP', 170, 12, '27.10', '44.90', 'Toner'),
( 'HP CF411X', 'HP', 210, 50, '132.00', '196.00', 'Toner'),
( 'HP Ultra White 5000 Sheets, 80 g ', 'HP', 7200, 500, '2.20', '3.49', 'Paper items'),
( '106R02775, 80 g ', 'Xerox', 8, 17, '28.00', '53.00', 'Paper items'),
( 'Edding Permanent-Marker 3000', 'Edding', 1685, 320, '0.68', '1.19', 'Stationery'),
( 'A4 Xerox Business - 5000 80 g', 'Xerox', 4300, 1200, '1.95', '2.85', 'Paper items')

--
SELECT 
SUM( CASE WHEN Category = 'Toner' THEN (sales * salesprice) END ) Toner, 
SUM( CASE WHEN Category = 'Paper items' THEN (sales * salesprice) END ) "Paper items", 
SUM( CASE WHEN Category = 'Stationery' THEN (sales * salesprice) END ) Stationery
FROM sales;

--
SELECT 
brand, 
SUM(CASE WHEN Category = 'Toner' THEN (sales * salesprice) END ) Toner, 
SUM( CASE WHEN Category = 'Paper items' THEN (sales * salesprice) END ) "Paper items", 
SUM( CASE WHEN Category = 'Stationery' THEN (sales * salesprice) END ) Stationery
FROM sales GROUP BY brand