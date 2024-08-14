CREATE DATABASE Movies_Project
-- Movies Data Exploration
USE Movies_Project

-- Select Data that we are going to be using
SELECT * FROM dbo.movie_statistic_dataset
GO

-- Top 5 movies have the worst ratings
SELECT TOP(5) movie_title, movie_averageRating FROM dbo.movie_statistic_dataset
ORDER BY movie_averageRating ASC
GO

-- Top 20 movies have the most votes
SELECT TOP(20) movie_title, movie_numerOfVotes FROM dbo.movie_statistic_dataset
ORDER BY movie_numerOfVotes DESC
GO

-- Financial gain from the movies
SELECT movie_title, (Domestic_gross + Worldwide_gross - Production_budget) AS profit
FROM dbo.movie_statistic_dataset
ORDER BY 2 DESC
GO

-- Film genres that are commonly directed by filmmakers
WITH GENTAB AS
(
    SELECT s.[value]
    FROM dbo.movie_statistic_dataset
    CROSS APPLY string_split(genres,',') s
)
SELECT value AS genre, COUNT(value) AS num_of_genre
FROM GENTAB
GROUP BY [value]
ORDER BY 2 DESC
GO

-- Compare the revenue and profit of movies made by the same director
WITH DIRSUC AS (
    SELECT director_name, (Domestic_gross + Worldwide_gross) AS revenue, 
    (Domestic_gross + Worldwide_gross - Production_budget) AS profit
    FROM dbo.movie_statistic_dataset
    WHERE NOT director_name = '-'
)
SELECT director_name, SUM(revenue)/1000 AS revenue_in_thousand, 
SUM(profit)/1000 AS profit_in_thousand
FROM DIRSUC
GROUP BY director_name
ORDER BY 2 DESC
