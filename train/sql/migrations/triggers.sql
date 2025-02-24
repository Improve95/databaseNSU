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

create or replace function find_correct_interval(cur_rs routes_structure%rowtype, check_s schedule_ex, newIsPrev bool)
    returns interval as $$
declare
    correct_s schedule[];
begin
    select s.* into correct_s from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where (rs.route_id = cur_rs.route_id and (rs.station_number_in_route = cur_rs.station_number_in_route or rs.station_number_in_route = check_s.number))
    order by rs.station_number_in_route;

    if (array_length(correct_s, 1) != 2) then
        return null;
    end if;

    return (correct_s[1]::schedule).arrival_time - (correct_s[0]::schedule).departure_time;
end;
$$ language plpgsql;

create or replace function check_schedule(default_move_interval interval, default_stop_interval interval) returns trigger as $$
declare
    new_s schedule%rowtype;
    first_rs routes_structure%rowtype;
    cur_rs routes_structure%rowtype;
    last_rs routes_structure%rowtype;

    schedule_list schedule_ex[];
    prev_schedule schedule_ex := null;
    next_schedule schedule_ex := null;
    correct_interval interval;
    stop_interval interval;
begin
    new_s := new;
    stop_interval := default_stop_interval;
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

    select s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time into prev_schedule
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new_s.thread_id and rs.station_number_in_route = cur_rs.station_number_in_route - 1;

    select s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time into next_schedule
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new_s.thread_id and rs.station_number_in_route = cur_rs.station_number_in_route + 1;

    if (prev_schedule is not null and prev_schedule.departure_time is not null) then
        if prev_schedule.departure_time >= new_s.arrival_time then
            select * into correct_interval from find_correct_interval(cur_rs, prev_schedule, false);
            if (new_s.arrival_time is not null and new_s.departure_time is not null) then
                stop_interval = new_s.arrival_time - new_s.departure_time;
            end if;
            new_s.arrival_time = prev_schedule.departure_time + correct_interval;
            new_s.departure_time = new_s.arrival_time + stop_interval;
        end if;
    end if;

    if (next_schedule is not null and next_schedule.arrival_time is not null) then
        if new_s.departure_time >= next_schedule.arrival_time then
            select * into correct_interval from find_correct_interval(cur_rs, prev_schedule, true);
            if (new_s.arrival_time is not null and new_s.departure_time is not null) then
                stop_interval = new_s.arrival_time - new_s.departure_time;
            end if;
            new_s.departure_time = prev_schedule.arrival_time - correct_interval;
            new_s.arrival_time = new_s.departure_time - stop_interval;
        end if;
    end if;

    return new_s;
end
$$ language plpgsql;

create or replace trigger check_schedule_on_insert
    before insert on schedule
    for each row execute function check_schedule(interval '1 hour');