create or replace function check_train_on_route() returns trigger as $$
declare
    new_rcb railroads_cars_booking%rowtype;
    trains_id int[];
    train_id int;
    t_id int;
begin
    new_rcb := new;
    select array(
        select row(t.train_id) from schedule s
        inner join threads t on s.thread_id = t.id
        where s.id = new_rcb.departure_point or s.id = new_rcb.arrival_point
    ) into trains_id;
    select rc.train_id into train_id from railroad_cars rc
    where rc.id = new_rcb.railroad_car_id;
    trains_id := array_append(trains_id, train_id);
    foreach t_id in array trains_id loop
        if t_id != trains_id[0] then
            raise exception 'trains_id incorrect';
        end if;
    end loop;
    return new_rcb;
end;
$$ language plpgsql;

create or replace trigger check_train_on_route_on_insert
    before insert on railroads_cars_booking
    for each row execute function check_train_on_route();

drop type if exists schedule_ex;
create type schedule_ex as (
    id int,
    route_struct int,
    thread_id int,
    number int,
    departure_time timestamp,
    arrival_time timestamp
);

create or replace function find_correct_interval(cur_rs routes_structure, check_s schedule_ex)
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

create or replace procedure shift_schedule(sched schedule_ex, default_move_interval interval, default_stop_time interval, direction int) as $$
declare
    move_interval interval := default_move_interval;
    stop_interval interval := default_stop_time;

    cur_schedule schedule_ex := sched;
    next_schedule schedule_ex := null;
    cur_rs routes_structure%rowtype;
    correct_interval interval;
begin
    while cur_schedule is not null loop
        select row(s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time) into next_schedule
        from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
        where s.thread_id = cur_schedule.thread_id and rs.station_number_in_route = cur_schedule.number + direction;

        select rs.* into cur_rs from routes_structure rs
        where rs.id = cur_schedule.route_struct;
        if next_schedule is not null then
            if direction = 1 then

                if cur_schedule.departure_time >= next_schedule.arrival_time then
                    select * into correct_interval from find_correct_interval(cur_rs, next_schedule);
                    if correct_interval is null then correct_interval = move_interval; end if;
                    update schedule s set
                                          arrival_time = cur_schedule.arrival_time + correct_interval,
                                          departure_time = cur_schedule.arrival_time + correct_interval + stop_interval
                    where s.id = next_schedule.id;
                end if;

            elseif direction = -1 then

                if next_schedule.departure_time >= cur_schedule.arrival_time then
                    select * into correct_interval from find_correct_interval(cur_rs, next_schedule);
                    if correct_interval is null then correct_interval = move_interval; end if;
                    update schedule s set
                                          arrival_time = cur_schedule.arrival_time + correct_interval,
                                          departure_time = cur_schedule.arrival_time + correct_interval + stop_interval
                    where s.id = next_schedule.id;
                end if;

            end if;
        end if;
        cur_schedule := next_schedule;
    end loop;
end;
$$ language plpgsql;

create or replace function check_schedule() returns trigger as $$
declare
    default_move_interval constant interval := interval '1 hour';
    default_stop_interval constant interval := interval '10 minutes';

    new_s schedule%rowtype;
    first_rs routes_structure%rowtype;
    cur_rs routes_structure%rowtype;
    last_rs routes_structure%rowtype;
    tmp_rs routes_structure%rowtype;

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
        stop_interval := new_s.arrival_time - new_s.departure_time;
    end if;

    select row(s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time) into schedule_list
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new.thread_id
    order by rs.station_number_in_route;

    if array_length(schedule_list, 1) == 0 then
        return new;
    end if;

    select s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time into prev_schedule
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new_s.thread_id and rs.station_number_in_route = cur_rs.station_number_in_route - 1;

    if (prev_schedule is not null and prev_schedule.departure_time is not null) then
        if prev_schedule.departure_time >= new_s.arrival_time then
            select * into correct_interval from find_correct_interval(cur_rs, prev_schedule);
            if correct_interval is null then correct_interval = default_move_interval; end if;
            new_s.arrival_time := prev_schedule.departure_time + correct_interval;
            new_s.departure_time := prev_schedule.departure_time + correct_interval + stop_interval;
            select shift_schedule(new_s, default_move_interval, default_stop_interval, 1);
        end if;
    end if;

    select s.id, s.route_structure_id, s.thread_id, rs.station_number_in_route, s.departure_time, s.arrival_time into next_schedule
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = new_s.thread_id and rs.station_number_in_route = cur_rs.station_number_in_route + 1;

    if (next_schedule is not null and next_schedule.arrival_time is not null) then
        if new_s.departure_time >= next_schedule.arrival_time then
            select shift_schedule(next_schedule, default_move_interval, default_stop_interval, -1);
        end if;
    end if;

    return new_s;
end
$$ language plpgsql;

create or replace trigger check_schedule_on_insert
    before insert on schedule
    for each row execute function check_schedule();

create or replace function set_free_route_number() returns trigger as $$
declare
    new_s schedule%rowtype;
    all_ids int[];
    schedule_ids int[];
begin
    new_s := new;
    if new_s.id is null then
        select array(
            select row(r.id) from routes r
        ) into all_ids;
        select array (
            select row(s.id) from schedule s
        ) into schedule_ids;
        all_ids := array_cat(all_ids, schedule_ids);
        select distinct id into all_ids from unnest(all_ids) as id order by id;
        for i in 1..array_length(all_ids, 1) loop
            if all_ids[i - 1] != i then
                new_s.id := i;
                return new_s;
            end if;
        end loop;
        new_s.id := array_length(all_ids, 1) + 1;
        return new_s;
    end if;

    return new_s;
end;
$$ language plpgsql;

create or replace trigger set_free_route_number_on_insert
    before insert on schedule
    for each row execute function set_free_route_number();

create table deleted_trains (like trains including all);
create or replace function log_train() returns trigger as $$
declare
    delete_t trains%rowtype;
    booking_count int;
begin
    delete_t := old;
    select count(*) into booking_count from trains t
        inner join railroad_cars rc on t.id = rc.train_id
        inner join railroads_cars_booking rcb on rc.id = rcb.railroad_car_id
    where t.id = delete_t.id;

    if booking_count > 300 then
        insert into deleted_trains select * from delete_t;
    end if;

    return delete_t;
end;
$$ language plpgsql;

create trigger log_train_on_delete
    after delete on trains
    for each row execute function log_train();
