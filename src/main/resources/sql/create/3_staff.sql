create type position_type as enum ( 'DOCTOR', 'CLEANER', 'ACCOUNTANT' );

create or replace function check_doctor_limit()
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
$$ language plpgsql;


create table staff (
    id int primary key references person("id") on delete cascade ,
    salary int check ( salary > 0 ) ,
    department_id int references department("id") on delete set null ,
    position position_type not null
);