-- 1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS count
FROM netflix
GROUP BY type;

-- 2. Most common rating per type (Movie/TV Show)
WITH RatingCounts AS (
    SELECT 
        type, 
        rating, 
        COUNT(*) AS count, 
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rn
    FROM netflix
    GROUP BY type, rating
)
SELECT type, rating, count
FROM RatingCounts
WHERE rn = 1;

-- 3. List all movies released in the year 2020
SELECT title 
FROM netflix
WHERE type = 'Movie' 
AND release_year = 2020;

-- 4. Top 5 countries with the most content (split multiple countries)
WITH splited_countries AS (
	SELECT unnest(string_to_array(country,', ')) AS country
	FROM netflix
	WHERE country IS NOT NULL
)
SELECT country, COUNT(*) AS content
FROM splited_countries
GROUP BY country
ORDER BY COUNT(*) DESC
LIMIT 5;

-- 5. Identify the longest movie
SELECT title, duration
FROM netflix
WHERE type = 'Movie' AND duration IS NOT NULL
ORDER BY CAST(TRIM(REPLACE(duration, 'min', '')) AS INT) DESC
LIMIT 1;

-- 6. Find content added in the last 5 years
WITH years_data AS (
    SELECT 
        *, 
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS added_year
    FROM netflix
    WHERE date_added IS NOT NULL
)
SELECT *, added_year
FROM years_data
WHERE added_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 5
ORDER BY added_year DESC;

-- 7. All content by director 'Rajiv Chilaka'
SELECT * 
FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';

-- 8. TV Shows with more than 5 seasons
WITH tv_shows AS (
	SELECT *, 
		   CAST(TRIM(REPLACE(duration, ' Seasons', '')) AS INT) AS seasons
	FROM netflix
	WHERE type ILIKE 'TV Show'
	AND duration ILIKE '%Seasons'
)
SELECT title, seasons
FROM tv_shows 
WHERE seasons > 5;

-- 9. Count of content items in each genre
WITH genres AS (
    SELECT 
        title,
        UNNEST(string_to_array(listed_in, ', ')) AS genre
    FROM netflix
    WHERE listed_in IS NOT NULL
)
SELECT 
    TRIM(genre) AS genre,
    COUNT(*) AS content_count
FROM genres
GROUP BY genre
ORDER BY content_count DESC;

-- 10. Average content released in France by year
WITH france_content AS (
    SELECT 
        release_year,
        COUNT(*) AS content_count
    FROM netflix
    WHERE country LIKE '%France%'
    GROUP BY release_year
)
SELECT 
    release_year, 
    ROUND(AVG(content_count), 2) AS avg_content_release
FROM france_content
GROUP BY release_year
ORDER BY avg_content_release DESC
LIMIT 5;

-- 11. All documentary movies
SELECT title, listed_in
FROM netflix
WHERE type = 'Movie' 
AND listed_in LIKE '%Documentaries%';

-- 12. Content with no director listed
SELECT * 
FROM netflix
WHERE director IS NULL OR director = '';

-- 13. Number of movies with Salman Khan in the last 10 years
WITH salman_khan_movies AS (
	SELECT *
	FROM netflix
	WHERE type = 'Movie' 
	AND casts LIKE '%Salman Khan%' 
)
SELECT COUNT(*)
FROM salman_khan_movies 
WHERE release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

-- 14. Top 10 actors in French movies
WITH france_content AS (
    SELECT 
		title, 
        UNNEST(string_to_array(casts, ', ')) AS actor
    FROM netflix
    WHERE country LIKE '%France%' 
    AND type = 'Movie'
	AND casts IS NOT NULL
)
SELECT 
    TRIM(actor) AS actor, 
    COUNT(*) AS movies
FROM france_content
GROUP BY actor
ORDER BY movies DESC
LIMIT 10;

-- 15. Categorize content as 'Good' or 'Bad' based on description
WITH pg AS (
	SELECT 
		title,
		CASE
			WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
			ELSE 'Good'
		END AS status,
		description
	FROM netflix 
)
SELECT status, COUNT(*) AS content
FROM pg 
GROUP BY status 
ORDER BY content DESC;
