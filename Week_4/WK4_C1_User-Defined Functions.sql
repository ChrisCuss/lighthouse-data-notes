--TASK 1 --
-- Create a function that can be used to compute the total order revenue of
-- a particular product from the products table (i.e., unit price times number
-- of units on order). Run a query using the function to compute the
-- total order revenue for each product in the table.

-- CREATE OR REPLACE FUNCTION TotalOnOrder(ordered int, unit_price float)
-- RETURNS float
-- AS
-- $$
-- BEGIN
--     RETURN unit_price*ordered;
-- END
-- $$
-- LANGUAGE PLPGSQL

-- TASK 2 --
-- Create a function that will compute the total cost of each individual
-- product line item in the order_details table (i.e., unit price times quantity
-- minus the percentage discount). Run a query using the function to compute the
-- product line item costs for each product in the table.

-- CREATE OR REPLACE FUNCTION totalcost(unit_price float, order_quantity int, order_discount float)
-- RETURNS float
-- AS
-- $$
-- DECLARE
-- 	cost_before_discount float;
-- 	product_cost float;
-- BEGIN
-- 	cost_before_discount = unit_price*order_quantity;
-- 	product_cost = (1-order_discount)*cost_before_discount;
-- 	RETURN product_cost;
-- END
-- $$
-- LANGUAGE PLPGSQL

-- SELECT *, totalcost(unitprice, quantity, discount)
-- FROM	order_details

-- TASK 3 --
-- Write a function that will compute the total cost of all of the orders in the
-- order_details table using the function that you wrote for question 2 and then
-- run it in a query.

-- CREATE OR REPLACE FUNCTION TotalCostAllOrders()
-- RETURNS float
-- AS
-- $$
-- DECLARE
-- 	Total_Cost_All_Orders float;
-- BEGIN
-- 	SELECT 	SUM(totalcost(unitprice, quantity, discount))
-- 	INTO	Total_Cost_All_Orders
-- 	FROM	order_details;
-- 	RETURN	Total_Cost_All_Orders;
-- END
-- $$
-- LANGUAGE PLPGSQL

-- SELECT TotalCostAllOrders()