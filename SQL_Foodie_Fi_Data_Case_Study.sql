---------- FOODIE_FI CASE STUDY ----------

use Foodie_Fi

select * from plans
select * from subscriptions


---------- Data Analysis Questions ----------


--Q1. How many customers has Foodie-Fi ever had?

select count(distinct customer_id) as customer_count
from subscriptions

--Q2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value.

select month(b.start_date) months, DATENAME(MONTH, b.start_date) month_name,
count(b.customer_id) customer_count from plans a
left join subscriptions b
on a.plan_id = b.plan_id
where a.plan_name = 'trial'
group by month(b.start_date), DATENAME(MONTH, b.start_date)
order by 1

