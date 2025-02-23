drop type full_trip;
create type full_trip as (
    id int,
    thread_id int,
    departure_time timestamp,
    station_in_number_route int,
    distance int
);
drop type report;
create type report as (
    thread_count int,
    passenger_count int,
    distance_sum int,
    quarter_calc timestamp,
    calc_year timestamp
);
create or replace function get_trip_report() returns int as $$
declare
    threads_count int;
    passenger_count int;
    distance_sum int;

    thread_id threads.id%TYPE;
    rcb_table railroads_cars_booking[];
    rcb_el railroads_cars_booking%rowtype;

    departure_schedule schedule.id%type;
    arrival_schedule schedule.id%type;
    departure_point_route schedule.id%type;
    arrival_point_route schedule.id%type;
    departure_rs routes_structure%rowtype;
    arrival_rs routes_structure%rowtype;

    trip_data full_trip[];
    full_trip_data full_trip[];
    td full_trip;

    report_by_day report[];
begin
    select rcb.* into rcb_table from railroads_cars_booking rcb;
    foreach rcb_el in array rcb_table
    loop
        select s.id, s.route_structure_id, s.thread_id into departure_schedule, departure_point_route, thread_id
                                                       from schedule s where s.id = rcb_el.departure_point;
        select s.id, s.route_structure_id into departure_schedule, arrival_point_route
                                          from schedule s where s.id = rcb_el.arrival_point;

        select rs.* into departure_rs from routes_structure rs where id = departure_point_route;
        select rs.* into arrival_rs from routes_structure rs where id = arrival_point_route;

        select rcb_el.id, s.thread_id, s.departure_time, rs.station_number_in_route, rs.distance into trip_data from routes_structure rs
        inner join schedule s on rs.id = s.route_structure_id
        where rs.id between departure_rs and arrival_rs;

        full_trip_data := array_cat(full_trip_data, td);
    end loop;

    full_trip_data := array_agg(x) from (select unnest(full_trip_data) as x order by x);
    unique_trip_data select array(select distinct e from unnest(full_trip_data) as a(e) order by e);

    return 5;
end;
$$ LANGUAGE plpgsql;

create or replace function fix_schedule_by_delay(from_time timestamp, to_time timestamp) returns void as $$
declare
    delay_list delay[];
    delay delay%rowtype;
begin
    select d.* into delay_list from delay d;
    foreach delay in array delay_list
    loop
        update schedule s set departure_time = s.departure_time + delay.departure_delay,
                              arrival_time = s.arrival_time + delay.arrival_delay
        where s.id = delay.schedule_record and
              s.arrival_time between from_time and to_time;
    end loop;
end;
$$ LANGUAGE plpgsql;
