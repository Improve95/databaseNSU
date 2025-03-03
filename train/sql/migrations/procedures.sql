drop type if exists full_trip cascade;
create type full_trip as (
    id int,
    thread_id int,
    departure_time timestamp,
    station_in_number_route int,
    distance int
);
drop type if exists report cascade;
create type report as (
    thread_count int,
    passenger_count int,
    distance_sum int,
    calc_day date
);
drop type if exists uniq_arr;
create type uniq_arr as (
    passenger_arr integer[],
    thread_arr integer[]
);
drop type if exists rep_final;
create type rep_final as (
    id int,
    thread_id int,
    station_in_number_route int,
    distance int,
    time varchar(10)
);
create type quarter_year as (
    quarter int,
    year int
);
create or replace function get_trip_report() returns report[] as $$
declare
    thread_id threads.id%TYPE;
    rcb_el railroads_cars_booking%rowtype;

    departure_schedule schedule.id%type;
    arrival_schedule schedule.id%type;
    departure_point_route schedule.id%type;
    arrival_point_route schedule.id%type;
    departure_rs routes_structure%rowtype;
    arrival_rs routes_structure%rowtype;

    trip_data_list full_trip[];

    td full_trip;
    len int;
    index int;
    rep_1 report;
    rep_2 report;
    day date;
    day_list date[];
    pass_append int := 0;
    thread_append int := 0;
    uniq_list uniq_arr[];

    qy_list quarter_year[];
    qy_prev quarter_year := null;

    r_day report[];
begin
    for rcb_el in (select rcb.* from railroads_cars_booking rcb) loop
        select s.id, s.route_structure_id, s.thread_id into departure_schedule, departure_point_route, thread_id
                                                       from schedule s where s.id = rcb_el.departure_point;
        select s.id, s.route_structure_id into arrival_schedule, arrival_point_route
                                          from schedule s where s.id = rcb_el.arrival_point;

        select rs.* into departure_rs from routes_structure rs where id = departure_point_route;
        select rs.* into arrival_rs from routes_structure rs where id = arrival_point_route;

        select array(
            select row(rcb_el.id, s.thread_id, s.departure_time, rs.station_number_in_route, rs.distance) from routes_structure rs
                inner join schedule s on rs.id = s.route_structure_id
            where ((rs.id between departure_rs.id and arrival_rs.id) and s.departure_time is not null)
            order by s.departure_time, rs.station_number_in_route)
        into trip_data_list;

        foreach td in array trip_data_list loop
            day := DATE(td.departure_time);
            index := array_position(day_list, day);
            len := array_length(day_list, 1);
            pass_append := 0;
            thread_append := 0;

            if index is null then
                day_list := array_append(day_list, day);
                if (len is null or len = 0) then
                    r_day := array_append(r_day, (1, 1, td.distance, day)::report);
                    uniq_list := array_append(uniq_list, row(array[td.id], array[td.id])::uniq_arr);
                else
                    if array_position((uniq_list[len]::uniq_arr).passenger_arr, td.id) is null then
                        uniq_list[len + 1] := row(array_append((uniq_list[len]::uniq_arr).passenger_arr, td.id), (uniq_list[len]::uniq_arr).thread_arr)::uniq_arr;
                        pass_append := 1;
                    end if;
                    if array_position((uniq_list[len + pass_append]::uniq_arr).thread_arr, td.thread_id) is null then
                        uniq_list[len + pass_append] := row((uniq_list[len + pass_append]::uniq_arr).passenger_arr, array_append((uniq_list[len + pass_append]::uniq_arr).thread_arr, td.thread_id))::uniq_arr;
                        thread_append := 1;
                    end if;
                    rep_1 := r_day[len];
                    rep_2 := (rep_1.thread_count + thread_append, rep_1.passenger_count + pass_append, rep_1.distance_sum + td.distance, day);
                    r_day := array_append(r_day, rep_2);
                end if;
            else
                for i in index..len loop
                    rep_1 := r_day[i];
                    if array_position((uniq_list[i]::uniq_arr).passenger_arr, td.id) is null then
                        uniq_list[i] := row(array_append((uniq_list[i]::uniq_arr).passenger_arr, td.id), (uniq_list[i]::uniq_arr).thread_arr)::uniq_arr;
                        pass_append := 1;
                    end if
                    if array_position((uniq_list[i]::uniq_arr).thread_arr, td.thread_id) is null then
                        uniq_list[i] := row((uniq_list[i]::uniq_arr).passenger_arr, array_append((uniq_list[i]::uniq_arr).thread_arr, td.thread_id))::uniq_arr;
                        thread_append := 1;
                    end if;
                    rep_2 := (rep_1.thread_count + thread_append, rep_1.passenger_count + pass_append, rep_1.distance_sum + td.distance, rep_1.calc_day);
                    r_day[i] := rep_2;
                end loop;
            end if;

            qy_prev := row(extract(quarter from td.departure_time), extract(year from td.departure_time));
        end loop;
    end loop;

    return r_day;
end;
$$ LANGUAGE plpgsql;

select * from unnest(get_trip_report());

create or replace procedure fix_schedule_by_delay(from_time timestamp, to_time timestamp) as $$
declare
    delay_cursor cursor for select * from delay;
    i_delay delay%rowtype;

    cur_schedule schedule%rowtype;
    i_schedule schedule%rowtype;
    s_list schedule[];
    cur_number int;
begin
    for i_delay in delay_cursor loop
        select s.* into cur_schedule from schedule s
        where s.id = i_delay.schedule_record;

        if cur_schedule.departure_time not between from_time and to_time then
            return;
        end if;

        select rs.station_number_in_route into cur_number from schedule s
            inner join routes_structure rs on s.route_structure_id = rs.id
        where s.id = i_delay.schedule_record;

        select array (
            select row(s.*) from schedule s
                inner join routes_structure rs on s.route_structure_id = rs.id
            where s.thread_id = cur_schedule.thread_id and
                  rs.station_number_in_route >= cur_number
            order by rs.station_number_in_route
        ) into s_list;

        foreach i_schedule in array s_list loop
            update schedule s set arrival_time = s.arrival_time + i_delay.arrival_delay,
                                  departure_time = s.departure_time + i_delay.arrival_delay + i_delay.departure_delay
            where s.id = i_schedule.id;
        end loop;

        update delay set arrival_delay = interval '0 second',
                         departure_delay = interval '0 second'
        where current of delay_cursor;
    end loop;
end;
$$ LANGUAGE plpgsql;
