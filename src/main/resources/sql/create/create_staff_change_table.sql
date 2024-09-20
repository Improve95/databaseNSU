drop type if exists staff_changes;
create type staff_changes as enum ( 'salary', 'position', 'department' ) ;

drop table if exists staff_change;
create table staff_change (
    id int primary key generated by default as identity ,
    staff_id int not null references staff("id") on delete cascade ,
    change_field staff_changes not null ,
    before varchar(50) not null,
    after varchar(50) not null ,
    change_time timestamp not null
);
create index staff_change_index on staff_change using btree(staff_id);
truncate table staff_change cascade;

-- alter table staff_change
--     add column change_field staff_changes not null ,
--     add column before varchar(50) not null,
--     add column after varchar(50) not null;