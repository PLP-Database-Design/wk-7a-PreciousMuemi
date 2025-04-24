
CREATE TEMPORARY TABLE ProductDetail_1NF AS
SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM
    ProductDetail
CROSS JOIN
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3) AS numbers -- Assuming a maximum of 3 products per order
WHERE
    LENGTH(Products) - LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1;

SELECT * FROM ProductDetail_1NF;



-- Create a new Customers table
CREATE TABLE Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255)
);

-- Insert distinct OrderID and CustomerName into the Customers table
INSERT INTO Customers (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create the new OrderDetails table (without CustomerName)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product), -- Composite primary key
    FOREIGN KEY (OrderID) REFERENCES Customers(OrderID)
);

-- Insert data into the new OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- The original OrderDetails table can now be dropped or renamed
-- DROP TABLE OrderDetails;
-- OR
-- ALTER TABLE OrderDetails RENAME TO OrderDetails_Original;

-- Final view of the 2NF structure (joining the two tables to see the complete information)
SELECT
    c.OrderID,
    c.CustomerName,
    oi.Product,
    oi.Quantity
FROM
    Customers c
JOIN
    OrderItems oi ON c.OrderID = oi.OrderID;
