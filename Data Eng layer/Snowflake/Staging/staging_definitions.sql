CREATE OR REPLACE TABLE ADDRESS(
    POSTAL_CODE INT,
    COUNTRY STRING,
    CITY STRING,
    STATE STRING,    
    REGION STRING
)


CREATE OR REPLACE TABLE PRODUCTS(
    Product_ID STRING,
    Category STRING,
    SubCategory STRING,
    Product_Name STRING
)


CREATE OR REPLACE TABLE CUSTOMERS(
    Customer_ID STRING,
    Customer_Name STRING,
    Segment STRING
)


CREATE OR REPLACE TABLE SALES(
    Row_ID int,
    Order_ID string,
    Order_Date date,
    Ship_Date date,
    Ship_Mode string,
    Customer_ID string,
    Postal_Code int,
    Product_ID string,
    Sales decimal(10,2),
    Quantity int,
    Discount decimal(10,2),
    Profit decimal(10,2)
)