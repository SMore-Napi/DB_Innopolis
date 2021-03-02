PREPARE exercise1 AS SELECT title
                     FROM film,
                          film_category
                     WHERE (rating = 'R' OR rating = 'PG-13')
                       AND (film.film_id = film_category.film_id AND
                            film_category.category_id IN
                            (SELECT category_id FROM category WHERE name = 'Horror' OR name = 'Sci-Fi'));

EXPLAIN ANALYZE EXECUTE exercise1;

DEALLOCATE exercise1;