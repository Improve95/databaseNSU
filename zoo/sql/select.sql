select * from animal a where a.animal_type = (
    select animal_type from animal
    group by animal_type
    order by count(*)
    fetch first 1 rows only);


select * from