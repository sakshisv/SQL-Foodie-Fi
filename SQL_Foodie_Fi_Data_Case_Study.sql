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

--Q3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name.

select a.plan_name, count(*) count_of_events from plans a
left join subscriptions b
on a.plan_id = b.plan_id
where YEAR(b.start_date) > '2020'
group by a.plan_name
order by 2

