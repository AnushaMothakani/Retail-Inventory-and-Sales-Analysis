CREATE DATABASE inventory_analytics_db;
USE inventory_analytics_db;

CREATE TABLE fact_sales (
sale_date DATE,
store_id VARCHAR(10),
product_id VARCHAR(10),
units_sold INT,
demand_forecast INT,
discount DECIMAL(5,2),
weather_condition VARCHAR(10),
holiday_promotion VARCHAR(5),
region VARCHAR(10),
competitor_pricing DECIMAL(5,2),
seasonality VARCHAR(10));

DROP TABLE fact_sales;

CREATE TABLE fact_inventory(
inventory_date DATE,
store_id VARCHAR(10),
product_id VARCHAR(10),
inventory_level INT,
units_ordered INT);

CREATE TABLE dim_products (
product_id VARCHAR(10),
category VARCHAR(20),
price DECIMAL(5,2));

CREATE TABLE dim_stores (
store_id VARCHAR(10),
region VARCHAR(10));

SHOW TABLES;

USE inventory_analytics_db;

SELECT COUNT(*) FROM fact_sales;      
SELECT COUNT(*) FROM fact_inventory;
SELECT COUNT(*) FROM dim_products;
SELECT COUNT(*) FROM dim_stores;

SELECT * FROM fact_sales LIMIT 10;     
SELECT * FROM fact_inventory LIMIT 10;
SELECT * FROM dim_products LIMIT 10;
SELECT * FROM dim_stores LIMIT 10;

SELECT SUM(units_sold * competitor_pricing * (1- discount)) AS total_revenue  
FROM fact_sales;

SELECT product_id, SUM(units_sold) AS total_units_sold  
FROM fact_sales
GROUP BY product_id
ORDER BY total_units_sold DESC
LIMIT 10;

SELECT product_id, store_id, inventory_level  
FROM fact_inventory
WHERE inventory_level <= 60;
SELECT product_id, SUM(units_sold) AS actual_sales, SUM(demand_forecast) AS forecast_sales 
FROM fact_sales
GROUP BY product_id;

SELECT region, SUM(units_sold) AS total_sales    
FROM fact_sales
GROUP BY region;

SELECT product_id, store_id, inventory_level  
FROM fact_inventory 
WHERE inventory_level <= 60;
SELECT product_id, inventory_level   
FROM fact_inventory
WHERE inventory_level > 250;

SELECT discount, AVG(units_sold) AS avg_sales  
FROM fact_sales
GROUP BY discount
ORDER BY discount;

CREATE VIEW vw_sales_summary AS   
SELECT product_id, SUM(units_sold) AS total_sales
FROM fact_sales
GROUP BY product_id;

CREATE VIEW vw_region_performance AS   
SELECT ds.region, SUM(fs.units_sold) AS total_sales
FROM fact_sales fs
JOIN dim_stores ds
ON fs.store_id = ds.store_id
GROUP BY ds.region;

CREATE VIEW vw_inventory_risk AS   
SELECT product_id, store_id, inventory_level
FROM fact_inventory
WHERE inventory_level < 60;
