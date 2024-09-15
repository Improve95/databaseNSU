drop table if exists staff_change;
create table staff_change (
    id int primary key generated by default as identity ,
    staff_id uuid not null references staff("id") on delete cascade ,
    change_time timestamp not null
);
create index staff_change_index on staff_change using btree (change_time);
truncate table staff_change cascade;

drop table if exists staff_change_department cascade;
create table staff_change_department (
    id int primary key generated by default as identity ,
    was uuid references department("id") on delete cascade ,
    became uuid references department("id") on delete cascade ,
    patient_change_id int references staff_change("id")
);
truncate table staff_change_department cascade;

drop table if exists staff_change_post cascade;
create table staff_change_post (
    id int primary key generated by default as identity ,
    was varchar not null ,
    became varchar not null ,
    patient_change_id int references staff_change("id")
);
truncate table staff_change_post cascade;

drop table if exists staff_change_salary cascade;
create table staff_change_salary (
    id int primary key generated by default as identity ,
    was uuid references department("id") on delete cascade ,
    became uuid references department("id") on delete cascade ,
    patient_change_id int references staff_change("id")
);
truncate table staff_change_salary cascade;