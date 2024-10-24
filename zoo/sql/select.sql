select * from (
    select *, max(ah.animal_in_habitat) over() as max_habitat from (
        select a.*,
        count(*) over (partition by (select habitat from animal_type at
                                     where at.id = a.animal_type)) as animal_in_habitat
        from animal a) as ah)
where animal_in_habitat = max_habitat;


