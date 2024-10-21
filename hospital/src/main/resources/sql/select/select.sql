select distinct staff.* from staff inner join staff_change sc on staff.id = sc.staff_id
    where sc.before is null and sc.change_time > current_date - interval '2 year' and
          staff.salary < 100000;

select patient.* from patient inner join disease_history dh on patient.id = dh.patient_id
    where dh.disease = 5 and dh.coming_time >= current_timestamp - interval '3 month';

select *, healthy_patient::NUMERIC / patient_number * 100 as "%" from (
    select count(*) as patient_number, sum(case when dh.patient_status = 'HEALTHY' then 1 else 0 end) as healthy_patient,
        current_doctor from doctor inner join disease_history dh on doctor.id = dh.current_doctor
            group by (dh.current_doctor))
    order by "%" desc
    fetch first 10 rows only;

select patient.*, sum(case when release_time is null then current_timestamp else release_time end - coming_time) as sick_time from patient
    inner join disease_history on patient.id = disease_history.patient_id
        group by (patient.id, patient.*)
            order by "sick_time" desc
            fetch first 10 rows only;

select department.* from department inner join staff s on department.id = s.department_id
inner join (
    select current_doctor, count(*) as doctor_patient_number from disease_history
    where patient_status = 'SICK'::patient_status_type
    group by (current_doctor)) on current_doctor = s.id
group by (department.id, department.*) 
having (sum(doctor_patient_number) / count(*) >= 10);

select sum((case when release_time is null then current_timestamp else release_time end) -
           (case when coming_time < current_timestamp - interval '1 years' then current_timestamp - interval '1 years' else coming_time end))
        as total_time, doctor.id
    from doctor inner join disease_history dh on doctor.id = dh.current_doctor
        where dh.release_time > current_timestamp - interval '1 years' or dh.release_time is null
                group by doctor.id
                    order by total_time desc;

