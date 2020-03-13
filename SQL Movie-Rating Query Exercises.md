# SQL Movie-Rating Query Exercises

#### Given the database as followed:
```
Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mIDa number of stars rating (1-5) on a certain ratingDate.
```

## Q1
#### Find the titles of all movies directed by Steven Spielberg.

```SQL
SELECT title FROM Movie
WHERE director = 'Steven Spielberg';
```

## Q2
#### Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 

```SQL
SELECT year FROM Movie
WHERE mID in (select mID from Rating where stars >= 4)
ORDER by year;
```

## Q3
#### Find the titles of all movies that have no ratings. 

```SQL
SELECT title FROM Movie
WHERE mID not in (select mID from Rating);
```

## Q4
#### Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. 

```SQL
SELECT name FROM Reviewer
WHERE rID in (select rID from Rating where ratingDate is null);
```

## Q5
#### Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. 

```SQL
SELECT name, title, stars, ratingDate
FROM Movie M NATURAL join Reviewer Re NATURAL join Rating Ra
ORDER by name, title, stars;
```

## Q6
#### For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. 

```SQL
SELECT name, title
FROM Movie
INNER JOIN Rating R1 USING(mId)
INNER JOIN Rating R2 USING(rId, mID)
INNER JOIN Reviewer USING(rId)
WHERE R1.stars > R2.stars AND R1.ratingDate > R2.ratingDate;
```

## Q7
#### For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. 

```SQL
SELECT title, MAX(stars)
FROM Movie 
INNER JOIN Rating Using(mID)
GROUP BY title
ORDER by title;
```

## Q8
#### For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. 

```SQL
SELECT title, max(stars)-min(stars) as ratingSpread
FROM Movie
INNER join Rating using (mID)
GROUP by mID
ORDER by ratingSpread desc, title;
```

## Q9
#### Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) 

```SQL
SELECT abs(avg(before.avestars) - avg(after.avestars))
FROM (select avg(stars) as avestars from Rating 
                                    INNER join Movie using (mID) 
                                    where year < 1980 group by mID) as before,
     (select avg(stars) as avestars from Rating 
                                    INNER join Movie using (mID) 
                                    where year >= 1980 group by mID) as after;
```
