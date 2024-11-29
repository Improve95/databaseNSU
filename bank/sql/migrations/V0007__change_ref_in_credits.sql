alter table credits drop constraint credits_client_id_fkey;
alter table credits drop constraint credits_credit_tariff_id_fkey;
alter table credits add foreign key (client_id, credit_tariff_id) references credit_tariff_client (client_id, credit_tariff_id);

alter table payments_schedule drop constraint payments_schedule_pkey;