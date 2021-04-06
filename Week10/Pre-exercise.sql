-- Pre-exercise
CREATE TABLE account
(
    id       SERIAL PRIMARY KEY NOT NULL,
    username VARCHAR(20)        NOT NULL,
    fullname VARCHAR(20)        NOT NULL,
    balance  INTEGER            NOT NULL,
    group_id INTEGER            NOT NULL
);

-- Populate table with data.
INSERT INTO account (username, fullname, balance, group_id)
VALUES ('jones', 'Alice Jones', 82, 1),
       ('bitdiddl', 'Ben Bitdiddle', 65, 1),
       ('mike', 'Michael Dole', 73, 2),
       ('alyssa', 'Alyssa P. Hacker', 79, 3),
       ('bbrown', 'Bob Brown', 100, 3);

