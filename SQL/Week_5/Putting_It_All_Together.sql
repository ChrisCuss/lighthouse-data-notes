-- TASK 1 --
-- Calculate the total sales for each customer

SELECT
	c.companyname AS Company_Name,
	CAST(SUM(quantity*unitprice*(1-discount)) AS numeric(10,2)) AS Total_Sales

FROM
	customers c
JOIN	orders o ON c.customerid = o.customerid
JOIN	order_details od ON o.orderid = od.orderid
GROUP BY 1
ORDER BY 2 DESC

-- TASK 2 --
--  Calculate the average order value for each customer

SELECT
	c.companyname AS Company_Name,
	CAST(AVG(quantity*unitprice*(1-discount)) AS numeric(10,2)) AS Total_Sales

FROM
	customers c
JOIN	orders o ON c.customerid = o.customerid
JOIN	order_details od ON o.orderid = od.orderid
GROUP BY 1
ORDER BY 2 DESC

-- TASK 3 --
-- Find the total revenue for each category of product

SELECT
	c.categoryname AS Category,
	CAST(SUM(od.quantity*od.unitprice*(1-od.discount)) AS NUMERIC(10,2)) AS TotalRev
FROM	categories c
JOIN	products p ON c.categoryid = p.categoryid
JOIN	order_details od ON p.productid = od.productid
GROUP BY 1
ORDER BY 2 DESC

-- TASK 4 --
-- Find the average order value for each month in 1997

SELECT
	EXTRACT(MONTH FROM o.orderdate) AS Month,
	CAST(AVG(od.quantity*od.unitprice*(1-od.discount)) AS NUMERIC(10,2)) AS AVG_Value
FROM
	orders o
JOIN order_details od ON o.orderid = od.orderid
WHERE EXTRACT(YEAR FROM o.orderdate) = 1997
GROUP BY 1
ORDER BY 1

-- TASK 5 --
-- Find customers who have made more than $50,000 in orders

SELECT
	c.companyname AS Company_Name,
	CAST(SUM(quantity*unitprice*(1-discount)) AS numeric(10,2)) AS Total_Sales

FROM
	customers c
JOIN	orders o ON c.customerid = o.customerid
JOIN	order_details od ON o.orderid = od.orderid
GROUP BY 1
HAVING SUM(quantity*unitprice*(1-discount)) > 50000
ORDER BY 2 DESC

-- TASK 6 --
-- Find the top 10 customers with the most orders shipped to Germany

SELECT
	c.companyname AS Company_Name,
	CAST(COUNT(*) AS numeric(10,2)) AS Total_Orders
FROM
	customers c
JOIN	orders o ON c.customerid = o.customerid
JOIN	order_details od ON o.orderid = od.orderid
WHERE shipcountry = 'Germany'
GROUP BY 1
HAVING COUNT(*) > 5
ORDER BY 2 DESC
LIMIT 10