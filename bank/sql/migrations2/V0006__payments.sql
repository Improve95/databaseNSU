create table payments_schedule (
    credit_id bigint not null references credits("id") on delete cascade ,
    amount numeric(15, 2) not null check ( amount > 0 ) ,
    deadline timestamp with time zone not null,
    is_paid boolean default false,
    primary key (credit_id, deadline)
);

create type payment_way as enum ('bank_account', 'qiwi', 'yandex_pay');
create table payments (
    amount numeric(15, 2) not null check ( amount > 0 ) ,
    way_of_payment payment_way not null ,
    date timestamp with time zone not null default current_timestamp ,
    credit_id bigint not null references credits("id") on delete set null
)