create or replace function check_timetable() returns trigger as $$
declare
begin
    new.
end;
$$ language plpgsql;

create or replace trigger check_timetable_on_insert
    before insert on schedule
    for each row execute function check_timetable();

create or replace function check_schedule(constant_time timestamp) returns trigger as $$
declare
    new_schedule schedule%rowtype;
    first_route_struct routes_structure%rowtype;
    cur_route_struct routes_structure%rowtype;
    last_route_struct routes_structure%rowtype;

    schedule_list schedule[];
    schedule schedule%rowtype;
    check_schedule schedule%rowtype;
    schedule_len int := 0;
    index int := 0;
begin
    new_schedule := new;
    select rs.* into cur_route_struct from routes_structure rs where rs.id = new_schedule.route_structure_id;
    select rs.* into first_route_struct from routes_structure rs where route_id = cur_route_struct.route_id
    order by rs.station_number_in_route
    limit 1;
    select rs.* into last_route_struct from routes_structure rs where route_id = cur_route_struct.route_id
    order by rs.station_number_in_route desc
    limit 1;

    if (new_schedule.departure_time is not null and new_schedule.arrival_time is not null) then
        if (new_schedule.arrival_time >= new_schedule.departure_time) then
            raise exception 'departure_time should be greater then arrival_time';
        end if;
    end if;

    select s.* into schedule_list from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new.thread_id
    order by rs.station_number_in_route;

    if array_length(schedule_list, 1) == 0 then
        return new;
    end if;

    schedule_len := array_length(schedule_list, 1);
    check_schedule := schedule_list[schedule_len - 1];
    if check_schedule.departure_time >= new_schedule.arrival_time then
        select * from schedule inner join routes_structure r on schedule.route_structure_id = r.id
        where
    end if;
end
$$ language plpgsql;

create or replace trigger check_schedule_on_insert
    before insert on schedule
    for each row execute function check_schedule();