CREATE TYPE genre_type as enum ('horror', 'action', 'drama', 'science fiction', 'comedy');

CREATE TABLE if not exists MOVIE
(
    id      serial primary key not null,
    title   varchar(255)       not null,
    year    integer            not null,
    length  integer            not null,
    outline text               not null
);

CREATE TABLE if not exists MOVIE_GENRE
(
    movie_id integer references MOVIE (id) on delete cascade not null,
    genre    genre_type                                      not null
);

CREATE TABLE if not exists COMPANY
(
    id      serial primary key not null,
    name    varchar(255)       not null,
    address varchar(255)       not null
);

CREATE TABLE if not exists PRODUCTION
(
    company_id integer references COMPANY (id) on delete cascade not null,
    movie_id   integer references MOVIE (id) on delete cascade   not null
);

CREATE TABLE if not exists EMPLOYEE
(
    id            serial primary key not null,
    name          varchar(255)       not null,
    date_of_birth date               not null
);

CREATE TABLE if not exists ACTING
(
    id          serial primary key                                 not null,
    employee_id integer references EMPLOYEE (id) on delete cascade not null,
    movie_id    integer references MOVIE (id) on delete cascade    not null,
    role        varchar(255)                                       not null
);

CREATE TABLE if not exists QUOTE
(
    acting_id integer references ACTING (id) on delete cascade not null,
    line      text                                             not null
);

CREATE TABLE if not exists DIRECTING
(
    employee_id integer references EMPLOYEE (id) on delete cascade not null,
    movie_id    integer references MOVIE (id) on delete cascade    not null
);

INSERT INTO MOVIE(title, year, length, outline)
VALUES ('Rocky', 1976, 119,
        'In 1975, the heavyweight boxing world champion, Apollo Creed, announces plans to hold a title bout in Philadelphia during the upcoming United States Bicentennial. However, he is informed five weeks from the fight date that his scheduled opponent is unable to compete due to an injured hand. With all other potential replacements booked up or otherwise unavailable, Creed decides to spice things up by giving a local contender a chance to challenge him. '),
       ('Godfather', 1972, 177,
        'In 1945 New York City, at his daughter Connie’s wedding to Carlo, Vito Corleone, the don of the Corleone crime family listens to requests. His youngest son, Michael, who was a Marine during World War II, introduces his girlfriend, Kay Adams, to his family at the reception. Johnny Fontane, a popular singer and Vito’s godson, seeks Vito’s help in securing a movie role; Vito dispatches his consigliere, Tom Hagen, to Los Angeles to persuade studio head Jack Woltz to give Johnny the part. Woltz refuses until he wakes up in bed with the severed head of his prized stallion. ');

INSERT INTO MOVIE_GENRE(movie_id, genre)
VALUES (1, 'drama'),
       (1, 'action'),
       (2, 'horror'),
       (2, 'drama');

INSERT INTO COMPANY(name, address)
VALUES ('Paramount Pictures Corporation', '5555 Melrose Avenue, Hollywood, California, United States'),
       ('Chartoff-Winkler Productions', '-, New York, State of New York, United States');

INSERT INTO EMPLOYEE(name, date_of_birth)
VALUES ('Marlon Brando', TO_DATE('03/04/1924', 'DD/MM/YYYY')),
       ('Al Pacino', TO_DATE('25/04/1940', 'DD/MM/YYYY')),
       ('Francis Ford Coppola', TO_DATE('07/04/1939', 'DD/MM/YYYY')),
       ('Sylvester Stallone', TO_DATE('06/06/1946', 'DD/MM/YYYY')),
       ('John Avildsen', TO_DATE('21/12/1935', 'DD/MM/YYYY'));

INSERT INTO DIRECTING(employee_id, movie_id)
VALUES (5, 1),
       (3, 2);

INSERT INTO PRODUCTION(movie_id, company_id)
VALUES (2, 1),
       (1, 2);

INSERT INTO ACTING(employee_id, movie_id, role)
VALUES (1, 2, 'Vito Carleone'),
       (2, 2, 'Michael Carleone'),
       (4, 1, 'Rocky Balboa');

INSERT INTO QUOTE(acting_id, line)
VALUES (1, 'Revenge is a dish best served cold'),
       (2,
        'There are negotiations being made that are going to answer all of your questions and solve all of your problems. That’s all I can tell you right now. Carlo, you grew up in Nevada. When we make our move there you’re going to be my right hand man. Tom Hagen is no longer Consigliari. He’s going to be our lawyer in Vegas. That’s no reflection on Tom it’s just the way I want it. Besides, if I ever help who’s a better Consigliari than my father. That’s it.'),
       (2,
        'I’ll make him an offer he can’t refuse. You see, Johnny, we feel that entertainment is going to be a big factor in drawing gamblers into the casinos. We’re hoping that you’ll sign a contract agreeing to appear 5 times a year. Perhaps convince some of your friends in the movies to do the same. We’re counting on you, Johnny.'),
       (3,
        'Let me tell you something you already know. The world ain’t all sunshine and rainbows. It is a very mean and nasty place and it will beat you to your knees and keep you there permanently if you let it. You, me, or nobody is gonna hit as hard as life. But it ain’t how hard you hit; it’s about how hard you can get hit, and keep moving forward. How much you can take, and keep moving forward. That’s how winning is done. Now, if you know what you’re worth, then go out and get what you’re worth. But you gotta be willing to take the hit, and not pointing fingers saying you ain’t where you are because of him, or her, or anybody. Cowards do that and that ain’t you. You’re better than that.'),
       (3,
        'Life’s not about how hard of a hit you can give… it’s about how many you can take, and still keep moving forward.');
