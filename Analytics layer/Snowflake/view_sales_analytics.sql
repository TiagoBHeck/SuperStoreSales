create or replace view SUPERSALESSTORE.DW.VIEW_SALESSTORE(
	ORDER_ID,
	ORDER_DATE,
	SHIP_DATE,
	SHIP_MODE,
	PRODUCT_NAME,
	CATEGORY,
	CUSTOMER_NAME,
	SEGMENT,
	CITY,
	STATE,
	REGION,
	COUNTRY,
	LOCATION,
	SALES,
	QUANTITY,
	DISCOUNT,
	PROFIT
) as
select
 s.order_id,
 od.date as order_date,
 sd.date as ship_date,
 s.ship_mode,
 p.product_name,
 p.category, 
 c.customer_name,
 c.segment,
 a.city,
 a.state,
 a.region,
 a.country,
 CONCAT_WS('-', a.city, a.state) as location,
 s.sales,
 s.quantity,
 s.discount,
 s.profit
from 
    supersalesstore.dw.fact_sales as s
left outer join supersalesstore.dw.dim_dates as od on (s.sk_order_date = od.sk_date)
left outer join supersalesstore.dw.dim_dates as sd on (s.sk_ship_date = sd.sk_date)
left outer join supersalesstore.dw.dim_products as p on (s.sk_product = p.sk_product)
left outer join supersalesstore.dw.dim_customers as c on (s.sk_customer = c.sk_customer)
left outer join supersalesstore.dw.dim_address as a on (s.sk_address = a.sk_address);