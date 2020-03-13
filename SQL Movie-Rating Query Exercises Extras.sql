{\rtf1\ansi\ansicpg1252\cocoartf2511
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;\red37\green33\blue32;\red255\green255\blue255;\red34\green34\blue31;
}
{\*\expandedcolortbl;;\cssrgb\c19608\c17255\c16863;\cssrgb\c100000\c100000\c100000;\cssrgb\c18039\c17647\c16078;
}
\margl1440\margr1440\vieww12760\viewh9080\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs43\fsmilli21600 \cf2 \cb3 \expnd0\expndtw0\kerning0
Q1
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find the names of all reviewers who rated Gone with the Wind. \cb1 \
\
select distinct name\
from Reviewer\
inner join Rating using (rID)\
inner join Movie using (mID)\
where title = 'Gone with the Wind';\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 \cb3 Q2
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars. \
\
select name, title, stars\
from Reviewer natural join Movie natural join Rating\
where name = director;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q3
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".) \
\
select name\
from Reviewer\
union\
select title\
from Movie\
order by name, title\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q4
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find the titles of all movies not reviewed by Chris Jackson. \
select title\
from Movie\
where mID not in (select mID from Rating \
                  inner join Reviewer using (rID)\
                  where name = 'Chris Jackson');\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q5
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order. \cb1 \
\
select distinct r1.name, r2.name\
from Reviewer r1, Reviewer r2, Rating ra1, Rating ra2\
where ra1.mID = ra2.mID\
      and r1.rID = ra1.rID \
      and r2.rID = ra2.rID \
      and r1.name < r2.name\
order by r1.name, r2.name;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 \cb3 Q6
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars. \
\
select distinct name, title, stars\
from Reviewer natural join Movie natural join Rating\
where stars = (select min(stars) from Rating);\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q7
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.\
\
select title, avg(stars) as averating\
from Movie natural join Rating\
group by title\
order by averating desc, title\
 \
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q8
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) \
\
select distinct name\
from Reviewer\
where (select count(rID) from Rating where Rating.rID = Reviewer.rID) >= 3;\
\
select distinct name\
from Reviewer natural join Rating\
group by rID\
having count(rID) >= 3;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q9
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) \
\
select m1.title, m1.director\
from Movie m1, Movie m2\
where m1.director = m2.director and m1.mID <> m2.mID\
order by m1.director, m1.title;\
\
select title, director\
from Movie m1\
where (select count(director) from Movie m2 where m1.director = m2.director) >= 2\
order by director, title;\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q10
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) \
\
select title, avg(stars) as avgstar\
from Movie\
inner join Rating using (mID)\
group by mID\
having avgstar = (select max(avgstar) \
                  from (select avg(stars) as avgstar, mID\
                        from Rating  \
                        group by mID\
                       ) \
                  );\
\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q11
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)\
\
select title, avg(stars) as avestar\
from Movie\
inner join Rating using (mID)\
group by mID\
having avestar = (select min(avestar) \
                  from (select avg(stars) as avestar from Rating\
                  group by mID));\
\
\pard\pardeftab720\partightenfactor0

\fs43\fsmilli21600 \cf2 Q12
\fs32 \cf4 \cb1 \
\pard\pardeftab720\partightenfactor0
\cf4 \cb3 For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.\
\
\
select director, title, MAX(stars)\
from Movie\
inner join Rating USING(mId)\
where director IS NOT NULL\
group by director;\
\
select director, title, R1.stars\
from Movie\
inner join Rating R1 using (mID)\
where R1.mID in (select mID from Rating R2 where R1.stars > R2.stars)\
      and director IS NOT NULL\
group by director;}