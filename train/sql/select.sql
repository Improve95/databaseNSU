select count(*) from staff;
select count(*) from passengers;
select count(*) from trains;
select count(*) from railroad_cars;
select count(*) from routes;
select count(*) from booking;

select * from staff;
select * from passengers;
select * from booking;
select * from routes;
select * from trains;
select * from railroad_cars;

select * from trains_on_route;
select * from schedule inner join routes_structure rs on schedule.route_structure_id = rs.id
where rs.route_id = 1
order by station_number_in_route;

select * from routes where id = 1;
select * from routes_structure where route_id = 1
order by station_number_in_route;

-- insert into routes_structure (route_id, station_id, station_number_in_route, distance)
-- insert into trains_on_route (train_id, route_id, setup_time, remove_time) values ()
-- insert into railroad_cars(train_id, route_id, category_id, number_in_train) values ()
-- insert into schedule(route_structure_id, arrival_time, departure_time) values ()
-- insert into booking(passenger_id, time) values
-- truncate table railroads_cars_booking
insert into railroads_cars_booking(railroad_car_id, place, departure_point, arrival_point, booking_record) values ()