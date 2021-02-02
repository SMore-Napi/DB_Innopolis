create type genre_type as enum ('horror', 'action', 'drama', 'science fiction');
create type role_type as enum ('actor', 'director');

CREATE TABLE if not exists MOVIE
(
    id      serial primary key not null,
    title   varchar(255)       not null,
    year    varchar(4)         not null,
    length  integer            not null,
    outline text               not null
);

CREATE TABLE if not exists MOVIE_GENRES
(
    movie_id integer references MOVIE (id) on delete cascade not null,
    genre    genre_type primary key                          not null
);

CREATE TABLE if not exists COMPANY
(
    id      serial primary key not null,
    name    varchar(255)       not null,
    address varchar(255)       not null
);

CREATE TABLE if not exists PERSON
(
    id            serial primary key not null,
    name          varchar(255)       not null,
    date_of_birth date               not null
);

CREATE TABLE if not exists ROLE_IN_MOVIE
(
    movie_id       integer references MOVIE (id) on delete cascade  not null,
    person_id      integer references PERSON (id) on delete cascade not null,
    responsibility role_type                                        not null
);

CREATE TABLE if not exists ACTOR
(
    person_id integer references PERSON (id) on delete cascade not null,
    role      varchar(255)                                     not null
);


