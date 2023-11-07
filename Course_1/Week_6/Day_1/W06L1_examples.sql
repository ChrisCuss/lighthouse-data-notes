-- Question 1
-- Show positions with more than 1 employee and the number of employees
SELECT
	title,
	COUNT(employeeid) AS num_employess
FROM
	employees
GROUP BY
	title
HAVING COUNT(employeeid) > 1


-- Question 2
-- Find employees who have handled more than 100 orders, along with the
-- total number of countries they handled orders from
SELECT
	CONCAT(e.firstname, ' ', e.lastname) AS employee,
	COUNT(o.orderid) AS num_orders,
	COUNT(DISTINCT o.shipcountry) AS num_countries
FROM
	orders o
JOIN
	employees e USING (employeeid)
GROUP BY
	1
HAVING
	COUNT(orderid) > 100


-- Question 3
-- Show customers who have placed at least 10 orders and have an average discount more than 5%
SELECT
	c.companyname,
	COUNT(orderid) AS num_orders,
	ROUND(CAST(AVG(od.discount) AS NUMERIC), 2) AS avg_discount
FROM
	orders o
JOIN
	order_details od USING (orderid)
JOIN
	customers c USING (customerid)
GROUP BY
	c.companyname
HAVING
	COUNT(orderid) >= 10 AND
	AVG(od.discount) > 0.05
ORDER BY
	2 DESC


-- Question 4
-- Show products with a total quantity ordered greater than 500 in categories having at least 10 products.
-- Include all products in category count
WITH product_counts AS (
SELECT
	p.productname,
	p.categoryid,
	COUNT(p.productname) OVER(PARTITION BY p.categoryid) AS num_products_in_category,
	SUM(od.quantity) AS total_quantity_ordered
FROM
	products p
LEFT JOIN 
	order_details od USING (productid)
GROUP BY
	p.productname,
	p.productid
)
SELECT
	productname,
	total_quantity_ordered
FROM
	product_counts
WHERE
	total_quantity_ordered > 500 AND
	num_products_in_category >= 10
ORDER BY total_quantity_ordered DESC


-- Question 5
-- Find products with 3 highest total sales amount and 3 lowest total sales amount, 
-- excluding products with fewer than 10 orders
WITH ranked_products AS (
SELECT
	p.productname,
	COUNT(DISTINCT od.orderid) AS num_orders,
	ROUND(CAST(SUM(od.unitprice * od.quantity * (1 - od.discount)) AS NUMERIC), 2) AS product_sales,
	RANK() OVER (
		ORDER BY SUM(od.unitprice * od.quantity * (1 - od.discount)) DESC
	) AS high_low,
	RANK() OVER (
		ORDER BY SUM(od.unitprice * od.quantity * (1 - od.discount))
	) AS low_high
FROM
	order_details od
JOIN
	products p USING (productid)
GROUP BY
	p.productname
HAVING
	COUNT(DISTINCT od.orderid) >= 10
)
SELECT
	productname,
	product_sales,
	num_orders
FROM 
	ranked_products
WHERE
	high_low <= 3 OR
	low_high <= 3
ORDER BY
	product_sales DESC
