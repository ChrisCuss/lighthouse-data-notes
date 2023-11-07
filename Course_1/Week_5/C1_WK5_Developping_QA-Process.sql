/*1. Data validation for TASK 1:

Check that the email addresses provided for each customer are in a valid email format.

Ensure that the FirstPurchaseDate is not later than the current date.

Verify that the TotalSpent column contains valid decimal or integer values.

Check that the NumDistinctArtists column contains integer values and is not negative. */

SELECT
		c.firstname
	,	c.lastname
	,	CASE
			WHEN c.email NOT LIKE '%_@%__%.__%' THEN NULL
			ELSE c.email
			END AS email
	,	MIN(i.invoicedate) AS "First_Purchase_Date"
	,	SUM(CASE WHEN i.total NOT BETWEEN 0 AND 9999999 THEN NULL
		   ELSE i.total END) AS "Total_Spent"
	,	COUNT(DISTINCT CASE WHEN al.artistid NOT BETWEEN 1 AND 999 THEN NULL
			 ELSE al.artistid END) AS "Num_Distinct_Artists"
FROM
	customer c
JOIN
	invoice i ON c.customerid = i.customerid
JOIN
	invoiceline il ON i.invoiceid = il.invoiceid
JOIN
	track t ON il.trackid = t.trackid
JOIN
	album al on t.albumid = al.albumid
GROUP BY
	c.customerid
HAVING
	SUM(i.total) > 0
ORDER BY
	5 DESC, 2
	
/* 2. Data validation for TASK 4:

Ensure that the InvoiceDate column is in a valid date format.

Verify that the TotalSpent column contains valid decimal or integer values.

Check that the FirstName and LastName columns contain only alphabetic characters
and have a length within a specified range. */

SELECT 	
		c.FirstName
	, 	c.LastName
	,	i.invoicedate
	,	CASE
			WHEN c.email NOT LIKE '%_@__%.__%' THEN NULL
			ELSE c.email
			END AS email
	,	SUM(CASE WHEN i.Total NOT BETWEEN 0 AND 999999 THEN NULL
		   ELSE i.total END) AS TotalSpent
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceDate BETWEEN '2013-01-01' AND '2013-01-31'
	AND EXTRACT('month' FROM i.invoicedate) = '01'
	AND LENGTH(c.firstname) BETWEEN 1 AND 50
	AND LENGTH(c.lastname)	BETWEEN 1 AND 50
	AND c.firstname SIMILAR to '[A-Za-z]{1,50}'
	AND c.lastname	SIMILAR to '[A-Za-z]{1,50}'
GROUP BY c.CustomerId, i.invoiceid
HAVING SUM(i.Total) > 0
ORDER BY SUM(i.Total) DESC;

/* 3. Data validation for TASK 6:

Ensure that the Genre table has a GenreId column that is a valid integer.

Verify that the Customer, Invoice, InvoiceLine, Track, and Genre tables are properly joined
on their respective keys.

Confirm that the COUNT function with the DISTINCT keyword is accurately calculating 
the number of distinct genres each customer has purchased music from.

Check that the results only include customers who have purchased music from more
than one genre.

Verify that the results are ordered by the number of distinct genres in descending order. */

-- Validate JOINS
SELECT 
	COUNT(*)
FROM
	Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
	
-- Validate the COUNT function with DISTINCT
SELECT
	COUNT(DISTINCT g.GenreId) 
FROM 
	Customer c 
JOIN Invoice i ON c.CustomerId = i.CustomerId 
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId;

-- Validate that the query only returns customers who have purchased music 
--from more than one genre
SELECT COUNT(*)
FROM (
SELECT c.FirstName, c.LastName, COUNT(DISTINCT g.GenreId) AS NumDistinctGenres
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY c.CustomerId
HAVING COUNT(DISTINCT g.GenreId) > 1
ORDER BY COUNT(DISTINCT g.GenreId) DESC
	) AS subquery

-- Validate the order by clause

SELECT
		c.FirstName
	,	c.LastName
	,	COUNT(DISTINCT g.GenreId) AS NumDistinctGenres
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
JOIN Genre g ON t.GenreId = g.GenreId
GROUP BY c.CustomerId
HAVING COUNT(DISTINCT g.GenreId) > 1
ORDER BY NumDistinctGenres DESC;
