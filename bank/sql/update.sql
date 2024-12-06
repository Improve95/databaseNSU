with random_id as (
    select c.id from credits c
    order by RANDOM()
    limit 1000
) update payments_schedule ps set is_paid = false
where ps.credit_id in (select id from random_id) and
      ps.deadline between current_timestamp - interval '1 month' and current_timestamp + interval '1 days';