create table balances (
    id uuid primary key default gen_random_uuid() ,
    credit_id uuid references credits("id") not null ,
    accrued_by_percent float4 not null check ( accrued_by_percent > 0 ),
    date date default current_date not null
)