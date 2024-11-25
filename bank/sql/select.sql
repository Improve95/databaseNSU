/* == noting == */
select * from clients limit 100;

select count(*) from credit_tariff_client;
select * from credit_tariff_client limit 100;

select count(*) from credits;
select * from credits limit 100;

/* == 1 == */


/* == 3 == */
with recursive tmp(id, name, position, manager_id) as (
    select e.*, cast (id as varchar (200)) as path from employees e where e.manager_id is null
    union
    select e.*, cast (tmp.path || '->'|| e.id as varchar(200)) from employees e
        inner join tmp on e.manager_id = tmp.id
) select * from tmp;