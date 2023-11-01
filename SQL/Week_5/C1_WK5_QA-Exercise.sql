-- TASK 1 --
-- DATA PROFILING --
-- Use SQL queries to identify the schema of the Northwind database and its tables.
-- Write SQL queries to determine the data types, null values, and unique values in each table.
-- Analyze the results of your queries and document any potential data quality issues.

SELECT 		table_name,
			column_name,
			data_type,
			is_nullable
FROM		information_schema.columns
WHERE		table_schema = 'public'
ORDER BY	table_name

-- ID data types are not consistent event though most of them can be smallint data types
-- unitprice should be numerical and not real

-- TASK 2 --
-- DATA VALIDATION --

SELECT		companyname,
			COUNT(*)
FROM		suppliers
GROUP BY	companyname
HAVING		COUNT(1) > 1

-- TASK 3 --
-- DATA CLEANSING --
/*Identify any data quality issues in the Northwind database, such as missing or 
inconsistent data, and write SQL queries to clean the data.
Document your cleaning process and explain any decisions you made.*/


-- Cleaning up the phone numbers
UPDATE	CUSTOMERS
SET phone = regexp_replace(phone, '[^0-9]', '', 'g')
	WHERE	phone LIKE '%(%%%) %%';
	
SELECT
	DISTINCT country
FROM
	customers
	
--Cleaning up the countries
UPDATE customers
SET country = CASE
		WHEN country IN ('USA', 'United States') THEN 'United States'
		WHEN country = 'UK' THEN 'United Kingdom'
		ELSE country
		END;
		
-- TASK 4 --
-- TESTING --
/*To develop a set of SQL test cases to ensure 
the quality of the Northwind database. */

-- Testing order dates

SELECT *
FROM orders
WHERE	orderdate > '1900-01-01';

-- Test that the discount amounts are correct

SELECT
		orderid
	, 	SUM(unitprice*quantity*(1-discount)) AS total_discount
FROM
	order_details
GROUP BY 1
HAVING SUM(unitprice*quantity*(1-discount)) < 0;
