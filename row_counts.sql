select 'call_center' AS TABLE_NAME, count(*) as count from call_center UNION 
select 'catalog_page' AS TABLE_NAME, count(*) as count from catalog_page UNION 
select 'catalog_returns' AS TABLE_NAME, count(*) as count from catalog_returns UNION 
select 'catalog_sales' AS TABLE_NAME, count(*) as count from catalog_sales UNION 
select 'customer_address' AS TABLE_NAME, count(*) as count from customer_address UNION 
select 'customer_demographics' AS TABLE_NAME, count(*) as count from customer_demographics UNION 
select 'customer' AS TABLE_NAME, count(*) as count from customer UNION 
select 'date_dim' AS TABLE_NAME, count(*) as count from date_dim UNION 
select 'household_demographics' AS TABLE_NAME, count(*) as count from household_demographics UNION 
select 'income_band' AS TABLE_NAME, count(*) as count from income_band UNION 
select 'inventory' AS TABLE_NAME, count(*) as count from inventory UNION 
select 'item' AS TABLE_NAME, count(*) as count from item UNION 
select 'promotion' AS TABLE_NAME, count(*) as count from promotion UNION 
select 'reason' AS TABLE_NAME, count(*) as count from reason UNION 
select 'ship_mode' AS TABLE_NAME, count(*) as count from ship_mode UNION 
select 'store_returns' AS TABLE_NAME, count(*) as count from store_returns UNION 
select 'store_sales' AS TABLE_NAME, count(*) as count from store_sales UNION 
select 'store' AS TABLE_NAME, count(*) as count from store UNION 
select 'time_dim' AS TABLE_NAME, count(*) as count from time_dim UNION 
select 'warehouse' AS TABLE_NAME, count(*) as count from warehouse UNION 
select 'web_page' AS TABLE_NAME, count(*) as count from web_page UNION 
select 'web_returns' AS TABLE_NAME, count(*) as count from web_returns UNION 
select 'web_sales' AS TABLE_NAME, count(*) as count from web_sales UNION 
select 'web_site' AS TABLE_NAME, count(*) as count from web_site
;