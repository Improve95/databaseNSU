select distinct staff.* from staff inner join staff_change sc on staff.id = sc.staff_id
    where sc.before is null and sc.change_time > current_date - interval '2 year' and
          staff.salary < 100000;

select distinct patient.* from patient inner join disease d on patient.id = d.patient_id
    where d.name = 'unknown_disease' and
          patient.coming_time > current_date - interval '3 months';



select doctor.*, count(*) from doctor inner join patient p on doctor.staff_id = p.doctor_id
    where p.status = 'HEALTHY'
    group by (staff_id)
    order by count(*) desc;

select doctor.*, count(*) from doctor inner join patient p on doctor.staff_id = p.doctor_id
    group by (staff_id)
    order by count(*) desc;
--     fetch next 10 rows only;

select count(*) / count(*) over (partition by p.status) as "% of total"
    from doctor inner join patient p on doctor.staff_id = p.doctor_id
        where p.status = 'HEALTHY';

select count(*) from doctor inner join patient p on doctor.staff_id = p.doctor_id
        where p.status = 'HEALTHY'
    union select count(*) from doctor inner join patient p on doctor.staff_id = p.doctor_id
        where p.status = 'OUT_TREATMENT' or p.status = 'TREATMENT_IN_ANOTHER_PLACE';

select count(*), p.status, doctor_id from doctor inner join patient p on doctor.staff_id = p.doctor_id
    group by (p.status='HEALTHY', p.doctor_id)
    order by doctor_id desc;

select count(*) from doctor inner join patient p on doctor.staff_id = p.doctor_id
    group by (p.status='HEALTHY')
    order by count(*) desc;

select total, doctor_id from (
select count(*) as total, doctor_id from doctor inner join patient p on doctor.staff_id = p.doctor_id
group by (p.status='HEALTHY', p.doctor_id)
order by doctor_id desc);