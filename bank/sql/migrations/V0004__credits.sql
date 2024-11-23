create type credit_status as enum ('open', 'close');
drop table if exists credits cascade ;
create table credits (
    id uuid primary key default gen_random_uuid() ,
    initial_debt float4 not null check ( initial_debt >= 0 ) ,
    remaining_debt float4 not null check ( remaining_debt > 0 ),
    period interval not null ,
    percent int not null check ( percent > 0 ),
    client_id int not null references clients("id") on delete set null,
    credit_status credit_status not null default 'open'::credit_status
);

create table commissions (
    credit_id uuid not null references credits("id") ,
    amount float4 not null check ( amount > 0 ) ,
    date date not null default current_date ,
    primary key (credit_id, date)
);

create table penalties (
    credit_id uuid not null references credits("id") ,
    amount float4 not null check ( amount > 0 ) ,
    date date not null default current_date ,
    primary key (credit_id, date)
);

create table payments_schedule (
    credit_id uuid not null references credits("id") on delete cascade ,
    month_amount float4 not null check ( month_amount >= 0 ) ,
    payment_date timestamp with time zone not null,
    payment_paid boolean default false,
    primary key (credit_id, payment_date)
);

create type payment_type as enum ('bank_account', 'qiwi', 'yandex_pay');
create table payments (
    id uuid default gen_random_uuid() ,
    amount int not null check ( amount > 0 ) ,
    type_of_payment payment_type not null ,
    date timestamp with time zone not null default current_timestamp ,
    credit_id uuid not null references credits("id") on delete set null
);
