-- Questions 1 --

-- SELECT		DISTINCT c.customerid,
-- 			companyname
-- FROM		customers c
-- JOIN		orders o
-- 			ON c.customerid = o.customerid
-- JOIN		order_details od
-- 			ON o.orderid = od.orderid
-- JOIN		products p
-- 			on od.productid = p.productid			
			
-- WHERE		p.unitsinstock = 0

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
-- HAVING		COUNT(o.orderid) > 1;

-- Question 4 --

-- SELECT		DISTINCT p.productid,
-- 			p.productname,
-- 			o.shippeddate
-- FROM		products p
-- JOIN		order_details od
-- 			ON p.productid = od.productid
-- JOIN		orders o
-- 			ON od.orderid = o.orderid
-- WHERE		o.shippeddate IS NULL

-- Question 5 --

-- SELECT		e.employeeid,
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
-- 		OR s.country = 'USA'

-- GROUP BY s.supplierid, p.productname

-- Question 8 --

WITH ProductOrders AS 
			(
			SELECT		DISTINCT c.customerid,
			c.companyname,
			p.productname
FROM		customers c
JOIN		orders o USING (customerid)
JOIN		order_details od
			ON	o.orderid = od.orderid
JOIN		products p
			ON	od.productid = p.productid
WHERE		p.productname = 'Chang'
			OR p.productname = 'Guaraná Fantástica'
			)
SELECT		customerid,
			companyname
FROM		ProductOrders
GROUP BY	customerid, companyname
HAVING		COUNT(productname) = 2;