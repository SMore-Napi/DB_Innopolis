-- Exercise 1.
CREATE OR REPLACE FUNCTION get_addresses()
    RETURNS TABLE
            (
                address_id  integer,
                address     varchar(50),
                address2    varchar(50),
                district    varchar(20),
                city_id     smallint,
                postal_code varchar(10),
                phone       varchar(20),
                last_update timestamp
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT *
        FROM address
        WHERE address.city_id >= 400
          AND address.city_id <= 600
          AND address.address LIKE '%11%';
END;