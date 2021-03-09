-- Exercise 1.
CREATE OR REPLACE FUNCTION get_addresses()
    RETURNS TABLE
            (
                address_id  integer,
                address     varchar(50)
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT address.address_id, address.address
        FROM address
        WHERE address.city_id >= 400
          AND address.city_id <= 600
          AND address.address LIKE '%11%';
END;
$$ LANGUAGE plpgsql;
