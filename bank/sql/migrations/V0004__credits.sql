create type credit_status as enum ('open', 'close');
create table credits (
    id uuid primary key default gen_random_uuid() ,
    initial_debt numeric(15, 2) not null check ( initial_debt >= 0 ) ,
    remaining_debt numeric(15, 2) not null check ( remaining_debt >= 0 ) ,
    taking_date date not null default current_date,
    percent int not null check ( percent > 0 ),
    credit_period interval not null ,
    month_amount numeric(15, 2) not null check ( month_amount > 0 ) ,
    credit_tariff_id int not null references credit_tariffs("id") on delete set null ,
    client_id int not null references clients("id") on delete set null,
    credit_status credit_status not null default 'open'::credit_status
);

create table penalties (
    id uuid primary key default gen_random_uuid() ,
    credit_id uuid not null references credits("id") ,
    amount numeric(15, 2) not null check ( amount > 0 ) ,
    penalty_date date not null default current_date ,
    paid_deadline date not null default current_date + interval '1 month' ,
    is_paid boolean not null default false
);

create table payments_schedule (
    credit_id uuid not null references credits("id") on delete cascade ,
    up_to_payment_date timestamp with time zone not null,
    is_paid boolean default false,
    primary key (credit_id, up_to_payment_date)
);

create type payment_type as enum ('month', 'main_debt');
create type payment_way as enum ('bank_account', 'qiwi', 'yandex_pay');
create table payments (
    id uuid default gen_random_uuid() ,
    amount int not null check ( amount > 0 ) ,
    payment_for_what payment_type not null ,
    way_of_payment payment_way not null ,
    date timestamp with time zone not null default current_timestamp ,
    credit_id uuid not null references credits("id") on delete set null
);

create table balances (
    id uuid primary key default gen_random_uuid() ,
    credit_id uuid not null references credits("id") ,
    remaining_debt numeric(15, 2) not null check ( remaining_debt > 0 ) ,
    accrued_by_percent numeric(15, 2) not null check ( accrued_by_percent > 0 ) ,
    date date not null default current_date
);
