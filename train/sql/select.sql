select count(*) from staff;
select count(*) from passengers;
select count(*) from trains;
select count(*) from railroad_cars;
select count(*) from routes;
select count(*) from booking;
select count(*) from railroads_cars_booking;

select rcb.*, s.* from railroads_cars_booking rcb
    inner join schedule s on rcb.arrival_point = s.id
        order by s.departure_time
            limit 1;
/* 01-01 || 07-20 */

select count(*), DATE(s.arrival_time) as trip_date from railroads_cars_booking rcb
    inner join schedule s on rcb.departure_point = s.id
        inner join routes_structure rs on s.route_structure_id = rs.id
            where rs.station_number_in_route = 0
group by trip_date;

select rcb.id, rcb.railroad_car_id, s.*, rs.station_number_in_route from railroads_cars_booking rcb
inner join schedule s on (rcb.arrival_point = s.id or rcb.departure_point = s.id)
inner join routes_structure rs on s.route_structure_id = rs.id
inner join routes_structure rs on
where rcb.id = 1
order by rs.station_number_in_route;

select rcb.id, rcb.railroad_car_id, s.*, rs2.id, rs2.route_id, rs2.station_number_in_route, rs2.distance
from railroads_cars_booking rcb
inner join schedule s on (rcb.arrival_point = s.id)
inner join routes_structure rs on s.route_structure_id = rs.id
inner join routes_structure rs2 on rs.route_id = rs2.route_id
where rcb.id = 1
order by rs2.station_number_in_route, s.id;

select rcb.id, s.*, (select s2.thread_id from schedule s2 where s2.id = rcb.arrival_point)
from railroads_cars_booking rcb
inner join schedule s on rcb.departure_point = s.id
where rcb.id = 1;

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
