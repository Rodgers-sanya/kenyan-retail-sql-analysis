             -- KENYAN RETAIL SALES ANALYTICS PROJECT
             -- 30 REAL WORLD BUSINESS QUESTIONS
             
 -- LEVEL 1- BEGINNER 
 -- (A).CUSTOMER ANALYSIS
use retail_analysis;
show tables;
 select * from customers;
 select * from order_details;
 select * from orders;
 select * from products;
 
 -- 1.How many customers does the business have in each city?
 
 select city, count(*) as no_of_customers_in_city
 from customers
 group by city;
 
 -- 2.What is the distribution of customers by gender?
 
select gender,
count(*) as count_based_on_gender,
round(count(*)*100/(select count(*) from customers),2) as 'percentage_%'
from customers
group by gender;

-- 3.How many new customers registered in each year?

select year(registration_date),
count(*) 
from customers
group by year(registration_date);

-- 4.Which cities have the largest customer bases?

select city,
count(*) as largest_customer_bases
from customers
group by city
order by largest_customer_bases desc
limit 5;


-- 5.How many customers registered in each month?

select monthname(registration_date),
count(*) as no_of_customers
from customers
group by monthname(registration_date);


  -- (B).PRODUCT ANALYSIS
-- 6.How many products are available in each product category?

select category,
count(*)
from products
group by category;


-- 7.What are the minimum, maximum, and average product prices for each category?

select category,
min(price) as min_price,
max(price) as max_price,
round(avg(price),2) as average_price 
from products
group by category;

-- 8.Which 10 products have the highest selling prices?

select product_name,sum(price) as selling_price
from products
group by product_name
order by selling_price desc
limit 10;

-- 9.What is the average product price across the entire product catalog?

select avg(price)
from products;


-- 10.Which product categories have an average price above KSh 10,000?

select category,
avg(price) as avg_price 
from products
group by category
having avg_price>10000
order by avg_price desc;


  -- LEVEL 2. INTERMEDIATE
  -- SALES PERFOMANCE
-- 11.What is the total revenue generated from completed orders?

select 
sum(price*quantity) as total_revenue
from order_details as od
join products as pr
on pr.product_id = od.product_id
join orders as odd
on odd.order_id=od.order_id
where  order_status = "completed";


-- 12.How much revenue did the business generate in each month?

select monthname(registration_date),
sum(price*quantity) as total_revenue_per_month
from order_details as od
join products as pr
on pr.product_id = od.product_id
join orders as odd
on odd.order_id=od.order_id
join customers as cu
on cu.customer_id=odd.customer_id
where  order_status = "completed"
group by monthname(registration_date);

-- 13.How did total revenue change between 2024 and 2025?
select  
round(sum(
case when year(registration_date)=2024 then (price*quantity) else 0
end),2)as 2024_revenue,
round(sum(
case when year(registration_date)=2025 then (price*quantity) else 0
end),2)as 2025_revenue,(
   round(sum(
case when year(registration_date)=2025 then (price*quantity) else 0
end),2)-round(sum(
case when year(registration_date)=2024 then (price*quantity) else 0
end),2)
) as revenue_difference
from order_details as od
join products as pr
on pr.product_id = od.product_id
join orders as odd
on odd.order_id=od.order_id
join customers as cu
on cu.customer_id=odd.customer_id
where  order_status = "completed";


-- 14.How much revenue did each product category generate?
select * from products;
select * from customers;
select * from order_details;
select * from orders;

select category,
sum(price*quantity) as revenue_per_category
from order_details as od
join products as pr
on pr.product_id = od.product_id
join orders as odd
on odd.order_id=od.order_id
where  order_status = "completed"
group by category;

-- 15.Which 10 products generated the highest revenue?
select product_name,
sum(price*quantity) as revenue_per_product
from order_details as od
join products as pr
on pr.product_id = od.product_id
join orders as odd
on odd.order_id=od.order_id
where  order_status = "completed"
group by product_name
order by revenue_per_product desc
limit 10;


    -- (C).CUSTOMERS BEHAVIOURS
-- 16.How much has each customer spent on completed orders?
select cu.customer_id,
cu.first_name,
cu.last_name,
sum(price*quantity) as spent_on_completed_order
from customers as cu
join orders as od 
on od.customer_id = cu.customer_id
join order_details as odd
on odd.order_id = od.order_id
join products as pr
on pr.product_id=odd.product_id
where od.order_status = "completed"
group by cu.customer_id,
cu.first_name,
cu.last_name;


-- 17.Which 20 customers have generated the highest revenue?

select cu.customer_id,
cu.first_name,
cu.last_name,
sum(price*quantity) as spent_on_completed_order
from customers as cu
join orders as od 
on od.customer_id = cu.customer_id
join order_details as odd
on odd.order_id = od.order_id
join products as pr
on pr.product_id=odd.product_id
where od.order_status = "completed"
group by cu.customer_id,
cu.first_name,
cu.last_name
order by spent_on_completed_order desc
limit 20;


-- 18.What is the average amount spent per customer?
select cu.customer_id,
cu.first_name,
cu.last_name,
avg(price*quantity) as avg_spent_on_completed_order
from customers as cu
join orders as od 
on od.customer_id = cu.customer_id
join order_details as odd
on odd.order_id = od.order_id
join products as pr
on pr.product_id=odd.product_id
where od.order_status = "completed"
group by cu.customer_id,
cu.first_name,
cu.last_name;


-- 19.How many orders has each customer placed?
select cu.customer_id,
cu.first_name,
cu.last_name,
count(*) as no_of_orders
from customers as cu
join orders as ord
on ord.customer_id = cu.customer_id
group by
cu.customer_id,
cu.first_name,
cu.last_name;

-- 20.How many customers have placed more than one completed order?
select cu.customer_id,
cu.first_name,
cu.last_name,
count(*) as no_of_orders
from customers as cu
join orders as ord
on ord.customer_id = cu.customer_id
where order_status = "completed"
group by
cu.customer_id,
cu.first_name,
cu.last_name
having count(*)!=1;


    -- LEVEL 3. ADVANCED
-- 21.How much revenue has each salesperson generated from completed orders?

select odd.salesperson,
sum(price*quantity) as revenue_per_salesperson
from products as pr
join order_details as od
on od.product_id=pr.product_id
join orders as odd
on odd.order_id=od.order_id
group by odd.salesperson;


-- 22.Rank salespeople according to their total revenue.
select odd.salesperson,
sum(price*quantity) as revenue_per_salesperson,
rank() over(order by sum(price*quantity) desc ) as rank_revenue
from products as pr
join order_details as od
on od.product_id=pr.product_id
join orders as odd
on odd.order_id=od.order_id
group by odd.salesperson;
 

-- 23. What is the average order value handled by each salesperson?

select salesperson,
avg(price*quantity) as avg_order_value
from orders as od
join order_details as odd
on odd.order_id=od.order_id
join products as pr
on pr.product_id = odd.product_id
group by salesperson;


-- 24.What percentage of total completed revenue was generated by each salesperson?

select salesperson,
sum(price*quantity) as total_order_value,
round(sum(price*quantity)/(select sum(price*quantity)
from products as pr
join order_details as os
on os.product_id = pr.product_id
join orders as od
on od.order_id=os.order_id
where order_status = "completed"
)*100,2) as percentage_total
from orders as od
join order_details as odd
on odd.order_id=od.order_id
join products as pr
on pr.product_id = odd.product_id
where order_status = "completed"
group by salesperson;




   -- ADVANCED CUSTOMERS ANALYTICS 
-- 25.Rank all customers according to their total spending.
-- Your final result should show: 
-- (i)Customer name,
-- (ii)City
-- (iii)Number of orders
-- (iv)Total quantity purchased
-- (v)Total spending
-- (vi)Customer rank

select cu.first_name,
cu.last_name,
cu.city,
count(od.order_status) as number_of_orders,
sum(odd.quantity) as total_quantity_purchased,
sum(pr.price * odd.quantity) as total_spendings,
rank() over(order by sum(pr.price * odd.quantity) desc) as customer_rank
from customers as cu
join orders as od
on od.customer_id = cu.customer_id
join order_details as odd
on odd.order_id=od.order_id
join products as pr
on pr.product_id = odd.product_id
where order_status = "completed"
group by
cu.first_name,
cu.last_name,
cu.city;



-- 26.Create three customer segments based on their total spending:
-- High Value
-- Medium Value
-- Low Value
-- Determine reasonable thresholds from the data and explain the business logic behind your thresholds.


-- (total spending >350000 -high value,total spending <100000- medium value else -low value )
select cu.first_name,
cu.last_name,
sum(price * quantity) as total_spending,
case
     when sum(price * quantity)>350000 then "high value"
     when sum(price * quantity)>100000 then "medium value"
     else "low value"
end as spending_segments
from customers as cu
join orders as od
on od.customer_id = cu.customer_id
join order_details as odd
on odd.order_id=od.order_id
join products as pr
on pr.product_id = odd.product_id
where order_status = "completed"
group by cu.first_name,
cu.last_name;



-- 27.For every product category, identify the product that generated the highest revenue.
-- Your result should allow management to answer:
-- "What is our best-performing product within each category?"

with cte_example as(
select category,
product_name,
sum(price*quantity) as total_revenue,
rank() over(partition by category order by sum(price*quantity) desc) as rank_per_category
from products as pr
join order_details as od
on od.product_id = pr.product_id
join orders as os
on os.order_id=od.order_id
where order_status="completed"
group by category,product_name
)
select *
from cte_example
where rank_per_category=1;


-- 28.Compare the performance of:(i)Store,(ii)Online,(iii)WhatsApp
-- Determine:Total orders,Total revenue,Average order value,Number of customers for each channel.
select sales_channel,
count(distinct os.order_id) as total_order,
sum(price*quantity) as Total_revenue,
 sum(price*quantity)/count(distinct os.order_id) as avg_order_value,
count(distinct cu.customer_id)
from products as pr
join order_details as od 
on od.product_id = pr.product_id
join orders as os
on os.order_id = od.order_id
join customers as cu
on cu.customer_id = os.customer_id
where order_status = "completed"
group by sales_channel;


-- 29.Analyze the performance of:(i)M-Pesa,(ii)Card,(iii)Cash,(iv)Bank Transfer
-- Determine:Number of orders,Revenue,Average order value,Revenue contribution percentage
-- Then investigate whether customer purchasing behaviour differs across payment methods.

select payment_method,
count(distinct od.order_id) as no_of_orders,
sum(price*quantity) as revenue,
sum(price*quantity)/count(distinct od.order_id) as average_order_value,
round(sum(price*quantity)/(select sum(price*quantity) 
from products as pt
join order_details as dl
on dl.product_id=pt.product_id
join orders as oe
on oe.order_id=dl.order_id
where order_status="completed"
)*100,2) as revenue_percentage
from products as pr
join order_details as od 
on od.product_id = pr.product_id
join orders as os
on os.order_id = od.order_id
join customers as cu
on cu.customer_id = os.customer_id
where os.order_status = "completed"
group by payment_method;


	   
