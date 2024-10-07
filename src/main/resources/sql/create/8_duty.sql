create table duty_schedule (
    int int primary key ,
    doctor_id int not null references doctor("staff_id") on delete cascade ,
    start_time timestamp not null ,
    end_time timestamp not null
);