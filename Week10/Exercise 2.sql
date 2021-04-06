-- Using READ COMMITTED isolation level.

-- TERMINAL 1.

-- Step 1. Start a transaction.
BEGIN;

-- Set isolation level.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Step 3. Read accounts with group_id=2.
SELECT * FROM account WHERE group_id = 2;

-- Step 5. Read accounts with group_id=2.
SELECT * FROM account WHERE group_id = 2;

-- Step 6. Update selected accounts balances by +15.
UPDATE account SET balance = balance + 15 WHERE group_id = 2;

-- Step 7. Commit transaction.
COMMIT;

-- TERMINAL 2.

-- Step 2. Start a transaction.
BEGIN;

-- Set isolation level.
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Step 4. Move Bob to group 2.
UPDATE account SET group_id = 2 WHERE fullname = 'Bob Brown';

-- Step 8. Commit transaction.
COMMIT;



-- Using REPEATABLE READ isolation level.

-- TERMINAL 1.

-- Step 1. Start a transaction.
BEGIN;

-- Set isolation level.
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Step 3. Read accounts with group_id=2.
SELECT * FROM account WHERE group_id = 2;

-- Step 5. Read accounts with group_id=2.
SELECT * FROM account WHERE group_id = 2;

-- Step 6. Update selected accounts balances by +15.
UPDATE account SET balance = balance + 15 WHERE group_id = 2;

-- Step 7. Commit transaction.
COMMIT;

-- TERMINAL 2.

-- Step 2. Start a transaction.
BEGIN;

-- Set isolation level.
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- Step 4. Move Bob to group 2.
UPDATE account SET group_id = 2 WHERE fullname = 'Bob Brown';

-- Step 8. Commit transaction.
COMMIT;
