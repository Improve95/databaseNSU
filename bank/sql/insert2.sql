select * from payments_schedule where credit_id = 1;
select * from payments where credit_id = 1;

truncate table payments;
insert into payments (amount, commission, time, credit_id, payments_schedule)
VALUES (65000, 0, '2024-11-26 00:00:00', 1, 1),
       (32500, 0, '2024-12-25 00:00:00', 1, 2),
       (32500, 0, '2024-12-26 00:00:00', 1, 2),
       (40000, 0, '2025-01-25 00:00:00', 1, 3),
       (32500, 0, '2025-01-29 00:00:00', 1, 3);
update payments_schedule set is_paid = true where id = 1 or id = 2 or id = 3;