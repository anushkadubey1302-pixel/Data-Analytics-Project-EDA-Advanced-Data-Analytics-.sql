/*                                  EXPLORATORY DATA ANALYSIS
---------------------------------------------------------------------------------------------- 
                       4) MEASURE EXPLORATION (USED TO GENERATE REPORTS FOR ALL METRICS)
----------------------------------------------------------------------------------------------- */

-- Calculate the total sales.
SELECT SUM(sales) as total_sales FROM gold.fact_sales

-- Find how many items are sold.
SELECT  SUM(quantity ) as total_items FROM gold.fact_sales

-- Find the average selling price.
SELECT AVG(price) as avg_price FROM gold.fact_sales

-- Find the Total number of Orders.
SELECT COUNT(order_number) as total_orders FROM gold.fact_sales;
SELECT COUNT(DISTINCT (order_number)) as total_orders FROM gold.fact_sales

-- Find the Total number of Products.
SELECT COUNT(product_key) as total_products FROM gold.dim_products;
SELECT COUNT(DISTINCT(product_key)) as total_products  FROM gold.dim_products

-- Find the Total number of customers.
SELECT  COUNT(customer_key) as total_customers FROM gold.dim_customers

-- Find the total number of customers that has placed an order.
SELECT COUNT(DISTINCT(customer_key)) as total_customers FROM gold.dim_customers

PRINT '-------------------------------'
PRINT 'MAIN QUERY'
PRINT '-------------------------------'
/* =========================================================================
            GENERATE REPORT THAT SHOWS ALL KEY METRICS OF THE BUSINESS
   ========================================================================= */

SELECT 'Total Sales' as measure_name, SUM (sales) as measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Sold Items' as measure_name, SUM(quantity ) as measure_value FROM gold.fact_sales
UNION ALL 
SELECT 'Avg Price' as measure_name, AVG(price) as measure_value  FROM gold.fact_sales
UNION ALL 
SELECT 'Total Orders' as measure_name, COUNT(DISTINCT (order_number)) as measure_value  FROM gold.fact_sales
UNION ALL 
SELECT 'Total Products' as measure_name, COUNT(DISTINCT(product_key)) as measure_value   FROM gold.dim_products
UNION ALL 
SELECT 'Total Customers' as measure_name, COUNT(customer_key) as measure_value FROM gold.dim_customers
UNION ALL 
SELECT 'Total Customers That Ordered ' as measure_name, COUNT(DISTINCT(customer_key)) as measure_value
FROM gold.dim_customers