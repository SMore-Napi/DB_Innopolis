## Report for Lab 10 - Week 11.

### Exercise 1.

Using `READ COMMITTED` isolation level: \
<b>Terminal 1. </b>
```
dvdrental=# BEGIN; 
BEGIN 

dvdrental=# SET TRANSACTION ISOLATION LEVEL READ COMMITTED; 
SET 

dvdrental=# SELECT * FROM account WHERE group_id = 2; 
 id | username |   fullname   | balance | group_id 
----+----------+--------------+---------+----------
  3 | mike     | Michael Dole |      73 |        2
(1 row)

dvdrental=# SELECT * FROM account WHERE group_id = 2;
 id | username |   fullname   | balance | group_id 
----+----------+--------------+---------+----------
  3 | mike     | Michael Dole |      73 |        2
(1 row)

dvdrental=# UPDATE account SET balance = balance + 15 WHERE group_id = 2;
UPDATE 1

dvdrental=# COMMIT;
COMMIT
```

<b> Terminal 2. </b>

```
dvdrental=# BEGIN;
BEGIN

dvdrental=# SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET

dvdrental=# UPDATE account SET group_id = 2 WHERE fullname = 'Bob Brown';
UPDATE 1

dvdrental=# COMMIT;
COMMIT
```

Final state of the table `account`. 

```
dvdrental=# SELECT * FROM account WHERE group_id = 2;
 id | username |   fullname   | balance | group_id 
----+----------+--------------+---------+----------
  5 | bbrown   | Bob Brown    |     100 |        2
  3 | mike     | Michael Dole |      88 |        2
(2 rows)
```

### Exercise 2.

### Exercise 3.

