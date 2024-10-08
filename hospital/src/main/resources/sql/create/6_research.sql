create table research_type (
    id int primary key generated by default as identity ,
    name varchar(100) not null
);

create table research (
    id uuid primary key default gen_random_uuid() ,
    disease uuid not null references disease_history("id") on delete cascade,
    research_type int not null references research_type("id") on delete set null ,
    date_of_research date not null ,
    status int not null ,
    result varchar(10)
);