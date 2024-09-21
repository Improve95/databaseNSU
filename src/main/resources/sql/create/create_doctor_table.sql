drop function if exists check_doctor_in_staff();
create or replace function check_doctor_in_staff()
    returns trigger as $$
declare
    doctor_position position_type;
begin
    select position into doctor_position from staff where staff.id = new.staff_id;
    if doctor_position != 'DOCTOR'::position_type then
        raise exception 'this staff is not a doctor';
    end if;
    return new;
end;
    $$ language plpgsql;

drop table if exists doctor cascade ;
create table doctor (
    staff_id int primary key references staff("id") on delete cascade
);
truncate table doctor cascade;

drop trigger if exists check_doctor_in_staff_trigger on doctor;
create trigger check_doctor_in_staff_trigger
    before insert on doctor
    for each row execute function check_doctor_in_staff();

drop table if exists doctor_specialization cascade ;
create table doctor_specialization (
    doctor_id int references doctor("staff_id") on delete cascade ,
    specialization_id int references specialization("id") on delete cascade ,
    primary key (doctor_id, specialization_id)
);
truncate table doctor_specialization cascade ;