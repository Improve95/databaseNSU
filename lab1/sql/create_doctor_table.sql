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

create or replace function check_doctor_exist()
    returns trigger as $$
declare
    staffIsExist boolean;
begin
    select exists(select * from staff where id = NEW.id) into staffIsExist;

    if not staffIsExist then
        raise exception 'this staff does not exist';
    end if;

    return NEW;
end
$$ language plpgsql;

drop table if exists doctor cascade ;
create table doctor (
    id uuid primary key references staff("id") ,
    department_id uuid not null references department("id") on delete cascade
);
truncate table doctor cascade;

create trigger doctor_limit_trigger before insert on doctor
    for each ROW execute function check_doctor_limit();
create trigger doctor_exist before insert on doctor
    for each ROW execute function check_doctor_exist();