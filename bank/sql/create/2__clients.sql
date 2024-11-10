create type employment_type as enum ('t1', 't2', 't3', 't4');
create table clients (
    id int primary key generated by default as identity ,
    name varchar(50) not null ,
    employment employment_type
);

create type credit_status as enum ('approve', 'reject');
create table credit_scoring (
    id int primary key generated by default as identity ,
    score float4 not null ,
    status credit_status not null ,
    credit_tariff_id int not null references credit_tariff("id") on delete cascade ,
    client_id int not null references clients("id") on delete cascade
);