select distinct staff.* from staff inner join staff_change sc on staff.id = sc.staff_id
    where sc.before is null and sc.change_time > current_date - interval '2 year' and
          staff.salary < 100000;

select patient.* from patient inner join disease_history dh on patient.id = dh.patient_id
    where dh.disease = 3 and dh.сoming_time >= current_timestamp - interval '3 month';

select *, healthy_patient::NUMERIC / patient_number * 100 as "%" from (
    select count(*) as patient_number, sum(case when dh.patient_status = 'HEALTHY' then 1 else 0 end) as healthy_patient,
        current_doctor from doctor inner join disease_history dh on doctor.id = dh.current_doctor
        group by (dh.current_doctor))
    order by "%" desc
    fetch first 10 rows only;

/*select sum((case when release_time is null then current_timestamp else release_time end)  - coming_time) as total_time, person_id from patient
    where coming_time >= current_date - interval '3 years'
    group by person_id
    order by total_time desc
    fetch first 10 rows only;

select department_id from department
    inner join staff on department.id = staff.department_id
    inner join (
        select count(*) as doctor_patients, doctor_id from patient
        group by (doctor_id)) on doctor_id = staff.id
    group by department_id
    having (sum(doctor_patients) /count(*) >= 10);

select sum((case when release_time is null then current_timestamp else release_time end) -
           (case when coming_time < current_timestamp - interval '1 years' then current_timestamp - interval '1 years' else coming_time end))
        as total_time, doctor_id
    from doctor inner join patient on doctor.staff_id = patient.doctor_id
    group by doctor_id
    order by total_time desc;
*/
