-- TASK 1 --
-- For each order, what is the number of days between order date
-- and shipping date (lead time)?

SELECT		orderid,
			customerid,
			orderdate,
			shippeddate,
			(shippeddate - orderdate) AS leadtime
FROM		orders

-- TASK 2 --
-- How many orders are shipped within each unique lead time number of days
-- (order the results by lead time descending)?

SELECT		COUNT(shippeddate - orderdate),
			(shippeddate - orderdate) AS leadtime
FROM		orders
GROUP BY	leadtime
ORDER BY 	leadtime DESC

-- TASK 3--
-- What is the lead time with the highest number of orders?

SELECT		COUNT(*) leadcount,
			(shippeddate - orderdate) AS leadtime
FROM		orders
GROUP BY	leadtime
ORDER BY 	COUNT(*) DESC
LIMIT 1

-- TASK 4 --
-- How many orders have a required delivery date on a Saturday or Sunday?

SELECT 			COUNT(*),
				EXTRACT(DOW FROM requireddate) dow

FROM			orders
GROUP BY		dow
ORDER BY		dow

-- TASK 4 --
-- For each order, determine if the order is late or not (i.e., if the shipping date is after
-- the required date)?

SELECT		*
FROM		orders

SELECT		orderid,
			customerid,
			CASE
				WHEN shippeddate > requireddate THEN 'Late'
				ELSE 'Not Late'
				END AS Status
FROM 		orders

-- TASK 5 --
-- How many orders are late vs. not late?


SELECT		COUNT(*),
			CASE
				WHEN shippeddate > requireddate THEN 'Late'
				ELSE 'Not Late'
				END AS Status
FROM 		orders
GROUP BY	Status

-- TASK 6 --
-- How many orders are shipped the same week as they are placed?

SELECT		COUNT(*)
FROM 		orders
WHERE		EXTRACT(WEEK FROM shippeddate) = EXTRACT(WEEK FROM orderdate)

SELECT COUNT(*),
CASE
  WHEN (shippeddate - orderdate BETWEEN 0 AND 7)
  AND EXTRACT(dow FROM shippeddate) > EXTRACT(dow FROM orderdate) THEN 'Yes'
  ELSE 'No'
END shipped_same_week
FROM orders
GROUP BY shipped_same_week