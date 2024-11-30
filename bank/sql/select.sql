/* == noting == */
select count(*) from clients;
select * from clients limit 100;
select count(*) from credit_tariff_client;
select * from credit_tariff_client limit 100;
select count(*) from credits;
select * from credits;
select count(*) from payments_schedule;
select count(*) from balances;
select count(*) from payments;
select * from payments p
order by p.date
limit 100;

/* == 1 == */
select * from (
select count(*), sum(initial_debt), avg(initial_debt),
       (select c2.client_id from credits c2 where c2.credit_tariff_id = c1.credit_tariff_id and
        c2.initial_debt = (select max(c3.initial_debt) from credits c3 where c3.credit_tariff_id = c1.credit_tariff_id)) as client_with_max_debt
from credits c1
where taking_date between current_timestamp - interval '3 month' and current_timestamp - interval '20 days'
group by credit_tariff_id) inner join clients c on c.id = client_with_max_debt;

/* == 2 == */
select DATE_TRUNC('year', p.date) AS year,
       DATE_TRUNC('month', p.date) AS month,
       DATE(p.date) AS day,
       count(*), sum(amount) from payments p
where p.date between current_timestamp - interval '4 month' and current_timestamp - interval '20 days'
group by rollup (year, month, day)
order by year, month, day;

/* == 3 == */
with recursive tmp(id, name, position, manager_id, path, depth) as (
    select e.*, cast (id as varchar (200)) as path, 1 from employees e where e.manager_id is null
    union
    select e.*, cast (tmp.path || '->'|| e.id as varchar(200)), depth + 1 from employees e
        inner join tmp on e.manager_id = tmp.id
) select * from tmp
order by tmp.depth;

/* == 4 == */
-- pnp_number - paid_not_paid_number
select c.id, paid_number, not_paid_number,
       (paid_number + not_paid_number) / 100.0 * not_paid_number as percent,
       not_paid_sum
from credits c inner join (
    select sum(case when ps.is_paid = true then 1 else 0 end) as paid_number,
           sum(case when ps.is_paid = false then 1 else 0 end) as not_paid_number,
           sum(case when ps.is_paid = false then ps.amount else 0 end) as not_paid_sum,
           credit_id
    from payments_schedule ps
    group by credit_id
) as pnp_number on c.id = pnp_number.credit_id;

/* == 5 == */
select sum_pay_credit.*, payment_sum / give_credit_sum as profit from (
    select sum(p.amount) as payment_sum,
           sum(c.initial_debt) as give_credit_sum
           from payments p inner join credits c on c.id = p.credit_id
    where c.taking_date + c.credit_period between current_timestamp - interval '2 month' and current_timestamp + interval '2 year'
) as sum_pay_credit;

/* == 6 == */
select pay_sum / initial_debt as profit, id from (
    select sum(p.amount) as pay_sum, c.id, c.initial_debt from payments p inner join credits c on p.credit_id = c.id
    where (c.taking_date between current_timestamp - interval '5 month' and current_timestamp + interval '2 year') and
          c.taking_date + c.credit_period <= current_date - interval '1 month' and
          c.credit_status = 'close'
    group by c.id);
