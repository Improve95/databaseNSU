drop type if exists full_trip cascade;
create type full_trip as (
    pass_id int,
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
    departure_rs routes_structure%rowtype;
    arrival_rs routes_structure%rowtype;

    len int;
    index int;
    day date;
    day_list date[];
    pass_append int := 0;
    thread_append int := 0;
    uniq_list uniq_arr[];

    rcb_cursor cursor for select rcb.* from railroads_cars_booking rcb;
    i_rcb railroads_cars_booking%rowtype;
    i_trip full_trip;
begin
    drop table if exists sum_by_days;
    create temp table sum_by_days (
        thread_count int,
        passenger_count int,
        distance_sum int,
        calc_day date
    );

    for i_rcb in rcb_cursor loop
        select rs.* into departure_rs from schedule s
                                        inner join routes_structure rs on s.route_structure_id = rs.id
                                    where s.id = i_rcb.departure_point;
        select rs.* into arrival_rs from schedule s
                                        inner join routes_structure rs on s.route_structure_id = rs.id
                                    where s.id = i_rcb.arrival_point;

        for i_trip in (
            select i_rcb.passenger_id, s.thread_id, s.departure_time, rs.station_number_in_route, rs.distance
            from routes_structure rs
                inner join schedule s on rs.id = s.route_structure_id
            where ((rs.id between departure_rs.id and arrival_rs.id) and s.departure_time is not null)
            order by s.departure_time, rs.station_number_in_route
        ) loop
            day := DATE(i_trip.departure_time);
            index := array_position(day_list, day);
            len := array_length(day_list, 1);
            pass_append := 0;
            thread_append := 0;

            if index is null then
                day_list := array_append(day_list, day);
                uniq_list := array_append(uniq_list, row(array[I_trip.pass_id], array[I_trip.thread_id])::uniq_arr);
                insert into sum_by_days values (1, 1, i_trip.distance, day);
            else
                if array_position((uniq_list[index]::uniq_arr).passenger_arr, i_trip.pass_id) is null then
                    uniq_list[index] := row(array_append((uniq_list[index]::uniq_arr).passenger_arr, i_trip.pass_id), (uniq_list[index]::uniq_arr).thread_arr)::uniq_arr;
                    pass_append := 1;
                end if;
                if array_position((uniq_list[index]::uniq_arr).thread_arr, i_trip.thread_id) is null then
                    uniq_list[index] := row((uniq_list[index]::uniq_arr).passenger_arr, array_append((uniq_list[index]::uniq_arr).thread_arr, i_trip.thread_id))::uniq_arr;
                    thread_append := 1;
                end if;
                update sum_by_days sbd set
                                           thread_count = thread_count + thread_append,
                                           passenger_count = passenger_count + pass_append,
                                           distance_sum = distance_sum + i_trip.distance
                where sbd.calc_day = day;
            end if;
        end loop;
    end loop;



    return array (
        select row(sbd.*)::report from sum_by_days sbd
    );
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
