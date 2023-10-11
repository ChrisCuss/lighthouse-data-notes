-- CASE

-- Example 1
-- In the order_details table, classify each row based on their quantity:
-- 'large' (>40), 'medium' (<=40 and >20), or 'small' (<=20)
SELECT
	quantity
	,CASE
		WHEN quantity > 40 THEN 'large'
		WHEN quantity <= 20 THEN 'small'
		ELSE 'medium'
	END AS quantity_class
FROM
	order_details


-- Example 2
-- Show every row from order_details that has no discount and quantity <10 or
-- if there is a discount, the quantity must be between 10 and 20
SELECT
	quantity,
	discount
FROM
	order_details
WHERE
	CASE
		WHEN discount = 0 THEN quantity < 10
		ELSE quantity BETWEEN 10 AND 20
	END


-- CAST

-- Example 1
-- In the orders table, convert orderdate to string
SELECT
	orderdate,
	CAST(orderdate AS VARCHAR(10)) AS orderdate_string
-- 	orderdate::VARCHAR(10) AS orderdate_string
FROM
	orders


-- Example 2
-- In the products table, show unitsinstock as a percentage of the grand total unitsinstock
SELECT
	CAST(unitsinstock AS FLOAT) / (SELECT SUM(unitsinstock) FROM products) * 100 AS perc_unitsinstock
	-- 100.0 * unitsinstock / (SELECT SUM(unitsinstock) FROM products) AS perc_unitsinstock
FROM
	products


-- WINDOW FUNCTIONS

-- ROW_NUMBER(), RANK(), DENSE_RANK(), PERCENT_RANK() example
-- Assign a row number(rank, dense rank, percent rank) to each order based on its order date in ascending order by shipper.
SELECT
	o.orderid,
	s.companyname,
	o.orderdate,
	ROW_NUMBER() OVER( -- same syntax as RANK(), DENSE_RANK(), PERCENT_RANK()
		PARTITION BY o.shipvia
		ORDER BY o.orderdate) AS row_no
FROM
	orders o
JOIN
	shippers s
ON o.shipvia = s.shipperid
	
	SELECT * FROM shippers

-- SUM(), AVG(), MIN(), MAX(), COUNT() example
-- Total (average, minimum, maximum, count) shipping weight by each shipper based on order date in ascending order.
SELECT
	s.companyname,
	o.orderdate,
	o.freight,
	SUM(o.freight) OVER( --same syntax as AVG(), MIN(), MAX(), COUNT()
		PARTITION BY o.shipvia
		ORDER BY o.orderdate) AS running_total 
FROM
	orders o
JOIN
	shippers s
ON 
	o.shipvia = s.shipperid


-- FIRST_VALUE(), LAST_VALUE() example
-- What was the weight of the first (last, nth) shipment of each shipping company?
SELECT
	s.companyname,
	o.orderdate,
	o.freight,
	FIRST_VALUE(o.freight) OVER( --same syntax as LAST_VALUE()
		PARTITION BY o.shipvia
		ORDER BY o.orderdate) 
FROM
	orders o
JOIN
	shippers s
ON 
	o.shipvia = s.shipperid


-- NTH_VALUE example (3rd)
-- What was the weight of the 3rd shipment of each shipping company?
SELECT
	s.companyname,
	o.orderdate,
	o.freight,
	NTH_VALUE(o.freight, 3) OVER(
		PARTITION BY o.shipvia
		ORDER BY o.orderdate) 
FROM
	orders o
JOIN
	shippers s
ON 
	o.shipvia = s.shipperid


-- LEAD(), LAG() example
-- Find the weight of the subsequent (previous) freight of a shipping company by order date (ascending).
SELECT
	s.companyname,
	o.orderdate,
	o.freight,
	LEAD(o.freight) OVER( --same syntax as LAG()
		PARTITION BY o.shipvia
		ORDER BY o.orderdate) AS subsequent_freight
FROM
	orders o
JOIN
	shippers s
ON 
	o.shipvia = s.shipperid

-- CUME_DIST example
-- Find the cumulative distribution of the weights of the freight by each shipper.

SELECT
	s.companyname,
	o.freight,
	CUME_DIST() OVER(
		PARTITION BY o.shipvia
		ORDER BY o.freight)
FROM
	orders o
JOIN
	shippers s
ON 
	o.shipvia = s.shipperid


-- NTILE example
-- Find the decile of the weights of the freight of each shipper.
SELECT
	s.companyname,
	o.freight,
	NTILE(10) OVER(
		PARTITION BY o.shipvia
		ORDER BY o.freight) AS decile
FROM
	orders o
JOIN
	shippers s
ON 
	o.shipvia = s.shipperid


-- USER DEFINED FINCTIONS

-- user defined function example
CREATE OR REPLACE FUNCTION calc_total_price(input_orderid INTEGER)
RETURNS NUMERIC AS $$
DECLARE
	total_price NUMERIC := 0;
BEGIN
	SELECT SUM(unitprice * quantity * (1 - discount))
	INTO total_price
	FROM order_details
	WHERE orderid = input_orderid;
	RETURN total_price;
END;
$$ LANGUAGE plpgsql;

-- function execution
SELECT
	orderid,
	calc_total_price(orderid)
FROM
	orders


-- EXERCISES
-- Exercise 1
-- Assign a 'Low', 'Medium', or 'High' price label to each product based on its unit price. 
SELECT
	productname,
	unitprice,
	CASE
		WHEN unitprice <= 20 THEN 'Low'
		WHEN unitprice > 50 THEN 'High'
		ELSE 'Medium'
	END AS price_group
FROM
	products


-- Exercise 2
-- Classify customers as 'Local' or 'International' based on their country.
SELECT
	companyname,
	country,
	CASE
		WHEN country = 'Canada' THEN 'Local'
		ELSE 'International'
	END AS region
FROM
	customers


-- Exercise 3
-- Assign a discount category to each order based on the average discount applied to its order details.
SELECT
	orderid,
	discount,
	AVG(discount) OVER(
		PARTITION BY orderid),
	CASE
		WHEN AVG(discount) OVER(PARTITION BY orderid) = 0 THEN 'No discount'
		WHEN AVG(discount) OVER(PARTITION BY orderid) <= 0.1 THEN 'Small discount'
		WHEN AVG(discount) OVER(PARTITION BY orderid) <= 0.2 THEN 'Medium discount'
		ELSE 'Large discount'
	END AS discount_group
FROM
	order_details


-- Exercise 4
-- Convert the order date to a string.
SELECT
	orderdate,
	CAST(orderdate AS VARCHAR(10)) AS orderdate_string
-- 	orderdate::VARCHAR(10) AS orderdate_string
FROM
	orders


-- Exercise 5
-- Calculate the VAT (Value Added Tax) for each product's unit price assuming a VAT rate of 20%. (HARD)
SELECT
	p.productname,
	o.unitprice,
	o.unitprice * 0.2 AS vat
FROM
	products p
JOIN
	order_details o USING (productid)


-- BONUS: Round the result to 2 decimal places.
SELECT
	p.productname,
	o.unitprice,
	ROUND(CAST(o.unitprice * 0.2 AS NUMERIC), 2) AS vat
FROM
	products p
JOIN
	order_details o USING (productid)


-- Exercise 6
-- Calculate the total price of each order, including VAT, and format the result as a string with a currency symbol. (HARD)
SELECT
	DISTINCT orderid,
	CONCAT('$', ROUND(SUM(CAST(unitprice * quantity * 1.2 AS NUMERIC)) OVER(PARTITION BY orderid), 2)) AS total_price
-- 	'$' || ROUND(SUM(CAST(unitprice * quantity * 1.2 AS NUMERIC)) OVER(PARTITION BY orderid), 2) AS total_price
FROM
	order_details
ORDER BY 1


-- Exercise 7
-- Assign a row number to each product based on its unit price in ascending order.
SELECT
	productname,
	unitprice,
	ROW_NUMBER() OVER(ORDER BY unitprice)
FROM
	products


-- Exercise 8
-- Rank employees by the total number of orders they have managed. (HARD)
SELECT
	DISTINCT CONCAT(firstname, ' ', lastname) AS employee,
	COUNT(o.orderid) AS num_orders_managed,
	RANK() OVER(ORDER BY COUNT(o.orderid) DESC NULLS LAST) AS employee_rank
FROM
	employees e
LEFT JOIN 
	orders o USING (employeeid)
GROUP BY
	e.employeeid
ORDER BY num_orders_managed DESC
-- Using an inner join will only include employees who have managed orders
-- Using a left join will include ALL employees, even ones with no orders managed
-- NULLS LAST will put all NULL values last (by default, they appear first)


-- Exercise 9
-- Assign a dense rank to customers based on the total revenue they have generated. (HARD)
SELECT
	c.companyname,
	ROUND(
		CAST(SUM(od.unitprice * od.quantity * (1 - od.discount)) AS NUMERIC), 2) AS total_revenue,
	DENSE_RANK() OVER(
		ORDER BY SUM(od.unitprice * od.quantity * (1 - od.discount)) DESC) AS revenue_rank
	
FROM
	order_details od
JOIN
	orders o USING (orderid)
JOIN
	customers c USING (customerid)
GROUP BY companyname


-- Exercise 10
-- Assign a row number to each product within its category based on its unit price in ascending order. 
SELECT
	productname,
	categoryid,
	unitprice,
	ROW_NUMBER() OVER(
		PARTITION BY categoryid
		ORDER BY unitprice) AS row_no
FROM
	products


-- Exercise 11
-- Take a look at the Other Window Functions, experiment on some queries, share your results with your peers in the
-- discord. Explain the insight of that query or how it can be useful.  (Build 2-3 unique queries) (HARD + CREATIVE)
