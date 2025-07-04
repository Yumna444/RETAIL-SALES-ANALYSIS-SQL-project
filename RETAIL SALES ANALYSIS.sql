-- RETAIL SALES ANALYSIS 
--(SQL PROJECT)


-- STEP 1: CREATE TABLE
Drop TABLE if exists retail_sales;
Create TABLE retail_sales 
             (
                transactions_id INT PRIMARY KEY ,
                sale_date DATE ,
                sale_time TIME ,
                customer_id INT,
                gender VARCHAR(15),
                age INT,
                category VARCHAR(15),
                quantiy INT,
                price_per_unit FLOAT,
                cogs  FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
LIMIT 10


SELECT
    COUNT(*)
FROM retail_sales

--Data Cleaning
SELECT * FROM retail_sales
where transactions_id IS NULL

SELECT * FROM retail_sales
where sale_date IS NULL

SELECT * FROM retail_sales
where sale_time IS NULL

SELECT * FROM retail_sales
where 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR 
	 quantiy IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL

--
DELETE FROM retail_sales
where
transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR
	 category IS NULL
	 OR 
	 quantiy IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL;

-- Data Exploration

-- How many sales record we have?
SELECT COUNT(*) as total_sale FROM retail_sales

--How many unique customers we have?
SELECT COUNT( Distinct customer_id) as total_sale FROM retail_sales


SELECT  Distinct category FROM retail_sales


---Data Analysis & Business Key Problems & Answers
-- My Analysis & Findings
-- Q.1 Write an SQL statement to fetch all columns for transactions that occurred on '2022-11-05'.
-- Q.2 Using SQL, retrieve all records where the category is 'Clothing' and quantity sold exceeds 10, specifically within November 2022.
-- Q.3 Create an SQL query to calculate the sum of total sales (total_sale) for each product category.
-- Q.4 Write an SQL command to find the average age of customers who made purchases from the 'Beauty' category.
-- Q.5 Use SQL to select all transactions where the total_sale value is greater than 1000.
-- Q.6 Formulate an SQL query to count the number of transactions (transactions_id) done by each gender, broken down by category.
-- Q.7 Using SQL, compute the average sales per month, and determine the best-performing month in terms of sales for each year.
-- Q.8 Write an SQL query to find the top 5 customers based on the highest total sales they’ve generated. 
-- Q.9 Use SQL to find how many unique customers made purchases within each product category.
-- Q.10 With SQL, categorize transactions into shifts (Morning ≤ 12, Afternoon 12–17, Evening >17) and count the number of orders in each shift.
--Q11. Use SQL to calculate the total cost of goods sold (cogs) for each day, and display the result in descending order of total COGS.
--Q12. Write an SQL query to find the total number of transactions made each day, and filter only those days where more than 5 transactions occurred.


 -- Q.1 Write an SQL statement to fetch all columns for transactions that occurred on '2022-11-05'.

SELECT *
From retail_sales
WHERE sale_date = '2022-11-05'


-- Q.2 Using SQL, retrieve all records where the category is 'Clothing' and quantity sold exceeds 3, specifically within November 2022.

SELECT
*
FROM retail_sales
Where category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 3


-- Q.3  Create an SQL query to calculate the sum of total sales (total_sale) for each product category.

SELECT 
    category,
    SUM (total_sale) as net_sale,
	count (*) total_orders
From retail_sales
GROUP BY 1

-- Q.4  Write an SQL command to find the average age of customers who made purchases from the 'Beauty' category.

SELECT
ROUND(AVG(age) , 2) as avg_age
From retail_sales
WHERE category = 'Beauty'


-- Q.5  Use SQL to select all transactions where the total_sale value is greater than 1000.

SELECT
*
FROM retail_sales
WHERE total_sale > 1000


-- Q.6  Formulate an SQL query to count the number of transactions (transactions_id) done by each gender, broken down by category.

SELECT 
    category,
    gender,
    COUNT(*) as total_transactions
FROM retail_sales
GROUP 
    by
	category,
	gender
ORDER BY 2


-- Q.7 Using SQL, compute the average sales per month, and determine the best-performing month in terms of sales for each year.
SELECT
      year,
	  month,
	 avg_sale
FROM
(
SELECT
	   EXTRACT(YEAR FROM sale_date) as year,
	   EXTRACT(MONTH FROM sale_date) as month,
	   AVG(total_sale) as avg_sale,
	   RANK()OVER(Partition by EXTRACT(YEAR FROM sale_date) ORDER by AVG(total_sale)DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1


-- Q.8  Write an SQL query to find the top 5 customers based on the highest total sales they’ve generated. 
SELECT
      customer_id,
      SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


-- Q.9  Use SQL to find how many unique customers made purchases within each product category.

SELECT
      category,
	  COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category



-- Q.10  With SQL, categorize transactions into shifts (Morning ≤ 12, Afternoon 12–17, Evening >17) and count the number of orders in each shift.
WITH hourly_sale
as 
(
SELECT *,
CASE
       WHEN EXTRACT( hour from sale_time) < 12 THEN 'Morning'
	   WHEN  EXTRACT ( hour from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	   Else 'Evening'
	  END as shift
	  
FROM retail_sales
)
SELECT
       shift, 
	   COUNT(*) as total_orders
From hourly_sale
Group by shift

--Q11. Use SQL to calculate the total cost of goods sold (cogs) for each day, and display the result in descending order of total COGS.

SELECT 
      sale_date,
	  
	  SUM(cogs) as total_cogs 
FROM retail_sales
GROUP BY 
       sale_date
ORDER BY 
total_cogs DESC;


--Q12. Write an SQL query to find the total number of transactions made each day, and filter only those days where more than 5 transactions occurred.

SELECT
      sale_date,
	  COUNT(transactions_id) as total_transaction
FROM retail_sales
GROUP BY 
        sale_date
HAVING
    COUNT(transactions_id)>5;
	  
--- PROJECT COMPLETED








