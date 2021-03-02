-- Exercise 1.

PREPARE exercise1 AS
    SELECT B.city, MAX(B.amount) as max_amount
    FROM (SELECT A.st_id as store_id, SUM(A.amount) AS amount, city.city, city.city_id
          FROM (SELECT payment.staff_id,
                       amount,
                       payment_date,
                       staff.store_id,
                       staff.staff_id,
                       store.store_id   as st_id,
                       store.address_id as id
                FROM public.payment,
                     public.staff,
                     public.store
                WHERE payment.staff_id = staff.staff_id
                  AND staff.store_id = store.store_id
                  AND payment.payment_date >= '2007-05-01') AS A,
               address,
               city
          WHERE A.id = address.address_id
            AND address.city_id = city.city_id
          GROUP BY A.st_id, city.city_id) AS B,
         city
    WHERE B.city_id = city.city_id
    GROUP BY B.city
    ORDER BY max_amount DESC;

EXPLAIN ANALYZE EXECUTE exercise1;
EXECUTE exercise1;
DEALLOCATE exercise1;

-- Exercise 2.

CREATE INDEX date_index ON payment using btree (payment_date);

PREPARE exercise2 AS
    SELECT B.city, MAX(B.amount) as max_amount
    FROM (SELECT A.st_id as store_id, SUM(A.amount) AS amount, city.city, city.city_id
          FROM (SELECT payment.staff_id,
                       amount,
                       payment_date,
                       staff.store_id,
                       staff.staff_id,
                       store.store_id   as st_id,
                       store.address_id as id
                FROM public.payment,
                     public.staff,
                     public.store
                WHERE payment.staff_id = staff.staff_id
                  AND staff.store_id = store.store_id
                  AND payment.payment_date >= '2007-05-01') AS A,
               address,
               city
          WHERE A.id = address.address_id
            AND address.city_id = city.city_id
          GROUP BY A.st_id, city.city_id) AS B,
         city
    WHERE B.city_id = city.city_id
    GROUP BY B.city
    ORDER BY max_amount DESC;

EXPLAIN ANALYZE EXECUTE exercise2;
EXECUTE exercise2;
DEALLOCATE exercise2;