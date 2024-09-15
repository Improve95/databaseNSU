drop table if exists research_type cascade ;
create table research_type (
    id uuid primary key default gen_random_uuid() ,
    department_id uuid not null references department("id") on delete cascade ,
    name varchar(100) not null
);
truncate table research_type cascade ;

drop table if exists research cascade ;
create table research (
                          id uuid primary key default gen_random_uuid() ,
                          research_type uuid not null references research_type("id") on delete cascade,
                          disease_id uuid not null references disease("id") on delete cascade,
                          date_of_research date not null ,
                          status int not null ,
                          result varchar(10) -- ??? что значит файл
);
truncate table research cascade ;