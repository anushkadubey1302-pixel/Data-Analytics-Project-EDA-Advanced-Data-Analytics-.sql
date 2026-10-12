/*                    EXPLORATORY DATA ANALYSIS
-----------------------------------------------------------------------
                         1) DATABASE EXPLORATION
--------------------------------------------------------------------*/

-- Explore All Objects in the Database

SELECT * FROM INFORMATION_SCHEMA.TABLES
ORDER BY TABLE_SCHEMA


-- Explore All Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='dim_customers'           -- select cols only for specific table