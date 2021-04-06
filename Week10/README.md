## Report for Lab 10 - Week 11.

### Exercise 1.

### Exercise 2.

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

Using `REPEATABLE READ` isolation level: \
<b>Terminal 1. </b>
```
dvdrental=# BEGIN;
BEGIN

dvdrental=# SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
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

dvdrental=# SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
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

### Exercise 3.
#### REPEATABLE READ
Repeatable read allows us to add new rows,
but rows that already was in the table
will be changed only by terminal one, while other terminals
cannot change existing data(update or delete).

Final stage of table `account`.
```
customers=# select * from account;
 id | username |     fullname     | balance | group_id
----+----------+------------------+---------+----------
  1 | jones    | Alice Jones      |      82 |        1
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        2
  3 | mike     | Michael Dole     |     146 |        2
```

#### SERIALIZABLE
Serializable cannot allow us to make any changes in the database,
so only first terminal changes will be used in the result.

Thus, serializable do not allow us to make concurrent transactions.

Terminal showed this message as confirmation of words above:

ОШИБКА:  не удалось сериализовать доступ из-за зависимостей чтения/записи между транзакциями
Translation: ERROR: failed to serialize access from read / transaction dependencies between transactions 

Final stage of table `account`.
```
customers=# SELECT * FROM account;
 id | username |     fullname     | balance | group_id
----+----------+------------------+---------+----------
  1 | jones    | Alice Jones      |      82 |        1
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
  3 | mike     | Michael Dole     |     146 |        2
```
