truncate table department cascade ;
alter sequence department_id_seq restart with 1;
insert into department (specialization_id, name, capacity)
    VALUES (2, 'cardiology_department', 6),
           (3, 'neurology_department', 8),
           (7, 'orthopedics_department', 4),
           (4, 'pediatrics_department', 7),
           (8, 'dermatology_department', 5);

insert into staff_change (staff_id, change_field, before, after, change_time)
VALUES (10, 'SALARY' ::staff_changes, null, 102000, '2024-07-21T00:00:00') ,
       (10, 'POSITION' ::staff_changes, null, 'doctor', '2024-07-21T00:00:00') ,
       (10, 'DEPARTMENT' ::staff_changes, null, 'name', '2024-07-21T00:00:00');

insert into staff_change (staff_id, change_field, before, after, change_time)
VALUES (7, 'SALARY' ::staff_changes, null, 85000, '2024-07-21T00:00:00') ,
       (7, 'POSITION' ::staff_changes, null, 'doctor', '2024-07-21T00:00:00') ,
       (7, 'DEPARTMENT' ::staff_changes, null, 'name', '2024-07-21T00:00:00');

insert into staff_change (staff_id, change_field, before, after, change_time)
VALUES (9, 'SALARY' ::staff_changes, null, 92000, '2024-07-21T00:00:00') ,
       (9, 'POSITION' ::staff_changes, null, 'doctor', '2024-07-21T00:00:00') ,
       (9, 'DEPARTMENT' ::staff_changes, null, 'name', '2024-07-21T00:00:00');

insert into staff_change (staff_id, change_field, before, after, change_time)
VALUES (17, 'SALARY' ::staff_changes, null, 86000, '2024-07-21T00:00:00') ,
       (17, 'POSITION' ::staff_changes, null, 'doctor', '2024-07-21T00:00:00') ,
       (17, 'DEPARTMENT' ::staff_changes, null, 'name', '2024-07-21T00:00:00');

insert into staff_change (staff_id, change_field, before, after, change_time)
VALUES (23, 'SALARY' ::staff_changes, null, 73000, '2023-07-21T00:00:00') ,
       (23, 'POSITION' ::staff_changes, null, 'cleaner', '2023-07-21T00:00:00') ,
       (23, 'DEPARTMENT' ::staff_changes, null, 'name', '2023-07-21T00:00:00');

insert into disease (patient_id, name, installation_time, doctor_id, is_relevant)
    values (7, 'unknown_disease', current_date - interval '1 month', 2, true) ,
           (8, 'unknown_disease', current_date - interval '1 month', 2, true) ,
           (9, 'unknown_disease', current_date - interval '1 month', 2, true) ,
           (10, 'unknown_disease', current_date - interval '1 month', 2, true) ,
           (11, 'unknown_disease', current_date - interval '1 month', 2, true),
           (12, 'unknown_disease2', current_date - interval '1 month', 2, true) ,
           (13, 'unknown_disease2', current_date - interval '1 month', 2, true) ;