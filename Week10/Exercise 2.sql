-- TERMINAL 1.

-- Step 1.
BEGIN;

-- Step 3.
SELECT *
FROM account
WHERE group_id = 2;

-- Step 5.
SELECT *
FROM account
WHERE group_id = 2;

-- Step 6.
UPDATE account
SET balance = balance + 15
WHERE group_id = 2;

-- Step 7.
COMMIT;

-- TERMINAL 2.

-- Step 2.
BEGIN;

-- Step 4.
UPDATE account
SET group_id = 2
WHERE fullname = 'Bob Brown';

-- Step 8.
COMMIT;
