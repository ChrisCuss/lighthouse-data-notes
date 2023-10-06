--FIX DATA TYPES
--change INTEGER discontinued flag to BOOLEAN in products table
-- DROP TABLE IF EXISTS products_clean;
-- CREATE TABLE products_clean AS
-- SELECT 	productid,
-- 		productname,
-- 		CAST(discontinued AS BOOL) discontinued_bool
-- FROM products;

-- SELECT *
-- FROM products_clean;

--REMOVE OUTLIERS:
--only keep products that we have in stock
-- DROP TABLE IF EXISTS productsinstock;
-- CREATE TABLE productsinstock AS
-- SELECT 	productid,
-- 		productname,
-- 		unitsinstock
-- FROM 	products
-- WHERE	unitsinstock > 0;

-- SELECT *
-- FROM productsinstock;

--FIX MISSING VALUES:
--replace null shippeddate from orders with '1997-01-01'
-- SELECT	shippeddate,
-- 		CASE
-- 			WHEN shippeddate IS NULL THEN CAST ('1997-01-01' AS DATE)
-- 			ELSE shippeddate
-- 			END AS shippeddate_fixed
-- FROM	orders

--FIX MISSING VALUES:
--replace customer region with country if null
-- SELECT 	companyname,
-- 		region,
-- 		CASE
-- 			WHEN region IS NULL THEN country
-- 			ELSE region
-- 			END AS region_fixed,
-- 		country
-- FROM	customers

--FIX STRUCTURAL ISSUE:
--replace symbols in customer phone numbers using REGEXP_REPLACE function
--and '[^0-9]' as pattern and 'g' as flag

-- SELECT	phone,
-- 		REGEXP_REPLACE(phone,'[^0-9]', '', 'g') AS phone_fixed
-- FROM 	customers

--REMOVE IRRELEVANT DATA:
--select only orders with total amount over $1,000 (there are discounts!)

-- SELECT		o.orderid,
-- 			SUM(od.unitprice*od.quantity*(1-od.discount)) AS Total_Value
-- FROM		orders o
-- JOIN		order_details od USING(orderid)
-- GROUP BY	o.orderid, (od.unitprice*od.quantity*(1-od.discount))
-- HAVING		SUM(od.unitprice*od.quantity*(1-od.discount)) > 1000
-- ORDER BY	Total_Value DESC