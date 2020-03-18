# SQL Social-Network Query Exercises

#### Given the database as followed:
```
Highschooler ( ID, name, grade ) 
English: There is a high school student with unique ID and a given first name in a certain grade. 

Friend ( ID1, ID2 ) 
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123). 

Likes ( ID1, ID2 ) 
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present. 
```

## Q1
#### Find the names of all students who are friends with someone named Gabriel. 
```SQL
SELECT name
FROM Highschooler
JOIN (select ID1, ID2 as ID from Friend) as F using (ID)
WHERE F.ID1 in (select ID from Highschooler where name = 'Gabriel');
```

## Q2
#### For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
```SQL
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
JOIN Likes on Likes.ID1 = H1.ID
JOIN Highschooler H2 on Likes.ID2 = H2.ID
WHERE H1.grade - H2.grade >= 2;
```

## Q3
#### For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order. 
```SQL
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
JOIN Likes on Likes.ID1 = H1.ID
JOIN Highschooler H2 on Likes.ID2 = H2.ID
WHERE H1.name < H2.name 
      and Likes.ID1 in (select ID2 from Likes) 
      and Likes.ID2 in (select ID1 from Likes)
ORDER by H1.name;
```

## Q4
#### Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
```SQL
SELECT name, grade
FROM Highschooler H1
WHERE ID not in (select ID1 from Likes) 
      and ID not in (select ID2 from Likes)
ORDER by grade, name;
```

## Q5
#### For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
```SQL
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1 
INNER JOIN Likes on Likes.ID1 = H1.ID
INNER JOIN Highschooler H2 on Likes.ID2 = H2.ID
WHERE H2.ID not in (select ID1 from Likes);
```

## Q6
#### Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
```SQL
SELECT DISTINCT H1.name, H1.grade
FROM Highschooler H1
WHERE ID not in (select F.ID1 from Friend F, Highschooler H2
                 where F.ID1 = H1.ID and H2.ID = F.ID2 and H1.grade <> H2.grade)
ORDER by H1.grade, H1.name;
```

## Q7
#### For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
```SQL
SELECT distinct ha.name, ha.grade, hb.name, hb.grade, hc.name, hc.grade
FROM Highschooler ha, Likes l, Friend f1, Friend f2, Highschooler hb, Highschooler hc
WHERE l.ID1 = ha.ID and l.ID2 = hb.ID 
      and ha.ID = f1.ID1 and hc.ID = f1.ID2
      and hb.ID = f2.ID1 and hc.ID = f2.ID2
      and hb.ID not in (select ID2 from Friend where ha.ID = ID1);
```

## Q8
#### Find the difference between the number of students in the school and the number of different first names. 
```SQL
SELECT COUNT(*) - COUNT(DISTINCT name)
FROM Highschooler;
```

## Q9
#### Find the name and grade of all students who are liked by more than one other student. 
```SQL
SELECT name, grade
FROM Highschooler h, Likes l
WHERE h.ID = l.ID2
GROUP BY l.ID2
HAVING count(ID2) >= 2;
```
