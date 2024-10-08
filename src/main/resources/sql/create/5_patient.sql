create table patient (
    id int generated by default as identity primary key ,
    passport_series varchar(4) check ( passport_series like '\d{4}' ),
    passport_number varchar(6) check ( passport_number like '\d{6}' ),
    polis_number varchar(16) unique check ( polis_number like '\d{16}' ),

    name varchar(50) not null ,
    second_name varchar(50) not null ,
    phone varchar(11) unique check ( phone like '\d{11}' )
);

alter table patient drop constraint patient_passport_series_check;
alter table patient drop constraint patient_passport_number_check;
alter table patient drop constraint patient_phone_check;
alter table patient drop constraint patient_polis_number_check;

create type patient_status_type as enum ('SICK', 'HEALTHY', 'OUT_TREATMENT', 'ANOTHER_PLACE');
create table disease_history (
    id uuid primary key default gen_random_uuid() ,
    patient_id int references patient("id") on delete cascade ,

    coming_time timestamp with time zone default current_timestamp not null,
    release_time timestamp with time zone,

    disease int references disease("id") on delete set null ,
    doctor_which_set_disease int references doctor("id") on delete set null ,

    patient_status patient_status_type default 'SICK'::patient_status_type,
    current_doctor int references doctor("id") on delete set null
);

create type disease_history_change_type as enum ('STATUS', 'DEPARTMENT', 'DOCTOR');
create table disease_history_change (
    id uuid primary key default gen_random_uuid() ,
    change_type disease_history_change_type not null ,
    before int ,
    after int not null ,
    change_time timestamp with time zone default current_timestamp not null,
    patient_id int references patient("id") on delete cascade
);
