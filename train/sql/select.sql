select count(*) from staff;
select count(*) from passengers;
select count(*) from trains;
select count(*) from railroad_cars;
select count(*) from routes;
select count(*) from booking;
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
) select
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
);

/*

WITH count_trips AS (
    SELECT date, COUNT(*)
    FROM (
        SELECT DATE(generate_series(DATE(MIN(timestamp_departure)), DATE(MAX(timestamp_arrival)), INTERVAL '1 day'))
        FROM timetable
        GROUP BY train_route_id
    ) AS dates
    GROUP BY date
),
passenger_count_distation AS (
    SELECT date, COUNT(*),SUM(distation)
    FROM (
        SELECT DATE(generate_series(DATE(td.timestamp_departure), DATE(ta.timestamp_arrival), INTERVAL '1 day')), (tars.distation - tdrs.distation) / ((DATE(ta.timestamp_arrival) - DATE(td.timestamp_departure)) + 1) AS distation
        FROM tickets JOIN timetable AS ta
        ON tickets.timetable_arrival_id = ta.id
        JOIN timetable AS td
        ON tickets.timetable_departure_id = td.id
        JOIN routes_stations AS tars
        ON ta.route_id = tars.id AND ta.order_route = tars.order_route
        JOIN routes_stations AS tdrs
        ON td.route_id = tdrs.id AND td.order_route = tdrs.order_route
    ) AS dates
    GROUP BY date
),
report AS (
    SELECT COALESCE(ct.date, pcd.date) AS report_date, COALESCE(ct.count, 0) AS trip_count, COALESCE(pcd.count, 0) AS passenger_count, COALESCE(pcd.sum, 0) AS distation_sum
    FROM count_trips ct
    FULL OUTER JOIN passenger_count_distation pcd ON ct.date = pcd.date
    ORDER BY 1
),
agregation_cumulative_report AS (
    SELECT
        report_date,
        EXTRACT(YEAR FROM report_date) AS year,
        EXTRACT(QUARTER FROM report_date) AS quarter,
        SUM(trip_count) AS trip_count,
        SUM(passenger_count) AS passenger_count,
        SUM(distation_sum) AS distation_sum
    FROM report
    GROUP BY ROLLUP(EXTRACT(YEAR FROM report_date), EXTRACT(QUARTER FROM report_date), report_date)
    HAVING report_date IS NULL
    UNION ALL
    SELECT
        report_date,
        EXTRACT(YEAR FROM report_date) AS year,
        EXTRACT(QUARTER FROM report_date) AS quarter,
        SUM(SUM(trip_count)) OVER (PARTITION BY EXTRACT(YEAR FROM report_date), EXTRACT(QUARTER FROM report_date) ORDER BY report_date) AS trip_count,
        SUM(SUM(passenger_count)) OVER (PARTITION BY EXTRACT(YEAR FROM report_date), EXTRACT(QUARTER FROM report_date) ORDER BY report_date) AS passenger_count,
        SUM(SUM(distation_sum)) OVER (PARTITION BY EXTRACT(YEAR FROM report_date), EXTRACT(QUARTER FROM report_date) ORDER BY report_date) AS distation_sum
    FROM report
    GROUP BY report_date
)
SELECT
    CASE
        WHEN report_date IS NULL AND quarter IS NULL THEN year  ' (итог)'
        WHEN report_date IS NULL THEN 'Q'  quarter  ' '  year
        ELSE report_date::text
    END AS date,
    trip_count,
    passenger_count,
    distation_sum
FROM agregation_cumulative_report
ORDER BY year, quarter, report_date;
*/
