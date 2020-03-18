# SQL Social-Network Modification Exercises

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
#### It's time for the seniors to graduate. Remove all 12th graders from Highschooler. 
```SQL
DELETE FROM Highschooler
WHERE grade = 12;
```

## Q2
#### If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple. 
```SQL
DELETE from Likes
WHERE ID2 in (select ID2 from Friend where Likes.ID1 = ID1) and
      ID2 not in (select l2.ID1 from Likes l2 where Likes.ID1 = l2.ID2);
```

## Q3 
#### For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself.
```SQL
INSERT INTO Friend
SELECT F1.iD1, F2.iD2 
FROM Friend F1, Friend F2
WHERE F1.iD2 = F2.iD1
      and F1.iD1 <> F2.iD2
EXCEPT 
select * from Friend
```


