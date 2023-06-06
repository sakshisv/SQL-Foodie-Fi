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

--Q4. What is the customer count and percentage of customers who have churned rounded to 1 decimal place?

select count(distinct b.customer_id) customer_count, 
round(100.0 * count(b.customer_id)/ (select count(distinct customer_id) from subscriptions), 1) customer_pct 
from plans a
left join subscriptions b
on a.plan_id = b.plan_id
where a.plan_name = 'churn'

--Q5. How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

with ranking as (
select b.customer_id, a.plan_id, a.plan_name, ROW_NUMBER() over (partition by b.customer_id order by a.plan_id) as plan_rank
from plans a
left join subscriptions b
on a.plan_id = b.plan_id)

select count(distinct customer_id) churn_customers, 
round(100 * count(customer_id)/ (select count(distinct customer_id) from subscriptions), 1) churn_customer_pct 
from ranking
where plan_name = 'churn' and plan_rank = 2

--Q6. What is the number and percentage of customer plans after their initial free trial?

with next_plan as (
select customer_id, plan_id,
LEAD(plan_id, 1) over (partition by customer_id order by plan_id) as next_plan
from subscriptions)

select next_plan, count(*) as plan_conversions,
count(*) * 100/ (select count(distinct customer_id) from subscriptions) as plan_conversions_pct
from next_plan
where next_plan is not null and plan_id = 0
group by next_plan
order by next_plan

--Q7. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

with ranking as(
select *, RANK() over (partition by customer_id order by start_date desc) date_rank
from subscriptions
where start_date <= '2020-12-31')

select b.plan_name, count(a.plan_id) as customer_count,
CAST(count(a.plan_id) AS Float) * 100/(select count(customer_id) FROM ranking where date_rank = 1) as customer_pct
from ranking a
left join plans b
on a.plan_id = b.plan_id
where date_rank = 1
group by b.plan_name
order by 2 desc

--Q8. How many customers have upgraded to an annual plan in 2020?

select count(distinct b.customer_id)customer_count from plans a
left join subscriptions b
on a.plan_id = b.plan_id
where a.plan_name = 'pro annual' and YEAR(b.start_date) = '2020'

--Q9. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?



select avg(DAY(b.start_date)) avg_days from plans a
left join subscriptions b
on a.plan_id = b.plan_id
where a.plan_id > 0 and a.plan_id <= 3
















