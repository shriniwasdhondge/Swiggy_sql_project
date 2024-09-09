create table delivery_partner(
partner_id int, 
partner_name varchar(15)
)




select * from orders


update orders
set restaurant_rating=3   --3.04
where restaurant_rating is null

select avg(restaurant_rating)
from orders

------------------------
---report & analysis
-------------------------

--Q1.write a query to find out most freuently order food by customers called Ankit 

select *
from user1 
where name='Ankit'

select order_id
from orders 
where user_id=4

select f_id 
from order_details 
where order_id=1016
	or order_id=1018
	or order_id=1019
	or order_id=1020
	or order_id=1017
	


----
select name, f_name,count(f_name)
from user1
inner join orders 
on user1.user_id=orders.user_id
inner join order_details on orders.order_id=order_details.order_id
inner join food on order_details.f_id=food.f_id
where name='Ankit'
group by  1,2


--limit 2
--joints in above question is very important 
--we need to joint table by each other to find out the result


--Q2 most order food by customers 

select f_name,count(f_name)
--dense_rank()over(order by f_name desc) as rank
from order_details
inner join food
on food.f_id=order_details.f_id
group by f_name
order by count(f_name) desc
limit 5

--restaurant revenue rating
--rank restaurant by their total revenue 
--result include their name and rankn within city

select  r_name,sum(amount)
from restaurants
inner join orders
on orders.r_id=restaurants.r_id
group by r_name
order by sum(amount) desc



select sum(amount)
from orders
group by r_id
order by sum(amount) desc



--Q3 ordered value analysis 
--list the customer who has spent more than 100k in total on food orders
--return their name and user id


select name,sum(amount) as total_spending ,avg(amount) as average_spending 
from user1 
inner join orders
on user1.user_id=orders.user_id
group by name 
order by sum(amount) desc
--limit 1

--Q4
--orders without delivery
--write a query to find out orders that are placed but not deliverd 
--return their name and user id

select name
from user1
inner join orders
on user1.user_id=orders.user_id
inner join  order_details
on order_details.order_id=orders.order_id
where delivery_status ='pending'
		or delivery_status='order cancel'


--Q5
--most popular dish by city

SELECT city, common_food, f_name, rank
FROM (
    SELECT DISTINCT city, 
           COUNT(f_name) AS common_food, 
           f_name,
           RANK() OVER (PARTITION BY city ORDER BY COUNT(f_name) DESC) AS rank
    FROM restaurants
    INNER JOIN orders
        ON restaurants.r_id = orders.r_id
    INNER JOIN order_details
        ON orders.order_id = order_details.order_id
    INNER JOIN food
        ON food.f_id = order_details.f_id
    GROUP BY city, f_name
) AS ranked_food
WHERE rank = 1;

--this is solution edited by chatgbt

--this is my solution

select distinct city, count(f_name) as common_food,f_name
from restaurants
inner join orders
on restaurants.r_id=orders.r_id
inner join order_details
on orders.order_id=order_details.order_id
inner join food
on food.f_id=order_details.f_id
group by city,f_name
order by common_food desc


--this is not the exact ans that we want its ok for the small data


--Q7
--order cancellation rate 
--calculate and comapre order cancellation rate of each restaurants

with cancel_ratio
as
(select r_name,count(user_id) as order_place,
count(case when delivery_status ='pending'
		or delivery_status='order cancel' then 1 end) as not_delivered
from restaurants
inner join orders 
on restaurants.r_id=orders.r_id
inner join order_details
on orders.order_id=order_details.order_id
group by r_name 
)

select 
order_place,
not_delivered,
round(not_delivered::numeric/order_place::numeric * 100,2) as cancellation_rate
from cancel_ratio

--this is new method/trick that we have learn to add new column in o/p table


--update cancel_ratio
--set cancellation_rate=(order_place/not_delivered)*100 

--Q8
--determine average delivery time of each rider

select 
partner_name,count(order_id),round(avg(delivery_time),2) as avg_deliverytime
from delivery_partner
inner join orders
on delivery_partner.partner_id=orders.partner_id
group by partner_name
order by partner_name


--Q9 data segmentation
--segment customer into gold and silver based on their total spending on avg 
--order value(aov).If the customers total spending exceeds the aov label them as gold 
--if not then silver

select name,sum(amount) as total_spending ,
case 
	when sum(amount)>(select avg(amount) from orders) then 'GOLD'
	else 'SILVER'
	end as cust_category
from user1
inner join orders
on user1.user_id=orders.user_id
group by name


select avg(amount) from orders
--419.6

--Q10
--riders rating of avg of best rirder
--find the best rider based on rating

select partner_name,avg(delivery_rating)
from delivery_partner
inner join orders
on orders.partner_id=delivery_partner.partner_id
group by partner_name
order by avg(delivery_rating) desc


--Q11
--monthly sales trends
--identify sales trends by comparing each months total sales to previous one

with diff 
as 
(select 
extract(month from order_date) as month,
sum(amount) as present_month_sale,
lag(sum(amount),1) over(order by extract(month from order_date)) as prev_month_sale
from orders
group by 1
order by 1 
)

select 
present_month_sale,
prev_month_sale,
present_month_sale::numeric - prev_month_sale::numeric as sales_growth
from diff



--Q12
--rank cities based on revenue generated



select city , sum(amount) as revenue_generated,
rank() over(order by sum(amount) desc) as city_rank
from restaurants
join orders
on restaurants.r_id=orders.r_id
group by city


--------------------------------
---end of analysis---
---------------------------------

