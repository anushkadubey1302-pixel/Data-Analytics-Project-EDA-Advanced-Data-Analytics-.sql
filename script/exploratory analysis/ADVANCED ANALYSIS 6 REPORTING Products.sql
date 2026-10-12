/*  
                    ================================================================================================
                                                  ADVANCED DATA ANALYSIS
                                   ---------------------------------------------------------- 
                                                   6) Reporting products
                  --------------------------------------------------------------------------------------------------- */

/*
==========================================================================================================================
                                                   Product Report
==========================================================================================================================
Purpose:
    - This report consolidats key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category , subcategory and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculates valuable KPIs:
          - recency (months since last sale)
          - avg order revenue (AOR)                         aor = total sales/ total nr. of orders
          - avg monthly revenue                             AMR = total sales/ nr. of months

========================================================================================================================= */
CREATE VIEW gold.report_products as
WITH base_query as (
/*
-------------------------------------------------------------
Base Query: Retrieves core cols from factb & dim tables
-----------------------------------------------------------*/
SELECT 
    p.product_name,
    p.product_key,
    p.category,
    p.subcategory,
    p.cost,
    f.order_number, 
    f.customer_key,
    f.order_date,
    f.sales,
    f.quantity
FROM gold.fact_sales as f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE order_date is not null                  -- Removing invalid dates 
)

, product_aggregation as (

/* --------------------------------------------------------------------
2) Product Aggregation: Summarizes key metrics at the customer level
-----------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    COUNT(DISTINCT order_number) as total_orders,
    SUM(sales) as total_sales,
    SUM(quantity) as total_quantity,
    COUNT(DISTINCT customer_key) as total_customers,
    MAX(order_date) as last_order,
    DATEDIFF(MONTH, MIN(order_date),MAX(order_date)) AS lifespan,
    ROUND (AVG (CAST(sales as float)/ NULLIF(quantity,0)),1) as avg_selling_price
    FROM base_query
    GROUP BY 
        product_key,
        product_name,
        category,
        subcategory,
        cost
)
--------------------------------------------------------
-- 3) CALCULATE KPI's AND FINAL RESULT
---------------------------------------------------------
SELECT 
    product_name,
    category,
    subcategory,
    cost,
    last_order,
    DATEDIFF(MONTH,last_order,getdate()) as recency,
    CASE WHEN total_sales > 50000 THEN 'High-Performers'
         WHEN total_sales >= 10000 THEN 'Mid-Range'
         ELSE 'Low-Performers'
    END as segment_product,
    avg_selling_price,
    total_sales,
    total_orders,
    total_quantity,
    total_customers,
    lifespan,
    -- Compute average order revenue
    CASE WHEN total_orders = 0 THEN 0
         ELSE total_sales/total_orders
    END AS avg_order_revenue,
    -- Compute average monthly  revenue
    CASE WHEN lifespan =0 THEN total_sales
         ELSE total_sales / lifespan
    END AS avg_monthly_revenue
FROM product_aggregation