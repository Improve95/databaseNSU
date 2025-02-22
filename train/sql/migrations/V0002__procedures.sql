create function get_trip_report() returns int as $$
declare
    threads_count int;
    passenger_count int;
    distance_sum int;
    rcb_table railroads_cars_booking%rowtype;
    thread_id int;
begin
    select rcb.* into rcb_table from railroads_cars_booking rcb;

    returns threads_count;
end;
$$ LANGUAGE plpgsql;