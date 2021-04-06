## Report for Lab 10 - Week 11.

### Exercise 1.

#### Test with Read committed isolation level.

##### Do both terminals show the same information? Explain the reason.
Terminals show different information.\
After step 4 the first Terminal shows the following table:
```
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  1 | jones    | Alice Jones      |      82 |        1
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  3 | mike     | Michael Dole     |      73 |        2
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
(5 rows)
```
While the second Terminal shows this table:
```
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  3 | mike     | Michael Dole     |      73 |        2
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
  1 | ajones   | Alice Jones      |      82 |        1
(5 rows)
```
It happens because the second transaction changed the row value, but this change has not been committed yet.\
That is why the first terminal still shows the old table version, so called the dirty read.\
After step 5 both terminals show the same table.

##### Explain the output form the second terminal.
The second terminal loops forever. It can't access and set new value to the row since it also was used in the first transaction.\
Transaction 1 holds this resource after step 7, and Transaction 2 can access it only after step 9 when the first Transaction is committed, and the resource is not locked.

#### Test with Repeatable read isolation level.

##### Do both terminals show the same information? Explain the reason.
Terminals show different information.\
After step 4 the first Terminal shows the following table:
```
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  1 | jones    | Alice Jones      |      82 |        1
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  3 | mike     | Michael Dole     |      73 |        2
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
(5 rows)
```
While the second Terminal shows this table:
```
 id | username |     fullname     | balance | group_id 
----+----------+------------------+---------+----------
  2 | bitdiddl | Ben Bitdiddle    |      65 |        1
  3 | mike     | Michael Dole     |      73 |        2
  4 | alyssa   | Alyssa P. Hacker |      79 |        3
  5 | bbrown   | Bob Brown        |     100 |        3
  1 | ajones   | Alice Jones      |      82 |        1
(5 rows)
```
It happens because the second transaction changed the row value, but this change has not been committed yet.\
That is why the first terminal still shows the old table version, so called the dirty read.\
After step 5 both terminals still show different tables.

##### Explain the output form the second terminal.
On step 8 Terminal 2 was preparing execution forever still the first Terminal hold the resource after its update. However, after step 9 it released it, but Terminal 2 provided the following error:
```
ERROR:  could not serialize access due to concurrent update
```

### Exercise 2.

#### Using `READ COMMITTED` isolation level: \
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

##### Explanation.
The `group_id` was updated from the second terminal (second session). This change was seen from the first session, i.e. Bob became member of second group globally. However, first session cannot modify balance of Bob due to read commited police (only second session can modify this row as it already modified earlier). As a result, the Bob was moved to second group, but his balance was not modified. 

#### Using `REPEATABLE READ` isolation level: \
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

##### Explanation.
The `group_id` was updated from the second terminal (second session). On contrary to the previous case, this change was not seen for the first session, i.e. Bob did not become member of second group and there was only one person with `group_id=2`. Therefore, the balance was updated only for `Michael Dole`. After the commits in both sessions Bob was moved to second group, but his balance was not modified. 


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
