-- TASK 1 --
-- Write a subquery to retrieve all orders where the order date is before the order date
-- of any orders placed by the same customer in the USA, and the total price of the order
-- is greater than $1,000.

SELECT		o.orderid,
			o.customerid,
			o.orderdate,
			SUM(od.unitprice*od.quantity*(1-od.discount)) AS Total_Value

FROM 		orders o
JOIN		order_details od USING(orderid)
WHERE 		o.orderdate < (
							SELECT MIN(o2.orderdate)
							FROM orders o2
							WHERE o2.customerid = o.customerid
							AND o2.customerid IN (
												SELECT 	customerid
												FROM 	customers
												WHERE	country = 'USA'
												)
							)
GROUP BY	o.orderid, o.customerid, o.orderdate
HAVING		SUM(od.unitprice*od.quantity*(1-od.discount)) > 1000
ORDER BY	orderdate

SELECT *
FROM Orders o
WHERE EXISTS(
  SELECT *
  FROM Orders o1
  JOIN Customers c ON o1.CustomerID = c.CustomerID AND c.Country = 'USA'
  WHERE o.CustomerID = o1.CustomerID AND o.OrderDate < o1.OrderDate
) AND (
  SELECT SUM(UnitPrice * Quantity)
  FROM Order_Details
  WHERE OrderID = o.OrderID
) > 1000;

-- TASK 2 --
-- Write a correlated subquery to retrieve the names of all employees who have a
-- higher salary than their immediate supervisor, and their respective job titles.

SELECT			firstname||' '||lastname AS name,
				title,
				(SELECT firstname||' '||lastname
				FROM	employees e2
				WHERE	e.reportsto = e2.employeeid)
FROM			employees e


SELECT e.FirstName || ' ' || e.LastName AS EmployeeName, e.Title, COUNT(*) AS NumberOfOrders
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName, e.Title
ORDER BY NumberOfOrders DESC;

-- TASK 3 --
-- Write a self-join to retrieve the names of all employees and their managers,
-- including employees who do not have a manager. Also include the job titles
-- for each employee and manager.

SELECT			firstname||' '||lastname AS name,
				title,
				(SELECT firstname||' '||lastname
				FROM	employees e2
				WHERE	e.reportsto = e2.employeeid) AS manager_name,
				(SELECT title
				FROM	employees e2
				WHERE	e.reportsto = e2.employeeid) AS manager_title
FROM			employees e

-- TASK 4 --
-- Write a window function to retrieve the top 5 customers who have spent the most money
-- on orders in the year 1997, and their respective sales amounts.
WITH		order_totals_1997 AS (
			SELECT			o.customerid,
							SUM(od.quantity*od.unitprice) AS total_sales,
							RANK() OVER (ORDER BY SUM(od.quantity*od.unitprice)DESC) AS rank
			FROM			order_details od
			JOIN			orders o USING(orderid)
			WHERE			EXTRACT(YEAR FROM orderdate) = 1997
			GROUP BY		o.customerid
									)
SELECT		c.customerid,
			c.companyname,
			ot.total_sales
FROM		customers c
JOIN		order_totals_1997 ot ON c.customerid = ot.customerid
WHERE		ot.rank <= 5

-- TASK 5 --
-- Write a CTE to retrieve the total sales revenue for each product, as well as
-- the percentage of total revenue that each product represents, for the year 1997 only.

WITH		total_product_revenue AS (
			SELECT		

)