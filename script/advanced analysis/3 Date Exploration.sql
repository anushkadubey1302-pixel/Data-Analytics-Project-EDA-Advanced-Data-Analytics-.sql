/*                    EXPLORATORY DATA ANALYSIS
-----------------------------------------------------------------------
                       3) DATE EXPLORATION
----------------------------------------------------------------------- */
--  Find the date of the first & last order.
-- How many years of sales are available

SELECT
MIN(order_date) first_order_date,
MAX(order_date) last_order_date,
DATEDIFF (year, MIN(order_date), MAX(order_date)) order_range_years
FROM gold.fact_sales

-- Find the youngest & the oldest customer (To know the boundaries of the date)

SELECT
MIN(birthdate) AS oldest_birthdate,
DATEDIFF (year, MIN(birthdate) , GETDATE()) AS oldest_age,
MAX(birthdate) AS oldest_birthdate,
DATEDIFF (year, MAX(birthdate) , GETDATE()) AS youngest_age

FROM gold.dim_customers