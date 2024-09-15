drop table if exists specialization cascade ;
create table specialization (
    id uuid primary key default gen_random_uuid() ,
    name varchar(100)
);
truncate table specialization cascade ;

drop table if exists doctor_specialization cascade ;
create table doctor_specialization (
    doctor_id uuid references doctor("id") on delete cascade ,
    department_id uuid references specialization("id") on delete cascade ,
    primary key (doctor_id, department_id)
);
truncate table doctor_specialization cascade ;

create or replace function check_doctor_limit()
    returns trigger as $$
declare
    doctor_count int;
    department_capacity int;
begin
    select count(*) into doctor_count from doctor where department_id = NEW.department_id;
    select capacity into department_capacity from department where id = NEW.department_id;

    if doctor_count >= department_capacity then
        raise exception 'exceeded department capacity limit';
    end if;

    return NEW;
end
$$ language plpgsql;
drop table if exists doctor cascade ;
create table doctor (
    id uuid primary key default gen_random_uuid() ,
    department_id uuid not null references department("id") on delete cascade,
    staff_id uuid references staff("id") ,
);
truncate table doctor cascade;

create trigger doctor_limit_trigger before insert on doctor
    for each ROW execute function check_doctor_limit();