/* second trigger */
truncate table schedule cascade;
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (1, 1, null, '01-01-2025 13:30:00'::timestamp);
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (2, 1, '01-01-2025 13:20:00'::timestamp, '01-01-2025 13:30:00'::timestamp);
insert into schedule (route_structure_id, thread_id, arrival_time, departure_time)
values (3, 1, '01-01-2025 14:30:00'::timestamp, '01-01-2025 14:40:00'::timestamp);
select * from schedule order by route_structure_id;