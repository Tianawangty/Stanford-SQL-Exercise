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
#### For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
```SQL
SELECT distinct ha.name, ha.grade, hb.name, hb.grade, hc.name, hc.grade
FROM Highschooler ha, Highschooler hb, Highschooler hc, Likes l1, Likes l2
WHERE ha.ID = l1.ID1 and hb.ID = l1.ID2 
      and hb.ID = l2.ID1 and hc.ID = l2.ID2 
      and ha.ID <> hc.ID;
```

## Q2
#### Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
```SQL
SELECT DISTINCT name, grade
FROM Highschooler H1
WHERE H1.grade not in (select distinct H2.grade from Highschooler H2, Friend f 
                       where H1.ID = f.ID1 and H2.ID = f.ID2);
```

## Q3
#### What is the average number of friends per student? (Your result should be just one number.)
```SQL
SELECT AVG(count)
FROM (select count(ID1) as count 
      from Friend 
      GROUP BY ID1);
```

## Q4
#### Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
```SQL
SELECT count(*)
FROM (select * from friend where ID1 = (select id from Highschooler where name = 'Cassandra')) as a
JOIN (select * from friend) as b ON b.ID1 = A.ID2;
```

## Q5
#### Find the name and grade of the student(s) with the greatest number of friends. 
```SQL
SELECT name, grade
FROM Highschooler h, Friend f
WHERE h.ID = f.ID1
GROUP BY ID1
HAVING count(*) = (select max(count) 
                    from (select count(ID2) as count 
                          from Friend f2 group by f2.ID1));
```
