/*
drop table if exists  cascade ;
alter sequence if exists _id_seq restart with 1;
truncate  cascade;
drop trigger if exists  on ;
drop type if exists;
*/

/* 0 */
drop schema if exists hospital cascade ;

/* 1 */
drop table if exists specialization cascade ;
truncate table specialization cascade ;
alter sequence specialization_id_seq restart with 1;

drop table if exists department cascade;
truncate department cascade;
alter sequence department_id_seq restart with 1;

/* 2 */
drop table if exists staff cascade ;
alter sequence staff_id_seq restart with 1;
truncate staff cascade;

drop trigger if exists check_staff_limit_in_department on staff;

drop type if exists staff_changes;

/* 6 */
drop table if exists patient cascade ;
alter sequence if exists patient_id_seq restart with 1;
truncate patient cascade;

drop type if exists patient_status_type;

drop type if exists disease_history_change_type;

drop table if exists disease_history_change cascade ;
alter sequence if exists disease_history_change_id_seq restart with 1;
truncate disease_history_change cascade;

/* 7 */
drop table if exists research_type cascade ;
alter sequence research_type_id_seq restart with 1;
truncate research_type cascade;

drop table if exists research cascade ;
alter sequence if exists  research_id_seq restart with 1;
truncate research cascade;

/* 8 */
drop table if exists duty_schedule cascade ;
alter sequence if exists  duty_schedule_id_seq restart with 1;
truncate duty_schedule cascade;