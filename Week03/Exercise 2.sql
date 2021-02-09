-- VIEW --
CREATE VIEW customer_spent AS
SELECT email, spent
FROM customer
         LEFT JOIN (SELECT customer_id, sum(amount) as spent
                    FROM payment
                    GROUP BY customer_id
                    ORDER BY customer_id) as spent_id ON customer.customer_id = spent_id.customer_id;

SELECT *
FROM customer_spent;


-- TRIGGERS --
