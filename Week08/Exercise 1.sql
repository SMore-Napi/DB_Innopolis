-- Exercise 1.

-- Part 1.
-- Create accounts table.
CREATE TABLE accounts
(
    id     SERIAL PRIMARY KEY NOT NULL,
    name   VARCHAR(40)        NOT NULL,
    credit INTEGER            NOT NULL
);

-- Populate table with data.
INSERT INTO accounts (name, credit)
VALUES ('Account 1', 1000),
       ('Account 2', 1000),
       ('Account 3', 1000);

-- Initial state of credits for all accounts.
SELECT name, credit
FROM accounts;

-- Shared transaction for part 1.
BEGIN;
SAVEPOINT PART1;

-- Transaction T1.
UPDATE accounts
SET credit = credit - 500
WHERE name = 'Account 1';
UPDATE accounts
SET credit = credit + 500
WHERE name = 'Account 3';

-- Transaction T2.
UPDATE accounts
SET credit = credit - 700
WHERE name = 'Account 2';
UPDATE accounts
SET credit = credit + 700
WHERE name = 'Account 1';

-- Transaction T3.
UPDATE accounts
SET credit = credit - 100
WHERE name = 'Account 2';
UPDATE accounts
SET credit = credit + 100
WHERE name = 'Account 3';

-- Credits for all accounts after execution of part 1.
SELECT name, credit
FROM accounts;

-- Return to the original state.
ROLLBACK TO PART1;


-- Part 2.
-- Create new attribute bank_name.
ALTER TABLE accounts
ADD bank_name VARCHAR(20) DEFAULT NULL;
UPDATE accounts SET bank_name = 'SpearBank' WHERE name = 'Account 1' or name = 'Account 3';
UPDATE accounts SET bank_name = 'Tinkoff' WHERE name = 'Account 2';

-- Create new account to store fees.
INSERT INTO accounts (name, credit, bank_name)
VALUES ('Account 4', 0, NULL);

-- Shared transaction for part 2.
BEGIN;
SAVEPOINT PART2;

-- Transaction T1.
UPDATE accounts
SET credit = credit - 500
WHERE name = 'Account 1';
UPDATE accounts
SET credit = credit + 500
WHERE name = 'Account 3';

-- Transaction T2.
UPDATE accounts
SET credit = credit - 730
WHERE name = 'Account 2';
UPDATE accounts
SET credit = credit + 700
WHERE name = 'Account 1';
UPDATE accounts
SET credit = credit + 30
WHERE name = 'Account 4';

-- Transaction T3.
UPDATE accounts
SET credit = credit - 130
WHERE name = 'Account 2';
UPDATE accounts
SET credit = credit + 100
WHERE name = 'Account 3';
UPDATE accounts
SET credit = credit + 30
WHERE name = 'Account 4';

-- Credits for all accounts after execution of part 2.
SELECT name, credit
FROM accounts;

-- Return to the original state.
ROLLBACK TO PART2;

-- Final state of credits for all accounts after the rollback.
SELECT name, credit
FROM accounts;
