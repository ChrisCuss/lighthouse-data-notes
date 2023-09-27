-- Question 1 --

-- SELECT 		o.orderid,
-- 			od.quantity,
-- 			o.shipaddress,
-- 			o.shipcity,
-- 			o.shipcountry
			
-- FROM 		orders o

-- JOIN 		order_details od
-- 			on o.orderid = od.orderid
			
-- WHERE		od.quantity > (SELECT AVG(quantity) FROM order_details)
-- 			AND o.shipcountry LIKE '%y%'

-- Question 2 --

-- SELECT 		*
-- FROM		orders o
-- JOIN		employeeterritories et
-- 			ON o.employeeid = et.employeeid
-- WHERE		et.territoryid = '40222'

-- Question 3 --

-- SELECT		o.orderid,
-- 			c.companyname,
-- 			e.lastname
-- FROM		orders o
-- JOIN		customers c
-- 			ON o.customerid = c.customerid			
-- JOIN		employees e
-- 			ON o.employeeid = e.employeeid

--Options #2			

-- SELECT o.orderid,
--        c.companyname,
--        (SELECT e.lastname FROM employees e WHERE e.employeeid = o.employeeid) AS lastname
-- FROM orders o
-- JOIN customers c ON o.customerid = c.customerid;
			
-- Question 4 --

-- SELECT	p.productname,
-- 			s.companyname
-- FROM		products p
-- JOIN		suppliers s
-- 			ON p.supplierid = s.supplierid

--Options #2

-- SELECT	p.productname,
-- 		(SELECT s.companyname FROM suppliers s WHERE p.supplierid = s.supplierid)
-- 			AS companyname
-- FROM products p

-- Question 5 --

-- SELECT		
-- 			(SELECT c.companyname FROM customers c
-- 			 	WHERE o.customerid = c.customerid)
-- 				AS companyname,
-- 			e.lastname,
-- 			o.orderid,
-- 			o.orderdate
-- FROM		orders o		
-- JOIN		employees e
-- 			ON o.employeeid = e.employeeid
			
-- Question 6 --

-- SELECT		p.productname,
-- 			p.categoryid,
-- 			p.unitprice
-- FROM		products p
-- WHERE		p.unitprice > (SELECT AVG(unitprice)
-- 						   FROM products p2
-- 						   WHERE p.categoryid = p2.categoryid)
			