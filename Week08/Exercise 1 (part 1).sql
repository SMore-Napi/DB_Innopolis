-- Exercise 1


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


-- Transaction T1.
BEGIN;
UPDATE accounts
SET credit = credit - 500
WHERE name = 'Account 1';
UPDATE accounts
SET credit = credit + 500
WHERE name = 'Account 3';
COMMIT;


-- Transaction T2.
BEGIN;
UPDATE accounts
SET credit = credit - 700
WHERE name = 'Account 2';
UPDATE accounts
SET credit = credit + 700
WHERE name = 'Account 1';
COMMIT;


-- Transaction T3.
BEGIN;
UPDATE accounts
SET credit = credit - 100
WHERE name = 'Account 2';
UPDATE accounts
SET credit = credit + 100
WHERE name = 'Account 3';
COMMIT;


-- Return credits for all accounts.
SELECT credit
FROM accounts;

