/*  
                    ================================================================================================
                                                  ADVANCED DATA ANALYSIS
                                   ---------------------------------------------------------- 
                                                5) Data Segmentation CONNECT 
                  --------------------------------------------------------------------------------------------------- */

-- Segment products into cost ranges and count how many products fall into each segment.

SELECT DISTINCT
    cost_range,
    COUNT(product_key) OVER (PARTITION BY cost_range) as total_products
FROM(
SELECT 
    product_key,
    product_name,
    cost,
    CASE WHEN cost<100 THEN 'Below 100'
         WHEN cost BETWEEN 100 AND 500 THEN '100-500'
         WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
         ELSE 'Above 1000'
    END cost_range
    
FROM gold.dim_products)T
ORDER BY total_products DESC

/* Group customers into three segments based on their spending behavior:
    - VIP: Customers with at least 12 months of history and spending more than 5000.
    - Regular : Customers with at least 12 months of history but spending 5000 or less.
    - New: Customers with a lipespan less than 12 months.
And find the total nr. of customers by each group */

WITH customer_spending as (
SELECT 
    c.customer_key,
    SUM(f.sales) total_spending,
    MIN(f.order_date) as first_order,
    MAX(f.order_date) as last_order,
    DATEDIFF (month,MIN(f.order_date),MAX(f.order_date)) AS lifespan
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key 
GROUP BY c.customer_key
)
SELECT
    customer_segment,
    COUNT (customer_key) AS total_customers
FROM(
SELECT 
    customer_key,
    CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
         WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
         ELSE 'New'
    END customer_segment
FROM customer_spending
)T
GROUP BY customer_segment