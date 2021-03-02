## Report for the Home Assignment - Week 7.

### Exercise 2.

#### Query 1.
Using `EXPLAIN EXECUTE exercise1;` yields:
```
Hash Join  (cost=554.90..627.33 rows=23 width=15)
  Hash Cond: (film.film_id = film_category.film_id)
  ->  Seq Scan on film  (cost=532.76..604.26 rows=187 width=19)
        Filter: ((NOT (hashed SubPlan 1)) AND ((rating = 'R'::mpaa_rating) OR (rating = 'PG-13'::mpaa_rating)))
        SubPlan 1
          ->  HashAggregate  (cost=520.78..530.36 rows=958 width=2)
                Group Key: inventory.film_id
                ->  Hash Join  (cost=128.07..480.67 rows=16044 width=2)
                      Hash Cond: (rental.inventory_id = inventory.inventory_id)
                      ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=4)
                      ->  Hash  (cost=70.81..70.81 rows=4581 width=6)
                            ->  Seq Scan on inventory  (cost=0.00..70.81 rows=4581 width=6)
  ->  Hash  (cost=20.58..20.58 rows=125 width=2)
        ->  Hash Join  (cost=1.26..20.58 rows=125 width=2)
              Hash Cond: (film_category.category_id = category.category_id)
              ->  Seq Scan on film_category  (cost=0.00..16.00 rows=1000 width=4)
              ->  Hash  (cost=1.24..1.24 rows=2 width=4)
                    ->  Seq Scan on category  (cost=0.00..1.24 rows=2 width=4)
                          Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Sci-Fi'::text))
```
As it might be seen, the most expensive step (that utilizes `HashAggregate  (cost=520.78..530.36 rows=958 width=2)`) in the proposed query is 
```
SELECT DISTINCT film_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id
```
The only way to optimize it is to rewrite it as follows:
``` 
SELECT film_id FROM inventory INNER JOIN rental ON rental.inventory_id = inventory.inventory_id
```
It yields an improvement `542.92 vs 554.90` in terms of cost function:
```
Hash Join  (cost=542.92..615.36 rows=23 width=15)
  Hash Cond: (film.film_id = film_category.film_id)
  ->  Seq Scan on film  (cost=520.78..592.28 rows=187 width=19)
        Filter: ((NOT (hashed SubPlan 1)) AND ((rating = 'R'::mpaa_rating) OR (rating = 'PG-13'::mpaa_rating)))
        SubPlan 1
          ->  Hash Join  (cost=128.07..480.67 rows=16044 width=2)
                Hash Cond: (rental.inventory_id = inventory.inventory_id)
                ->  Seq Scan on rental  (cost=0.00..310.44 rows=16044 width=4)
                ->  Hash  (cost=70.81..70.81 rows=4581 width=6)
                      ->  Seq Scan on inventory  (cost=0.00..70.81 rows=4581 width=6)
  ->  Hash  (cost=20.58..20.58 rows=125 width=2)
        ->  Hash Join  (cost=1.26..20.58 rows=125 width=2)
              Hash Cond: (film_category.category_id = category.category_id)
              ->  Seq Scan on film_category  (cost=0.00..16.00 rows=1000 width=4)
              ->  Hash  (cost=1.24..1.24 rows=2 width=4)
                    ->  Seq Scan on category  (cost=0.00..1.24 rows=2 width=4)
                          Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Sci-Fi'::text))
```

