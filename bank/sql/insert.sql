insert into positions (name) values ('director'),
                                    ('manager1'),
                                    ('manager2'),
                                    ('employee');

insert into credit_tariffs (type, initial_amount, final_amount, payment_period, credit_percent) VALUES ('t1', 100000, 1000000, interval '5 years', 10),
                                                                                                       ('t2', 200000, 2000000, interval '6 years', 11),
                                                                                                       ('t3', 300000, 3000000, interval '7 years', 12),
                                                                                                       ('t4', 400000, 4000000, interval '8 years', 13),
                                                                                                       ('t5', 500000, 5000000, interval '9 years', 14);

-- insert into payments (amount, type_of_payment, credit_id) VALUES ()