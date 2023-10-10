-- Task 1 --
-- Display a list of orders with their ID, order date, customer ID,
-- and a new column called "Days Late" that shows the number of days
-- the order was late, calculated as the difference between the required date
-- and the shipped date. If the order has not been shipped yet, the "Days Late" 
-- column should be NULL.

-- SELECT		o.orderid,
-- 			o.orderdate,
-- 			o.customerid,
-- 			CASE
-- 				WHEN requireddate < shippeddate THEN (shippeddate-requireddate)
-- 				ELSE 0
-- 				END AS "Days Late"
-- FROM		orders o
-- ORDER BY	"Days Late" DESC

-- Task 2 --
-- Display a list of products with their name, unit price, and a new column
-- called "Discounted Price" that shows the unit price with a 10% discount
-- if the unit price is greater than $20, and otherwise shows the unit price
-- without any discount. If the unit price is NULL, the "Discounted Price" column
-- should also be NULL.

-- SELECT			p.productname,
-- 				p.unitprice,
-- 				CASE
-- 					WHEN p.unitprice > 20 THEN CAST(unitprice*0.9 AS NUMERIC)
-- 					WHEN p.unitprice IS NULL THEN NULL
-- 					else CAST(unitprice AS NUMERIC)
-- 					END AS discounted_price
-- FROM			products p

-- TASK 3 --
-- Display a list of orders with their ID, order date, customer ID,
-- and a new column called "Shipped Date" that shows the date the order
-- was shipped in the format "MM/DD/YYYY". If the shipped date is NULL, 
-- the "Shipped Date" column should display "N/A".

-- SELECT			o.orderid,
-- 				o.orderdate,
-- 				o.customerid,
-- 				COALESCE(TO_CHAR(o.shippeddate, 'MM/DD/YYYY'), 'N/A')
-- 				AS shippeddate
-- FROM			orders o

-- TASK 4 --
-- Display a list of employees with their ID, first name, last name,
-- and a new column called "Birth Year" that shows the year they were born in.
-- If the birth date is NULL, the "Birth Year" column should also be NULL.

-- SELECT		e.employeeid,
-- 			e.firstname,
-- 			e.lastname,
-- 			COALESCE(EXTRACT(YEAR FROM e.birthdate), NULL)
-- 			AS Birth_Year
-- FROM			employees e

-- Task 5 --
-- Display a list of orders with their ID, order date, customer ID,
-- and a new column called "Total Sales" that shows the total sales
-- for each order in the format "XX.XX". The total sales should be calculated
-- as the sum of the product of the quantity and unit price for each product
-- in the order. If the total sales is NULL, the "Total Sales" column should
-- also be NULL.

SELECT		o.orderid,
			o.orderdate,
			o.customerid,
			CAST(SUM(od.unitprice*od.quantity*(1-od.discount)) AS NUMERIC(10,2))
				 AS Total_Sales
FROM		orders o
JOIN		order_details od USING(orderid)
GROUP BY	o.orderid,
			o.orderdate,
			o.customerid