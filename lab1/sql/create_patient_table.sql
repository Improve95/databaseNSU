drop table if exists patient cascade ;
create table patient (
                         id uuid primary key references person("id"),
                         coming_time timestamp not null ,
                         release_time time ,
                         status int not null
);
truncate table patient cascade;