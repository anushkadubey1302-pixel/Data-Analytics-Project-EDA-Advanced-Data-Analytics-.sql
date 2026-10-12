/*  
                    ================================================================================================
                                                  ADVANCED DATA ANALYSIS
                                   ---------------------------------------------------------- 
                                                4) PART TO WHOLE ANALYSIS 
                  --------------------------------------------------------------------------------------------------- */

-- Which categories contribute the most to overall sales
SELECT
    total_sales,
    category,
    SUM(total_sales) OVER () overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) OVER ()) * 100,2),'%') as percentage
FROM (
SELECT 
    p.category,
    SUM(f.sales) as total_sales
FROM gold.fact_sales as f
LEFT JOIN gold.dim_products as p
ON f.product_key = p.product_key
GROUP BY p.category
)T
ORDER BY total_sales DESC