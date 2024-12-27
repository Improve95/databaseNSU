/*
вопросы:
я сделал так, чтобы штрафы стали как расписание выплат, но:
стоит ли хранить дату выставления штрафа, тогда
придется хранить и дату выставления оплаты, хотя вот она уже и не нужна
теперь придется хранить сумму платежа
еще нужно хранить тип записи - штраф это или ежемесячный платеж
*/

drop table if exists penalties;

alter table payments_schedule rename column up_to_payment_date to deadline;

alter table payments_schedule add column amount numeric(15, 2) not null check ( amount > 0 );
/*with credits_table as (
    select id, month_amount from credits
) update payments_schedule ps set amount = (select ct.month_amount from credits_table ct
where ps.credit_id = ct.id);
alter table payments_schedule alter column amount drop default ;*/

alter table balances drop column id;
alter table balances drop column remaining_debt;

alter table payments drop column id;