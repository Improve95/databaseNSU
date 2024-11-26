/* == noting == */
select * from clients limit 100;
select count(*) from credit_tariff_client;
select * from credit_tariff_client limit 100;
select count(*) from credits;
select * from credits limit 100;
select count(*) from payments_schedule;
select count(*) from balances;

select * from credits where id = 'b218d58e-6314-4790-8711-7378cd365f82';
select * from balances where credit_id = 'b218d58e-6314-4790-8711-7378cd365f82' order by date desc limit 100;

select count(*) from payments;

/* == 1 == */


/* == 3 == */
with recursive tmp(id, name, position, manager_id) as (
    select e.*, cast (id as varchar (200)) as path from employees e where e.manager_id is null
    union
    select e.*, cast (tmp.path || '->'|| e.id as varchar(200)) from employees e
        inner join tmp on e.manager_id = tmp.id
) select * from tmp;