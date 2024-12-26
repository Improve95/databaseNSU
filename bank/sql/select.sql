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
        c2.initial_debt = (select max(c3.initial_debt) from credits c3 where c3.credit_tariff_id = c1.credit_tariff_id)) as client_with_max_debt, credit_tariff_id
from credits c1
where taking_date between current_timestamp - interval '3 month' and current_timestamp - interval '20 days'
group by credit_tariff_id) inner join clients c on c.id = client_with_max_debt;

with client_with_biggest_credit as (
    select cl.*, credit_tariff_id as tariff from clients cl
        inner join credits cr on cl.id = cr.client_id
            inner join (
                select max(initial_debt) as max_credit from credits
                group by credit_tariff_id
            ) as max_credit_group_tariff on max_credit_group_tariff.max_credit = cr.initial_debt
) select * from (
    select count(*), sum(initial_debt), avg(initial_debt), c1.credit_tariff_id
    from credits c1
    where taking_date between current_timestamp - interval '3 month' and current_timestamp - interval '20 days'
    group by credit_tariff_id) as credit_stats
inner join client_with_biggest_credit on client_with_biggest_credit.tariff = credit_stats.credit_tariff_id ;

/* == 2 == */
select DATE_TRUNC('year', p.date) AS year,
       DATE_TRUNC('month', p.date) AS month,
       DATE(p.date) AS day,
       count(*), sum(amount) from payments p
where p.date between current_timestamp - interval '4 month' and current_timestamp - interval '20 days'
group by rollup (year, month, day)
order by year, month, day;

/* == 3 == */
with recursive tmp(id, name, position, manager_id, depth) as (
    select e.*, 1 from employees e where e.manager_id is null
    union
    select e.*, depth + 1 from employees e
        inner join tmp on e.manager_id = tmp.id
) select string_agg(case when emp.manager_id is null then 'null' else emp.manager_id::varchar end || ': ' || emp.employees, '; ') as emps_managers,
         emp.depth
  from (
    select
          string_agg(tmp.id::varchar, '; ') as employees,
          manager_id,
          depth
      from tmp
    group by manager_id, depth
    order by depth, manager_id) as emp
group by depth
order by depth;

/* == 4 == */
-- pnp_number - paid_not_paid_number
select c.id, paid_number, not_paid_number,
       not_paid_number::float / (paid_number + not_paid_number) * 100.0 as not_paid_count_percent,
       paid_sum, not_paid_sum,
       not_paid_sum::float / (paid_sum + not_paid_sum) * 100.0 as not_paid_sum_percent
from credits c inner join (
    select sum(case when ps.is_paid = true then 1 else 0 end) as paid_number,
           sum(case when ps.is_paid = false then 1 else 0 end) as not_paid_number,
           sum(case when ps.is_paid = true then ps.amount else 0 end) as paid_sum,
           sum(case when ps.is_paid = false then ps.amount else 0 end) as not_paid_sum,
           credit_id
    from payments_schedule ps
    where ps.deadline <= current_timestamp
    group by credit_id
) as pnp_number on c.id = pnp_number.credit_id
where not_paid_number > 0;

/* == 5 == */
select sum_pay_credit.*, payment_sum / initial_debt as profit from (
    select c.id as credit_id,
            sum(p.amount) as payment_sum,
           c.initial_debt
           from payments p inner join credits c on c.id = p.credit_id
    where c.taking_date + c.credit_period between current_timestamp - interval '1 year' and current_timestamp
    group by c.id
) as sum_pay_credit;

/* == 6 == */
with suppose_payments as (
    select ps.amount, ps.credit_id from payments_schedule ps
    where (deadline between current_timestamp and current_timestamp + interval '2 month')
) select pay_credit_sum.*, (payment_sum + suppose_payment)::float / initial_debt as suppose_profit from (
    select c.id as credit_id,
           sum(p.amount) as payment_sum,
           sum(case when sp.amount is null then 0 else sp.amount end) as suppose_payment,
           c.initial_debt
    from payments p inner join credits c on p.credit_id = c.id
                    left join suppose_payments sp on sp.credit_id = c.id
        where (c.taking_date between current_timestamp - interval '1 year' and current_timestamp)
    group by c.id) as pay_credit_sum
order by credit_id;

select pay_credit_sum.*, pay_credit_sum.payment_sum::float4 / pay_credit_sum.initial_debt as profit from (
    select sum(p.amount) as payment_sum,
           c.initial_debt
    from payments p inner join credits c on c.id = p.credit_id
    where p.date <= c.taking_date + c.credit_period + interval '2 month'
    group by c.id) as pay_credit_sum;
