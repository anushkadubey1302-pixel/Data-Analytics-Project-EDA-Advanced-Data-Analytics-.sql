/*  
                    ================================================================================================
                                                  ADVANCED DATA ANALYSIS
                                   ---------------------------------------------------------- 
                                        1) CHANGE OVER TIME ANALYSIS ( Measure by Date dimension )
                  --------------------------------------------------------------------------------------------------- */

-- Analyze Sales Performance Over Time

SELECT 
order_date,
sales 
FROM gold.fact_sales            -- to know the order_date by sales

-- ANALYSIS OVER YEAR

SELECT                                                     
YEAR(order_date) AS order_year ,                       -- change over year analysis  
SUM(sales) AS total_sales,                            -- aggregate to know the data by total_sales     
COUNT(DISTINCT customer_key) as total_customers,      -- aggregate to know the total nr.s of customers  ( Are we gaining cust over time )
SUM(quantity) as total_quantity                     -- to know the qunatity of order sales. Ia the revenue gaining or losing over time Summarize quantity over total quantity 
                                                    -- best year worst year for total sales etc 
FROM gold.fact_sales                                          
WHERE order_date IS NOT NULL                       -- filtering                          
GROUP BY YEAR(order_date)                                    
ORDER BY YEAR(order_date)  ASC

-- ANALYSIS OVER MONTH

SELECT                                                     
MONTH(order_date) AS order_month ,                    -- data change analysis over month  WORST  month -> feb and BEST month -> december
SUM(sales) AS total_sales,                            
COUNT(DISTINCT customer_key) as total_customers,      
SUM(quantity) as total_quantity                                                     
FROM gold.fact_sales                                          
WHERE order_date IS NOT NULL                          -- filtering                          
GROUP BY MONTH(order_date)                                    
ORDER BY MONTH(order_date)  

-- ANALYSIS SPECIFIC FOR EACH YEAR BY MONTH

SELECT year(order_date) as order_year,
MONTH(order_date) AS order_month ,                    -- data change analysis per month over year  WORST  month -> feb and BEST month -> december
SUM(sales) AS total_sales,                            
COUNT(DISTINCT customer_key) as total_customers,      
SUM(quantity) as total_quantity                                                     
FROM gold.fact_sales                                          
WHERE order_date IS NOT NULL                          -- filtering                          
GROUP BY YEAR(order_date),
         MONTH(order_date)                                  
ORDER BY YEAR(order_date), MONTH(order_date)

-- TO FOCUS ON SPECIFIC MONTH just filter the data in the above query but u have to use datetrunc OR FORMAT
-- for year & month instead of using them separately

-- Datetrunc

SELECT datetrunc (month,order_date) as order_date,
SUM(sales) AS total_sales,                            
COUNT(DISTINCT customer_key) as total_customers,      
SUM(quantity) as total_quantity                                                     
FROM gold.fact_sales                                          
WHERE order_date IS NOT NULL                          --   better sorting                         
GROUP BY datetrunc (month,order_date)                                   
ORDER BY datetrunc (month,order_date)
-----------------------------------------------------------------------------------------------------------------------------------

--Format

SELECT FORMAT (order_date, 'yyyy-MMM') as order_date,
SUM(sales) AS total_sales,                            
COUNT(DISTINCT customer_key) as total_customers,      
SUM(quantity) as total_quantity                                                     
FROM gold.fact_sales                                          
WHERE order_date IS NOT NULL                          -- Sorting here in format is based on string bec                           
GROUP BY FORMAT (order_date, 'yyyy-MMM')              -- the format we put is a string unordered months so better to go with the datetrunc                  
ORDER BY FORMAT (order_date, 'yyyy-MMM') 

