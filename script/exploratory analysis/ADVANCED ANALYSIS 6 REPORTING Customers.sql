/*  
                    ================================================================================================
                                                  ADVANCED DATA ANALYSIS
                                   ---------------------------------------------------------- 
                                                  6) Reporting customers
                  --------------------------------------------------------------------------------------------------- */

/*
==================================================================
Customer Report
==================================================================
Purpose:
    - This report consolidats key customer metrics and behaviors.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - lifespan (in months)
    4. Calculates valuable KPIs:
          - recency (months since last order)
          - avg order value                         aov = total sales/ total nr. of orders
          - avg monthly spend                       AMS = total sales/ nr. of months
================================================================== */
CREATE VIEW gold.report_customers as 
WITH base_query as (
/*
-----------------------------------------------
Base Query: Retrieves core cols from tables
----------------------------------------------*/
SELECT 
    f.order_number, 
    f.product_key,
    f.order_date,
    f.sales,
    f.quantity,
    c.first_name + ' ' + c.last_name AS customer_name, 
    DATEDIFF(year,c.birthdate, getdate()) as age,
    c.customer_key,
    c.customer_number
FROM gold.fact_sales f 
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL)

, customer_aggregation as(
/* --------------------------------------------------------------------
2) Customer Aggregation: Summarizes key metrics at the customer level
-----------------------------------------------------------------------*/
SELECT 
    customer_name, 
    age,
    customer_key,
    customer_number,
    COUNT(DISTINCT order_number) as total_orders,
    SUM(sales) as total_sales,
    SUM(quantity) as total_quantity,
    COUNT(DISTINCT product_key) as total_products,
    MAX(order_date) as last_order,
    DATEDIFF (month,MIN(order_date),MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
    customer_name, 
    age,
    customer_key,
    customer_number
)
--------------------------------------------------------
-- 3) CALCULATE KPI's AND FINAL RESULT
---------------------------------------------------------
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE WHEN age < 20 THEN 'under 20'
         WHEN age BETWEEN 20 and 29 THEN 'under 20-29'
         WHEN age BETWEEN 30 and 39 THEN 'under 30-39'
         WHEN age BETWEEN 40 and 49 THEN 'under 40-49'
         ELSE '50 And Above'
    END AS age_group,
    CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
         WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
         ELSE 'New'
    END customer_segment,
    last_order,
    DATEDIFF(MONTH, last_order,getdate()) as recency,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    lifespan,
    -- Compute avg order value (AOV)
    CASE WHEN total_orders = 0 THEN 0
         ELSE total_sales/total_orders
    END as avg_order_value,
    -- Compute avg monthly spend (AMS)
    CASE WHEN lifespan = 0 THEN 0
         ELSE total_sales/lifespan 
    END AS avg_monthly_order
FROM customer_aggregation