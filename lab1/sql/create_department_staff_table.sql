drop table if exists specialization cascade ;
create table specialization (
    id int primary key generated by default as identity ,
    name varchar(100)
);
truncate table specialization cascade ;

drop table if exists department cascade;
create table department (
    id int primary key generated by default as identity,
    specialization_id int references specialization("id") on delete cascade,
    name varchar(50) not null ,
    number int not null ,
    capacity int not null
);
truncate department cascade;

drop table if exists department_specialization cascade ;
create table department_specialization (
    department_id int references department("id") on delete cascade ,
    specialization_id int references specialization("id") on delete cascade ,
    primary key (specialization_id, department_id)
);
truncate table department_specialization cascade ;

drop table if exists staff cascade ;
create table staff (
    id int primary key references person("id") on delete cascade ,
    salary int check ( salary > 0 )
);
truncate table staff cascade ;