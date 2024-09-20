drop table if exists doctor cascade ;
create table doctor (
    id int primary key references staff("id") on delete cascade
);
truncate table doctor cascade;

drop table if exists doctor_specialization cascade ;
create table doctor_specialization (
    doctor_id int references doctor("id") on delete cascade ,
    specialization_id int references specialization("id") on delete cascade ,
    primary key (doctor_id, specialization_id)
);
truncate table doctor_specialization cascade ;