-- Active: 1725467443941@@localhost@5430@dbCourse
create table person (
    id int primary key generated by default as identity ,
    name varchar(50) not null ,
    second_name varchar(50) not null ,
    phone varchar(11) unique not null
)