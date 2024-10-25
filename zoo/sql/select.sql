/* == 1 == */
select * from (
    select *, max(ah.animal_in_habitat) over() as max_habitat from (
        select a.*,
        count(*) over (partition by (select habitat from animal_type at
                                     where at.id = a.animal_type)) as animal_in_habitat
        from animal a) as ah)
where animal_in_habitat = max_habitat;

/* == 2 == */
select habitat, min(min_coming_time) from (
    select *, min(animal_habitat_table.coming_time) over (partition by animal_habitat_table.habitat) as min_coming_time from (
        select a.*, (select habitat from animal_type at
                    where a.animal_type = at.id) as habitat from animal a) as animal_habitat_table)
group by habitat;

select * from (
    select *, dense_rank() over (partition by habitat order by coming_time) as time_rank from (
            select a.*, (select habitat from animal_type at
                         where a.animal_type = at.id) as habitat from animal a)
) where time_rank = 1;

/* == 3 == (jrjyyfz функция) */
select cage.*, light_weight_animal from cage inner join (
    select cage, min(weight) light_weight_animal from animal
    group by cage
    ) as light_weight_cage on cage.id = light_weight_cage.cage;

/* == 4 == */
select * from (
    select *, max(max_in_cage) over () as max_in_cage_between_all_cages from (
        select cage, total_weight, max(animals_in_cage) as max_in_cage from (
            select a.*,
            sum(a.weight) over (partition by cage) as total_weight, /* без оконных функций внутри */
            count(*) over (partition by cage) as animals_in_cage
            from animal a)
        group by cage, total_weight
        order by max_in_cage desc))
where max_in_cage = max_in_cage_between_all_cages;

select * from (
    select *, max(animals_in_cage) over () as max_in_cage_between_all_cages from (
        select a.*,
        count(*) over (partition by cage) as animals_in_cage
        from animal a)) as cmp_animals_in_cage
where animals_in_cage = max_in_cage_between_all_cages;

/* == 5 == */
/* доабавить параметр для колва типов в клетке */
select cage.* from cage where cage.id in (
    select cage from (
    select cage,
    first_value(animal_type_num) over (partition by cage order by animal_type, animal_type_num) as first_animal_type,
    last_value(animal_type_num) over (partition by cage order by animal_type, animal_type_num) as last_animal_type
    from (
        select a.*,
        dense_rank() over (partition by cage order by animal_type) as animal_type_num
        from animal a)
    ) where first_animal_type != last_animal_type
);

/* == test ==*/
select *, sum(weight) over (partition by animal_type order by coming_time) from animal
order by animal_type desc ;