
/* PROJECT: Retail Sales & Profit Analytics
DATABASE: PostgreSQL
DESCRIPTION: This script creates the data schema for 9,000+ retail records 
and performs deep-dive business analysis including trend analysis, 
loss detection, and data quality checks.
*/

CREATE TABLE sales_data (
    "Row ID" INT,
    "Order ID" VARCHAR(255),
    "Order Date" DATE,
    "Ship Date" DATE,
    "Ship Mode" VARCHAR(100),
    "Customer ID" VARCHAR(100),
    "Customer Name" VARCHAR(255),
    "Segment" VARCHAR(100),
    "Country" VARCHAR(100),
    "City" VARCHAR(100),
    "State" VARCHAR(100),
    "Postal Code" VARCHAR(20), -- Varchar is safer for zip codes
    "Region" VARCHAR(50),
    "Product ID" VARCHAR(100),
    "Category" VARCHAR(100),
    "Sub-Category" VARCHAR(100),
    "Product Name" VARCHAR(255),
    "Sales" DECIMAL(10, 2),
    "Quantity" INT,
    "Discount" DECIMAL(10, 2),
    "Profit" DECIMAL(10, 2),
    "Shipping Cost" DECIMAL(10, 2),
    "Order Priority" VARCHAR(50)
    -- Add any extra custom columns from your specific file below
);
SELECT * FROM sales_data;

--Top 5 most profitable categories:

SELECT "Customer Name", SUM("Sales") AS total_spent
FROM sales_data
GROUP BY "Customer Name"
ORDER BY total_spent DESC
LIMIT 5;



--Which Region is performing the best?

SELECT "Region", SUM("Sales") AS total_sales
FROM sales_data
GROUP BY "Region"
ORDER BY total_sales DESC;

--Monthly Sales Trend:

SELECT DATE_TRUNC('month', "Order Date") AS month, SUM("Sales") AS monthly_revenue
FROM sales_data
GROUP BY month
ORDER BY month;
--Check if there are any rows where the Profit is missing?

SELECT count(*) FROM sales_data WHERE "Profit" IS NULL;
--The "Business Insight" Queries (SQL):

SELECT "Product Name", SUM("Profit") as total_profit
FROM sales_data
GROUP BY "Product Name"
ORDER BY total_profit ASC
LIMIT 10;
--Which Category makes the most money?

SELECT "Category", 
       SUM("Sales") AS total_revenue, 
       SUM("Profit") AS total_profit
FROM sales_data
GROUP BY "Category"
ORDER BY total_profit DESC;

--What is our overall Profit Margin?

SELECT (SUM("Profit") / SUM("Sales")) * 100 AS profit_margin_percentage
FROM sales_data;

--Are there any "Loss-Makers"?

SELECT "City", SUM("Profit") AS total_loss
FROM sales_data
GROUP BY "City"
HAVING SUM("Profit") < 0
ORDER BY total_loss ASC;

-- The "Scan All" Query:

SELECT 
    COUNT(*) - COUNT("Order ID") AS order_id_nulls,
    COUNT(*) - COUNT("Customer Name") AS customer_nulls,
    COUNT(*) - COUNT("Sales") AS sales_nulls,
    COUNT(*) - COUNT("Quantity") AS quantity_nulls,
    COUNT(*) - COUNT("Category") AS category_nulls,
    COUNT(*) - COUNT("City") AS city_nulls
FROM sales_data;

