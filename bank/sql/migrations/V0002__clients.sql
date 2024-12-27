create type employment_type as enum ('t1', 't2', 't3', 't4');
create table clients (
    id int primary key generated by default as identity ,
    name varchar(50) not null ,
    employment employment_type
);
