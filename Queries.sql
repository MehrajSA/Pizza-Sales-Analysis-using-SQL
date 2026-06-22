Create database pizzahut;
Create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));

Select * from pizzahut.orders;

Create table orders_details_id (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id));

select * from pizzahut.orders_details_id;
-- Retrieve the total number of orders placed.
Select 
count(order_id) Total_Orders
from pizzahut.orders;

Alter table orders_details_id
Rename to order_details;

-- TASK: Calculate the total revenue generated from pizza sales.
/* p.price = price of one pizza
   od.quantity = how many were sold
  Revenue = Quantity Sold × Price
 quantity * price = revenue from that sale
 SUM() = total revenue */
Select 
ROUND(sum(od.quantity * p.price),2) as total_revenue
From order_details od
JOIN pizzas p
on od.pizza_id = p.pizza_id;

Select 
SUM(od.quantity * p.price) AS Total_Sales
From order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id;

-- Ctrl + B gives the below format of query.
SELECT 
    ROUND(SUM(od.quantity * p.price), 2) AS Total_sales
FROM
    order_details od
        JOIN
    pizzas p ON od.pizza_id = p.pizza_id;

/* Identify the highest-priced pizza. If you want the pizza name too : then in the Pizza Hut dataset, the pizza name is usually in the pizza_types table, so you need a JOIN.*/

Select
pt.name,
p.price
From pizza_types pt
join pizzas p
ON pt.pizza_type_id = p.pizza_type_id
Where p.price = (select max(price) from pizzas);

SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Identity the most common pizza size order 
Select
p.size,
SUM(quantity) as Total_Orders
From order_details od
join pizzas p
ON od.pizza_id = p.pizza_id
group by size
Order by total_orders DESC;

Select 
	p.size,
	COUNT(order_details_id) Order_Count
From order_details od
join pizzas p
ON od.pizza_id = p.pizza_id
Group by size
Order by Order_Count Desc;

-- List the top 5 most ordered pizza types along with their quantities.
Select
pt.name,
SUM(quantity) Total_Quantity
From order_details od
Join pizzas p
On od.pizza_id = p.pizza_id
Join pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
Group By pt.name
Order by Total_Quantity DESC
Limit 5;

-- Intermediate :
-- Join the necessary tables to find the total quantity of each pizza category ordered.
Select 
pt.category,
sum(quantity)TotalQuantity
From order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
Group by category
Order by totalquantity DESC;

--  Determine the distribution of orders by hour of the day.
Select
COUNT(order_id) as Order_count,
Hour(order_time) as hour
From orders
Group by Hour(order_time)
Order by Hour(order_time) desc;

-- Join relevant tables to find the category wise distribution of pizzas.
-- Select
-- pt.category,
-- COUNT(pizza_id)AS pizza_count
-- From pizza_types pt
-- Join pizzas p
-- on pt.pizza_type_id = p.pizza_type_id
-- Group by category
-- Order by pizza_count DESC;

Select
category, 
count(name)
from pizza_types
group by category;

Select
	category,
	count(name)
From pizza_types
group by category;

-- Group the orders by date and 
-- calculate the average number of pizzas ordered per day.
Select 
Round(Avg(Total_Orders),0) AS AvgPizza_perday
From
(Select
o.order_date,
SUM(od.quantity) AS Total_Orders
From orders o
JOIN order_details od
ON o.order_id = od.order_id
group by o.order_date
)t; 


-- Determine top 3 most ordered pizza types based on revenue.
-- Revenue = quantity * price  

Select
pt.name,
ROUND(sum(quantity * price),2)as revenue
From order_details od
JOIN pizzas p
on od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
Group by pt.name
Order by Revenue DESC
Limit 3;

-- Advanced: 
-- Calculate the percentage contribution of each pizza type to total revenue. 
Select 
pt.name,
ROUND(sum(Price*Quantity) *100 /
(Select
Sum(price * quantity) AS Total_Revenue
From order_details od
JOIN  pizzas p 
on od.pizza_id = p.pizza_id),2) as Revenue_percentage
From order_Details od 
Join pizzas p
on od.pizza_id = p.pizza_id
Join pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
Group by pt.name
order by Revenue_percentage DESC
Limit 3;

Select 
pt.category,
ROUND(sum(Price*Quantity) *100 /
(Select
Sum(price * quantity) AS Total_Revenue
From order_details od
JOIN  pizzas p 
on od.pizza_id = p.pizza_id),2) as Revenue_percentage
From order_Details od 
Join pizzas p
on od.pizza_id = p.pizza_id
Join pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
Group by pt.category
order by Revenue_percentage DESC;

--  Analyse the cumulative revenue generated over time. 
Select
order_date,
TotalRevenue,
SUM(Totalrevenue)OVER(Order by order_date) as Cumulative_revenue
FROM (
	Select
	o.order_date,
	ROUND(SUM(price * quantity),2) Totalrevenue
	From order_details od
	JOIN pizzas p
	ON od.pizza_id = p.pizza_id
	Join orders o
	ON o.order_id = od.order_id
	Group by order_date) as sales;
    
 -- Determine the top 3 most ordered pizza types
 -- based on revenue for each pizza category
 
 Select
 name, 
 revenue
 From
 (Select
name,
category,
Revenue,
rank()Over(partition by category order by revenue desc) as Rn
FROM
(Select
pt.name,
pt.category,
SUM(quantity * price)Revenue
From order_details od
JOIN pizzas p
ON  od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
Group by pt.name, pt.category)as ta) as tb
where rn <=3;
 
  
WITH CTE_pizza_revenue AS
( 
Select
pt.name,
pt.category,
SUM(quantity * price)Revenue
From order_details od
JOIN pizzas p
ON  od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
Group by pt.name, pt.category
)

Select * 
FROM 
(Select
name, 
category,
Revenue,
RANK()over(partition by category order by revenue desc) as rn
From CTE_pizza_revenue
)t
Where rn <= 3




