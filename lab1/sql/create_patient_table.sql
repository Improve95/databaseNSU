drop table if exists patient cascade ;
create table patient (
                         id uuid primary key references person("id"),
                         coming_time timestamp not null ,
                         release_time time ,
                         status int not null
);
truncate table patient cascade;

drop table if exists research_type cascade ;
create table research_type (
                               id uuid primary key default gen_random_uuid() ,
                               department_id uuid not null references department("id")
);
truncate table research_type cascade ;

drop table if exists research cascade ;
create table research (
                          id uuid primary key default gen_random_uuid() ,
                          research_type uuid not null references research_type("id") ,
                          patient_id uuid not null references patient("id") ,
                          date_of_research timestamp not null ,
                          status int not null ,
                          result varchar(10) -- ??? что значит файл в тз
);
truncate table research cascade ;