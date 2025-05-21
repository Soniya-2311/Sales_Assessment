CREATE VIEW OrderShippingMatched AS
WITH order_ranked AS (
  SELECT 
    Order_Id, Customer_Id, Item_Name, Amount,
    ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY Order_Id ASC) AS rn_asc,
    ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY Order_Id DESC) AS rn_desc
  FROM Orders
),
shipping_ranked AS (
  SELECT 
    Shipping_Id, Customer_Id, Status,
    ROW_NUMBER() OVER (
      PARTITION BY Customer_Id, Status
      ORDER BY 
        CASE WHEN Status = 'Delivered' THEN Shipping_Id END ASC,
        CASE WHEN Status = 'Pending' THEN Shipping_Id END DESC
    ) AS rn_by_status,
    ROW_NUMBER() OVER (PARTITION BY Customer_Id ORDER BY Shipping_Id ASC) AS rn_asc
  FROM Shipping
),
orders_1 AS (
  SELECT Customer_Id
  FROM Orders
  GROUP BY Customer_Id
  HAVING COUNT(*) = 1
),
shipping_1 AS (
  SELECT Customer_Id
  FROM Shipping
  GROUP BY Customer_Id
  HAVING COUNT(*) = 1
),
customers_with_1_each AS (
  SELECT o.Customer_Id
  FROM orders_1 o
  INNER JOIN shipping_1 s ON o.Customer_Id = s.Customer_Id
),
delivered_match AS (
  SELECT 
    o.Order_Id, o.Item_Name, o.Amount, o.Customer_Id,
    s.Shipping_Id, s.Status
  FROM order_ranked o
  JOIN shipping_ranked s 
    ON o.Customer_Id = s.Customer_Id 
   AND o.rn_asc = 1 
   AND s.Status = 'Delivered' AND s.rn_by_status = 1
   AND o.Customer_Id IN (SELECT Customer_Id FROM customers_with_1_each)
),
pending_match AS (
  SELECT 
    o.Order_Id, o.Item_Name, o.Amount, o.Customer_Id,
    s.Shipping_Id, s.Status
  FROM order_ranked o
  JOIN shipping_ranked s 
    ON o.Customer_Id = s.Customer_Id 
   AND o.rn_desc = 1 
   AND s.Status = 'Pending' AND s.rn_by_status = 1
   AND o.Customer_Id IN (SELECT Customer_Id FROM customers_with_1_each)
),
combined_matches AS (
  SELECT * FROM delivered_match
  UNION
  SELECT * FROM pending_match
)
SELECT 
  cm.Customer_Id,
  c.Country,
  cm.Order_Id,
  cm.Item_Name,
  cm.Amount,
  1 AS Quantity,
  cm.Shipping_Id,
  cm.Status
FROM combined_matches cm
JOIN Customers c ON cm.Customer_Id = c.Customer_Id;