create table requests (
    id uuid primary key default gen_random_uuid() ,
    credit_tariff int not null references credit_tariffs("id") ,
    time timestamp with time zone not null default current_timestamp ,
    client_id int not null references clients("id") on delete cascade
);

create type credit_scoring_status as enum ('approve', 'reject');
create table credits_scoring (
    score float4 not null ,
    credit_request_id uuid primary key references requests("id") on delete cascade ,
    status credit_scoring_status not null
);

