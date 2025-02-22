select count(*) from staff;
select count(*) from passengers;
select count(*) from trains;
select count(*) from railroad_cars;
select count(*) from routes;
select count(*) from booking;
select count(*) from railroads_cars_booking;

update railroads_cars_booking rcb set arrival_point = 5 where rcb.id = 1;

select count(distinct thread_id), count(distinct rcb.id), sum(distance),
       DATE(departure_time) as calc_date,
       DATE_TRUNC('quarter', departure_time) as quarter_year,
       DATE_TRUNC('year', departure_time) as calc_year
from railroads_cars_booking rcb
         inner join lateral (
    select s.id as schedule_id, s.thread_id, s.departure_time, s.arrival_time, rs.*
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = (select s2.thread_id from schedule s2 where s2.id = rcb.departure_point)
    ) as src on src.schedule_id between rcb.departure_point and rcb.arrival_point
group by rollup (DATE_TRUNC('year', departure_time), DATE_TRUNC('quarter', departure_time), DATE(departure_time))
having DATE_TRUNC('year', departure_time) is not null;
