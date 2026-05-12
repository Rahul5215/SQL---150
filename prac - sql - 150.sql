select * from customers

select * from products

select * from orders

select * from order_items

select * from payments

select * from user_activity

--1. BASIC TO INTERMEDIATE
--Filtering & Aggregation

--1.Find total customers.
select distinct count(customer_id) as total_customers from customers

--2.Find customers from Mumbai.
select customer_id, customer_name from customers where city = 'Mumbai'

--3.Find total revenue.
select sum(amount) as total_revenue from payments

--4.Find total orders per customer.
select 
c.customer_id,
c.customer_name,
count(o.order_id) as total_orders
from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_id
order by c.customer_id

--5.Find average order value.
select sum(amount) / count(order_id) as avg_order_value from payments

--6.Find highest order amount.
select amount from payments order by amount desc limit 1

--7.Find category-wise revenue.
select
distinct 
category
from products

--8.Find monthly revenue.
select 
to_char(payment_date,'Mon') as month,
sum(amount) as monthly_revenue
from payments 
group by month 
order by month

--9.Find customers with more than 2 orders.
select 
c.customer_id,
c.customer_name,
count(o.order_id) as total_orders
from customers c
left join orders o
on c.customer_id = o.customer_id
group by c.customer_id
having count(o.order_id) > 2

--10.Find products never ordered.
select
product_id
from products 
where product_id not in (select distinct product_id from order_items)


--2. JOINS
--11.Get customer name with order details.
select 
o.customer_id,
c.customer_name,
o.order_date,
o.status
from orders o 
left join customers c
on c.customer_id = o.customer_id
order by o.customer_id

--12.Get product names for each order.
select 
oi.order_id,
oi.product_id,
p.product_name,
oi.quantity
from order_items oi
left join products p
on p.product_id = oi.product_id
order by oi.order_id

--13.Find customers who never ordered.
select
customer_id
from customers
where customer_id not in (select distinct customer_id from orders)

select
c.customer_id
from customers c
left join orders o
on c.customer_id = o.customer_id
where o.customer_id is null

--14.Find orders without payment.
select
o.order_id
from orders o
left join payments p
on o.order_id = p.order_id
where p.order_id is null

--15.Find products purchased by Rahul.
select
oi.order_id,
o.customer_id,
c.customer_name,
p.product_name
from order_items oi
left join orders o
on o.order_id = oi.order_id
left join customers c
on c.customer_id = o.customer_id 
left join products p
on p.product_id = oi.product_id
where c.customer_name = 'Rahul'

--16.Find customers who bought Electronics products.
select
distinct
c.customer_name
from order_items oi
left join orders o
on o.order_id = oi.order_id
left join customers c
on c.customer_id = o.customer_id 
left join products p
on p.product_id = oi.product_id
where p.category = 'Electronics'

--17.Find revenue generated per city.
select
c.city,
sum(amount) as total_revenue
from customers c
left join orders o
on o.customer_id = c.customer_id
left join payments p
on o.order_id = p.order_id
group by c.city

--18.Find customers who bought more than one category.
select
c.customer_name,
count(distinct p.category) as count_of_category_bought
from customers c
left join orders o
on c.customer_id = o.customer_id
left join order_items oi
on oi.order_id = o.order_id
left join products p
on p.product_id = oi.product_id
group by customer_name
having count(distinct p.category) > 1

--19.Find orders containing multiple products.
select
o.order_id,
count(oi.product_id) as count_of_products
from orders o
left join order_items oi
on o.order_id = oi.order_id
group by o.order_id
having count(oi.product_id) > 1

--20.Find customers who ordered in both June and July.
select
distinct
o.customer_id,
c.customer_name
from orders o
left join customers c
on o.customer_id = c.customer_id
where trim(to_char(order_date, 'Month')) in  ('June','July')

--3. SUBQUERIES
--21.Find second highest salary.
select
salary
from employees e
where salary not in (select salary from employees order by salary desc limit 1)
order by salary desc limit 1

--22.Find employees earning above average salary.
select
emp_id,
emp_name,
salary
from employees 
where salary > (select avg(salary) from employees)

--23.Find highest paid employee per department.
select
department,
emp_name
from employees
where emp_id in (
select department
from employees 
group by department
order by salary desc limit 1
)

--24.Find products priced above average product price.
select
product_name,
price
from products
where price > (select avg(price) from products)

--25.Find customers whose spending is above average.
select
c.customer_id,
c.customer_name,
sum(p.amount) as total_spending
from customers c
left join orders o
on c.customer_id = o.customer_id
left join payments p
on p.order_id = o.order_id
group by c.customer_id, c.customer_name
where total_spending > (
select avg(sum(p.amount)) 
from customers c
left join orders o
on c.customer_id = o.customer_id
left join payments p
on p.order_id = o.order_id 
)


--26.Find orders with value greater than average order value
select
order_id,
amount
from payments 
where amount > (select sum(amount) / count(order_id) from payments )

--27.Find employees whose manager earns less than them.
select
emp_id,
emp_name
from employees 
where salary > (select )

select * from employees

select 
emp_id 
where salary > 
select
emp_id as manager_id,
salary
from employees
where emp_id in (
select
distinct
manager_id
from employees
where manager_id is not null
)



--28.Find customers who spent more than Rahul.
select
c.customer_id,
c.customer_name,
sum(p.amount) as total_spending
from customers c
left join orders o
on c.customer_id = o.customer_id
left join payments p
on p.order_id = o.order_id
group by c.customer_id, c.customer_name
having sum(p.amount) > (
select
sum(p.amount) as total_spending
from customers c
left join orders o
on c.customer_id = o.customer_id
left join payments p
on p.order_id = o.order_id
where c.customer_name = 'Rahul'
group by c.customer_id, c.customer_name 
)

--29.Find products with highest quantity sold.
select
p.product_name,
sum(oi.quantity) as quantity_sold
from products p
left join order_items oi
on p.product_id = oi.product_id
group by p.product_name
order by quantity_sold desc limit 1

--30.Find departments with average salary above 65000.
select
department,
sum(salary) / count(emp_id) as avg_salary
from employees
group by department
having sum(salary) / count(emp_id)  > 65000







--4. CTEs
--Find monthly revenue using CTE.
with date_range as (
select
date_trunc('month',min(payment_date)) as start_date,
date_trunc('month',max(payment_date)) as end_date
from payments
),
date_table as (
select
cast(generate_series(start_date, end_date, interval '1 month') as date) as date
from date_range
)
select
to_char(d.date,'Mon yyyy') as month,
sum(p.amount) as monthly_revenue
from date_table d
left join payments p
on d.date = date_trunc('month',p.payment_date)
group by month


--Find cumulative revenue using CTE.
with date_range as (
select
date_trunc('month',min(payment_date)) as start_date,
date_trunc('month',max(payment_date)) as end_date
from payments
),
date_table as (
select
cast(generate_series(start_date, end_date, interval '1 month') as date) as date
from date_range
),
monthly_revenue as (
select
to_char(d.date,'Mon yyyy') as month,
sum(p.amount) as monthly_revenue
from date_table d
left join payments p
on d.date = date_trunc('month',p.payment_date)
group by month
)
select
month,
monthly_revenue,
sum(monthly_revenue) over(order by month) as cumulative_revenue
from monthly_revenue

--Find customers with consecutive monthly orders.
with cte as(
select
customer_id,
order_date
from orders
),
cte2 as (
select
customer_id,
order_date,
lag(order_date) over(partition by customer_id order by order_date) as prev_month
from cte
)
select 
*,
case when prev_month is not null then customer_id end as retained_customers
from cte2










--Find top customer per month.
with date_range as (
select
date_trunc('month',min(payment_date)) as start_date,
date_trunc('month',max(payment_date)) as end_date
from payments
),
date_table as (
select
cast(generate_series(start_date, end_date, interval '1 month') as date) as date
from date_range
),
monthly_customer_revenue as (
select 
d.date as month,
o.customer_id,
sum(p.amount) as revenue
from date_table d
left join payments p
on d.date = date_trunc('month',p.payment_date)
left join orders o
on p.order_id = o.order_id
group by d.date,o.customer_id
),
ranking_customers as (
select
month,
customer_id,
revenue,
dense_rank() over(partition by month order by revenue desc) as ranking
from monthly_customer_revenue
)
select
month,
customer_id,
revenue
from ranking_customers
where ranking = 1







select * from payments



--Find revenue contribution percentage.
with products_revenue as (
select 
p.product_name,
sum(py.amount) as total_products_revenue
from payments py
left join orders o
on o.order_id = py.order_id
left join order_items oi
on o.order_id = oi.order_id
left join products p
on p.product_id = oi.product_id
group by p.product_name
)
,total_revenue as (
select
product_name,
total_products_revenue,
sum(total_products_revenue) over() as total_revenue
from products_revenue
)
select
product_name,
total_products_revenue,
round((total_products_revenue *100/ total_revenue),2) as revenue_contribution
from total_revenue

--Find category growth month-over-month.
with category_revenue as (
select
cast(date_trunc('month',o.order_date)as date) as order_month,
p.category,
sum(py.amount) as total_revenue
from payments py
left join orders o
on py.order_id = o.order_id
left join order_items oi
on oi.order_id = o.order_id
left join products p
on p.product_id = oi.product_id
group by p.category, o.order_date
),
cte as (
select
category,
order_month,
total_revenue,
lag(order_month) over(partition by category) as previous_month
from category_revenue
),
prev_month_revenue as(
select
category,
order_month,
total_revenue,
previous_month,
lag(total_revenue) over(partition by category) as prev_month_revenue
from cte
)
select
category,
to_char(order_month,'Mon yyyy') as current_month,
total_revenue,
to_char(previous_month,'Mon yyyy') as previous_month,
prev_month_revenue,
round(((total_revenue - prev_month_revenue) / prev_month_revenue)*100,2) as growth_rate
from prev_month_revenue
order by category, order_month


--Find customer retention month-wise.
with cte as (
select
distinct customer_id,
cast(date_trunc('month',order_date)as date) as month
from orders
),
cte2 as (
select
customer_id,
month,
lag(month) over(partition by customer_id) as prev_month
from cte
),
cte3 as (
select
customer_id,
month,
prev_month,
case when prev_month = month - interval '1 month' then customer_id end as retained_customers
from cte2
)
select
to_char(month,'Mon yyyy') as months,
count(distinct retained_customers) as total_retained_customers
from cte3
group by month

--Find inactive customers.
with cte as (
select
customer_id,
max(order_date) as last_purchase
from orders
group by customer_id
),
cte2 as (
select
customer_id,
last_purchase,
(extract(year from age(current_date,last_purchase))*12) + extract(month from age(current_date,last_purchase)) as diff
from cte 
)
select
customer_id
from cte2
where diff > 12

--Find reactivated customers.
with cte as(
select
customer_id,
order_date,
row_number() over(partition by customer_id order by order_date desc) as ranking
from orders
),
last_order_date as(
select
customer_id,
order_date
from cte
where ranking = 1
),
previous_order_date as (
select
customer_id,
order_date
from cte
where ranking = 2
),
interval_month as (
select
l.customer_id,
l.order_date as last_order_date,
p.order_date as previous_order_date,
(extract(year from age(l.order_date,p.order_date))*12) + extract(month from age(l.order_date,p.order_date)) as diff
from last_order_date l
join previous_order_date p
on l.customer_id = p.customer_id
)
select
customer_id
from interval_month
where diff > 1

--Find customer first and latest purchase.
select
customer_id,
min(order_date) as first_purchase,
max(order_date) as latest_purchase
from orders
group by customer_id
order by customer_id


--5. WINDOW FUNCTIONS
--Rank customers by revenue.
with customer_revenue as (
select
o.customer_id,
sum(py.amount) as total_revenue
from payments py
left join orders o
on o.order_id = py.order_id
group by o.customer_id
)
select
customer_id,
total_revenue,
dense_rank() over(order by total_revenue desc) as revenue_ranking
from customer_revenue

--Dense rank employees by salary.
select
emp_id,
salary,
dense_rank() over(order by salary desc) as salary_ranking
from employees

--Find top 3 highest revenue customers.
with customer_revenue as (
select
o.customer_id,
sum(py.amount) as total_revenue
from payments py
left join orders o
on o.order_id = py.order_id
group by o.customer_id
),
customer_revenue_ranking as (
select
customer_id,
total_revenue,
dense_rank() over(order by total_revenue desc) as revenue_ranking
from customer_revenue
)
select
customer_id,
total_revenue
from customer_revenue_ranking
where revenue_ranking <= 3
order by revenue_ranking

--Find running total revenue.
with mothly_revenue as (
select
cast(date_trunc('month',o.order_date)as date) as months,
sum(py.amount) as total_revenue
from payments py
left join orders o
on o.order_id = py.order_id
group by months
)
select
to_char(months,'Mon yyyy') as month,
total_revenue,
sum(total_revenue) over(order by months) as rolling_revenue
from mothly_revenue

--Find moving average revenue.
with mothly_revenue as (
select
cast(date_trunc('month',o.order_date)as date) as months,
sum(py.amount) as total_revenue
from payments py
left join orders o
on o.order_id = py.order_id
group by months
)
select
to_char(months,'Mon yyyy') as months,
total_revenue,
round(avg(total_revenue) over(order by months rows between 1 preceding and current row),2) as moving_avg
from mothly_revenue

--Find previous month revenue.
with mothly_revenue as (
select
cast(date_trunc('month',o.order_date)as date) as months,
sum(py.amount) as total_revenue
from payments py
left join orders o
on o.order_id = py.order_id
group by months
)
select
months,
total_revenue,
lag(months) over() as prev_month,
lag(total_revenue) over(order by months) as prev_month_revenue
from mothly_revenue

--Find month-over-month growth.
with mothly_revenue as (
select
cast(date_trunc('month',o.order_date)as date) as months,
sum(py.amount) as total_revenue
from payments py
left join orders o
on o.order_id = py.order_id
group by months
),
prev_monthly_revenue as (
select
months,
total_revenue,
lag(months) over() as prev_month,
lag(total_revenue,1,total_revenue) over(order by months) as prev_month_revenue
from mothly_revenue
)
select
months,
total_revenue,
round(((total_revenue - prev_month_revenue) / prev_month_revenue)*100,2) as revenue_growth_rate
from prev_monthly_revenue

--Compare current order with previous order.
select
o.order_id,
py.amount as revenue,
lag(o.order_id) over(order by o.order_date) as prev_order_id,
lag(py.amount) over(order by o.order_date) as prev_order_revenue
from payments py
left join orders o
on o.order_id = py.order_id

--Find difference between consecutive salaries.


--Find first order per customer.
with cte as (
select
o.customer_id,
o.order_id,
py.amount as order_amount,
row_number() over(partition by o.customer_id order by o.order_date) as ranking
from payments py
left join orders o
on py.order_id = o.order_id
)
select
customer_id,
order_id,
order_amount
from cte
where ranking = 1

--Find latest order per customer.
with cte as (
select
o.customer_id,
o.order_id,
py.amount as order_amount,
row_number() over(partition by o.customer_id order by o.order_date desc) as ranking
from payments py
left join orders o
on py.order_id = o.order_id
)
select
customer_id,
order_id,
order_amount
from cte
where ranking = 1

--Find duplicate transactions using ROW_NUMBER.
with cte as(
select
*,
row_number() over(partition by payment_id order by payment_date) as ranking
from payments
)
select
*
from cte
where ranking > 1

--Find consecutive login/activity days.
select * from orders

--Find longest purchase streak.
with cte as(
select
order_id,
customer_id,
cast(date_trunc('month',order_date)as date) as months,
status
from orders
),
cte2 as (
select
order_id,
customer_id,
months,
status,
row_number() over(partition by customer_id,months order by customer_id,months) as ranking
from cte
),
cte3 as (
select
order_id,
customer_id,
months,
status,
max(ranking) over(partition by customer_id)
from cte2
)
select
*
from cte3
order 


--Find top product per category.

6. DATE & TIME PROBLEMS
--Generate monthly date series.
with date_range as(
select
date_trunc('month',min(order_date)) as start_date,
date_trunc('month',max(order_date)) as end_date
from orders
)
select
cast(generate_series(start_date,end_date,interval '1 day')as date) as date
from date_range

--Fill missing revenue dates.
with date_range as(
select
min(order_date) as start_date,
max(order_date) as end_date
from orders
),
date_table as(
select
cast(generate_series(start_date,end_date,interval '1 day')as date) as date
from date_range
)
select
d.date,
py.*
from date_table d
left join payments py
on d.date = py.payment_date

--Find days with no orders.
with date_range as(
select
min(order_date) as start_date,
max(order_date) as end_date
from orders
),
date_table as(
select
cast(generate_series(start_date,end_date,interval '1 day')as date) as date
from date_range
)
select
d.date,
py.*
from date_table d
left join payments py
on d.date = py.payment_date
where py.payment_id is null

--Find customers inactive for 30+ days.
select
customer_id,
max(order_date) as last_order_date,
age(current_date,max(order_date))
from orders
group by customer_id
having age(current_date,max(order_date)) > '30 days'

--Find average days between orders.
with cte as(
select
order_id,
order_date,
lead(order_date) over() as next_date
from orders 
),
final_cte as (
select 
order_id,
order_date,
(next_date - order_date) as diff
from cte
where next_date is not null
)
select
round(avg(diff),2) as avg_days_btw_orders
from final_cte

--Find repeat purchase within 7 days.
with cte as(
select
*,
lead(order_date) over(partition by customer_id order by order_date) as next_order
from orders
),
final_cte as (
select
*,
(next_order - order_date) as diff
from cte
where next_order is not null
)
select
*
from final_cte
where diff <= 7

--Find first purchase month.
select
to_char(min(order_date),'Month') as first_purchase_month
from orders

--Find retention after first purchase.
with cte as (
select
customer_id,
order_date,
min(order_date) over(partition by customer_id) as first_purchase,
lead(order_date) over(partition by customer_id order by order_date) as next_purchase,
row_number() over(partition by customer_id order by order_date) as ranking
from orders
),
retained_customer_after_fp as (
select
customer_id,
order_date,
first_purchase,
next_purchase
from cte 
where ranking = 1 and next_purchase is not null
)
select
*,
(next_purchase - first_purchase) as retention_days
from retained_customer_after_fp

--Find orders placed on weekends.


--Find busiest ordering day.
with cte as (
select
trim(to_char(order_date,'day')) as days,
count(order_id) as total_orders
from orders
group by days 
),
cte2 as(
select
*,
dense_rank() over(order by total_orders desc) as ranking
from cte
)
select
days,
total_orders
from cte2
where ranking = 1

--7. GAP & ISLAND PROBLEMS


--Find consecutive order streaks.
with cte as (
select
customer_id,
order_date,
row_number() over(partition by customer_id order by order_date) as rn
from orders
),
cte2 as(
select
customer_id,
order_date,
order_date - (rn * interval '1 day') as streak_id
from cte
)
select
customer_id,
streak_id::date,
min(order_date) as streak_start,
max(order_date) as streak_end,
count(*) as streak_lenght
from cte2
group by customer_id, streak_id
order by customer_id, streak_id

--Find missing dates in orders for each customers.
with date_range as(
select
customer_id,
min(order_date) as first_purchase,
max(order_date) as last_purchase
from orders
group by customer_id
),
customer_date_table as (
select
customer_id,
cast(generate_series(first_purchase,last_purchase,interval '1 day')as date) as date
from date_range
)
select
c.customer_id,
c.date
from customer_date_table c
left join orders o
on c.customer_id = o.customer_id
and c.date = o.order_date
where o.order_date is null
order by c.customer_id

--Merge continuous order ranges.
with cte as (
select
customer_id,
order_date,
row_number() over(partition by customer_id order by order_date) as rn
from orders
),
cte2 as (
select
customer_id,
order_date,
order_date - (rn * interval '1 day') as streak_id
from cte
)
select
customer_id,
min(order_date) as streak_start,
max(order_date) as streak_end
from cte2
group by customer_id, streak_id

--Find longest inactivity streak.
with cte as (
select
customer_id,
order_date,
lead(order_date) over(partition by customer_id order by order_date) as next_order_date
from orders
),
inactivity_days as (
select
customer_id,
order_date,
next_order_date,
case when next_order_date is null then (current_date - order_date) 
     else (next_order_date - order_date) 
	 end as inactivity_days
from cte
),
ranking_inactivity_days as (
select
*,
row_number() over(order by inactivity_days desc) as rn
from inactivity_days
)
select
customer_id,
order_date,
next_order_date,
inactivity_days
from ranking_inactivity_days
where rn = 1

--Find users active 3 consecutive days.
with cte as(
select
customer_id,
order_date,
row_number() over(partition by customer_id order by order_date) as rn
from orders
),
cte2 as (
select
customer_id,
order_date,
order_date - (rn * interval '1 day') as streak_id
from cte 
)
select
customer_id,
min(order_date) as streak_start,
max(order_date) as streak_end,
count(*) as streak_lenght
from cte2
group by customer_id, streak_id
having count(*) >= 3

--Find consecutive months with purchases.
with month_cus as(
select
customer_id,
cast(date_trunc('month',order_date)as date) as order_month
from orders
group by customer_id,order_month
),
cte as (
select
*,
row_number() over(partition by customer_id order by order_month) as rn
from month_cus
),
cte2 as (
select
customer_id,
order_month,
order_month - (rn * interval '1 month') as streak_id
from cte 
)
select
customer_id,
min(order_month) as streak_start,
max(order_month) as streak_end,
count(*) as streak_length
from cte2
group by customer_id, streak_id
order by customer_id, streak_id

--Find products sold continuously for 3 months.
with cte as (
select
p.product_name,
cast(date_trunc('month',o.order_date)as date) as order_month
from order_items oi
left join products p 
on p.product_id = oi.product_id
left join orders o
on oi.order_id = o.order_id
group by p.product_name, order_month
),
cte2 as (
select
*,
row_number() over(partition by product_name order by order_month) as rn
from cte
),
cte3 as (
select
product_name,
order_month,
order_month - (rn * interval '1 month') as streak_id
from cte2
)
select 
product_name,
min(order_month) as streak_start,
max(order_month) as streak_end,
count(*) as streak_length
from cte3
group by product_name, streak_id
order by product_name, streak_id

--Detect revenue drop streaks.
with monthly_revenue as (
select
cast(date_trunc('month', order_date) as date) as month,
sum(amount) as revenue
from orders o
join payments p on o.order_id = p.order_id
group by month
),
with_lag as (
select
month,
revenue,
lag(revenue) over(order by month) as prev_revenue
from monthly_revenue
),
flagged as (
select
month,
revenue,
prev_revenue,
case when revenue < prev_revenue then 1 else 0 end as is_drop
from with_lag
),
streaks as (
select
month,
revenue,
is_drop,
sum(case when is_drop = 0 then 1 else 0 end) over(order by month) as streak_id
from flagged
)
select
min(month) as streak_start,
max(month) as streak_end,
count(*) as streak_length,
first_value(revenue) over(partition by streak_id order by month) -
last_value(revenue)  over(partition by streak_id order by month) as total_drop
from streaks
where is_drop = 1
group by streak_id
having count(*) >= 2
order by streak_start

--Find islands of increasing revenue.


--Find continuous employee attendance periods.

select * from customers

select * from products

select * from orders

select * from order_items

select * from payments

select * from user_activity

--8. ADVANCED BUSINESS QUESTIONS
--Build customer lifetime value.
--Perform RFM analysis.
--Find churned customers.
--Find retained customers.
--Find repeat purchase rate.
--Find average basket size.
--Find highest revenue category per month.
--Find percentage contribution of top customers.
--Find Pareto 80/20 customers.
--Find customer segmentation by spending.
--Find conversion funnel drop-offs.
--Find daily active users.
--Find monthly active users.
--Find user growth rate.
--Find customer acquisition trend.

--9. HARD WINDOW + CTE QUESTIONS
--Find median salary.
--Find nth highest salary.
--Find cumulative percentage contribution.
--Find top customer contributing 50% revenue.
--Find rolling 3-month revenue.
--Find customers with increasing monthly spending.
--Detect anomalies in revenue.
--Find first time buyers every month.
--Find users ordering every month continuously.
--Find departments with salary growth.
