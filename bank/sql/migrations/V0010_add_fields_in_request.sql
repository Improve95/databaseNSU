alter table requests add column credit_amount numeric(15, 2) not null default 0;
alter table requests add column credit_period interval not null default interval '10 years';