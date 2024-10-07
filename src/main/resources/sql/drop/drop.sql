/* 1 */
drop schema if exists public cascade ;

/* 2 */
drop table if exists specialization cascade ;
truncate table specialization cascade ;

drop table if exists department cascade;
truncate department cascade;

/* 3 */
drop type if exists position_type cascade ;
drop function if exists check_staff_limit();

drop table if exists staff cascade ;
truncate table staff cascade ;

drop trigger if exists doctor_limit on staff;

drop type if exists staff_changes cascade ;
drop table if exists staff_change;

truncate table staff_change cascade;

/* 5 */
drop function if exists check_doctor_in_staff();

drop table if exists doctor cascade ;
truncate table doctor cascade;
drop trigger if exists check_doctor_in_staff_trigger on doctor;

drop table if exists doctor_specialization cascade ;
truncate table doctor_specialization cascade ;

/* 6 */
drop type if exists patient_status_type cascade ;

drop table if exists patient cascade ;
truncate table patient cascade;

drop table if exists disease cascade ;
truncate table disease cascade;

drop table if exists patient_history cascade;
truncate table patient_history cascade;

/* 7 */

drop type if exists patient_change_type cascade ;
drop table patient_history;

drop table if exists research_type cascade ;
truncate table research_type cascade ;

drop table if exists research cascade ;
truncate table research cascade ;

/* 8 */
drop table if exists duty_schedule;
truncate table duty_schedule cascade;