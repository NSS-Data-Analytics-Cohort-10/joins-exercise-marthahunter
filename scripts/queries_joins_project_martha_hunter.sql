-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT 
	specs.movie_id, 
	film_title, 
	release_year, 
	worldwide_gross
FROM specs
	LEFT JOIN revenue
	USING (movie_id)
ORDER BY worldwide_gross
LIMIT 1;

-- Semi-Tough (1977): 37187139

-- 2. What year has the highest average imdb rating?

SELECT 
	release_year, 
	(AVG(imdb_rating)) AS avg_imdb
FROM specs
	INNER JOIN rating
	ON specs.movie_id = rating.movie_id
GROUP BY release_year
ORDER BY avg_imdb DESC
LIMIT 1;

-- 1991

-- 3. What is the highest grossing G-rated movie? Which company distributed it?

SELECT 
	film_title,
	mpaa_rating,
	worldwide_gross,
	company_name
FROM specs AS s
	LEFT JOIN revenue AS r
	ON s.movie_id = r.movie_id
	LEFT JOIN distributors AS d
	ON d.distributor_id = s.domestic_distributor_id
WHERE mpaa_rating = 'G'
ORDER BY worldwide_gross DESC
LIMIT 1;

-- Toy Story 4, Walt Disney

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

SELECT
	company_name,
	(COUNT (movie_id)) AS movie_count
FROM distributors
	LEFT JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id 
GROUP BY company_name
ORDER BY movie_count DESC;

-- 5. Write a query that returns the five distributors with the highest average movie budget.

SELECT 
	company_name,
	(AVG (film_budget)) AS average_budget
FROM revenue
	LEFT JOIN specs
	ON specs.movie_id = revenue.movie_id
	LEFT JOIN distributors
	ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY company_name
ORDER BY average_budget DESC
LIMIT 5;

-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

SELECT 
	film_title,
	(AVG (imdb_rating)) AS imdb_avg_rating
FROM distributors
	LEFT JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
	LEFT JOIN rating
	ON specs.movie_id = rating.movie_id
WHERE headquarters NOT LIKE '%CA'
GROUP BY film_title
ORDER by imdb_avg_rating DESC;

-- 2, Dirty Dancing

-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

SELECT
	(SELECT AVG (imdb_rating)
	FROM specs
		LEFT JOIN rating
		USING (movie_id)
	WHERE length_in_min > 120) AS imdb_avg_over_2_hrs,
	(SELECT AVG (imdb_rating)
	FROM specs
		LEFT JOIN rating
		USING (movie_id)
	WHERE length_in_min < 120) AS imdb_avg_under_2_hrs
	
-- Movies over 2 hours have a higher average IMDB rating

-- Bonus: Testing whether movies over 2 hours have a higher budget (could explain the higher IMDB rating)
SELECT
	(SELECT AVG (film_budget)
	FROM specs
		LEFT JOIN revenue
		USING (movie_id)
	WHERE length_in_min > 120) AS avg_budget_over_2_hrs,
	(SELECT AVG (film_budget)
	FROM specs
		LEFT JOIN revenue
		USING (movie_id)
	WHERE length_in_min < 120) AS avg_budget_under_2_hrs

-- Yes, movies over 2 hours have a significantly higher budget!