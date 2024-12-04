alter table payments drop column way_of_payment;
alter table payments add column commissions_percent int not null check ( commissions_percent >= 0 ) default 0;
