select distinct staff.* from staff inner join staff_change sc on staff.id = sc.staff_id
    where sc.before is null and sc.change_time > current_date - interval '2 year' and
          staff.salary < 100000;

select distinct patient.* from patient inner join disease d on patient.id = d.patient_id
    where d.name = 'unknown_disease' and
          patient.coming_time > current_date - interval '3 months';

select *, healthy_patient::NUMERIC / patient_number * 100 as "%" from (
    select count(*) as patient_number, sum(case when p.status = 'HEALTHY' then 1 else 0 end) as healthy_patient,
           doctor_id from doctor inner join patient p on doctor.staff_id = p.doctor_id
    group by (p.doctor_id))
order by "%" desc
fetch first 10 rows only ;

select sum(case when release_time is null then current_date else release_time end  - patient.coming_time) as total_time, person_id from patient
    where coming_time >= current_date - interval '3 years'
    group by person_id
    order by total_time desc
    fetch first 10 rows only;

select count(*) as doctor_patients, doctor_id from patient
group by (doctor_id)
order by doctor_id;

select * from department
    inner join staff on department.id = staff.department_id
    inner join (
        select count(*) as doctor_patients, doctor_id from patient
        group by (doctor_id)) on doctor_id = staff.id;

se
select sum(doctor_patients), count(*), department_id from department
    inner join staff on department.id = staff.department_id
    inner join (
        select count(*) as doctor_patients, doctor_id from patient
        group by (doctor_id)) on doctor_id = staff.id
    group by department_id ;





