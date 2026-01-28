CREATE TABLE sales_store (
	transaction_id VARCHAR(15),
	customer_id VARCHAR(15),
	customer_name VARCHAR(35),
	customer_age INT,
	gender VARCHAR(15),
	product_id VARCHAR(15),
	product_name VARCHAR(15),
	product_category VARCHAR(15),
	quantiy int,
	prce FLOAT,
	payment_mode VARCHAR(15),
	purchase_date DATE,
	time_of_purchase TIME,
	status VARCHAR(15)
);


SET DATEFORMAT dmy
BULK INSERT sales_store
FROM 'C:\Users\Hewlett Packard\Downloads\Sales_Store.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		ROWTERMINATOR='\n'
	);

-- DATA CLEANING

--Step 1 - Make a copy of original data 
SELECT * INTO sales FROM sales_store

SELECT * FROM sales


--Step 2 - Check for Duplicates

SELECT transaction_id, COUNT(*) AS count
FROM sales
GROUP BY transaction_id
HAVING COUNT(transaction_id) >1; 


WITH CTE AS (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY transaction_id ORDER BY transaction_id) AS ROW_NUM
FROM sales
)

--DELETE FROM CTE
--WHERE ROW_NUM > 1

SELECT * FROM CTE
WHERE transaction_id IN ('TXN240646', 'TXN342128', 'TXN855235', 'TXN981773')


--Step 3 - Headers Correction

EXEC sp_rename'sales.quantiy','quantity','COLUMN';

EXEC sp_rename'sales.prce','price','COLUMN';

SELECT * FROM sales

--Step 4 - Check for Datatype

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='sales'

--Step 5 - Check for Null Values

-- Check for Null Count

DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = STRING_AGG(
	'SELECT ''' + COLUMN_NAME + ''' AS ColumnName,
	COUNT(*) AS NullCount
	FROM ' + QUOTENAME(TABLE_SCHEMA) + '.sales
	WHERE '+ QUOTENAME(COLUMN_NAME) + ' IS NULL',
	' UNION ALL '
)
WITHIN GROUP (ORDER BY COLUMN_NAME)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME ='sales';

-- Execute the dynamic SQL
EXEC sp_executesql @SQL;


-- Treating Null Values

SELECT * FROM sales
WHERE transaction_id IS NULL
OR
customer_id IS NULL
OR
customer_name IS NULL
OR
customer_age IS NULL
OR
gender IS NULL
OR
product_id IS NULL
OR 
product_name IS NULL
OR
product_category IS NULL
OR 
quantity IS NULL
OR
price IS NULL
OR 
payment_mode IS NULL
OR
purchase_date IS NULL
OR
time_of_purchase  IS NULL
OR 
status IS NULL;

SELECT * FROM sales
WHERE customer_name = 'Ehsaan Ram'

UPDATE sales
SET customer_id='CUST9494'
WHERE transaction_id='TXN977900'

DELETE FROM sales
WHERE transaction_id IS NULL

SELECT * FROM sales
WHERE customer_name = 'Damini Raju'

UPDATE sales
SET customer_id='CUST1401'
WHERE transaction_id='TXN985663'


SELECT * FROM sales
WHERE customer_id='CUST1003'

UPDATE sales
SET customer_name='Mahika Saini',
customer_age='35',
gender='Male'
WHERE transaction_id='TXN432798'

-- Step 6 - Data Format

SELECT DISTINCT gender 
FROM sales

UPDATE sales
SET gender='M'
WHERE gender='Male'


UPDATE sales
SET gender='F'
WHERE gender='Female'


SELECT DISTINCT payment_mode 
FROM sales

UPDATE sales
SET payment_mode='Credit Card'
WHERE payment_mode='CC'


-- DATA ANALYSIS --

-- Q1. What are the top 5 most selling products by quantity?

SELECT TOP 5 product_name, SUM(quantity) AS total_quantity_sold
FROM sales
WHERE status = 'delivered'
GROUP BY product_name
ORDER BY total_quantity_sold DESC

-- INSIGHT: It helps priortize stock and boost sales through targeted promotions.

-- Q2. Which produts are most frequently cancelled?

SELECT TOP 5 product_name, COUNT(*) AS total_cancelled 
FROM sales
WHERE status='cancelled'
GROUP BY product_name
ORDER BY total_cancelled DESC

-- INSIGHT: Identify poor performing products to improve quality or remove rom catalog.

--Q3. What time of the day has the highest number of purchases?

SELECT
	CASE
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
	END AS time_of_day,
	COUNT(*) AS total_orders
FROM sales
GROUP BY
	CASE
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 0 AND 5 THEN 'NIGHT'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 6 AND 11 THEN 'MORNING'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		WHEN DATEPART(HOUR,time_of_purchase) BETWEEN 18 AND 23 THEN 'EVENING'
	END
ORDER BY total_orders DESC

-- INSIGHT: Found peak sales times, helps in optimize staffing, promotions and manage server loads.

-- Q4. Who are the top 5 highest spending customers?

SELECT TOP 5 customer_name, 
	FORMAT(SUM(price * quantity),'C0','en-IN') AS total_amount_spent
FROM sales
GROUP BY customer_name
ORDER BY SUM(price * quantity) DESC

-- INSIGHT: Identified top 5 spending customers, personalized offers, Loyalty Rewards, and retention.

-- Q5. Which product category generates the highest revenue?

SELECT product_category,
	FORMAT(SUM(price * quantity),'C0','en-IN') AS Revenue
FROM sales
GROUP BY product_category
ORDER BY SUM(price * quantity) DESC

-- INSIGHT: Refine product strategy, supply chain, and promotions. allowing the business to invest more 
-- in high-margin or high-demand category.


-- Q6. What is the return/cancellation rate per product category?

SELECT * FROM sales

-- Return

SELECT product_category,
	FORMAT(COUNT(CASE WHEN status='returned' THEN 1 END)*100.0/COUNT(*),'N2') + ' %' AS Return_Percent
FROM sales
GROUP BY product_category
ORDER BY Return_Percent DESC


-- Cancellation

SELECT product_category,
	FORMAT(COUNT(CASE WHEN status='cancelled' THEN 1 END)*100.0/COUNT(*),'N2') + ' %' AS Cancellation_Percent
FROM sales
GROUP BY product_category
ORDER BY Cancellation_Percent DESC

--INSIGHT: Monitor dissatisfaction trends per category, improve product description/expecttions, 
-- helps identify and fix produt or logistics issues.

-- Q7. What is the most preferred payment mode?

SELECT payment_mode, COUNT(payment_mode) AS total_count
FROM sales
GROUP BY payment_mode
ORDER BY total_count DESC

-- INSIGHT: Streamline payment processing, prioritize popular modes.

-- Q8. How does age group affect purchasing behavior?

--SELECT MIN(customer_age), MAX(customer_age) FROM sales

SELECT 
	CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
		ELSE '51+'
	END AS customer_age,
	FORMAT(SUM(price * quantity),'C0','en-IN') AS total_purchase
FROM sales
GROUP BY CASE
		WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
		WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
		WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
		ELSE '51+'
	END
ORDER BY SUM(price * quantity) DESC

-- INSIGHT: Targeted marketing and product recommendations by age group.

-- Q9. Waht's the monthly sales trends?

SELECT 
	YEAR(purchase_date) AS Years,
	MONTH(purchase_date) AS Months,
	FORMAT(SUM(price * quantity), 'C0', 'en-IN') AS total_sales,
	SUM(quantity) AS total_quantity
FROM sales
GROUP BY YEAR(purchase_date), MONTH(purchase_date)
ORDER BY Months

-- INSIGHT: Plan inventory and marketing according to seasonal trends.

-- Q10. Are certain genders buying more specific product category?

SELECT product_category, gender, COUNT(product_category) AS total_purchase
FROM sales
GROUP BY gender, product_category
ORDER BY product_category, gender

--OR--

SELECT * 
FROM (
	SELECT product_category, gender
	FROM sales
	) AS source_table
PIVOT (
	COUNT(gender)
	FOR gender IN ([M],[F])
	) AS pivot_table
ORDER BY product_category

-- INSIGHT: Personalized Ads, gender-focused campaigns