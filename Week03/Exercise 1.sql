-- Order countries by id asc, then show the 12th to 17th rows.
SELECT *
FROM country
ORDER BY country_id ASC
LIMIT 6 OFFSET 11;

-- List all addresses in a city whose name starts with 'A’.
SELECT address
FROM address
         JOIN city ON address.city_id = city.city_id
WHERE city.city ~ 'A.+';

--  List all customers' first name, last name and the city they live in.
SELECT first_name, last_name, city
FROM (customer FULL JOIN address ON customer.address_id = address.address_id) AS temp
         FULL JOIN city ON city.city_id = temp.city_id;

-- Find all customers with at least one payment whose amount is greater
-- than 11 dollars.
SELECT *
FROM payment,
     customer
WHERE amount > 11
  and payment.customer_id = customer.customer_id;

-- Find all duplicated first names in the customer table.
SELECT first_name
FROM customer
GROUP BY first_name
HAVING COUNT(first_name) > 1
