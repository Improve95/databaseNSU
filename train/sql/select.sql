select count(*) from staff;
select count(*) from passengers;
select count(*) from trains;
select count(*) from railroad_cars;
select count(*) from routes;
select count(*) from booking;
select count(*) from railroads_cars_booking;

select rcb.id, src.*, row_number() over (partition by rcb.id order by station_number_in_route) as partition
from railroads_cars_booking rcb
inner join lateral (
    select s.id as schedule_id, s.thread_id, s.departure_time, s.arrival_time, rs.*
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = (select s2.thread_id from schedule s2 where s2.id = rcb.departure_point)
    ) as src on ((src.schedule_id between rcb.departure_point and rcb.arrival_point) and departure_time is not null);

update railroads_cars_booking rcb set arrival_point = 5 where rcb.id = 1;

select count(distinct thread_id) as thread_count,
       count(distinct rcb.id) as passenger_count,
       sum(distance) as distance_sum,
       DATE(departure_time) as calc_day,
       DATE_TRUNC('quarter', departure_time) as calc_quarter,
       DATE_TRUNC('year', departure_time) as calc_year
from railroads_cars_booking rcb
    inner join lateral (
        select s.id as schedule_id, s.thread_id, s.departure_time, s.arrival_time, rs.*
        from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
        where s.thread_id = (select s2.thread_id from schedule s2 where s2.id = rcb.departure_point)
    ) as src on ((src.schedule_id between rcb.departure_point and rcb.arrival_point) and departure_time is not null)
group by rollup (
    DATE_TRUNC('year', departure_time),
    DATE_TRUNC('quarter', departure_time),
    DATE(departure_time)
    )
having DATE_TRUNC('year', departure_time) is not null;
