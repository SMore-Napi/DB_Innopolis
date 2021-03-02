SELECT A.st_id as store_id, SUM (A.amount) AS amount, address.address as store_address FROM
(SELECT payment.staff_id, amount, payment_date,
       staff.store_id, staff.staff_id,
       store.store_id as st_id, manager_staff_id, store.address_id as id
FROM public.payment, public.staff, public.store
WHERE payment.staff_id = staff.staff_id AND staff.store_id = store.store_id AND
      payment.payment_date >='2007-05-01') AS A, address
WHERE A.id=address.address_id
GROUP BY A.st_id, store_address
