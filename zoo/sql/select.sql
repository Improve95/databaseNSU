select * from (
    select *, max(ah.animal_in_habitat) over() as max_habitat from (
        select a.*,
        count(*) over (partition by (select habitat from animal_type at
                                     where at.id = a.animal_type)) as animal_in_habitat
        from animal a) as ah)
where animal_in_habitat = max_habitat;

select habitat, min(min_coming_time) from (
    select *, min(animal_habitat_table.coming_time) over (partition by animal_habitat_table.habitat) as min_coming_time from (
        select a.*, (select habitat from animal_type at
                    where a.animal_type = at.id) as habitat from animal a) as animal_habitat_table)
group by habitat;

select cage.*, light_weight_animal from cage inner join (
    select cage, min(weight) light_weight_animal from animal
    group by cage
    ) as light_weight_cage on cage.id = light_weight_cage.cage;

