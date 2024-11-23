create table requests (
    id uuid primary key default gen_random_uuid() ,
    credit_tariff int references credit_tariff("id") not null ,
    time timestamp with time zone not null default current_timestamp ,
    client_id int references clients("id") not null
);

create type credit_scoring_status as enum ('approve', 'reject');
create table credit_scoring (
    score float4 not null ,
    credit_request_id uuid references requests("id") primary key ,
    status credit_scoring_status not null
);

