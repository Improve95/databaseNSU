CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

drop table if exists person cascade;
create table person (
    id uuid primary key default gen_random_uuid() ,
    name varchar(50) not null ,
    second_name varchar(50) not null ,
    phone varchar(11) unique not null
);
truncate table person cascade;

drop table if exists passport cascade;
create table passport (
    person_id uuid primary key references person("id") on delete cascade ,
    series int not null ,
    number int not null
);
truncate passport cascade;

drop table if exists polis cascade;
create table polis (
    person_id uuid primary key references person("id") on delete cascade ,
    number int unique not null
);
truncate polis cascade;