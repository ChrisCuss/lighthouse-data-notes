SELECT		a.albumid AS albumid,
			a.title AS title,
			t.name AS track_name
			
FROM		album a
INNER JOIN	track t USING(albumid)


-- STEP 1 --
-- Systematically validate
-- the number of albums and number of tracks

-- Album Query 1 --
-- Get the number of albums from our original query

SELECT			COUNT(DISTINCT albumid)

FROM			(
				SELECT			a.albumid AS albumid,
								a.title AS title,
								t.name AS track_name
				FROM			album a
				JOIN		track t USING(albumid)
				) tmp
				
-- Album Query 2 --
-- Get the number of albums from the Album table

SELECT			COUNT(DISTINCT albumid)
FROM			album

-- Track Query 1 --
-- Get the number of tracks from our original query

SELECT		COUNT(DISTINCT track_name)
FROM		(
			SELECT		a.albumid AS albumid,
						a.title AS title,
						t.name AS track_name
			FROM		album a
			INNER JOIN	track t USING(albumid)
			) tmp
			
-- TRACK Query 2 --
-- Get the number of tracks from the Tracks table

SELECT 	COUNT(trackid)
FROM	track

-- Make sure albums don't have multiple tracks
-- that have the same name

SELECT		title,
			track_name,
			COUNT(*)
FROM		(
			SELECT		a.albumid AS albumid,
						a.title AS title,
						t.name AS track_name
			FROM		album a
			INNER JOIN	track t USING(albumid)
			)
GROUP BY	track_name, title
HAVING		COUNT(*) > 1
ORDER BY	track_name

-- Spot check a specific album

SELECT 	*
FROM	track
WHERE albumid = 229

-- STEP 2 --
-- Manually spot check

SELECT 	*
FROM	(
			SELECT		a.albumid AS albumid,
						a.title AS title,
						t.name AS track_name
			FROM		album a
			INNER JOIN	track t USING(albumid)
			WHERE		albumid = 229
		) tmp
ORDER BY	track_name