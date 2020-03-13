# SQL Movie-Rating Query Exercises Extras

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
#### Find the names of all reviewers who rated Gone with the Wind. 

```SQL
SELECT distinct name
FROM Reviewer
INNER join Rating using (rID)
INNER join Movie using (mID)
WHERE title = 'Gone with the Wind';
```

## Q2 
#### For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. 

```SQL
SELECT name, title, stars
FROM Reviewer NATURAL join Movie NATURAL join Rating
WHERE name = director;
```

## Q3 
#### Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) 

```SQL
SELECT name FROM Reviewer
UNION
SELECT title FROM Movie
ORDER by name, title
```

## Q4
#### Find the titles of all movies not reviewed by Chris Jackson. 
select title
from Movie
where mID not in (select mID from Rating 
                  inner join Reviewer using (rID)
                  where name = 'Chris Jackson');

## Q5
#### For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. 

```SQL
SELECT distinct r1.name, r2.name
FROM Reviewer r1, Reviewer r2, Rating ra1, Rating ra2
WHERE ra1.mID = ra2.mID
      AND r1.rID = ra1.rID 
      AND r2.rID = ra2.rID 
      AND r1.name < r2.name
ORDER by r1.name, r2.name;
```

## Q6
#### For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. 

```SQL
SELECT distinct name, title, stars
FROM Reviewer NATURAL join Movie NATRUAL join Rating
WHERE stars = (select min(stars) from Rating);
```

## Q7
#### List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

```SQL
SELECT title, avg(stars) as averating
FROM Movie NATRUAL join Rating
GROUP by title
ORDER by averating desc, title
```

## Q8
#### Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 

```SQL
SELECT distinct name
FROM Reviewer
WHERE (select count(rID) from Rating 
       where Rating.rID = Reviewer.rID) >= 3;

SELECT distinct name
FROM Reviewer NATURAL join Rating
GROUP by rID
HAVING count(rID) >= 3;
```

## Q9
#### Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 

```SQL
SELECT m1.title, m1.director
FROM Movie m1, Movie m2
WHERE m1.director = m2.director and m1.mID <> m2.mID
ORDER by m1.director, m1.title;

SELECT title, director
FROM Movie m1
WHERE (select count(director) from Movie m2 
       where m1.director = m2.director) >= 2
ORDER by director, title;
```

## Q10
#### Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 

```SQL
SELECT title, avg(stars) as avgstar
FROM Movie
INNER join Rating using (mID)
GROUP by mID
HAVING avgstar = (select max(avgstar) 
                  from (select avg(stars) as avgstar, mID
                        from Rating  
                        group by mID
                       ) 
                  );
```

## Q11
#### Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)

```SQL
SELECT title, avg(stars) as avestar
FROM Movie
INNER join Rating using (mID)
GROUP by mID
HAVING avestar = (select min(avestar) 
                  from (select avg(stars) as avestar from Rating
                  group by mID));
```

## Q12
#### For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.

```SQL
SELECT director, title, MAX(stars)
FROM Movie
INNER join Rating USING(mId)
WHERE director IS NOT NULL
GROUP by director;

SELECT director, title, R1.stars
FROM Movie
INNER join Rating R1 using (mID)
WHERE R1.mID in (select mID from Rating R2 
                 where R1.stars > R2.stars)
      AND director IS NOT NULL
GROUP by director;
```
