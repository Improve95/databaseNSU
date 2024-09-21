truncate table department cascade ;
alter sequence department_id_seq restart with 1;
insert into department (specialization_id, name, capacity)
    VALUES (2, 'cardiology_department', 6),
           (3, 'neurology_department', 8),
           (7, 'orthopedics_department', 4),
           (4, 'pediatrics_department', 7),
           (8, 'dermatology_department', 5);

TRUNCATE table patient cascade ;
insert into patient (coming_time, release_time, doctor_id, status, person_id)
values ('2016-06-01T14:41:36', null, 2, 'HEALTHY', 40);