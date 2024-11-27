/* == noting == */
select * from clients limit 100;
select count(*) from credit_tariff_client;
select * from credit_tariff_client limit 100;
select count(*) from credits;
select * from credits limit 100;
select count(*) from payments_schedule;
select count(*) from balances;
select * from credits where id = '73b4abfa-563b-4a3a-87f9-ce737cc85e11';
select * from balances where credit_id = '73b4abfa-563b-4a3a-87f9-ce737cc85e11' order by date desc limit 200;
select count(*) from payments;
select * from payments where credit_id = '73b4abfa-563b-4a3a-87f9-ce737cc85e11';

/* == 1 == */
select * from (
select count(*), sum(initial_debt), avg(initial_debt), max(initial_debt),
       (select c2.client_id from credits c2 where c2.credit_tariff_id = c1.credit_tariff_id and
        c2.initial_debt = (select max(c3.initial_debt) from credits c3 where c3.credit_tariff_id = c1.credit_tariff_id)) as client_with_max_debt
from credits c1
where taking_date between current_timestamp - interval '2 month' and current_timestamp - interval '20 days'
group by credit_tariff_id) inner join clients c on c.id = client_with_max_debt;

/* == 2 == */
select DATE_TRUNC('day', p.date) AS day,
       DATE_TRUNC('month', p.date) AS month,
       DATE_TRUNC('year', p.date) AS year,
       count(*), sum(amount) from payments p
where date between current_timestamp - interval '2 month' and current_timestamp - interval '20 days'
group by rollup (day, month, year)
order by day, month, year;

/* == 3 == */
with recursive tmp(id, name, position, manager_id) as (
    select e.*, cast (id as varchar (200)) as path from employees e where e.manager_id is null
    union
    select e.*, cast (tmp.path || '->'|| e.id as varchar(200)) from employees e
        inner join tmp on e.manager_id = tmp.id
) select * from tmp;