/*                    EXPLORATORY DATA ANALYSIS
-----------------------------------------------------------------------
                      2 ) DIMENSION EXPLORATION
----------------------------------------------------------------------- */
-- Explore all countries our customers come from

SELECT DISTINCT country
FROM gold.dim_customers

-- Explore all categories "The major Divisions" TO GET THE overview of the product range

SELECT DISTINCT 
category,                                       -- 4
subcategory,                                    -- 36
product_name                                    -- 295 whole hierarchy of products
FROM gold.dim_products
ORDER BY 1,2,3