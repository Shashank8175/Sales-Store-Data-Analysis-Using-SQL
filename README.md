# Sales-Store-Data-Analysis-Using-SQL

PROJECT SUMMARY

This project is an end-to-end SQL data analysis case study on a retail sales dataset.
It demonstrates how SQL is used to:
-Design a database table
-Perform data quality checks
-Explore customer and sales behavior
-Answer real business questions
-Generate insights for decision-making
-The entire analysis is written in SQL and structured as a sequence of analytical questions.


BUSINESS OBJECTIVE

The goal of this project is to analyze store sales data to understand:
-Customer demographics and behavior
-Product and category performance
-Sales trends by time and gender
-Operational insights to support marketing and business strategy


DATASET OVERVIEW

The analysis is based on a single main table:

sales_store
Column Name -	Description
transaction_id -	Unique transaction identifier
customer_id	- Unique customer ID
customer_name	- Customer name
customer_age	- Customer age
gender	- Customer gender
product_id	- Product ID
product_name	- Product name
product_category	- Product category
quantity	- Quantity purchased
price	- Price per unit
payment_mode	- Payment method
purchase_date	- Date of purchase
time_of_purchase	- Time of purchase
status	- Transaction status

The project starts with table creation, followed by data validation and analysis queries.


TOOLS & TECHNOLOGIES

-SQL (T-SQL)
-Microsoft SQL Server / SSMS
-Git & GitHub


PROJECT WORKFLOW

1. Database & Table Setup

Created the sales_store table with appropriate data types.

2. Data Quality Checks

Identified null values across important columns

Checked for invalid or incomplete records

Example:
<img width="738" height="196" alt="image" src="https://github.com/user-attachments/assets/75727635-0728-4a41-9193-d7c7199c3116" />


3. Exploratory Data Analysis (EDA)

The project answers multiple business questions such as:
-Customer-wise purchase checks
-Sales distribution by gender
-Product category performance
-Time-based purchasing behavior

Example: Time of day with highest purchases
<img width="655" height="375" alt="image" src="https://github.com/user-attachments/assets/bb6e6a4c-848a-4a61-9181-c4fe85faf6db" />


4. Advanced Analysis

Gender-based category analysis using PIVOT

Aggregations and grouping for business insight extraction

Example:
<img width="687" height="270" alt="image" src="https://github.com/user-attachments/assets/0c393836-ab9d-46fb-a51c-4ba42e32e3c4" />


KEY INSIGHTS (from SQL comments)
-Clear time-of-day patterns in purchasing
-Product categories show gender-based preferences
-Dataset can support targeted marketing and campaign design
-Structured SQL can directly drive business decisions


HOW TO RUN THIS PROJECT

-Install Microsoft SQL Server and SSMS
-Create a new database
-Open SQLQuery1.sql in SSMS
-Run the script step-by-step:
-Table creation
-Data checks
-Analysis queries


AUTHOR
Shashank
Aspiring Data Analyst

Skills demonstrated:
SQL • Data Cleaning • Business Analysis • Analytical Thinking • EDA
