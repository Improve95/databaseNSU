select count(*) from staff;
select count(*) from passengers;
select count(*) from trains;
select count(*) from railroad_cars;
select count(*) from routes;
select count(*) from railroads_cars_booking;

select rcb.id, src.*, row_number() over (partition by rcb.id order by station_number_in_route) as partition
from railroads_cars_booking rcb
inner join lateral (
    select s.id as schedule_id, s.thread_id, s.departure_time, s.arrival_time, rs.*
    from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
    where s.thread_id = (select s2.thread_id from schedule s2 where s2.id = rcb.departure_point)
    ) as src on ((src.schedule_id between rcb.departure_point and rcb.arrival_point) and departure_time is not null);

with default_report as (
    select count(distinct thread_id) as thread_count,
           count(distinct rcb.id) as passenger_count,
           sum(distance) as distance_sum,
           extract(DAY from departure_time) as day,
           extract(QUARTER from departure_time) as quarter,
           extract(YEAR from departure_time) as year
    from railroads_cars_booking rcb
        inner join lateral (
            select s.id as schedule_id, s.thread_id, s.departure_time, s.arrival_time, rs.*
            from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
            where s.thread_id = (select s2.thread_id from schedule s2 where s2.id = rcb.departure_point)
        ) as src on ((src.schedule_id between rcb.departure_point and rcb.arrival_point) and departure_time is not null)
    group by rollup (
        extract(YEAR from departure_time),
        extract(QUARTER from departure_time),
        extract(DAY from departure_time)
    )
    having extract(YEAR from departure_time) is not null
),
aggregated_data as (
    select
        sum(passenger_count) over (partition by quarter, year order by day) as p_day,
        sum(case when day is null then passenger_count else 0 end) over (partition by year order by quarter) as p_quarter,
        sum(case when day is null AND quarter is null then passenger_count else 0 end) over (order by year) as p_year,

        sum(thread_count) over (partition by quarter, year order by day) as tc_day,
        sum(case when day is null then thread_count else 0 end) over (partition by year order by quarter) as tc_quarter,
        sum(case when day is null AND quarter is null then thread_count else 0 end) over (order by year) as tc_year,

        sum(distance_sum) over (partition by quarter, year order by day) as d_day,
        sum(case when day is null then distance_sum else 0 end) over (partition by year order by quarter) as d_quarter,
        sum(case when day is null AND quarter is null then distance_sum else 0 end) over (order by year) as d_year,

        day, quarter, year
    from default_report
) select * from aggregated_data;

/*select
    (case when day is null and quarter is null then tc_year else case when day is null and quarter is not null then tc_quarter else tc_day end end),
    (case when day is null and quarter is null then p_year else case when day is null and quarter is not null then p_quarter else p_day end end),
    (case when day is null and quarter is null then d_year else case when day is null and quarter is not null then d_quarter else d_day end end),
    (case when day is null and quarter is null then year::text else case when day is null and quarter is not null then quarter::text || '-' || year::text else day::text end end)
  from (
  select
      sum(passenger_count) over (partition by quarter, year order by dr.day) as p_day,
      sum(case when day is null then passenger_count else 0 end) over (partition by year order by dr.quarter) as p_quarter,
      sum(case when (day is null and quarter is null) then passenger_count else 0 end) over (order by dr.year) as p_year,

      sum(thread_count) over (partition by quarter, year order by dr.day) as tc_day,
      sum(case when day is null then thread_count else 0 end) over (partition by year order by dr.quarter) as tc_quarter,
      sum(case when (day is null and quarter is null) then thread_count else 0 end) over (order by dr.year) as tc_year,

      sum(distance_sum) over (partition by quarter, year order by dr.day) as d_day,
      sum(case when day is null then distance_sum else 0 end) over (partition by year order by dr.quarter) as d_quarter,
      sum(case when (day is null and quarter is null) then distance_sum else 0 end) over (order by dr.year) as d_year,
      dr.day,
      dr.quarter,
      dr.year
  from default_report dr
);*/

with default_report as (
    select count(distinct thread_id) as thread_count,
           count(distinct rcb.id) as passenger_count,
           sum(distance) as distance_sum,
           extract(day from departure_time) as day,
           extract(quarter from departure_time) as quarter,
           extract(year from departure_time) as year
    from railroads_cars_booking rcb
        inner join lateral (
            select s.id as schedule_id, s.thread_id, s.departure_time, s.arrival_time, rs.*
            from schedule s inner join routes_structure rs on s.route_structure_id = rs.id
            where s.thread_id = (select s2.thread_id from schedule s2 where s2.id = rcb.departure_point)
        ) as src on ((src.schedule_id between rcb.departure_point and rcb.arrival_point) and departure_time is not null)
    group by rollup (
        extract(year from departure_time),
        extract(quarter from departure_time),
        extract(day from departure_time)
    )
    having extract(year from departure_time) is not null
),
aggregated_data as (
    select
        sum(passenger_count) over (partition by quarter, year order by day) as p_day,
        sum(case when day is null then passenger_count else 0 end) over (partition by year order by quarter) as p_quarter,
        sum(case when day is null AND quarter is null then passenger_count else 0 end) over (order by year) as p_year,

        sum(thread_count) over (partition by quarter, year order by day) as tc_day,
        sum(case when day is null then thread_count else 0 end) over (partition by year order by quarter) as tc_quarter,
        sum(case when day is null AND quarter is null then thread_count else 0 end) over (order by year) as tc_year,

        sum(distance_sum) over (partition by quarter, year order by day) as d_day,
        sum(case when day is null then distance_sum else 0 end) over (partition by year order by quarter) as d_quarter,
        sum(case when day is null AND quarter is null then distance_sum else 0 end) over (order by year) as d_year,

        day, quarter, year
    from default_report
)
select
    coalesce(tc_day, tc_quarter, tc_year) as thread_count,
    coalesce(p_day, p_quarter, p_year) as passenger_count,
    coalesce(d_day, d_quarter, d_year) as distance_sum,
    coalesce(day::text, quarter::text || '-' || year::text, year::text) as time_group
from aggregated_data;
