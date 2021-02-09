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
create function exists_phone() returns trigger
    language plpgsql
as
$$
BEGIN
    IF EXISTS(SELECT * FROM address WHERE phone = NEW.phone) THEN
        -- Since the table address cannot be modified (there is a constraint on UPDATE/DELETE operations),
        -- just notify about already existed entry with specified phone number.

        -- DELETE FROM address WHERE phone = NEW.phone;

        RAISE NOTICE 'Address with specified phone number % is already exists!', NEW.phone;
        RETURN NULL;
    END IF;
END
$$;

alter function exists_phone() owner to postgres;

CREATE TRIGGER view_insert
    BEFORE INSERT
    ON address
    FOR EACH ROW
EXECUTE PROCEDURE exists_phone();

INSERT INTO address(address, district, city_id, postal_code, phone)
VALUES ('1 Studencheskaya', 'RT', 343, 420500, 14033335568);
