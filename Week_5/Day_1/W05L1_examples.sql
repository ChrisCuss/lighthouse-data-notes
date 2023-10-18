-- DATETIME EXAMPLES --
-- Documentation https://www.postgresql.org/docs/16/functions-datetime.html

-- Find the current date, time, timestamp
SELECT
	CURRENT_DATE,
	CURRENT_TIME,
	CURRENT_TIMESTAMP,
	CURRENT_TIMESTAMP(0)


-- Converting a string to a date
SELECT
	'2023-10-17' AS date_string, -- string as YYYY-MM-DD format
	TO_DATE('2023-10-17', 'YYYY-DD-MM') AS converted_date
	
SELECT
	'2023-17-10' AS date_string, -- string as YYYY-DD-MM format
	TO_DATE('2023-17-10', 'YYYY-DD-MM') AS converted_date

SELECT
	'10-17-23' AS date_string, -- string as MM-DD-YY format
	TO_DATE('10-17-23', 'MM-DD-YY') AS converted_date
	

-- 
SELECT
	orderdate AS date_orderdate,
	TO_CHAR(orderdate, 'YYYY-MM-DD') AS string_orderdate,
	CAST(orderdate AS TIMESTAMP) AS timestamp_orderdate
FROM
	orders
	

-- Extracting parts of a date or time
SELECT
	CURRENT_TIMESTAMP,
	EXTRACT(CENTURY FROM CURRENT_TIMESTAMP) AS current_century,
	EXTRACT(YEAR FROM CURRENT_TIMESTAMP) AS current_year,
	EXTRACT(QUARTER FROM CURRENT_TIMESTAMP) AS current_quarter,
	EXTRACT(MONTH FROM CURRENT_TIMESTAMP) AS current_month,
	EXTRACT(DAY FROM CURRENT_TIMESTAMP) AS current_day,
	EXTRACT(DOW FROM CURRENT_TIMESTAMP) AS current_dow,
	EXTRACT(HOUR FROM CURRENT_TIMESTAMP) AS current_hour,
	EXTRACT(MINUTE FROM CURRENT_TIMESTAMP) AS current_minute,
	EXTRACT(SECOND FROM CURRENT_TIMESTAMP) AS current_second
	
-- How many total orders were placed in each quarter?
SELECT
	CONCAT(EXTRACT(YEAR FROM orderdate), ' - Q', EXTRACT(QUARTER FROM orderdate)) AS quarter,
	COUNT(orderid)
FROM
	orders
GROUP BY
	1
ORDER BY
	1


-- Arithmetic/conditional operators
-- Calculate 3 days after order date and whether order shipped on time for orders placed in September 1997.
SELECT
	orderdate,
	CAST(orderdate + INTERVAL '3 days' AS DATE) AS plus_3_days,
	shippeddate - orderdate AS days_to_ship,
	(shippeddate < requireddate) AS shipped_on_time
FROM 
	orders
WHERE
	EXTRACT(MONTH FROM orderdate) = '9' AND EXTRACT(YEAR FROM orderdate) = '1997'
	
	
-- EXERCISES --

-- Other useful functions include DATE_PART, DATE_TRUNC
/*
Question 1
Join the "orders" and "order_details" tables to get a list of all
orders with their corresponding customer id and product details,
including the product name, unit price, quantity, and discount.
*/
SELECT
	o.orderid,
	o.customerid,
	p.productname,
	od.unitprice,
	od.quantity,
	od.discount
FROM
	orders o
JOIN
	order_details od ON o.orderid = od.orderid
JOIN
	products p ON od.productid = p.productid


/*
Question 2
Use a window function to rank the orders by the total price of their products, from highest to lowest.
*/
SELECT
	o.orderid,
	ROUND(CAST(SUM(od.unitprice * od.quantity * (1 - od.discount)) AS NUMERIC), 2) AS total_price,
	RANK() OVER(
		ORDER BY SUM(od.unitprice * od.quantity * (1 - od.discount)) DESC
	) AS total_price_rank
FROM
	orders o
JOIN
	order_details od ON o.orderid = od.orderid
GROUP BY o.orderid


/*
Question 3
Calculate the average time it took to fulfill an order, in days, for
orders that were shipped on time and orders that were shipped late.
*/
SELECT
	CASE
		WHEN requireddate < shippeddate THEN 'Late'
		ELSE 'On-Time'
	END AS ship_status,
	ROUND(AVG(shippeddate - orderdate)) AS days_to_ship
FROM
	orders
GROUP BY
	ship_status


/*
Question 4
Use a case statement to categorize customers based on their
total spending, as "low", "medium", or "high" spenders.
*/
SELECT
	c.companyname,
	ROUND(CAST(SUM(od.unitprice * od.quantity * (1 - od.discount)) AS NUMERIC), 2) AS total_spend,
	CASE
		WHEN SUM(od.unitprice * od.quantity * (1 - od.discount)) <= 5000 THEN 'low'
		WHEN SUM(od.unitprice * od.quantity * (1 - od.discount)) > 25000 THEN 'high'
		ELSE 'medium'
	END AS spend_category
FROM
	customers c
JOIN
	orders o ON c.customerid = o.customerid
JOIN
	order_details od ON o.orderid = od.orderid
GROUP BY c.companyname


/*
Question 5
Find the top 3 salespeople who generated the highest sales revenue in the year 1997, along with
their manager's name and their sales revenue percentage change compared to the previous year.
*/
SELECT
	CONCAT(e1.firstname, ' ', e1.lastname) AS salesperson,
	CONCAT(e2.firstname, ' ', e2.lastname) AS manager,
	ROUND(CAST(SUM(od.unitprice * od.quantity * (1 - od.discount)) AS NUMERIC), 2) AS sales_revenue
FROM 
	orders o
JOIN
	order_details od ON o.orderid = od.orderid
JOIN
	employees e1 ON o.employeeid = e1.employeeid
JOIN
	employees e2 ON e1.reportsto = e2.employeeid
WHERE
	EXTRACT(YEAR FROM o.orderdate) = 1997
GROUP BY
	1, 2
ORDER BY
	3 DESC
LIMIT 3