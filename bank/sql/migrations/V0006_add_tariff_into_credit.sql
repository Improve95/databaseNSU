alter table credits drop column if exists month_amount;
alter table credits add column credit_tariff_id int not null references credit_tariffs("id") on delete set null ;