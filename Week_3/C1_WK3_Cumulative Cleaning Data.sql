-- Task 1. --
-- Write a query to find out if there are order ids missing

-- SELECT		*
-- FROM			orders
-- WHERE		orderid IS NULL

-- Task 2 --
-- Write a query to get the orders with 5% discounts or higher.
-- The output should be a list of unique order id.

-- SELECT		o.orderid,
-- 			(od.unitprice*od.quantity) AS value,
-- 			od.discount
-- FROM 		orders o
-- JOIN		order_details od USING(orderid)
-- WHERE		od.discount >= 0.05
-- ORDER BY	discount DESC

-- Task 3 --
-- Write a query to get detailed information on customers that made orders.
-- Your output must include the company name, the contact title,
-- and the id of each customer.

-- SELECT		c.customerid,
-- 			c.companyname,
-- 			c.contacttitle,
-- 			COUNT(o.orderid) AS total_orders

-- FROM		customers c
-- JOIN		orders o USING(customerid)
-- GROUP BY	c.customerid,
-- 			c.companyname,
-- 			c.contacttitle	
-- HAVING		COUNT(o.orderid) > 0
-- ORDER BY	total_orders DESC

-- Task 4 --
-- Write a query to get suppliers’ companies names that are located in Germany
-- within the cities of Berlin or Frankfurt. Make sure there are no duplicates
-- in the output.

SELECT		S