create or replace function check_timetable() returns trigger as $$
declare
begin
--     new.
end;
$$ language plpgsql;

create or replace trigger check_timetable_on_insert
    before insert on schedule
    for each row execute function check_timetable();

create type schedule_ex as (
    id int,
    route_struct int,
    thread_id int,
    number int,
    departure_time timestamp,
    arrival_time timestamp
);

create or replace procedure shift_schedule(new_s schedule%rowtype, check_s schedule_ex, move_time interval, stop_time interval)
    returns null on null input as $$
declare
begin

end;
$$ language plpgsql;

create or replace function check_schedule(move_time interval, stop_time interval) returns trigger as $$
declare
    new_s schedule%rowtype;
    first_rs routes_structure%rowtype;
    cur_rs routes_structure%rowtype;
    last_rs routes_structure%rowtype;

    schedule_list schedule_ex[];
    check_schedule schedule_ex := null;
    schedule_len int := 0;
    index int := 0;
begin
    new_s := new;
    select rs.* into cur_rs from routes_structure rs where rs.id = new_s.route_structure_id;
    select rs.* into first_rs from routes_structure rs where route_id = cur_rs.route_id
    order by rs.station_number_in_route
    limit 1;
    select rs.* into last_rs from routes_structure rs where route_id = cur_rs.route_id
    order by rs.station_number_in_route desc
    limit 1;

    if cur_rs.station_number_in_route == first_rs.station_number_in_route then
        if (new_s.departure_time is null or new_s.arrival_time is not null) then
            raise exception 'error';
        end if;
    elseif cur_rs.station_number_in_route == last_rs.station_number_in_route then
        if (new_s.departure_time is not null or new_s.arrival_time is null) then
            raise exception 'error';
        end if;
    else
        if (new_s.departure_time is not null or new_s.arrival_time is not null) then
            raise exception 'error';
        end if;
        if (new_s.arrival_time >= new_s.departure_time) then
            raise exception 'departure_time should be greater then arrival_time';
        end if;
    end if;

    select s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time into schedule_list
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new.thread_id
    order by rs.station_number_in_route;

    if array_length(schedule_list, 1) == 0 then
        return new;
    end if;

    select s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time into check_schedule
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new_s.thread_id and rs.station_number_in_route = cur_rs.station_number_in_route - 1;
    if (check_schedule is not null and check_schedule.departure_time is not null) then
        if check_schedule.departure_time >= new_s.arrival_time then

        end if;
    end if;

    select s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time into check_schedule
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new_s.thread_id and rs.station_number_in_route = cur_rs.station_number_in_route + 1;
    check_schedule := null;
    if (check_schedule is not null and check_schedule.arrival_time is not null) then
        if new_s.departure_time >= check_schedule.arrival_time then

        end if;
    end if;
end
$$ language plpgsql;

create or replace trigger check_schedule_on_insert
    before insert on schedule
    for each row execute function check_schedule(interval '1 hour');