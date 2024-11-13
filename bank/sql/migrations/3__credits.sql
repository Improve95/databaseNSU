create table credits (
    id uuid primary key default gen_random_uuid() ,
    remaining_debt int not null check ( remaining_debt > 0 ),
    current_percent int not null check ( current_percent > 0 ),
    /* комиссии? commission_amount int not null check ( commission_amount >= 0 ) ,*/
    /* штрафы ?? */
    client_id int not null references clients("id") on delete set null
);

create table payments_schedule (
    credit_id uuid not null references credits("id") on delete cascade ,
    debt_less_then int not null check ( debt_less_then >= 0 ) ,
    payment_date timestamp with time zone not null,
    primary key (credit_id, payment_date)
);

create type payment_type as enum ('bank_account', 'qiwi', 'yandex_pay');
create table payments (
    id uuid default gen_random_uuid() ,
    amount int not null check ( amount > 0 ) ,
    type_of_payment payment_type not null ,
    date timestamp with time zone not null default current_timestamp ,
    client_id int not null references clients("id") on delete cascade ,
    credit_id uuid not null references credits("id") on delete set null
);

alter table payments drop column client_id;