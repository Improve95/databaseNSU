update patient set coming_time = current_date - interval '2 months' where id=7;
update patient set coming_time = current_date - interval '1 months' where id=8;
update patient set coming_time = current_date - interval '3 months' where id=9;
update patient set coming_time = current_date - interval '5 months' where id=10;
update patient set coming_time = current_date - interval '4 months' where id=11;
update patient set coming_time = current_date - interval '2 months' where id=12;
update patient set coming_time = current_date - interval '5 months' where id=13;

update patient set release_time = current_date where status = 'HEALTHY'::patient_status_type;