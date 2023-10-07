-- ** Movie Database project. See the file movies_erd for table\column info. **

-- Give the name, release year, and worldwide gross of the lowest grossing movie.

SELECT specs.movie_id, film_title, release_year, worldwide_gross
FROM specs
LEFT JOIN revenue
USING (movie_id)
ORDER BY worldwide_gross;

-- Semi-Tough (1977): 37187139

-- What year has the highest average imdb rating?

SELECT release_year, AVG(imdb_rating) AS avg_imdb
FROM specs
INNER JOIN rating
ON specs.movie_id = rating.movie_id
GROUP BY release_year
ORDER BY avg_imdb DESC;

-- 1991

-- What is the highest grossing G-rated movie? Which company distributed it?

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
ORDER BY worldwide_gross DESC;

-- Toy Story 4, Walt Disney

-- Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.

-- Write a query that returns the five distributors with the highest average movie budget.

-- How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?

-- Which have a higher average rating, movies which are over two hours long or movies which are under two hours?