--STREAM PRODUCTS STAGING TABLE

CREATE STREAM products_stream ON TABLE supersalesstore.staging.products;

-- TASK CREATED TO COLLECT DATA FROM STREAM AND INSERT INTO DW.
CREATE OR REPLACE TASK task_dim_products
WAREHOUSE = COMPUTE_WH
SCHEDULE = '15 MINUTE'
AS
INSERT INTO supersalesstore.dw.dim_products (product_id, category, product_name)
SELECT
  ps.product_id,
  ps.category,
  ps.product_name
FROM
  products_stream ps
WHERE
  ps.METADATA$ACTION = 'INSERT';



--STREAM CUSTOMERS STAGING TABLE

CREATE STREAM customers_stream ON TABLE supersalesstore.staging.customers;

-- TASK CREATED TO COLLECT DATA FROM STREAM AND INSERT INTO DW.
CREATE OR REPLACE TASK task_dim_customers
WAREHOUSE = COMPUTE_WH
AFTER task_dim_products
AS
INSERT INTO supersalesstore.dw.dim_customers (customer_id, customer_name, segment)
SELECT
    cs."Customer ID",
    cs."Customer Name",
    cs.segment
FROM 
    customers_stream cs
WHERE
cs.METADATA$ACTION = 'INSERT';



--STREAM ADDRESS STAGING TABLE

CREATE STREAM address_stream ON TABLE supersalesstore.staging.address;

-- TASK CREATED TO COLLECT DATA FROM STREAM AND INSERT INTO DW.
CREATE OR REPLACE TASK task_dim_address
WAREHOUSE = COMPUTE_WH
AFTER task_dim_customers
AS
INSERT INTO supersalesstore.dw.dim_address (postal_code, country, city, state, region)
SELECT 
    ads."Postal Code",
    ads.country,
    ads.city,
    ads.state,
    ads.region
FROM
    address_stream ads
WHERE 
    ads.METADATA$ACTION = 'INSERT';



--STREAM SALES STAGING TABLE

CREATE STREAM sales_stream ON TABLE supersalesstore.staging.sales;

-- TASK CREATED TO COLLECT DATA FROM STREAM AND INSERT INTO DW.
CREATE OR REPLACE TASK task_fact_sales
WAREHOUSE = COMPUTE_WH
AFTER task_dim_address
AS
INSERT INTO supersalesstore.dw.fact_sales (row_id, order_id, ship_mode, sk_product, sk_address, sk_customer, sk_order_date, sk_ship_date, sales, quantity, discount, profit)
SELECT 
    ss.row_id,
    ss.order_id,  
    ss.ship_mode,    
    (SELECT MAX(sk_product) FROM supersalesstore.dw.dim_products WHERE product_id = ss.product_id) as sk_product,
    (SELECT MAX(sk_address) FROM supersalesstore.dw.dim_address WHERE postal_code = ss.postal_code) as sk_address,
    (SELECT MAX(sk_customer) FROM supersalesstore.dw.dim_customers WHERE customer_id = ss.customer_id) as sk_customer,
    (SELECT MAX(sk_date) FROM supersalesstore.dw.dim_dates WHERE date = ss.order_date) as sk_order_date,
    (SELECT MAX(sk_date) FROM supersalesstore.dw.dim_dates WHERE date = ss.ship_date) as sk_ship_date,
    ss.sales,
    ss.quantity,
    ss.discount,
    ss.profit
FROM 
    sales_stream ss
WHERE 
    ss.METADATA$ACTION = 'INSERT';


-- ALTER TASK task_fact_sales RESUME
-- ALTER TASK task_dim_address RESUME
-- ALTER TASK task_dim_customers RESUME
-- ALTER TASK task_dim_products RESUME