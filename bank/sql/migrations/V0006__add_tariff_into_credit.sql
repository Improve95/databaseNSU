alter table credits add column credit_tariff_id int not null references credit_tariffs("id") on delete set null ;
alter table credits add column credit_period interval;