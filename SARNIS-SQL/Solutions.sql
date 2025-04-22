-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends
select city, sum(amount) spends ,
round((sum(amount) / (select sum(amount) from credit_card_transcations))*100, 2) percentage_contribution
from credit_card_transcations
GROUP BY city
ORDER BY spends desc
limit 5 ;
 
-- 2- write a query to print highest spend month and amount spent in that month for each card type
select monthname(transactions_date) month ,card_type, 
sum(amount) amount_spend
from credit_card_transcations 
group by month, card_type 
having month = 
			(select monthname(transactions_date) month
			from credit_card_transcations
			group by month
			order by sum(amount) desc limit 1);

-- 3- write a query to print the transaction details(all columns from the table) for each card type when
-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
with cte1 as (
		with cte as (
				select transaction_id,city,transactions_date,card_type,exp_type,gender,amount,
				sum(amount) over (PARTITION BY card_type ORDER BY transactions_date,transaction_id) cumsum
				from credit_card_transcations )
		select *,
		rank() over(PARTITION BY card_type ORDER BY cumsum) rn
		from cte where cumsum >= 1000000 )
select transaction_id,city,transactions_date,card_type,exp_type,gender,amount
from cte1 where rn = 1;


-- 4- write a query to find city which had lowest percentage spend for gold card type credit_card_transcations
with cte as (
	select city,card_type,
	round((sum(amount) over (PARTITION BY city, card_type ) / sum(amount) over (PARTITION BY city)) * 100, 2) percentage
	from credit_card_transcations )
select city,percentage FROM cte where card_type = "Gold"
ORDER BY percentage limit 1;

-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)

with cte1 as (with cte as(
select distinct city,exp_type,
sum(amount) over (PARTITION BY city, exp_type) spend
from credit_card_transcations )
select city,
case when ROW_NUMBER() over (PARTITION BY city ORDER BY spend ) = 1 then exp_type else Null end lower ,
case when ROW_NUMBER() over (PARTITION BY city ORDER BY spend desc ) = 1 then exp_type else Null end higher
from cte),
ctea as (select city,lower from cte1 where lower is not null ),
cteb as ( select city,higher from cte1 where higher is not null )
select ctea.city, ctea.lower, cteb.higher
from ctea inner join cteb on ctea.city = cteb.city ;

-- other solution

with cte1 as (
	with cte as (
		select DISTINCT city, exp_type, 
		sum(amount) over (PARTITION BY city, exp_type) spend
		from credit_card_transcations)
		select *,
		ROW_NUMBER() over (PARTITION BY city order by spend) low ,
		ROW_NUMBER() over (PARTITION BY city order by spend desc) high from cte ),
	ctelow as (
		select city,exp_type lowest_expense_type  from cte1 where low = (select min(low) from cte1)),
	ctehigh as (
		select city,exp_type highest_expense_type from cte1 where high = (select min(high) from cte1))
	select ctehigh.*, ctelow.lowest_expense_type 
    	from ctelow
	inner join ctehigh 
    	on ctelow.city = ctehigh.city ;


-- 6- write a query to find percentage contribution of spends by females for each expense type
with cte as
(select 
distinct exp_type,gender,
round((sum(amount) over (PARTITION BY exp_type,gender) / sum(amount) over (PARTITION BY exp_type) )*100) per
from credit_card_transcations )
select exp_type, per from cte where gender = "F";

-- 7- which card and expense type combination saw highest month over month growth in Jan-2014

with cte1 as (
	with cte as (
		select distinct card_type,exp_type,year(transactions_date) yr, month(transactions_date) mnt,
		sum(amount) over (PARTITION BY card_type,exp_type,year(transactions_date) , month(transactions_date)) exp
		from credit_card_transcations )
	select *,exp-lag(exp) over(PARTITION BY card_type,exp_type ORDER BY yr,mnt) dif
	from cte )
select card_type,exp_type from cte1 where yr = 2014 and mnt = 1 and dif>0
order by dif desc limit 1;

-- 8- during weekends which city has highest total spend to total no of transcations ratio 

with cte as (select distinct city, dayofweek(transactions_date) days, amount,
count(city) over(PARTITION BY city) cnt1
from credit_card_transcations )
select distinct city,
round(sum(amount) over(PARTITION BY city,days) / cnt1 , 2 ) ratio
 from cte where days in (6,7)
 order by ratio desc limit 1;


-- 9- which city took least number of days to reach its 500th transaction after the first transaction in that city

with cte as (select city,transactions_date,
ROW_NUMBER() over(PARTITION BY city ORDER BY city,transactions_date) rn
from credit_card_transcations),
ctea as (
select city, transactions_date initial from cte where rn = 1),
cteb as (
select city, transactions_date final from cte where rn = 500) 
select ctea.city,
datediff(final,initial) diff
from ctea
right join cteb
on ctea.city = cteb.city
ORDER BY diff limit 1 ;






