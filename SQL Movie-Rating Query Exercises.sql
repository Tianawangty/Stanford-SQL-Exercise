{\rtf1\ansi\ansicpg1252\cocoartf2511
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;\red37\green33\blue32;\red255\green255\blue255;\red34\green34\blue31;
}
{\*\expandedcolortbl;;\cssrgb\c19608\c17255\c16863;\cssrgb\c100000\c100000\c100000;\cssrgb\c18039\c17647\c16078;
}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs43\fsmilli21600 \cf2 \cb3 \expnd0\expndtw0\kerning0
Q1\

\fs32 \cf4 Find the titles of all movies directed by Steven Spielberg.
\fs24 \cf0 \cb1 \kerning1\expnd0\expndtw0 \
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0
\cf0 \
select title from Movie\
where director = 'Steven Spielberg';\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 \cb3 \expnd0\expndtw0\kerning0
Q2
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. \
\pard\pardeftab720\partightenfactor0
\cf4 \cb1 \
select year from Movie\
where mID in (select mID from Rating where stars >= 4)\
order by year;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 \cb3 Q3
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find the titles of all movies that have no ratings. \
\
select title from Movie\
where mID not in (select mID from Rating);\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q4
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date. \
\
select name from Reviewer\
where rID in (select rID from Rating where ratingDate is null);\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q5
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars. \cb1 \
\
select name, title, stars, ratingDate\
from Movie M natural join Reviewer Re natural join Rating Ra\
order by name, title, stars;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 \cb3 Q6
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie. \
\
SELECT name, title\
FROM Movie\
INNER JOIN Rating R1 USING(mId)\
INNER JOIN Rating R2 USING(rId, mID)\
INNER JOIN Reviewer USING(rId)\
WHERE R1.stars > R2.stars AND R1.ratingDate > R2.ratingDate;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q7
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title. \
\pard\pardeftab720\partightenfactor0
\cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 SELECT title, MAX(stars)\
FROM Movie \
INNER JOIN Rating Using(mID)\
GROUP BY title\
ORDER by title;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q8
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title. \
\
select title, max(stars)-min(stars) as ratingSpread\
from Movie\
inner join Rating using (mID)\
group by mID\
order by ratingSpread desc, title;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q9
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.) \
\
select abs(avg(before.avestars) - avg(after.avestars))\
from (select avg(stars) as avestars from Rating inner join Movie using (mID) where year < 1980 group by mID) as before,\
     (select avg(stars) as avestars from Rating inner join Movie using (mID) where year >= 1980 group by mID) as after;\
}