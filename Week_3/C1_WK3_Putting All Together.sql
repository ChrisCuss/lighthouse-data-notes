--TASK 1--
/* Display a list of all customers, their email address, 
and the date they made their first purchase at the store. 
Order the results by the customer's last name. 
Additionally, include a column that shows the customer's total spending 
at the store, as well as a column that shows the number of distinct artists 
the customer has purchased music from. Only include customers who have 
made at least one purchase, and order the results by the total spending, 
in descending order.*/

-- SELECT 		DISTINCT (c.customerid) AS customerid,
-- 			c.firstname AS firstname,
-- 			c.lastname AS lastname,
-- 			c.email AS email,
-- 			MIN(i.invoicedate) AS firstpurchacedate,
-- 			SUM(i.total) AS totalspending,
-- 			COUNT(al.artistid) AS distinctartists
-- FROM		customer AS c
-- JOIN		invoice AS i USING(customerid)
-- JOIN		invoiceline AS il ON i.invoiceid = il.invoiceid
-- JOIN		track AS t ON il.trackid = t.trackid
-- JOIN		album	AS al ON t.albumid = al.albumid

-- GROUP BY	c.customerid
-- HAVING		SUM(i.total) > 0
-- ORDER BY	SUM(i.total)

-- Task 2 --
/*
- list all employees
- number of customers they have served
- Broken down by country
- Served at least 1 customer
- order results by total nnumber of customers DESC
*/

-- SELECT			e.employeeid AS id,
-- 				e.firstname AS firstname,
-- 				e.lastname AS lastname,
-- 				COUNT(c.supportrepid) AS customersserved,
-- 				c.country
-- FROM			customer c
-- JOIN			employee e
-- 				ON	c.supportrepid = e.employeeid
-- GROUP by		c.country, e.employeeid
-- HAVING			COUNT (c.supportrepid) IS NOT NULL
-- ORDER BY		COUNT (c.supportrepid) DESC

-- Course Solution --
--More accurate since its got a distinct stateming on customerid
-- SELECT e.FirstName || ' ' || e.LastName AS EmployeeName, c.Country, COUNT(DISTINCT c.CustomerId) AS NumCustomersServed
-- FROM Employee e
-- JOIN Customer c ON e.EmployeeId = c.SupportRepId
-- GROUP BY e.EmployeeId, c.Country
-- HAVING COUNT(DISTINCT c.CustomerId) > 0
-- ORDER BY COUNT(DISTINCT c.CustomerId) DESC;

-- Task 3 --

-- SELECT		g.name,
-- 			(SELECT 	a.name
-- 			FROM		artist a
-- 			JOIN		album al ON a.artistid = al.artistid
-- 			JOIN		track t ON al.albumid = t.albumid
-- 			JOIN		invoiceline i ON t.trackid = i.trackid
-- 			WHERE		t.genreid = g.genreid
-- 			GROUP BY	a.name
-- 			ORDER BY	COUNT(DISTINCT i.invoiceid) DESC
-- 			LIMIT 1
-- 			) AS topsellingartist
-- FROM		genre g

-- Course Solution --
-- SELECT 
--     g.Name AS GenreName, 
--     a.Name AS ArtistName, 
--     COUNT(il.InvoiceLineId) AS NumSales
-- FROM 
--     Genre g
-- JOIN 
--     Track t ON g.GenreId = t.GenreId
-- JOIN 
--     InvoiceLine il ON t.TrackId = il.TrackId
-- JOIN 
--     Album al ON t.AlbumId = al.AlbumId
-- JOIN 
--     Artist a ON al.ArtistId = a.ArtistId
-- GROUP BY 
--     g.GenreId, a.ArtistId
-- HAVING 
--     COUNT(il.InvoiceLineId) = (
--         SELECT 
--             COUNT(il2.InvoiceLineId)
--         FROM 
--             Track t2
--         JOIN 
--             InvoiceLine il2 ON t2.TrackId = il2.TrackId
--         JOIN 
--             Album al2 ON t2.AlbumId = al2.AlbumId
--         WHERE 
--             t2.GenreId = g.GenreId
--         GROUP BY 
--             al2.ArtistId
--         ORDER BY 
--             COUNT(il2.InvoiceLineId) DESC
--         LIMIT 1
--     )
-- ORDER BY 
--     GenreName DESC, NumSales DESC;

-- Task 4 --

-- SELECT	c.customerid AS customerid,
-- 			c.firstname||' '||c.lastname AS customer_name,
-- 			SUM(i.total) AS total_spending
-- FROM		customer c
-- JOIN		invoice i ON c.customerid = i.customerid
-- JOIN		invoiceline il ON i.invoiceid = il.invoiceid
-- WHERE		i.invoicedate BETWEEN '2013-01-01' AND '2013-01-31'
-- GROUP BY	c.customerid
-- HAVING		SUM(i.total) > 0
-- ORDER BY	total_spending DESC

-- TASK 5 --

-- SELECT		t.trackid AS trackid,
-- 			t.name AS trackname,
-- 			COUNT(il.invoicelineid) AS trackpurchases
-- FROM		track t
-- JOIN		invoiceline il ON t.trackid = il.trackid
-- GROUP BY	t.trackid
-- HAVING		COUNT(il.invoicelineid) > 1
-- ORDER BY	trackpurchases DESC

-- TASK 6 --

-- SELECT		c.customerid,
-- 			c.firstname,
-- 			c.lastname,
-- 			COUNT(DISTINCT g.genreid) AS total_genres
-- FROM 		customer c
-- JOIN		invoice i USING(customerid)
-- JOIN		invoiceline il ON i.invoiceid = il.invoiceid
-- JOIN		track t ON il.trackid = t.trackid
-- JOIN		genre g ON t.genreid = g.genreid
-- GROUP BY	c.customerid
-- HAVING		COUNT(g.genreid) > 1
-- ORDER BY	total_genres DESC

-- Task 7 --

-- DROP TABLE IF EXISTS PopularAlbums;
-- CREATE TABLE PopularAlbums(
-- 			AlbumID INT PRIMARY KEY,
-- 			Title VARCHAR(255),
-- 			ArtistID INT,
-- 			Albums_Sold INT
-- );

-- INSERT INTO PopularAlbums(AlbumID, Title, ArtistID, Albums_Sold)

-- SELECT		a.albumid,
-- 			a.title,
-- 			a.artistid,
-- 			SUM(il.quantity)
-- FROM		album a
-- JOIN		track t USING(albumid)
-- JOIN		invoiceline il ON t.trackid = il.trackid
-- JOIN		invoice i ON il.invoiceid = i.invoiceid
-- GROUP BY	a.albumid
-- ORDER by	SUM(il.quantity) DESC
-- LIMIT 5;

-- Select *
-- FROM popularalbums