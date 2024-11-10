create schema bank;
set search_path to bank;

create table positions (
    id int primary key generated by default as identity ,
    name varchar(50) unique
);

create table employees (
    id int primary key generated by default as identity ,
    name varchar(50) not null ,
    position_id int references positions("id") on delete set null
);

create table employees_managers (
    employee_id int references employees("id") on delete cascade ,
    manager_id int references employees("id") on delete cascade ,
    primary key (employee_id, manager_id)
)
