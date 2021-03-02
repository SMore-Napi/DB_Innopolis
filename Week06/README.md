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

As it might be seen, the most expensive step (that utilizes `HashAggregate  (cost=520.78..530.36 rows=958 width=2)`) in
the proposed query is

```
SELECT DISTINCT film_id FROM rental JOIN inventory ON rental.inventory_id = inventory.inventory_id
```

Since the `DISTINCT` keyword cannot be optimized and introduction of indices on `inventory_id` attribute do not impact
anyhow on the efficiency of queries, the only way to optimize it is to rewrite it as several nested `JOIN` operations as it is done [here](Query%201.sql). \
It yields an improvement `88.14 vs 554.90` in terms of cost function:

```
Nested Loop Left Join  (cost=88.14..299.72 rows=1 width=15)
  Filter: (rental.staff_id IS NULL)
  ->  Hash Right Join  (cost=87.86..177.99 rows=215 width=19)
        Hash Cond: (inventory.film_id = film.film_id)
        ->  Seq Scan on inventory  (cost=0.00..70.81 rows=4581 width=6)
        ->  Hash  (cost=87.27..87.27 rows=47 width=19)
              ->  Nested Loop  (cost=1.54..87.27 rows=47 width=19)
                    ->  Hash Join  (cost=1.26..20.58 rows=125 width=2)
                          Hash Cond: (film_category.category_id = category.category_id)
                          ->  Seq Scan on film_category  (cost=0.00..16.00 rows=1000 width=4)
                          ->  Hash  (cost=1.24..1.24 rows=2 width=4)
                                ->  Seq Scan on category  (cost=0.00..1.24 rows=2 width=4)
                                      Filter: (((name)::text = 'Horror'::text) OR ((name)::text = 'Sci-Fi'::text))
                    ->  Index Scan using film_pkey on film  (cost=0.28..0.53 rows=1 width=19)
                          Index Cond: (film_id = film_category.film_id)
                          Filter: ((rating = 'R'::mpaa_rating) OR (rating = 'PG-13'::mpaa_rating))
  ->  Index Scan using rental_idx on rental  (cost=0.29..0.53 rows=4 width=6)
        Index Cond: (inventory.inventory_id = inventory_id)
```

#### Query 2.
Using `EXPLAIN EXECUTE exercise1;` yields:
```
Sort  (cost=347.57..348.03 rows=183 width=41) (actual time=2.042..2.049 rows=2 loops=1)
  Sort Key: (max(b.amount)) DESC
  Sort Method: quicksort  Memory: 25kB
  ->  HashAggregate  (cost=338.86..340.69 rows=183 width=41) (actual time=2.029..2.036 rows=2 loops=1)
        Group Key: b.city
        ->  Hash Join  (cost=322.87..337.95 rows=183 width=41) (actual time=1.959..2.029 rows=2 loops=1)
              Hash Cond: (city.city_id = b.city_id)
              ->  Seq Scan on city  (cost=0.00..11.00 rows=600 width=4) (actual time=0.014..0.061 rows=600 loops=1)
              ->  Hash  (cost=320.58..320.58 rows=183 width=45) (actual time=1.889..1.894 rows=2 loops=1)
                    Buckets: 1024  Batches: 1  Memory Usage: 9kB
                    ->  Subquery Scan on b  (cost=316.46..320.58 rows=183 width=45) (actual time=1.875..1.882 rows=2 loops=1)
                          ->  HashAggregate  (cost=316.46..318.75 rows=183 width=49) (actual time=1.874..1.880 rows=2 loops=1)
"                                Group Key: store.store_id, city_1.city_id"
                                ->  Nested Loop  (cost=1.32..315.09 rows=183 width=23) (actual time=1.554..1.822 rows=182 loops=1)
                                      Join Filter: (staff.staff_id = payment.staff_id)
                                      Rows Removed by Join Filter: 182
                                      ->  Seq Scan on payment  (cost=0.00..290.45 rows=183 width=8) (actual time=1.470..1.495 rows=182 loops=1)
                                            Filter: (payment_date >= '2007-05-01 00:00:00'::timestamp without time zone)
                                            Rows Removed by Filter: 14414
                                      ->  Materialize  (cost=1.32..19.16 rows=2 width=21) (actual time=0.000..0.001 rows=2 loops=182)
                                            ->  Nested Loop  (cost=1.32..19.15 rows=2 width=21) (actual time=0.057..0.210 rows=2 loops=1)
                                                  ->  Nested Loop  (cost=1.04..18.44 rows=2 width=10) (actual time=0.045..0.195 rows=2 loops=1)
                                                        Join Filter: (store.store_id = staff.store_id)
                                                        Rows Removed by Join Filter: 2
                                                        ->  Hash Join  (cost=1.04..17.36 rows=2 width=6) (actual time=0.037..0.183 rows=2 loops=1)
                                                              Hash Cond: (address.address_id = store.address_id)
                                                              ->  Seq Scan on address  (cost=0.00..14.03 rows=603 width=6) (actual time=0.007..0.081 rows=604 loops=1)
                                                              ->  Hash  (cost=1.02..1.02 rows=2 width=6) (actual time=0.017..0.019 rows=2 loops=1)
                                                                    Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                                    ->  Seq Scan on store  (cost=0.00..1.02 rows=2 width=6) (actual time=0.003..0.004 rows=2 loops=1)
                                                        ->  Materialize  (cost=0.00..1.03 rows=2 width=6) (actual time=0.003..0.004 rows=2 loops=2)
                                                              ->  Seq Scan on staff  (cost=0.00..1.02 rows=2 width=6) (actual time=0.004..0.004 rows=2 loops=1)
                                                  ->  Index Scan using city_pkey on city city_1  (cost=0.28..0.35 rows=1 width=13) (actual time=0.006..0.006 rows=1 loops=2)
                                                        Index Cond: (city_id = address.city_id)
```
As it might be seen, the most expensive step (that utilizes `Seq Scan on payment  (cost=0.00..290.45 rows=183 width=8)`) in the proposed query is 
```
WHERE payment.payment_date >= '2007-05-01'
```
We can optimize it using indexing. Since we need to compare dates with >= sign, it is optimal to use the b-tree on *payment_date* column:
``` 
CREATE INDEX date_index ON payment using btree (payment_date);
```
It yields an improvement `183.39 vs 348.03` in terms of overall cost function:
```
Sort  (cost=182.89..183.39 rows=200 width=41) (actual time=0.631..0.634 rows=2 loops=1)
  Sort Key: (max((sum(payment.amount)))) DESC
  Sort Method: quicksort  Memory: 25kB
  ->  HashAggregate  (cost=173.25..175.25 rows=200 width=41) (actual time=0.617..0.620 rows=2 loops=1)
        Group Key: city_1.city
        ->  Hash Join  (cost=163.44..171.62 rows=325 width=41) (actual time=0.611..0.615 rows=2 loops=1)
              Hash Cond: (city_1.city_id = city.city_id)
              ->  HashAggregate  (cost=144.94..149.01 rows=325 width=49) (actual time=0.366..0.369 rows=2 loops=1)
"                    Group Key: store.store_id, city_1.city_id"
                    ->  Hash Join  (cost=25.97..142.51 rows=325 width=23) (actual time=0.237..0.313 rows=182 loops=1)
                          Hash Cond: (payment.staff_id = staff.staff_id)
                          ->  Bitmap Heap Scan on payment  (cost=6.80..118.87 rows=325 width=8) (actual time=0.034..0.052 rows=182 loops=1)
                                Recheck Cond: (payment_date >= '2007-05-01 00:00:00'::timestamp without time zone)
                                Heap Blocks: exact=3
                                ->  Bitmap Index Scan on date_index  (cost=0.00..6.72 rows=325 width=0) (actual time=0.029..0.029 rows=182 loops=1)
                                      Index Cond: (payment_date >= '2007-05-01 00:00:00'::timestamp without time zone)
                          ->  Hash  (cost=19.15..19.15 rows=2 width=21) (actual time=0.186..0.188 rows=2 loops=1)
                                Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                ->  Nested Loop  (cost=1.32..19.15 rows=2 width=21) (actual time=0.054..0.179 rows=2 loops=1)
                                      ->  Nested Loop  (cost=1.04..18.44 rows=2 width=10) (actual time=0.044..0.164 rows=2 loops=1)
                                            Join Filter: (store.store_id = staff.store_id)
                                            Rows Removed by Join Filter: 2
                                            ->  Hash Join  (cost=1.04..17.36 rows=2 width=6) (actual time=0.035..0.151 rows=2 loops=1)
                                                  Hash Cond: (address.address_id = store.address_id)
                                                  ->  Seq Scan on address  (cost=0.00..14.03 rows=603 width=6) (actual time=0.006..0.061 rows=604 loops=1)
                                                  ->  Hash  (cost=1.02..1.02 rows=2 width=6) (actual time=0.013..0.014 rows=2 loops=1)
                                                        Buckets: 1024  Batches: 1  Memory Usage: 9kB
                                                        ->  Seq Scan on store  (cost=0.00..1.02 rows=2 width=6) (actual time=0.004..0.005 rows=2 loops=1)
                                            ->  Materialize  (cost=0.00..1.03 rows=2 width=6) (actual time=0.003..0.004 rows=2 loops=2)
                                                  ->  Seq Scan on staff  (cost=0.00..1.02 rows=2 width=6) (actual time=0.004..0.005 rows=2 loops=1)
                                      ->  Index Scan using city_pkey on city city_1  (cost=0.28..0.35 rows=1 width=13) (actual time=0.005..0.005 rows=1 loops=2)
                                            Index Cond: (city_id = address.city_id)
              ->  Hash  (cost=11.00..11.00 rows=600 width=4) (actual time=0.236..0.236 rows=600 loops=1)
                    Buckets: 1024  Batches: 1  Memory Usage: 30kB
                    ->  Seq Scan on city  (cost=0.00..11.00 rows=600 width=4) (actual time=0.011..0.101 rows=600 loops=1)
Planning Time: 3.579 ms
Execution Time: 0.855 ms

```
