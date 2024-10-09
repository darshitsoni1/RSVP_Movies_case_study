USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- No.of rows in the tables director_mapping, genre, movie, names, ratings and role_mapping are as follow:

select count(*) as no_rows_director from director_mapping;
select count(*) as no_rows_genre from genre;
select count(*) as no_rows_movie from movie;
select count(*) as no_rows_names from names;
select count(*) as no_rows_rating from ratings;
select count(*) as no_rows_role from role_mapping;







-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- For checking the Null values making use of Count function as follows:
select count(*)- count(id) as number_null_id from movie;
select count(*)- count(title) as number_null_title from movie;
select count(*)- count(year) as number_null_year from movie;
select count(*)- count(date_published) as number_null_date from movie;
select count(*)- count(duration) as number_null_duration from movie;
select count(*)- count(country) as number_null_country from movie; -- 20 NA values
select count(*)- count(worlwide_gross_income) as number_null_gross from movie; -- 3724 NA values
select count(*)- count(languages) as number_null_lang from movie; -- 194 NA values
select count(*)- count(production_company) as number_null_prod from movie; -- 528 NA values

-- So we have 4 columns: country, worldwide_gross_income, languages, production_company which have NA values. 

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)
/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+

Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year as Year, count(title) as number_of_movies from movie group by Year;
-- The trend shows that with each passing year number of movies produced declined with highest movie produced in 2017 and lowest in 2019.
select month(date_published) as month_num, count(title) as number_of_movies from movie group by month_num order by month_num;
-- For the month wise trend, most number of movies were produced in the month of March while least number of movies were produced in December. 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select * from movie;
select count(id) as num_movies from movie where year= 2019 and (country like '%USA%' OR country like '%India%');
-- 1059 movies were produced in the USA or India in the year 2019
/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre as "List_genres" from genre;
-- 13 unique genres present in data set. 
/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

create view movie_genre as 
select m.*, genre
 from movie m inner join genre g on m.id= g.movie_id;
 
select genre, count(id) as num_movies from movie_genre 
group by genre order by num_movies desc limit 1;

-- Drama genre has highest number of movies produced with 4285 movies.  

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
select * from movie_genre;

select count(*) from
(select id
from movie_genre
group by id
having count(genre) =1) as num_movie_1_genre;
-- 3289 movies belong to only one genre. 

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)
/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select genre, round(avg(duration),2) as avg_duration from movie_genre group by genre order by avg_duration desc;
-- Action genres have highest average duration for movies followed by Romance and Crime. 
/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)
/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select genre, count(id) as movie_count, rank() over (order by count(id) desc) as "genre_rank"
from movie_genre group by genre;
-- Thriller has RANK 3 and movie count of 1484

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select min(avg_rating) as min_avg_rating, max(avg_rating) as max_avg_rating, min(total_votes) as min_total_votes, 
max(total_votes) as max_total_votes, min(median_rating) as min_median_rating, max(median_rating) as max_median_rating
from ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
select title, avg_rating, rank() over (order by avg_rating desc) as movie_rank
from movie m join ratings r on m.id= r.movie_id limit 10;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
select median_rating, count(movie_id) as movie_count from ratings group by median_rating order by movie_count desc;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH movie_rating AS (
  SELECT m.production_company, m.id
  FROM movie m
  INNER JOIN ratings r ON m.id = r.movie_id
  WHERE r.avg_rating > 8.0
    AND m.production_company IS NOT NULL
),
company_movie_counts AS (
  SELECT production_company, COUNT(id) AS movie_count
  FROM movie_rating
  GROUP BY production_company
),
ranked_companies AS (
  SELECT production_company, movie_count,
         RANK() OVER (ORDER BY movie_count DESC) AS prod_company_rank
  FROM company_movie_counts
)
SELECT production_company, movie_count, prod_company_rank
FROM ranked_companies
WHERE prod_company_rank = 1;

-- Dream Warrior Pictures and National Theater Live are the production houses that has produced the most number of hit movies

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with moviegenre_ratings as 
(
select * from movie_genre m inner join ratings r on m.id= r.movie_id)
select genre, count(id) as movie_count from moviegenre_ratings 
where year= 2017 and month(date_published)= 03 and country like '%USA%' and total_votes > 1000 group by genre order by movie_count desc;
-- So the top 3 genre are Drama with movie count of 24 followed by Comedy and Action. 

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT m.title, r.avg_rating, g.genre
FROM movie m
INNER JOIN genre g ON m.id = g.movie_id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE m.title LIKE 'The%' AND r.avg_rating > 8
ORDER BY g.genre, r.avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT count(*) as num_movies
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
WHERE  median_rating = 8
AND date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- 361 movies released between 1 April 2018 and 1 April 2019 were given median rating of 8. 

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT sum(total_votes) as "Votes Total of German Movies"
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
where languages like '%German%';
-- 4,421,525 total votes for German movies

SELECT sum(total_votes) as "Votes Total of Italian Movies"
FROM movie m
INNER JOIN ratings r ON m.id = r.movie_id
where languages like '%Italian%';
-- 2,559,540 total votes for Italian Movies
-- Yes German movies get more votes than Italian movies. 
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select count(*) - count(name) as name_nulls,
count(*) - count(height) as height_nulls,
count(*) - count(date_of_birth) as date_of_birth_nulls,
count(*) - count(known_for_movies) as known_for_movies_nulls
from names; 

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT DISTINCT
    D.name AS 'director_name', COUNT(D.Movie_id) AS movie_count
FROM
    (SELECT DISTINCT
        A.name, A.genre, A.id AS 'Movie_id'
    FROM
        (SELECT 
        d.movie_id, name, m.id, avg_rating, genre
    FROM
        names n
    INNER JOIN director_mapping d ON n.id = d.name_id
    INNER JOIN movie m ON d.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
    INNER JOIN genre g ON m.id = g.movie_id
    WHERE
        avg_rating > 8.0) A
    INNER JOIN (SELECT 
        B.genre, COUNT(movie_id) AS num_movies
    FROM
        (SELECT 
        g.movie_id, g.genre, r.avg_rating, m.title
    FROM
        movie m
    INNER JOIN genre g ON m.id = g.movie_id
    INNER JOIN ratings r ON m.id = r.movie_id
    WHERE
        r.avg_rating > 8.0) B
    GROUP BY B.genre
    ORDER BY num_movies DESC
    LIMIT 3) C ON A.genre = C.genre) D
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;
 -- The top 3 directors are James Mangold, Anthony Russo and Soubin Shahir. 

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
with name_actor as (
select movie_id, name from 
(select * from role_mapping r where category like 'actor')act inner join names n on act.name_id= n.id),

name_id_rating as (
select name, r.movie_id, median_rating from name_actor n inner join movie m on n.movie_id= m.id inner join ratings r on m.id= r.movie_id)

select name as actor_name, count(movie_id) as movie_count from name_id_rating where median_rating >= 8
group by actor_name order by movie_count desc limit 2;

-- Mammootty and Mohanlal are the 2 actors whose movies have median rating greater than or equal to 8.  


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
with movies_ratings_join as (
select m.id, m.title, m.production_company, r.total_votes from movie m inner join ratings r on m.id= r.movie_id)

select production_company, sum(total_votes) as vote_count, RANK() OVER (ORDER BY sum(total_votes) desc) as prod_comp_rank
from movies_ratings_join group by production_company limit 3;
-- So the top three production houses based on the number of votes received by their movies are 1) Marvel Studios 2) Twentieth Century Fox
-- and 3) Warner Bros.

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as 
-- the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with actor_name_India as (
select act.movie_id, act.name_id, n.name from 
(select * from role_mapping where category like 'actor')act inner join movie m on act.movie_id= m.id 
inner join names n on act.name_id= n.id where country like '%India%') 


select name as actor_name, sum(total_votes) as total_votes, count(movie_id) as movie_count,
Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating, 
RANK() OVER (ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) desc) as actor_rank from 
(select a.movie_id, a.name_id, a.name, r.avg_rating, r.total_votes, r.median_rating
 from actor_name_India a inner join ratings r on a.movie_id= r.movie_id)A
 group by actor_name having movie_count >= 5;

-- So the actor at top of the list is Vijay Sethupathi followed by Fahadh Faasil and Yogi Babu
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with actor_name_India as (
select act.movie_id, act.name_id, n.name from 
(select * from role_mapping where category like 'actress')act inner join movie m on act.movie_id= m.id 
inner join names n on act.name_id= n.id where country like '%India%' and languages like '%hindi%') 

select name as actress_name, sum(total_votes) as total_votes, count(movie_id) as movie_count,
Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating, 
RANK() OVER (ORDER BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) desc) as actress_rank from 
(select a.movie_id, a.name_id, a.name, r.avg_rating, r.total_votes, r.median_rating
 from actor_name_India a inner join ratings r on a.movie_id= r.movie_id)A
 group by actress_name having movie_count >= 3 limit 5;
-- The top actress is Taapsee Pannu followed by Kriti Sanon, Divya Dutta, Shraddha Kapoor and Kriti Kharbanda. 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
with thriller_movies as (
select title, date_published, avg_rating from genre g inner join movie m on g.movie_id= m.id inner join ratings r on m.id= r.movie_id
where genre like 'Thriller')
SELECT *,
		CASE 
			WHEN avg_rating > 8 THEN 'Superhit movie'
            WHEN avg_rating between 7 and 8 THEN 'Hit movie'
            WHEN avg_rating between 5 and 7 THEN 'One-time-watch movie'
            ELSE 'Flop movie'
		END AS movie_category
FROM thriller_movies;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
with genre_summary as (
SELECT 
    genre, AVG(duration) AS avg_duration
FROM
    genre g
        INNER JOIN
    movie m ON g.movie_id = m.id
        INNER JOIN
    ratings r ON m.id = r.movie_id
GROUP BY genre
ORDER BY avg_duration DESC)

SELECT *,
		SUM(avg_duration) OVER w1 AS running_total_duration,
        AVG(avg_duration) OVER w2 AS moving_avg_duration
FROM genre_summary
WINDOW w1 as (ORDER BY genre ROWS UNBOUNDED PRECEDING),
w2 AS (ORDER BY genre ROWS 10 PRECEDING);
-- Round is good to have and not a must have; Same thing applies to sorting
-- Let us find top 5 movies of each year with top 3 genres.
-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Top 3 Genres based on most number of movies
select D.genre, D.year, D.movie_name, D.worlwide_gross_income, D.movie_rank from 
(select C.genre, C.year, C.movie_name, C.worlwide_gross_income, row_number() over (partition by year order by worlwide_gross_income desc) as movie_rank 
from 
(select A.genre, B.year, B.movie_name, B.worlwide_gross_income from
(select genre, count(m.id) as movie_count_per_genre, rank() over(order by count(m.id) desc) as genre_rank
 from genre g inner join movie m on g.movie_id= m.id group by genre limit 3)A
inner join 
(select genre, year, title as movie_name, CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income 
  from genre g inner join movie m on g.movie_id= m.id)B
on A.genre= B.genre) C) D where D.movie_rank<=5;



-- Top 3 genres are Drama, Comedy and Thriller
-- Highest Grossing Movies of 2017:  The Fate of the Furious, Despicable Me 3, Jumanji: Welcome to the Jungle, Zhan lang II (Thriller), Zhan lang II (Drama)
--  Highest Grossing Movies of 2018:  The Villain, Bohemian Rhapsody, Venom, Mission: Impossible - Fallout and Deadpool 2
--  Highest Grossing Movies of 2019: Avengers: Endgame, The Lion King, Toy Story 4, Joker (Thriller) and Joker (Drama)

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

with prod_movie_summary as(
select *  from movie m inner join ratings r on m.id= r.movie_id
where median_rating >= 8 and POSITION(',' IN languages)>0 and production_company is not null)
select production_company, count(movie_id) as movie_count, RANK() OVER (ORDER BY count(movie_id) desc) as prod_comp_rank
from prod_movie_summary 
group by production_company limit 2;

-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits among 
-- multilingual movies. 

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


select n.name as actress_name, sum(r.total_votes) as total_votes, count(m.id) as movie_count, avg(r.avg_rating) as actress_avg_rating,
row_number() over (order by count(m.id) desc) as actress_rank
 from 
(select * from role_mapping where category like 'actress')act inner join movie m on act.movie_id= m.id 
inner join names n on act.name_id= n.id inner join ratings r on m.id= r.movie_id inner join genre g on m.id= g.movie_id
where r.avg_rating > 8 and g.genre like 'drama' group by actress_name order by movie_count desc limit 3;

-- The top 3 actresses are Parvathy Thiruvothu, Susan Brown and Amanda Lawrence. 


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH t_date_summary 
AS ( SELECT d.name_id, NAME, d.movie_id, duration, r.avg_rating, total_votes, m.date_published, 
Lead(date_published,1) OVER
(PARTITION BY d.name_id 
ORDER BY date_published,movie_id ) AS next_date_published 
FROM director_mapping AS d 
INNER JOIN names AS n ON n.id = d.name_id 
INNER JOIN movie AS m ON m.id = d.movie_id 
INNER JOIN ratings AS r ON r.movie_id = m.id ), top_director_summary AS ( 
SELECT *, Datediff(next_date_published, date_published) AS date_difference FROM t_date_summary ) 
SELECT name_id AS director_id, NAME AS director_name, 
COUNT(movie_id) AS number_of_movies, 
ROUND(AVG(date_difference),2) AS avg_inter_movie_days, 
ROUND(AVG(avg_rating),2) AS avg_rating, 
SUM(total_votes) AS total_votes, 
MIN(avg_rating) AS min_rating, 
MAX(avg_rating) AS max_rating, 
SUM(duration) AS total_duration 
FROM top_director_summary 
GROUP BY director_id 
ORDER BY COUNT(movie_id) DESC 
limit 9;
 





