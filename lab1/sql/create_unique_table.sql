drop table if exists staff;
create table staff (
    id uuid primary key references person("id") ,
    position int not null ,
    salary int check ( salary > 0 )
);
truncate table staff;

drop table if exists department cascade;
create table department (
    id uuid primary key default gen_random_uuid(),
    name varchar(50) not null ,
    number int not null ,
    capacity int not null
);
truncate department cascade;

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

drop table if exists patient cascade ;
create table patient (
    id uuid primary key references person("id"),
    coming_time timestamp not null ,
    release_time time ,
    status int not null
);
truncate table patient cascade;