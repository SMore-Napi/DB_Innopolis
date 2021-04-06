-- TERMINAL 1.

-- Step 1. Start a transaction and display the accounts information.
BEGIN;
-- Test with Read committed isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Test with Repeatable read isolation level
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT *
FROM account;

-- Step 3. Display again the accounts table.
SELECT *
FROM account;

-- Step 5. Commit the changes and compare again both sessions.
SELECT *
FROM account;

-- Step 7. Update the balance for the Alice’s account by +10.
UPDATE account
SET balance = balance + 10
WHERE fullname = 'Alice Jones';

-- Step 9. Commit the changes.
COMMIT;



-- TERMINAL 2.
-- Step 2. Start a transaction and update the username for “Alice Jones” as “ajones”.
BEGIN;
-- Test with Read committed isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Test with Repeatable read isolation level
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
UPDATE account
SET username = 'ajones'
WHERE fullname = 'Alice Jones';

-- Step 4. Display again the accounts table.
SELECT *
FROM account;

-- Step 5. Commit the changes and compare again both sessions.
COMMIT;
SELECT *
FROM account;

-- Step 6. Start a new transaction.
BEGIN;
-- Test with Read committed isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
-- Test with Repeatable read isolation level
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Step 8. Update the balance for the Alice’s account by +20.
UPDATE account
SET balance = balance + 20
WHERE fullname = 'Alice Jones';

-- Step 10.
ROLLBACK;
