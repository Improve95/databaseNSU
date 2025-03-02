/* first trigger */

/* second trigger */
truncate table schedule cascade;
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (1, 1, null, '01-01-2025 13:30:00'::timestamp);
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (2, 1, '01-01-2025 13:20:00'::timestamp, '01-01-2025 13:30:00'::timestamp);


insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (2, 2, '01-01-2025 13:20:00'::timestamp, '01-01-2025 13:30:00'::timestamp);
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (3, 2, '01-01-2025 16:30:00'::timestamp, '01-01-2025 16:40:00'::timestamp);

insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (1, 1, null, '01-01-2025 13:30:00'::timestamp);
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (2, 1, '01-01-2025 13:20:00'::timestamp, '01-01-2025 13:30:00'::timestamp);
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (3, 1, '01-01-2025 13:20:00'::timestamp, '01-01-2025 14:40:00'::timestamp);
select * from schedule order by thread_id, route_structure_id;

/* third trigger */


/* fourth trigger */
