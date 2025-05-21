use data_analytics;
-- the total amount spent and the country for the Pending delivery status for each country.
SELECT
Country,
SUM(Amount) AS Total_Amount_Spent
FROM
OrderShippingMatched
WHERE
Status = 'Pending'
GROUP BY
Country;

-- The maximum product purchased for each country
WITH CountryProductSales AS (
SELECT
Country,
Item_Name,
SUM(Quantity) AS Total_Quantity
FROM SalesDetails
GROUP BY Country, Item_Name
)
SELECT
cps.Country,
cps.Item_Name,
cps.Total_Quantity
FROM CountryProductSales cps
JOIN (
SELECT
Country,
MAX(Total_Quantity) AS Max_Quantity
FROM CountryProductSales
GROUP BY Country
) maxprod
ON cps.Country = maxprod.Country
AND cps.Total_Quantity = maxprod.Max_Quantity;

-- the total number of transactions, total quantity sold, and total amount spent for each customer, along with the product details.
SELECT
Customer_Id,
Full_Name,
Country,
Item_Name,
COUNT(Order_Id) AS Total_Transactions,
SUM(Quantity) AS Total_Quantity_Sold,
SUM(Amount) AS Total_Amount_Spent
FROM SalesDetails
GROUP BY Customer_Id, Full_Name, Country, Item_Name
ORDER BY Customer_Id, Item_Name;

-- The most purchased product based on the age category less than 30 and above 30.
WITH AgeCategoryProductSales AS (
SELECT
Age_Category,
Item_Name,
SUM(Quantity) AS Total_Quantity
FROM SalesDetails
GROUP BY Age_Category, Item_Name
)
SELECT
acps.Age_Category,
acps.Item_Name,
acps.Total_Quantity
FROM AgeCategoryProductSales acps
JOIN (
SELECT
Age_Category,
MAX(Total_Quantity) AS Max_Quantity
FROM AgeCategoryProductSales
GROUP BY Age_Category
) maxcat
ON acps.Age_Category = maxcat.Age_Category
AND acps.Total_Quantity = maxcat.Max_Quantity;

-- The country that had minimum transactions and sales amount.

-- Minimum Transactions
SELECT
Country,
COUNT(Order_Id) AS Total_Transactions
FROM SalesDetails
GROUP BY Country
ORDER BY Total_Transactions ASC
LIMIT 1;
-- Minimum Sales Amount
SELECT
Country,
SUM(Amount) AS Total_Sales_Amount
FROM SalesDetails
GROUP BY Country
ORDER BY Total_Sales_Amount ASC
LIMIT 1;