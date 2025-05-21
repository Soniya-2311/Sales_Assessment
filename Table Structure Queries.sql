-- Main Table Structure Creation Queries


-- Orders Tables
CREATE TABLE Orders (
    Order_Id VARCHAR(20) PRIMARY KEY NOT NULL,
    Item_Name VARCHAR(255) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    Customer_Id VARCHAR(20),
    FOREIGN KEY (Customer_Id) REFERENCES Customers(Customer_Id)
);
-- Customers Table

CREATE TABLE Customers (
  Customer_Id VARCHAR(20) PRIMARY KEY NOT NULL,
  First_Name VARCHAR(100),
  Last_Name VARCHAR(100),
  Age INT,
  Country VARCHAR(50)
);

-- Shipping Table
CREATE TABLE Shipping (
  Shipping_Id VARCHAR(20) PRIMARY KEY NOT NULL,
  Status VARCHAR(30),
  Customer_Id VARCHAR(20),
  FOREIGN KEY (Customer_Id) REFERENCES Customers(Customer_Id)
);
