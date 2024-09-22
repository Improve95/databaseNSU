select distinct staff.* from staff inner join staff_change sc on staff.id = sc.staff_id
    where sc.before is null and sc.change_time > current_date - interval '2 year' and
          staff.salary < 100000;

select distinct patient.* from patient inner join disease d on patient.id = d.patient_id
    where d.name = 'unknown_disease' and
          patient.coming_time > current_date - interval '3 months';

select sum(patient_number), doctor_id from (
    select count(*) as patient_number,
           case
               when p.status = 'HEALTHY' then 'HEALTHY'
               else 'OTHER'
               end as status_group, doctor_id from doctor inner join patient p on doctor.staff_id = p.doctor_id
    group by (status_group, p.doctor_id)
)
group by doctor_id
order by doctor_id desc ;

select count(*) as patient_number,
       case
           when p.status = 'HEALTHY' then 'HEALTHY'
           else 'OTHER'
           end as status_group, doctor_id from doctor inner join patient p on doctor.staff_id = p.doctor_id
group by (status_group, p.doctor_id);

select *, healthy_patient / total_patient * 100 as "%" from (
    select doctor_id,
           sum(case when status_group = 'HEALTHY' then patient_number else 0 end) as healthy_patient,
           sum(patient_number) as total_patient from (
           select * from (
                select count(*) as patient_number,
                case
                    when p.status = 'HEALTHY' then 'HEALTHY'
                    else 'OTHER'
                    end as status_group, doctor_id from doctor inner join patient p on doctor.staff_id = p.doctor_id
                                                   group by (status_group, p.doctor_id)
            )
    ) group by doctor_id)
order by "%" desc
fetch next 10 rows only;