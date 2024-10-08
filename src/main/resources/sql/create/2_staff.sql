create type position_type as enum ( 'DOCTOR', 'CLEANER', 'ACCOUNTANT' );
create table staff (
    id int primary key generated by default as identity ,
    passport_series varchar(4) check ( passport_series like '\d{4}' ),
    passport_number varchar(6) check ( passport_number like '\d{6}' ),

    name varchar(50) not null ,
    second_name varchar(50) not null ,
    phone varchar(11) unique check ( phone like '\d{11}' ) ,

    salary int check ( salary > 0 ) ,
    department_id int references department("id") on delete set null ,
    position position_type not null
);

/*alter table staff drop constraint staff_passport_number_check;
alter table staff drop constraint staff_passport_series_check;
alter table staff drop constraint staff_phone_check;*/

/*create or replace function check_staff_limit()
    returns trigger as $$
declare
    doctor_count int;
    department_capacity int;
begin
    if new.position = 'DOCTOR'::position_type then

        select count(*) into doctor_count from staff where NEW.department_id = staff.department_id and staff.position = 'DOCTOR'::position_type;
        select capacity into department_capacity from department where id = NEW.department_id;

        if doctor_count >= department_capacity then
            raise exception 'exceeded department capacity limit';
        end if;

    end if;

    return new;
end
$$ language plpgsql;*/

/*create trigger check_staff_limit_in_department
    before insert on staff
    for each row execute function check_staff_limit();*/

create type staff_changes_type as enum ( 'SALARY', 'POSITION', 'DEPARTMENT' ) ;
create table staff_change (
    id int primary key generated by default as identity ,
    staff_id int not null references staff("id") on delete cascade ,
    change_field staff_changes_type not null ,
    before varchar(50),
    after varchar(50) not null ,
    change_time timestamp with time zone not null default current_timestamp
);
