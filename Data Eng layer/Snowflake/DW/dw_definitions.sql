CREATE TABLE Dim_Products(
    sk_product INTEGER AUTOINCREMENT PRIMARY KEY,
    product_id varchar(50) not null,
    category varchar(50) not null,
    product_name varchar(500) not null    
)

CREATE TABLE Dim_Customers(
    sk_customer INTEGER AUTOINCREMENT PRIMARY KEY,
    customer_id varchar(50) not null,
    customer_name varchar(100) not null,
    segment varchar(50) null
)

CREATE TABLE Dim_Address(
    sk_address INTEGER AUTOINCREMENT PRIMARY KEY,
    postal_code integer not null,
    country varchar(50) not null,
    city varchar(50) not null,
    state varchar(50) not null,
    region varchar(50) not null
)

CREATE TABLE Dim_Dates (
  sk_date INTEGER AUTOINCREMENT PRIMARY KEY,
  date DATE NOT NULL UNIQUE,
  day INTEGER NOT NULL,
  month INTEGER NOT NULL,
  year INTEGER NOT NULL,
  quarter INTEGER NOT NULL
)

CREATE TABLE Fact_Sales(
    sk_sales INTEGER AUTOINCREMENT PRIMARY KEY,
    row_id integer not null,
    order_id varchar(100) not null,
    ship_mode varchar(50) null,
    sk_product integer not null,
    sk_address integer not null,
    sk_customer integer not null,
    sk_order_date integer not null,
    sk_ship_date integer not null,
    sales decimal(10,2) null,
    quantity integer null,
    discount decimal(10,2) null,
    profit decimal(10,2) null,
    FOREIGN KEY (sk_product) REFERENCES Dim_Products(sk_product),
    FOREIGN KEY (sk_address) REFERENCES Dim_Address(sk_address),
    FOREIGN KEY (sk_customer) REFERENCES Dim_Customers(sk_customer),
    FOREIGN KEY (sk_order_date) REFERENCES Dim_Dates(sk_date)
)
