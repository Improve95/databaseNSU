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

with recursive tmp (id, name, position, manager_id, depth, hierarchy_path) as (
    select e.*, 0, CAST(id AS TEXT)
    from employees e where e.manager_id is null
    union all
    select e.*, depth + 1, CAST(tmp.hierarchy_path || ' -> ' || e.id AS TEXT)
    from tmp inner join employees e on e.manager_id = tmp.id
) select * from tmp
order by hierarchy_path;

/* == 4 == */
select
    sum(case when ps.amount <= pnp.payed_sum then 1 else 0 end) as payed_shedule,
    count(*)
from payments_schedule ps inner join (
    select ps.id, sum(case when p.amount is null then 0 else p.amount end) as payed_sum from payments_schedule ps
        left join payments p on p.payments_schedule = ps.id
        where p.time <= ps.deadline or time is null
    group by ps.id) as pnp on ps.id = pnp.id
group by ps.credit_id
order by payed_shedule desc;

select payed_shedule_count, total_shedule_count,
       payed_shedule_count::float4 / (payed_shedule_count + total_shedule_count) * 100 as count_percent,
       tps_on_credits, tmps_on_credits,
       tps_on_credits::float4 / (tps_on_credits + tmps_on_credits) * 100 as sum_percent
from (
    select
        ps.credit_id,
        sum(case when ps.amount <= pnp.payed_sum then 1 else 0 end) as payed_shedule_count ,
        count(*) total_shedule_count ,
        sum(pnp.payed_sum) as tps_on_credits ,
        sum(total_need_payed_sum) as tmps_on_credits
    from payments_schedule ps inner join (
        select ps.id,
               sum(case when p.amount is null then 0 else p.amount end) as payed_sum,
               sum(ps.amount) as total_need_payed_sum
               from payments_schedule ps
            left join payments p on p.payments_schedule = ps.id
        where p.time <= ps.deadline or time is null
        group by ps.id) as pnp on ps.id = pnp.id
    group by ps.credit_id)
order by payed_shedule_count desc;

/* == 5 == */
select sum_pay_credit.*, payment_sum / initial_debt as profit from (
    select c.id as credit_id,
            sum(p.amount) as payment_sum,
           c.initial_debt
           from payments p inner join credits c on c.id = p.credit_id
    where c.taking_date + c.credit_period between current_timestamp - interval '1 year' and current_timestamp
    group by c.id
) as sum_pay_credit;

select total_pay_sum::float4 / total_init_debt as profit from (
    select sum(payments_sum) as total_pay_sum, sum(initial_debt) as total_init_debt from (
        select sum(p.amount) as payments_sum, c.initial_debt from payments p
            inner join credits c on c.id = p.credit_id
        group by c.id));

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

select total_pay_sum::float4 / total_init_debt as profit from (
    select sum(payments_sum) as total_pay_sum, sum(initial_debt) as total_init_debt from (
        select sum(p.amount) as payments_sum, c.initial_debt from payments p
            inner join credits c on c.id = p.credit_id
        where c.taking_date + c.credit_period <= current_timestamp + '2 month'
        group by c.id));
