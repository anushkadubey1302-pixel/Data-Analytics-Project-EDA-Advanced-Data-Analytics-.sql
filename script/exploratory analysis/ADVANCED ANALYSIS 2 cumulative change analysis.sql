/*  
                    ================================================================================================
                                                  ADVANCED DATA ANALYSIS
                                   ---------------------------------------------------------- 
                          2) CUMULATIVE CHANGE OVER TIME ANALYSIS (Cumulative Measure by Date dimension )
                  --------------------------------------------------------------------------------------------------- 
Used to change the granularity of data */
-----------------------------------------------------------------------------------------------------------------------------------------------------
--  Calculate the total sales per month & the running total of sales by year over time.

SELECT
      order_date,
      total_sales,
      SUM(total_sales) over (PARTITION BY year(order_date) order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM
(
    SELECT 
        DATETRUNC (MONTH, order_date) AS order_date,
        SUM(sales) as total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC (MONTH, order_date)
)T


-- Calculate the total sales per year & running total by year
SELECT
      order_date,
      total_sales,
      SUM(total_sales) over ( order by order_date) as running_total
FROM
(
    SELECT 
        DATETRUNC (year, order_date) AS order_date,
        SUM(sales) as total_sales
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC (year, order_date)
)T

-- Calculate the moving avg per year along with running total
SELECT
      order_date,
      total_sales,
      SUM(total_sales) over (order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total,
      avg_price,
      AVG(avg_price) over (order by order_date) as rmoving_avg
FROM
(
    SELECT 
        DATETRUNC (year, order_date) AS order_date,
        SUM (sales) as total_sales,
        AVG (price) as avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC (year, order_date)
)T
