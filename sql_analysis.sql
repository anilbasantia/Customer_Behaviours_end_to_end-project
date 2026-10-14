select * from customers
-----Q1 What is total revenue generate by male vs female customers
select gender ,sum(purchase_amount) as total_revenue from customers
group by gender
-----Q2 Which customers use discount but still spent more than money from average  purchase amount
select customer_id,purchase_amount from customers
where discount_applied ='Yes' and purchase_amount >= (select avg(purchase_amount) from customers)
-----Q3 Which are the top 5 product with average rating
select item_purchased,round(avg(review_rating::numeric),2) as average_rating_product from customers
group by item_purchased
order by average_rating_product desc
limit 5
-----Q4 Compare average purchase amount between standard and express
select shipping_type,round(avg(purchase_amount),2)as compare from customers
where shipping_type in ('Express','Standard')
group by shipping_type
-----Q5 Do subscriber spend more ? Compare average spend and total revenue between do subscriber and non-subscriber
select 
subscription_status,
count(customer_id)as total_customers,
round(avg(purchase_amount),2)as avg_spend,
round(sum(purchase_amount),2)as total_spend
from customers 
group by subscription_status
order by total_spend,avg_spend desc
------Q6 Which top 5 products have highest percentage purchase applied percentage
select item_purchased,
round(100*sum(case when discount_applied ='Yes' then 1 else 0 end )/count(*),2) 
as discount_rate 
from customers 
group by item_purchased
order by discount_rate desc
limit 5
-----Q7 segment customers new returnnin and loyal based on previous purchase and count segment  customers 
with customers_type as(
select case when previous_purchases = 1 then 'New'
when previous_purchases  between 2 and 10 then 'Returnning'
else 'Loyal'  end as customer_segment from customers)

select customer_segment,count(*) as number_of_customer from customers_type
group by customer_segment
-----Q8 What are the top 3 product in a each category
with item_counts as(
select category,item_purchased,count(customer_id)as total_orders,
row_number() over(partition by category order by count(customer_id) desc) as item_rank 
from customers
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders from item_counts
where item_rank<=3
-----Q9 Are customers who repeat buyers(more than 5 previous purchase)aslo like to subscribers ?
select subscription_status,count(customer_id)as repeat_buyers  from customers
where previous_purchases >5
group by subscription_status
------Q10 What is the revenue contribution of each age group
select age_group,sum(purchase_amount) as age_by_revenue from customers
group by age_group
order by age_by_revenue desc

