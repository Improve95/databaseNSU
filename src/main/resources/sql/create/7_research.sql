create table research_type (
    id int primary key generated by default as identity ,
    department_id int references department("id") on delete set null ,
    name varchar(100) not null
);

create table research (
    id int primary key generated by default as identity ,
    research_type int not null references research_type("id") on delete cascade ,
    disease_id int not null references disease("id") on delete cascade ,
    date_of_research date not null ,
    status int not null ,
    result varchar(10)
);