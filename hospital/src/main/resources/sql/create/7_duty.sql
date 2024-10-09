create table duty_schedule (
    doctor_id int not null references doctor("id") on delete cascade ,
    start_time timestamp not null ,
    end_time timestamp not null ,
    primary key (start_time, end_time)
);