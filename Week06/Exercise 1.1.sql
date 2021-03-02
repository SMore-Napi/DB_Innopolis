PREPARE exercise1 AS
    SELECT title
    FROM film,
         film_category
    WHERE film.film_id NOT IN
          (SELECT DISTINCT film_id
           FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id)
      AND (rating = 'R' OR rating = 'PG-13')
      AND (film.film_id = film_category.film_id AND
           film_category.category_id IN
           (SELECT category_id FROM category WHERE name = 'Horror' OR name = 'Sci-Fi'));

EXPLAIN ANALYZE EXECUTE exercise1;
EXECUTE exercise1;

DEALLOCATE exercise1;

