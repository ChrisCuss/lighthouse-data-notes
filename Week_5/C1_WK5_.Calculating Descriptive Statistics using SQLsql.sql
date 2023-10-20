-- TASK 1 --
-- Write a query to find out the total amount invoiced of all time.
SELECT
	SUM(total)
FROM
	invoice

-- TASK 2 --
-- Write a query to find out how are the sales (invoice amounts) distributed over the years.

SELECT
	invoice_year,
	SUM(total)
FROM
	invoice
GROUP BY 1
ORDER BY 1 DESC

-- TASK 3 --
-- Write a query to find out the average value of invoices by country and by year.

SELECT
	invoice_year,
	billingcountry,
	CAST(AVG(total) AS numeric(10,2))
FROM
	invoice
GROUP BY 2,1
ORDER BY 2,1

-- TASK 4 --
-- Write a query to find out the number of unique customers by country.

SELECT
	billingcountry,
	COUNT(DISTINCT customerid)
FROM
	invoice
GROUP by 1

-- TASK 5 --
-- Write a query to find out the maximum and minimum invoice amount by country and by year.

SELECT
	billingcountry,
	MAX(total),
	MIN(total)
FROM
	invoice
GROUP BY 1
ORDER BY 1