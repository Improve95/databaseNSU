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

/* == 3 == (оконная функция) */
select id, animal_type, cage, name, weight, length, coming_time from (
    select animal.*, max(weight) over (partition by cage) as heaviest_weight from animal
)
where heaviest_weight = weight;

select a.* from animal a inner join (
    select cage, max(weight) as max_weight from animal
    group by cage) as cage_max_weight on a.weight = cage_max_weight.max_weight
order by cage;

/* == 4 == */
select animal.weight from animal where cage = (
    select cage as animal_count from animal
    group by cage
    order by count(*) desc
    fetch first 1 rows only
);

/* == 5 == */
select cage.* from cage inner join (
    select cage from animal
    group by cage
    having count(distinct animal_type) > 2
) as cage_type_freq on cage_type_freq.cage = cage.id;
