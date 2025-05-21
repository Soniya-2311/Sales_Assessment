-- ------------------------------
-- 1. NULL / MISSING VALUES
-- ------------------------------

-- Null checks in Customers
SELECT * FROM Customers 
WHERE First_Name IS NULL OR Last_Name IS NULL OR Age IS NULL OR Country IS NULL;

-- Null checks in Orders
SELECT * FROM Orders 
WHERE Item_Name IS NULL OR Amount IS NULL OR Customer_Id IS NULL;

-- Null checks in Shipping
SELECT * FROM Shipping 
WHERE Status IS NULL OR Customer_Id IS NULL;

-- ------------------------------
-- 2. INVALID VALUE RANGES
-- ------------------------------

-- Invalid Age
SELECT * FROM Customers WHERE Age < 0 OR Age > 120;

-- Negative Amount
SELECT * FROM Orders WHERE Amount < 0;

-- Invalid Status in Shipping
SELECT * FROM Shipping 
WHERE Status NOT IN ('Pending', 'Delivered');

-- View all distinct status values
SELECT DISTINCT Status FROM Shipping;

-- ------------------------------
-- 3. DUPLICATES & UNIQUENESS
-- ------------------------------

-- Duplicate Customer_IDs
SELECT Customer_Id, COUNT(*) 
FROM Customers 
GROUP BY Customer_Id 
HAVING COUNT(*) > 1;

-- Duplicate Order_IDs
SELECT Order_Id, COUNT(*) 
FROM Orders 
GROUP BY Order_Id 
HAVING COUNT(*) > 1;

-- Duplicate Shipping_IDs
SELECT Shipping_Id, COUNT(*) 
FROM Shipping 
GROUP BY Shipping_Id 
HAVING COUNT(*) > 1;

-- ------------------------------
-- 4. FOREIGN KEY VALIDATION
-- ------------------------------

-- Orders referencing non-existent customers
SELECT * FROM Orders 
WHERE Customer_Id NOT IN (SELECT Customer_Id FROM Customers);

-- Shipping referencing non-existent customers
SELECT * FROM Shipping 
WHERE Customer_Id NOT IN (SELECT Customer_Id FROM Customers);

-- ------------------------------
-- 5. JOIN VALIDATION & ORPHANS
-- ------------------------------

-- Customers without any orders (Total 90 Customers)
SELECT c.Customer_Id 
FROM Customers c
LEFT JOIN Orders o ON c.Customer_Id = o.Customer_Id
WHERE o.Customer_Id IS NULL;

-- Customers without any shipping (Total 96 Customers)
SELECT c.Customer_Id 
FROM Customers c
LEFT JOIN Shipping s ON c.Customer_Id = s.Customer_Id
WHERE s.Customer_Id IS NULL;

-- Orders without corresponding shipping ( 94 records)
SELECT o.Order_Id, o.Customer_Id 
FROM Orders o
LEFT JOIN Shipping s ON o.Customer_Id = s.Customer_Id
WHERE s.Customer_Id IS NULL;

-- Shipping without any orders (98 records)
SELECT s.Shipping_Id, s.Customer_Id 
FROM Shipping s
LEFT JOIN Orders o ON s.Customer_Id = o.Customer_Id
WHERE o.Customer_Id IS NULL;

-- ------------------------------
-- 6. JOIN CARDINALITY ANALYSIS
-- ------------------------------

-- Number of orders per customer (160 records)
SELECT Customer_Id, COUNT(*) AS Order_Count 
FROM Orders 
GROUP BY Customer_Id 
ORDER BY Order_Count DESC;

-- Number of shipments per customer (154 records)
SELECT Customer_Id, COUNT(*) AS Shipping_Count 
FROM Shipping 
GROUP BY Customer_Id 
ORDER BY Shipping_Count DESC;

-- ------------------------------
-- 7. BASIC METRICS SUMMARY (250 records each table)
-- ------------------------------

SELECT 
  (SELECT COUNT(*) FROM Customers) AS Total_Customers,
  (SELECT COUNT(*) FROM Orders) AS Total_Orders,
  (SELECT COUNT(*) FROM Shipping) AS Total_Shipping,
  (SELECT COUNT(Distinct Customer_Id) FROM Customers) AS No_Of_Customers,
  (SELECT COUNT(DISTINCT Item_name) FROM ORDERs) AS Unique_Items,
  (SELECT COUNT(DISTINCT Country) FROM Customers) AS Unique_Countries;


