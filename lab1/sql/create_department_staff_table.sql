drop table if exists specialization cascade ;
create table specialization (
    id uuid primary key default gen_random_uuid() ,
    name varchar(100)
);
truncate table specialization cascade ;

drop table if exists department cascade;
create table department (
    id uuid primary key default gen_random_uuid(),
    specialization_id uuid references specialization("id") ,
    name varchar(50) not null ,
    number int not null ,
    capacity int not null
);
truncate department cascade;

drop table if exists department_specialization cascade ;
create table department_specialization (
    department_id uuid references department("id") on delete cascade ,
    specialization_id uuid references specialization("id") on delete cascade ,
    primary key (specialization_id, department_id)
);
truncate table department_specialization cascade ;

drop table if exists staff cascade ;
create table staff (
    id uuid primary key default gen_random_uuid() ,
    salary int check ( salary > 0 ) ,
    person_id uuid references person("id")
);
truncate table staff cascade ;

drop table if exists staff_change;
create table staff_change (
    id int primary key generated by default as identity ,
    staff_id uuid not null references staff("id") on delete cascade ,
    type int not null
);
truncate table staff_change;
