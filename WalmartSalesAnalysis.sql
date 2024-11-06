Create database if not exists WalmartSales;
USE walmartsales;
Create Table if not exists Sales(
invoice_id Varchar (30) not null primary key,
branch varchar (5) not null,
city varchar (30) not null,
customer_type varchar (30) not null,
gender varchar (10) not null,
product_line varchar (100) not null,
unit_price decimal (10,2) not null,
quantity int,
VAT float not null,
total decimal (12,4) not null,
date Datetime not null,
time Time not null,
payment_method varchar (15) not null,
cogs decimal (10,2) not null,
gross_margin_pct float,
gross_income decimal (12,4) not null,
rating float not null
);



-- Time of the day

Select time,
(Case when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
when time between "16:01:00" and "20:00:00" then "Evening"
Else "Night"
end) as Time_of_the_day
from Sales;

Alter table sales Add column Time_of_the_day varchar (20);

Update sales
set Time_of_the_day = Case when time between "00:00:00" and "12:00:00" then "Morning"
when time between "12:01:00" and "16:00:00" then "Afternoon"
when time between "16:01:00" and "20:00:00" then "Evening"
Else "Night"
end;

-- Name of the days

Select date, dayname(date)as day_name from sales;

Alter table sales add column day_name varchar (10);
Update sales 
set day_name = dayname(date);

-- Name of the month

Select date, monthname(date)as month_name from sales;

Alter table sales add column month_name varchar (20);
Update sales 
set month_name = monthname(date);

-- Answering some important questions to understand the data further -- 

-- How many unique cities does the data have?

Select Distinct City from sales;

-- In which city is each branch? 

Select Distinct city, branch from sales;

-- How many unique product lines does the data have?

Select Count(distinct product_line) as CountofProductlines from sales;

-- What is the most common payment method?

Select Payment_method, count(payment_method) as Tcount from sales
group by payment_method
order by Tcount desc;

-- What is the most selling product line?

SELECT SUM(quantity) as PQuantity, product_line
FROM sales
GROUP BY product_line
ORDER BY PQuantity DESC;

-- What is the total revenue by month?

SELECT month_name AS Month, SUM(total) AS TotalRev
FROM sales
GROUP BY month_name 
ORDER BY TotalRev;

-- What month had the largest Costs of goods sold?

SELECT month_name AS month, SUM(cogs) AS Largestcogs
FROM sales
GROUP BY month_name 
ORDER BY Largestcogs;

-- What product line had the largest revenue?

SELECT product_line, SUM(total) as TotalRev
FROM sales
GROUP BY product_line
ORDER BY TotalRev DESC;

-- What is the city with the largest revenue?

SELECT branch, city, SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;

-- What product line had the largest VAT?

SELECT product_line, AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

SELECT AVG(quantity) AS avg_quantity
FROM sales;

SELECT product_line,
	CASE WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?


SELECT branch, SUM(quantity) AS TQuantity
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender

SELECT gender, product_line, COUNT(gender) AS total_count
FROM sales
GROUP BY gender, product_line
ORDER BY total_count DESC;

-- What is the average rating of each product line

SELECT ROUND(AVG(rating), 2) as avg_rating, product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT payment
FROM sales;


-- What is the most common customer type?
SELECT customer_type, count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT customer_type, COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT gender, COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT gender, COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;


-- Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;


-- Which day of the week has the best average ratings per branch?
SELECT  day_name, COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- Number of sales made in each time of the day per weekday 
SELECT time_of_day, COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;