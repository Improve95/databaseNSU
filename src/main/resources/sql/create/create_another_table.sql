drop table if exists duty_schedule;
create table duty_schedule (
    int int primary key ,
    doctor_id int not null references doctor("id") on delete cascade ,
    start_time timestamp not null ,
    end_time timestamp not null
);
truncate table duty_schedule cascade;