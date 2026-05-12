select * from customers

select * from products

select * from orders

select * from order_items

select * from payments

select * from employees

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





select * from payments

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











Find revenue contribution percentage.
Find category growth month-over-month.
Find customer retention month-wise.
Find inactive customers.
Find reactivated customers.
Find customer first and latest purchase.
5. WINDOW FUNCTIONS
Rank customers by revenue.
Dense rank employees by salary.
Find top 3 highest revenue customers.
Find running total revenue.
Find moving average revenue.
Find previous month revenue.
Find month-over-month growth.
Compare current order with previous order.
Find difference between consecutive salaries.
Find first order per customer.
Find latest order per customer.
Find duplicate transactions using ROW_NUMBER.
Find consecutive login/activity days.
Find longest purchase streak.
Find top product per category.
6. DATE & TIME PROBLEMS
Generate monthly date series.
Fill missing revenue dates.
Find days with no orders.
Find customers inactive for 30+ days.
Find average days between orders.
Find repeat purchase within 7 days.
Find first purchase month.
Find retention after first purchase.
Find orders placed on weekends.
Find busiest ordering day.
7. GAP & ISLAND PROBLEMS
Find consecutive order streaks.
Find missing dates in orders.
Merge continuous order ranges.
Find longest inactivity streak.
Find users active 3 consecutive days.
Find consecutive months with purchases.
Find products sold continuously for 3 months.
Detect revenue drop streaks.
Find islands of increasing revenue.
Find continuous employee attendance periods.
8. ADVANCED BUSINESS QUESTIONS
Build customer lifetime value.
Perform RFM analysis.
Find churned customers.
Find retained customers.
Find repeat purchase rate.
Find average basket size.
Find highest revenue category per month.
Find percentage contribution of top customers.
Find Pareto 80/20 customers.
Find customer segmentation by spending.
Find conversion funnel drop-offs.
Find daily active users.
Find monthly active users.
Find user growth rate.
Find customer acquisition trend.
9. HARD WINDOW + CTE QUESTIONS
Find median salary.
Find nth highest salary.
Find cumulative percentage contribution.
Find top customer contributing 50% revenue.
Find rolling 3-month revenue.
Find customers with increasing monthly spending.
Detect anomalies in revenue.
Find first time buyers every month.
Find users ordering every month continuously.
Find departments with salary growth.
