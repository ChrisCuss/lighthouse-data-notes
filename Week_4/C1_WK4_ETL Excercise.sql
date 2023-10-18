-- STEP 1 --
-- Create a general template for creating a table
CREATE TABLE public.tempt
(
	categoryid smallint NOT NULL,
	categoryname character varying NOT NULL,
	description character varying NOT NULL,
	picture bytea,
	PRIMARY KEY(categoryid)
);

ALTER TABLE IF EXISTS public.tempt
	OWNER to postgres;
	
-- STEP 2 --
-- Use this to insert data into the created table

INSERT INTO tempt
SELECT *
FROM categories;

-- STEP 3 --
-- Validate data in the new table

SELECT 	*
FROM	tempt