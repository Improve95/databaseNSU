/* == 1 == */
select distinct staff.* from staff inner join staff_change sc on staff.id = sc.staff_id
where sc.change_type = 'EMPLOY'::staff_changes_type and sc.change_time > current_date - interval '2 year' and
staff.salary < 100000;

/* == 2 == */
select patient.*, dh.disease, count(*) over  from patient inner join disease_history dh on patient.id = dh.patient_id
where coming_time > current_timestamp - interval '2 month'
order by dh.disease;

/* == 3 == */
select *, healthy_patient::NUMERIC / patient_number * 100 as "%" from (
    select count(*) as patient_number, sum(case when dh.patient_status = 'HEALTHY' then 1 else 0 end) as healthy_patient,
    current_doctor from doctor inner join disease_history dh on doctor.id = dh.current_doctor
    group by (dh.current_doctor))
order by "%" desc
fetch first 10 rows only;

/* == 4 == */
select patient.*, sum(case when release_time is null then current_timestamp else release_time end - coming_time) as sick_time from patient
inner join disease_history on patient.id = disease_history.patient_id
group by (patient.id, patient.*)
order by "sick_time" desc
fetch first 10 rows only;

/* == 5 == */
select department.* from department
inner join (
    select current_doctor, count(*) as doctor_patient_number from disease_history
    where patient_status = 'SICK'::patient_status_type
    group by (current_doctor)) on current_doctor = department.id
group by (department.id, department.*) 
having (sum(doctor_patient_number) / count(*) >= 10);

/* == 6 == */
select d.*, patient_disease_time_sum from doctor d inner join (
    select sum(case when release_time is null then current_timestamp else release_time end -
               case when coming_time <  current_timestamp - interval '1 year' then current_timestamp else coming_time end) as patient_disease_time_sum,
    current_doctor from disease_history
    where coming_time > current_timestamp - interval '1 year'
    group by current_doctor) on d.id = current_doctor
order by patient_disease_time_sum desc ;

