alter table payments drop column way_of_payment;
alter table payments add column commission decimal(15, 2) not null check ( commission >= 0 ) default 0;
