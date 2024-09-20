truncate table department cascade ;
alter sequence department_id_seq restart with 1;
insert into department (specialization_id, name, capacity)
    VALUES (2, 'cardiology_department', 6),
           (3, 'neurology_department', 8),
           (7, 'orthopedics_department', 4),
           (4, 'pediatrics_department', 7),
           (8, 'dermatology_department', 5);