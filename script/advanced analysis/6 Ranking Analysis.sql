/*  
                    ================================================================================================
                                                  EXPLORATORY DATA ANALYSIS
                                   ---------------------------------------------------------- 
                                        6) RANKING ANALYSIS ( Measure by dimension )
                  --------------------------------------------------------------------------------------------------- */
-- WHICH 5 PRODUCT GENERATE THE HIGHEST REVENUE

 SELECT *
 FROM (
 SELECT
 p.product_name,
 SUM (f.sales) total_sales,
 RANK() OVER( ORDER BY SUM (f.sales) DESC) AS rank_
 FROM gold.fact_sales as f
 LEFT JOIN gold.dim_products as p
 ON f.product_key = p.product_key
 GROUP BY  p.product_name )T
 WHERE rank_<= 5
                                   --  OR  --

 SELECT TOP 5 
 p.product_name,
 SUM (f.sales) total_revenue
 FROM gold.fact_sales as f
 LEFT JOIN gold.dim_products as p
 ON f.product_key = p.product_key
 GROUP BY  p.product_name
 ORDER BY total_revenue DESC

-- WHAT ARE THE 5 WORST-PERFORMING PRODUCTS IN TERMS OF SALES?

 SELECT TOP 5 
 p.product_name,
 SUM (f.sales) total_revenue
 FROM gold.fact_sales as f
 LEFT JOIN gold.dim_products as p
 ON f.product_key = p.product_key
 GROUP BY  p.product_name
 ORDER BY total_revenue

 -- Find the Top 10 customers who have generated the highest revenue 
 SELECT *
 FROM (
 SELECT
     c.customer_key,
     c.first_name,
     c.last_name,
     SUM (f.sales) total_sales,
     RANK() OVER( ORDER BY SUM (f.sales) DESC) AS rank_
 FROM gold.fact_sales as f
 LEFT JOIN gold.dim_customers as c 
 ON f.customer_key = c.customer_key 
 GROUP BY 
 c.customer_key,
 c.first_name,
 c.last_name )T
 WHERE rank_<= 10

 -- THE 3 CUSTOMERS WITH THE FEWEST ORDERS PLACED


     SELECT TOP 3 
         c.customer_key,
         c.first_name,
         c.last_name,
         COUNT (DISTINCT order_number) total_orders
     FROM gold.fact_sales as f
     LEFT JOIN gold.dim_customers as c 
     ON f.customer_key = c.customer_key 
     GROUP BY 
     c.customer_key,
     c.first_name,
     c.last_name
     ORDER BY total_orders