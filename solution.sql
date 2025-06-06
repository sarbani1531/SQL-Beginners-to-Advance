-- Active: 1739904563235@@127.0.0.1@3306@local


SELECT * FROM credit_card_transcations LIMIT 10;

-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 

select city,sum(amount) spend,
round((sum(amount)/ (select sum(amount) from credit_card_transcations))* 100, 2) percentage_contribution
from credit_card_transcations 
group by city
order by spend desc
limit 5 ;


-- 2- write a query to print highest spend month and amount spent in that month for each card type
select  distinct month(transactions_date),card_type,
sum(amount) OVER(PARTITION BY month(transactions_date)) spend,
sum(amount) OVER(PARTITION BY month(transactions_date), card_type) type_spend 
from credit_card_transcations 
order by spend DESC;

-- 3- write a query to print the transaction details(all columns from the table) for each card type when
-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
-- 4- write a query to find city which had lowest percentage spend for gold card type
-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
-- 6- write a query to find percentage contribution of spends by females for each expense type
-- 7- which card and expense type combination saw highest month over month growth in Jan-2014
-- 8- during weekends which city has highest total spend to total no of transcations ratio 
-- 9- which city took least number of days to reach its 500th transaction after the first transaction in that city
