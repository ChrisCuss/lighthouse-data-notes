-- Questions 1 --

-- SELECT		DISTINCT(c.customerid) AS customerid,
-- 			companyname
-- FROM		customers c
-- JOIN		orders o
-- 			ON c.customerid = o.customerid
-- JOIN		order_details od
-- 			ON o.orderid = od.orderid
-- JOIN		products p
-- 			on od.productid = p.productid			
			
-- WHERE		od.quantity > p.unitsinstock

-- Question 2 --

-- SELECT		DISTINCT e.employeeid,
-- 			firstname,
-- 			lastname,
-- 			COUNT(o.employeeid)
-- FROM		employees e

-- FULL JOIN		orders o
-- 			on e.employeeid = o.employeeid

-- GROUP BY	e.employeeid, firstname, lastname

-- HAVING		COUNT(o.employeeid) = 0

-- Question 3 --

-- SELECT	DISTINCT c.customerid,
-- 			c.companyname,
-- 			o.orderdate
-- FROM		customers c
-- JOIN		orders o
-- 			ON c.customerid = o.customerid
-- GROUP BY	c.customerid, c.companyname, o.orderdate
-- HAVING		COUNT(o.orderid) > 1

-- Question 4 --

-- SELECT	DISTINCT p.productid,
-- 			p.productname,
-- 			o.shippeddate
-- FROM		products p
-- JOIN		order_details od
-- 			ON p.productid = od.productid
-- JOIN		orders o
-- 			ON od.orderid = o.orderid
-- WHERE	o.shippeddate IS NULL
-- ORDER BY p.productid

-- Question 5 --

-- SELECT		DISTINCT e.employeeid,
-- 			e.firstname,
-- 			e.lastname
-- FROM		employees e
-- JOIN		orders o
-- 			ON e.employeeid = o.employeeid
-- JOIN		customers c
-- 			ON o.customerid = c.customerid
-- WHERE		e.city = c.city;

-- Question 6 --
-- Employees that live in the same city as Suppliers

-- -- Find Employees
-- SELECT		e.employeeid AS id,
-- 			e.firstname||' '||e.lastname as name,
-- 			e.city,
-- 			'Employee' as relation
-- FROM		employees e
-- JOIN		suppliers s
-- 			ON e.city = s.city
-- UNION

-- --Find Suppliers
-- SELECT		supplierid,
-- 			s.companyname,
-- 			s.city,
-- 			'Supplier' as relation
-- FROM		suppliers s
-- JOIN		employees e
-- 			ON s.city = e.city

-- Question 7 --

-- SELECT	s.supplierid,
-- 		s.companyname,
-- 		s.country,
-- 		p.productname

-- FROM	suppliers s
-- JOIN	products p
-- 		ON s.supplierid = p.supplierid
-- WHERE	s.country = 'UK'
-- 			OR s.country = 'USA'

-- GROUP BY s.supplierid, p.productname

-- Question 8 --

-- SELECT		DISTINCT c.customerid,
-- 			c.companyname
-- FROM		customers c
-- JOIN		orders o
-- 			ON	c.customerid = o.customerid
-- JOIN		order_details od
-- 			ON	o.orderid = od.orderid
-- JOIN		products p
-- 			ON	od.productid = p.productid
-- WHERE		p.productname IN ('Chang', 'Guaraná Fantástica')

-- Question 9 --

-- WITH		samecountry AS
-- 			(
-- 			SELECT		p.productid,
-- 						p.productname,
-- 						c.customerid,
-- 						c.country customer_country,
-- 						s.country supplier_country,
-- 						o.orderid
-- 			FROM		orders o
-- 			JOIN		order_details od
-- 						ON o.orderid = od.orderid
-- 			JOIN		products p
-- 						ON od.productid = p.productid
-- 			JOIN		customers c
-- 						ON o.customerid = c.customerid
-- 			JOIN		suppliers s
-- 						ON p.supplierid = s.supplierid
-- 			WHERE		c.country = s.country	
-- 			)
-- SELECT	DISTINCT productid,
-- 		productname
-- FROM	samecountry
-- ORDER BY	productID


-- -- Course Solution
-- SELECT productname
-- FROM products p
-- WHERE supplierid IN (
--   SELECT supplierid
--   FROM suppliers s
--   WHERE country IN (
--     SELECT shipcountry
--     FROM orders o
--     JOIN customers c 
--       ON o.customerid = c.customerid
--     WHERE p.supplierid = s.supplierid
--   )
-- )
-- Question 10 --

WITH ordercount AS
(
SELECT		p.productid productid,
			p.productname productname,
			SUM(od.quantity) total_quantity,
			COUNT(o.orderid) numberoforders
FROM		orders o
JOIN		order_details od USING(orderid)
JOIN		products p
			ON od.productid = p.productid
GROUP BY	p.productid
)

SELECT 	productid,
		productname,
		total_quantity,
		numberoforders
FROM	ordercount
WHERE	numberoforders > 1

-- Course Solution

-- SELECT p.productname, od.quantity
-- FROM products p
-- JOIN order_details od 
-- ON p.productid = od.productid
-- WHERE od.quantity > (
--   SELECT od2.quantity
--   FROM order_details od2
--   WHERE od2.productid = od.productid
--   AND od2.orderid <> od.orderid
--   ORDER BY od2.quantity DESC
--   LIMIT 1
-- )