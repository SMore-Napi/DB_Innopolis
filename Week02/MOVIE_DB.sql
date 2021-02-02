CREATE TYPE genre_type as enum ('horror', 'action', 'drama', 'science fiction', 'comedy');

CREATE TABLE if not exists MOVIES
(
    id      serial primary key not null,
    title   varchar(255)       not null,
    year    integer            not null,
    length  integer            not null,
    outline text               not null
);

CREATE TABLE if not exists MOVIE_GENRES
(
    movie_id integer references MOVIES (id) on delete cascade not null,
    genre    genre_type                                       not null
);

CREATE TABLE if not exists COMPANY
(
    id      serial primary key not null,
    name    varchar(255)       not null,
    address varchar(255)       not null
);

CREATE TABLE if not exists PRODUCED_BY
(
    movie_id   integer references MOVIES (id) on delete cascade  not null,
    company_id integer references COMPANY (id) on delete cascade not null
);

CREATE TABLE if not exists PEOPLE
(
    id            serial primary key not null,
    name          varchar(255)       not null,
    date_of_birth date               not null
);

CREATE TABLE if not exists ACTING
(
    id        serial primary key                               not null,
    person_id integer references PEOPLE (id) on delete cascade not null,
    movie_id  integer references MOVIES (id) on delete cascade not null,
    role      varchar(255)                                     not null
);

CREATE TABLE if not exists QUOTES
(
    acting_id integer references ACTING (id) on delete cascade not null,
    quote     text                                             not null

);

CREATE TABLE if not exists DIRECTING
(
    person_id integer references PEOPLE (id) on delete cascade not null,
    movie_id  integer references MOVIES (id) on delete cascade not null
);

INSERT INTO MOVIES(title, year, length, outline)
VALUES ('Rocky', 1976, 119,
        'In 1975, the heavyweight boxing world champion, Apollo Creed, announces plans to hold a title bout in Philadelphia during the upcoming United States Bicentennial. However, he is informed five weeks from the fight date that his scheduled opponent is unable to compete due to an injured hand. With all other potential replacements booked up or otherwise unavailable, Creed decides to spice things up by giving a local contender a chance to challenge him. '),
       ('Godfather', 1972, 177,
        'In 1945 New York City, at his daughter Connie''s wedding to Carlo, Vito Corleone, the don of the Corleone crime family listens to requests. His youngest son, Michael, who was a Marine during World War II, introduces his girlfriend, Kay Adams, to his family at the reception. Johnny Fontane, a popular singer and Vito''s godson, seeks Vito''s help in securing a movie role; Vito dispatches his consigliere, Tom Hagen, to Los Angeles to persuade studio head Jack Woltz to give Johnny the part. Woltz refuses until he wakes up in bed with the severed head of his prized stallion. ');

INSERT INTO MOVIE_GENRES(movie_id, genre)
VALUES (1, 'drama'),
       (1, 'action'),
       (2, 'horror'),
       (2, 'drama');

INSERT INTO COMPANY(name, address)
VALUES ('Paramount Pictures Corporation', '5555 Melrose Avenue, Hollywood, California, United States'),
       ('Chartoff-Winkler Productions', '-, New York, State of New York, United States');

INSERT INTO PEOPLE(name, date_of_birth)
VALUES ('Marlon Brando', TO_DATE('03/04/1924', 'DD/MM/YYYY')),
       ('Al Pacino', TO_DATE('25/04/1940', 'DD/MM/YYYY')),
       ('Francis Ford Coppola', TO_DATE('07/04/1939', 'DD/MM/YYYY')),
       ('Sylvester Stallone', TO_DATE('06/06/1946', 'DD/MM/YYYY')),
       ('John Avildsen', TO_DATE('21/12/1935', 'DD/MM/YYYY'));

