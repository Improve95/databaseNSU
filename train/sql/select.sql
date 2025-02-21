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

select s.*, rs.* from schedule s
inner join routes_structure rs on s.route_structure_id = rs.id
where route_id = 1;

insert into threads(train_id, route_id, trip_date) values ()