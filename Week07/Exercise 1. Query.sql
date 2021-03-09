-- Exercise 2.
CREATE OR REPLACE FUNCTION get_customers(start_id integer, end_id integer)
    RETURNS TABLE
            (
                customer_id INT,
                first_name  VARCHAR(45),
                last_name   VARCHAR(45),
                email       VARCHAR(50),
                address_id  SMALLINT
            )
AS
$$
BEGIN
    IF start_id < 0 THEN
        RAISE EXCEPTION 'Start address_id cannot be negative.';
    END IF;
    IF start_id > 600 THEN
        RAISE EXCEPTION 'Start address_id cannot be greater than 600.';
    END IF;
    IF end_id < 0 THEN
        RAISE EXCEPTION 'End address_id cannot be negative.';
    END IF;
    IF end_id > 600 THEN
        RAISE EXCEPTION 'End address_id cannot be greater than 600.';
    END IF;
    IF start_id >= end_id THEN
        RAISE EXCEPTION 'End address_id cannot be greater than start address_id.';
    END IF;
    RETURN QUERY
        SELECT customer.customer_id, customer.first_name, customer.last_name, customer.email, customer.address_id
        FROM customer
        WHERE start_id <= customer.address_id
          AND customer.address_id < end_id
        ORDER BY customer.address_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM  get_customers(10, 40);
SELECT * FROM  get_customers(10, 11);
SELECT * FROM  get_customers(0, 600);
SELECT * FROM  get_customers(-10, 40);
SELECT * FROM  get_customers(10, 601);
SELECT * FROM  get_customers(10, -10);
SELECT * FROM  get_customers(30, 10);
