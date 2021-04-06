-- TERMINAL 1.

-- Step 1.
BEGIN;

-- Step 3.
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Step 5.
SELECT SUM(balance) as total
FROM account
WHERE group_id = 2
GROUP BY group_id;

-- Step 7.
SELECT *
FROM account
WHERE group_id = 2;

-- TODO: what is sum?
-- Step 8.
UPDATE account
SET balance = balance + 15
WHERE group_id = 2;

-- Step 9.
SELECT *
FROM account
WHERE group_id = 2;

-- Step 10.
COMMIT;

-- TERMINAL 2.

-- Step 2.
BEGIN;

-- Step 4.
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Step 6.
UPDATE account
SET group_id = 2
WHERE fullname = 'Bob Brown';

-- Step 10.
SELECT *
FROM account
WHERE group_id = 2;

-- Step 11.
COMMIT;
