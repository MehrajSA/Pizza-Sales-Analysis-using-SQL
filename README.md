# 🍕 Pizza Sales Analysis using SQL

## 📌 Project Overview

This project analyzes pizza sales data using SQL to uncover valuable business insights related to revenue, customer ordering patterns, best-selling pizzas, and sales performance. The objective of this project is to demonstrate SQL skills including data aggregation, joins, subqueries, Common Table Expressions (CTEs), and window functions while solving real-world business problems.

---

## 🎯 Business Problem

A pizza restaurant wants to understand:

* Which pizzas generate the highest revenue?
* What are the most popular pizza categories?
* Which pizza sizes are ordered most frequently?
* What are the peak sales periods?
* Which pizzas contribute the most to overall revenue?

By analyzing sales data, the business can make data-driven decisions to improve profitability and customer satisfaction.

---

## 📂 Dataset Information

The dataset contains the following tables:

### Orders

Stores order details such as order date and time.

### Order Details

Contains information about pizzas ordered and quantities purchased.

### Pizzas

Includes pizza prices and size information.

### Pizza Types

Contains pizza names, categories, and ingredients.

---
Schema Structure:

Pizza-Sales-SQL-Analysis/
│
├── Dataset/
│   ├── orders.csv
│   ├── order_details.csv
│   ├── pizzas.csv
│   └── pizza_types.csv
│
├── SQL Queries/
│   ├── Basic_Analysis.sql
│   ├── Intermediate_Analysis.sql
│   └── Advanced_Analysis.sql
│
├── Refer Screenshots in Pdf File
│   ├── Revenue_Analysis.png
│   ├── Top_Pizzas.png
│   └── Category_Performance.png
│
└── README.md

---
## 🛠️ SQL Concepts Used

* SELECT Statements
* WHERE Clause
* GROUP BY
* ORDER BY
* Aggregate Functions (SUM, COUNT, AVG)
* INNER JOIN
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions (RANK, DENSE_RANK)
* Date & Time Functions

---

## 📊 Key Business Insights

### Revenue Analysis

* Calculated total revenue generated from pizza sales.
* Identified highest revenue-generating pizzas.

### Product Performance

* Determined top-selling pizzas by quantity.
* Analyzed pizza category performance.

### Customer Ordering Patterns

* Identified most common pizza sizes ordered.
* Analyzed order distribution across different time periods.

### Advanced Analysis

* Ranked pizzas within each category based on revenue.
* Calculated percentage contribution of each pizza to total sales.

---

## 📈 SQL Queries

### the cumulative revenue generated over time. 
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
```

### the top 3 most ordered pizza types based on revenue for each pizza category
 
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
 
-- Solved it using CTE:

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
```
TASK : The percentage contribution of each pizza type to total revenue. 

SQL QUERY:
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
---

TASK: Determine top 3 most ordered pizza types based on revenue.
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

TASK: Group the orders by date and 
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

TASK: The distribution of orders by hour of the day.
Select
COUNT(order_id) as Order_count,
Hour(order_time) as hour
From orders
Group by Hour(order_time)
Order by Hour(order_time) desc;
---

## 🚀 Key Learnings

Through this project, I gained hands-on experience in:

* Writing complex SQL queries
* Data cleaning and transformation
* Business-oriented data analysis
* Query optimization techniques
* Converting raw data into actionable insights


About Me:
Mehraj Sultana A
Executive MBA in Business Intelligence & Analytics
Business Analyst 

Skills:
SQL | MySQL | Excel | Power BI | Tableau | Requirement Gathering | Business Analysis

LinkedIn: www.linkedin.com/in/mehraj-sultana-a-477ab6330
GitHub: (https://github.com/MehrajSA)
