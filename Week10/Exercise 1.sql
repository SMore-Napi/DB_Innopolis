-- TERMINAL 1.

BEGIN;

-- Step 1.
SELECT *
FROM account;

-- Step 3.
SELECT *
FROM account;

-- Step 5.
SELECT *
FROM account;

-- Step 7.
UPDATE account
SET balance = balance + 10
WHERE fullname = 'Alice Jones';

-- Step 9.
COMMIT;

-- TERMINAL 2.

BEGIN;

-- Step 2.
UPDATE account
SET username = 'ajones'
WHERE fullname = 'Alice Jones';

-- Step 4.
SELECT *
FROM account;

-- Step 5.
COMMIT;

SELECT *
FROM account;

-- Step 6
BEGIN;

-- Step 8.
UPDATE account
SET balance = balance + 20
WHERE fullname = 'Alice Jones';

-- Step 10.
ROLLBACK;
