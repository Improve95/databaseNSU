update patient set coming_time = now() - interval '2 days';
update patient set coming_time = now() - interval '2 months' where id=7;
update patient set coming_time = now() - interval '1 months' where id=8;
update patient set coming_time = now() - interval '3 months' where id=9;
update patient set coming_time = now() - interval '5 months' where id=10;
update patient set coming_time = now() - interval '4 months' where id=11;
update patient set coming_time = now() - interval '2 months' where id=12;
update patient set coming_time = now() - interval '5 months' where id=13;

update patient set release_time = now() where status = 'HEALTHY'::patient_status_type;
update patient set release_time = now() + interval '1 days' where status = 'OUT_TREATMENT'::patient_status_type;
update patient set release_time = now() + interval '10 minutes' where status = 'ANOTHER_PLACE'::patient_status_type;