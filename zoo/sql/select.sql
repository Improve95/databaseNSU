select *, count(*) over (partition by (select habitat from animal_type at where at.id = a.animal_type)) from animal a;