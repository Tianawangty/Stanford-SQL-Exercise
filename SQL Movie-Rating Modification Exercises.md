# SQL Movie-Rating Modification Exercises

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
#### Add the reviewer Roger Ebert to your database, with an rID of 209. 
```SQL
INSERT INTO Reviewer
VALUES (209, "Roger Ebert");
```

## Q2
#### Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL. 
```SQL
INSERT INTO Rating
SELECT (SELECT rId FROM Reviewer WHERE name = "James Cameron"), mId, 5, NULL
FROM Movie;
```

## Q3
#### For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.) 
```SQL
UPDATE Movie
SET year = year + 25
WHERE mId IN (select mId from Rating
                GROUP BY mId
                HAVING AVG(stars) >= 4);
```

## Q4
#### Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars. 
```SQL
DELETE FROM Rating
WHERE mID in (select mID from Movie where year < 1970 or year > 2000) and stars < 4;
```
