------ Basic examples for lecture -------
SELECT
	categoryid,
	categoryname 
FROM categories
UNION
SELECT
	categoryid,
	categoryname 
FROM categories;


-- UNION -- ex1
SELECT
	'products' AS table_name, 
	COUNT(*) AS count_rows, 
	'productid' AS key_name,
	COUNT(DISTINCT(productid)) AS count_distinct_key
FROM products
UNION ALL
SELECT
	'categories' AS table_name,
	COUNT(*) AS count_rows, -- second statment column names dont matter
    'categoryid' AS key_name,
	COUNT(DISTINCT(categoryid)) AS count_distinct_key  -- but the amount of columns do... 
FROM categories;


-- UNION -- Compare counts of rows and distinct ids... this should match as they should all be primary keys in the schema...
SELECT
	'categories' as table_name,
	COUNT(*) AS count_rows,
	COUNT(DISTINCT(categoryid)) AS count_distinct_id 
FROM categories
UNION ALL
SELECT
	'customers' as table_name,
	COUNT(*) AS count_rows, 
    COUNT(DISTINCT(customerid)) AS count_distinct_id
FROM customers
UNION ALL
SELECT
	'employees' as table_name, 
	COUNT(*) AS count_rows, 
    COUNT(DISTINCT(employeeid)) AS count_distinct_id
FROM employees
UNION ALL 
SELECT
	'products' as table_name,
	COUNT(*) AS count_rows,
	COUNT(DISTINCT(productid)) AS count_distinct_id
FROM products;


-- UNION -- data types must match
SELECT
	'category' AS table_name,
	categoryid AS primary_key_id,
	categoryname  
FROM categories
UNION ALL
SELECT
	'products' AS table_name,
	productid as primary_key_id,
	productname -- productname
FROM products;


-- UNION -- data types must match, but there is "compatability"
SELECT
	firstname
FROM employees
UNION ALL
SELECT
	lastname
FROM employees;


SELECT
	quantity
FROM order_details
UNION ALL
SELECT
	unitprice
FROM order_details;


------------------------------------------------------------------------------------------------


-- VIEWS --

SELECT
	o.orderid,
	o.orderdate,
	od.productid,
	od.unitprice,
	pr.productname,
	pr.categoryid,
	ca.categoryname
FROM orders o
JOIN order_details od USING(orderid)
JOIN products pr USING(productid)
JOIN categories ca USING(categoryid);


--- create this as a view... 
DROP VIEW IF EXISTS vw_ordered_products;
CREATE VIEW vw_ordered_products AS 
SELECT
	o.orderid,
	o.orderdate,
	od.productid,
	od.unitprice,
	pr.productname,
	pr.categoryid,
	ca.categoryname
FROM orders o
JOIN order_details od USING (orderid)
JOIN products pr USING (productid)
JOIN categories ca USING (categoryid);

SELECT * FROM vw_ordered_products;


--- create materialized view
DROP MATERIALIZED VIEW IF EXISTS vw_ordered_products_materialized;
CREATE MATERIALIZED VIEW vw_ordered_products_materialized AS 
SELECT
	o.orderid,
	o.orderdate,
	od.productid,
	od.unitprice,
	pr.productname,
	pr.categoryid,
	ca.categoryname
FROM orders o
INNER JOIN order_details od USING (orderid)
INNER JOIN products pr USING (productid)
INNER JOIN categories ca USING (categoryid);

SELECT * FROM vw_ordered_products_materialized;

REFRESH MATERIALIZED VIEW vw_ordered_products_materialized;


------------------------------------------------------------------------------------------------


-- Temp Tables --


--- what about creating this as a temporary table...
DROP TABLE IF EXISTS t_temp_test;
CREATE TEMP TABLE t_temp_test AS 
SELECT
	o.orderid,
	o.orderdate,
	od.productid,
	od.unitprice,
	pr.productname,
	pr.categoryid,
	ca.categoryname,
	AVG(od.unitprice) OVER(PARTITION BY ca.categoryname) AS avg_price_per_cat -- get avg price of a unit per category on same line...
FROM orders o
JOIN order_details od USING (orderid)
JOIN products pr USING (productid)
JOIN categories ca USING (categoryid);

SELECT
	*
FROM t_temp_test;


DROP TABLE IF EXISTS t_temp_test2;
CREATE TEMP TABLE t_temp_test2 AS 
SELECT
	orderid,
	orderdate,
	productid,
	unitprice,
	productname,
	categoryid,
	categoryname,
	ROUND(CAST(avg_price_per_cat AS numeric), 2) AS avg_price_per_cat,
	ROUND(CAST(((unitprice - t_temp_test.avg_price_per_cat)/t_temp_test.avg_price_per_cat) AS numeric),2) AS percent_dif_from_category_mean
FROM t_temp_test;

SELECT
	*
FROM t_temp_test2;


------------------------------------------------------------------------------------------------

-- what about the above in a nested manner?

SELECT
	orderid,
	orderdate,
	productid,
	unitprice,
	productname,
	categoryid,
	categoryname, 
	ROUND(CAST(avg_price_per_cat AS numeric), 2) AS avg_price_per_cat,
	ROUND(CAST(((unitprice - nt.avg_price_per_cat)/nt.avg_price_per_cat) AS numeric),2) AS percent_dif_from_category_mean
FROM (
	SELECT
		o.orderid,
		o.orderdate,
		od.productid,
		od.unitprice,
		pr.productname,
		pr.categoryid,
		ca.categoryname,
		AVG(od.unitprice) OVER(PARTITION BY ca.categoryname) AS avg_price_per_cat -- get avg price of a unit per category on same line...
	FROM orders o
	JOIN order_details od USING (orderid)
	JOIN products pr USING (productid)
	JOIN categories ca USING (categoryid)
    ) AS nt;


------------------------------------------------------------------------------------------------


-- CTE Examples --

-- Want to find most valuable item per order and then which employee is responsible for the order...
-- Selecting columns needed and calculating total order amounts...

SELECT
	c.companyName,
	o.orderID,
	e.firstname,
	e.lastname,
	o.orderdate, 
	od.productID,
	od.unitprice,
	od.quantity,
	od.unitprice * od.quantity AS total_order_value, -- calculated a value... 
	RANK(total_order_value) OVER(PARTITION BY orderid ORDER BY total_order_value DESC) AS rank_item
	-- cant ref name of calc column due to the order or operations... maybe I can use a CTE to step through this...
FROM employees e
JOIN orders o USING (employeeid)
JOIN customers c USING (customerID)
JOIN order_details od USING (orderid);


--###### lets try a CTE for our processing #####
WITH CTE_calc_column AS (
	SELECT
		c.companyName,
		o.orderID,
		e.employeeid,
		e.firstname,
		e.lastname,
		o.orderdate, 
		od.productID,
		od.unitprice,
		od.quantity,
		od.unitprice * od.quantity AS total_order_value 
		-- calculated a column....
	FROM employees e
	LEFT JOIN orders o USING (employeeid) 
	-- Used left join because I wanted to capture if any employees had no orders attributed with them
	JOIN customers c USING (customerID)
	JOIN order_details od USING (orderid)
),
-- Lets do the rank function in step 2 now we have materialized the calculated column from step one
CTE_rank AS (
	SELECT
		*,
		RANK() OVER(PARTITION BY orderid ORDER BY total_order_value DESC) AS rank_item
	FROM CTE_calc_column
),
-- Only return top product sold with most $ value
CTE_only_1_product AS(
	SELECT
		*
	FROM CTE_rank
	WHERE rank_item = 1
),                   
-- Group by employee to show the max and min value of total product value sold per order... 
CTE_group_emp AS (
SELECT
	employeeid,
	MAX(total_order_value) AS max_order_product_value, 
	MIN(total_order_value) AS min_order_product_value, 
	COUNT(orderID) AS count_orders
FROM CTE_only_1_product
GROUP BY employeeid -- used employeeID because maybe there are employees with the same name
),                
CTE_join_e_names AS (
SELECT
	cte.employeeid,
	ROUND(cte.max_order_product_value::numeric,2) AS max_order_product_value, 
	ROUND(cte.min_order_product_value::numeric, 2) AS min_order_product_value,
       cte.count_orders,
       e.firstname, e.lastname, e.title
FROM CTE_group_emp cte
JOIN employees e USING (employeeID)
ORDER BY count_orders DESC
)
SELECT
	*
FROM CTE_join_e_names;
-- find what maximum value item per order was had and which employee was responsible for that order... 

