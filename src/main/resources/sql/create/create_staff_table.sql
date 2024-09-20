drop type if exists position_type cascade ;
create type position_type as enum ( 'doctor', 'cleaner', 'accountant');

create or replace function check_doctor_limit()
    returns trigger as $$
declare
    doctor_count int;
    department_capacity int;
begin
    if NEW.position == 'doctor' then

        select count(*) into doctor_count from staff where NEW.department_id = staff.department_id and staff.position == 'doctor';
        select capacity into department_capacity from department where id = NEW.department_id;

        if doctor_count >= department_capacity then
            raise exception 'exceeded department capacity limit';
        end if;

    end if;

    return NEW;
end
$$ language plpgsql;

drop table if exists staff cascade ;
create table staff (
    id int primary key references person("id") on delete cascade ,
    salary int check ( salary > 0 ) ,
    department_id int not null references department("id") ,
    position position_type not null
);
truncate table staff cascade ;

drop trigger if exists doctor_limit on staff;
create trigger doctor_limit before insert on staff
    for each row execute function check_doctor_limit();

-- alter table staff
--     add column department_id int not null references department("id");

-- alter table staff.txt
--     drop constraint staff_person_id_fkey ,
--     add constraint staff_person_id_fkey foreign key (id) references person("id");

-- alter table staff.txt
--     add column position position_type not null ;