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
    calc_day timestamp,
    calc_quarter timestamp,
    calc_year timestamp
);
drop table if exists report_by_day;
create table report_by_day (
    thread_count int,
    passenger_count int,
    distance_sum int,
    calc_day timestamp,
    calc_quarter timestamp,
    calc_year timestamp
);
create extension if not exists hstore;
drop function get_trip_report();
create or replace function get_trip_report() returns report[] as $$
declare
    threads_count int;
    passenger_count int;
    distance_sum int;

    thread_id threads.id%TYPE;
--     rcb_table [];
    rcb_el railroads_cars_booking%rowtype;

    departure_schedule schedule.id%type;
    arrival_schedule schedule.id%type;
    departure_point_route schedule.id%type;
    arrival_point_route schedule.id%type;
    departure_rs routes_structure%rowtype;
    arrival_rs routes_structure%rowtype;

    td full_trip;

    report_by_day report[];
    report_by_day2 hstore := hstore('');
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

        foreach td in array(
            select row(rcb_el.id, s.thread_id, s.departure_time, rs.station_number_in_route, rs.distance) from routes_structure rs
                inner join schedule s on rs.id = s.route_structure_id
            where rs.id between departure_rs.id and arrival_rs.id)
        loop
            if (select count(*) from report_by_day rbd where rbd.calc_day > 0) then

            else
                insert into report_by_day values (1, 1, );
            end if;
--             report_by_day2
        end loop;



--         full_trip_data := array_cat(full_trip_data, trip_data);
    end loop;

   /*select array (
        select row(
            count(distinct (ftd::full_trip).thread_id),
            count(distinct (ftd::full_trip).id),
            sum((ftd::full_trip).distance),
            DATE_TRUNC('year', (ftd::full_trip).departure_time),
            DATE_TRUNC('quarter', (ftd::full_trip).departure_time),
            DATE((ftd::full_trip).departure_time)
        )
        from unnest(full_trip_data) as ftd
        group by rollup (
            DATE_TRUNC('year', (ftd::full_trip).departure_time),
            DATE_TRUNC('quarter', (ftd::full_trip).departure_time),
            DATE((ftd::full_trip).departure_time)
            )
        having DATE_TRUNC('year', (ftd::full_trip).departure_time) is not null
    ) into report_by_day;*/

    return report_by_day;
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
