/*  
                    ================================================================================================
                                                  ADVANCED DATA ANALYSIS
                                   ---------------------------------------------------------- 
                                        3) PERFORMANCE ANALYSIS ( Measure by dimension )
                  --------------------------------------------------------------------------------------------------- */

/* Analyze the yearly performance of products by comparing each product's sales to both its avg sales 
 performance & the previous year's sales.                   */

WITH yearly_product_sales as (
SELECT 
     YEAR(f.order_date) as order_year,
     p.product_name,
     SUM(f.sales) as current_sales
 FROM gold.fact_sales f
 LEFT JOIN gold.dim_products p
 ON f.product_key =p.product_key
 WHERE f.order_date IS NOT NULL
 GROUP BY 
         YEAR(f.order_date),p.product_name
)

SELECT 
     order_year,
     product_name,
     current_sales,
     AVG(current_sales) over (partition by product_name) avg_sales,
     current_sales - AVG(current_sales) over (partition by product_name) as difference,
     CASE 
         WHEN current_sales - AVG(current_sales) over (partition by product_name) > 0 THEN 'Above Avg'
         WHEN current_sales - AVG(current_sales) over (partition by product_name) < 0 THEN 'Below Avg'
         ELSE 'Avg'
     END as comparison,
     LAG(current_sales) over (partition by product_name ORDER BY order_year) prev_sales,
     current_sales - LAG(current_sales) over (partition by product_name ORDER BY order_year) as diff_py,
     CASE 
         WHEN current_sales - LAG(current_sales) over (partition by product_name ORDER BY order_year)>0 THEN 'Increment'
         WHEN current_sales - LAG(current_sales) over (partition by product_name ORDER BY order_year)<0 THEN 'Decrement'
         ELSE 'same'
         END as py_comparison
FROM yearly_product_sales
ORDER BY 2,1


