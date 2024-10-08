create table duty_schedule (
    int int primary key ,
    doctor_id int not null references doctor("id") on delete cascade ,
    start_time timestamp with time zone not null ,
    end_time timestamp with time zone not null
);