-- Task 1. --
-- Write a query to find out if there are order ids missing

-- SELECT		*
-- FROM			orders
-- WHERE		orderid IS NULL

-- Task 2 --
-- Write a query to get the orders with 5% discounts or higher.
-- The output should be a list of unique order id.

-- SELECT		od.orderid
-- FROM		order_details od 
-- WHERE		od.discount >= 0.05

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

-- SELECT customerid, companyname, contacttitle
-- FROM customers
-- WHERE EXISTS 
--     (SELECT customerid
--      FROM orders
--      WHERE customers.customerid = orders.customerid)

-- Task 4 --
-- Write a query to get suppliers’ companies names that are located in Germany
-- within the cities of Berlin or Frankfurt. Make sure there are no duplicates
-- in the output.

-- SELECT		DISTINC(s.supplierid) AS supplierid,
-- 			s.companyname,
-- 			s.city,
-- 			s.country

-- FROM		suppliers s
-- WHERE		country = 'Germany'
-- 			AND city IN ('Berlin', 'Frankfurt')
-- ORDER BY	supplierid

-- Task 5 --
-- Write a query to get the orders that wer
-- made in 1997 and were required in 1998.

-- SELECT		o.orderid,
-- 			o.orderdate,
-- 			o.requireddate
-- FROM		orders o
-- WHERE		DATE_PART('year', o.orderdate) = 1997
-- 			AND DATE_PART('year', o.requireddate) = 1998
-- ORDER BY	o.orderid

-- Task 6 --
-- Write a query to get the information on products with a quantity per unit
-- defined in pieces. Make sure to include all capitalization (Upper and Lower case).

-- SELECT			productid
-- 				productname,
-- 				quantityperunit

-- FROM			products

-- WHERE			quantityperunit ILIKE ('%pieces%')
-- FROM		products