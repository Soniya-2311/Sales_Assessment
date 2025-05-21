CREATE VIEW SalesDetails AS
SELECT 
  o.Order_Id,
  o.Item_Name,
  o.Amount,
  1 AS Quantity,
  c.Customer_Id,
  CONCAT(c.First_Name, ' ', c.Last_Name) AS Full_Name,
  c.Age,
  CASE WHEN c.Age < 30 THEN 'Below 30' ELSE '30 and Above' END AS Age_Category,
  CASE 
    WHEN c.Age < 18 THEN 'Under 18'
    WHEN c.Age BETWEEN 18 AND 29 THEN '18-29'
    WHEN c.Age BETWEEN 30 AND 49 THEN '30-49'
    WHEN c.Age >= 50 THEN '50+'
  END AS Age_Group,
  CASE WHEN o.Amount >= 500 THEN 'High Value' ELSE 'Standard Value' END AS Order_Value_Type,
  ROW_NUMBER() OVER (PARTITION BY o.Customer_Id ORDER BY o.Order_Id ASC) AS Order_Sequence,
  c.Country
FROM Orders o
JOIN Customers c ON o.Customer_Id = c.Customer_Id;