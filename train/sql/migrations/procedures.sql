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
drop type uniq_arr;
create type uniq_arr as (
    thread_arr integer[],
    passanger_arr integer[]
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
    uniq_arr uniq_arr[];
    add int := 0;

    rbd report[];
begin
    for rcb_el in
        select rcb.* from railroads_cars_booking rcb
    loop
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
            if index is null then
                day_list := array_append(day_list, day);
                if (len is null or len = 0) then
                    rep_2 := (1, 1, td.distance, day);
                else
                    rep_1 := rbd[len];
                    rep_2 := (rep_1.thread_count + 1, rep_1.passenger_count + 1, rep_1.distance_sum + td.distance, day);
                end if;
            else
                for i in index..len loop
                    rep_1 := rbd[i];

                    rep_2 := (rep_1.thread_count + add, rep_1.passenger_count + add, rep_1.distance_sum + td.distance, rep_1.calc_day);
                    rbd[i] := rep_2;
                end loop;
            end if;
        end loop;
    end loop;

    return rbd;
end;
$$ LANGUAGE plpgsql;

select * from unnest(get_trip_report());

create or replace function fix_schedule_by_delay(from_time timestamp, to_time timestamp) returns void as $$
declare
    delay_list delay[];
    delay delay%rowtype;
begin
    select d.* into delay_list from delay d;
    foreach delay in array delay_list loop
        update schedule s set departure_time = s.departure_time + delay.departure_delay,
                              arrival_time = s.arrival_time + delay.arrival_delay
        where s.id = delay.schedule_record and
              s.arrival_time between from_time and to_time;
    end loop;
end;
$$ LANGUAGE plpgsql;
