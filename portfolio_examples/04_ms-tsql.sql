/*
Peter Jungers
SQL Portfolio Examples 4
MS T-SQL
*/



USE SalesDB
GO



PRINT '================================================================================' + CHAR(10)
PRINT 'Who ordered the most quantity?' + CHAR(10)
/* 
Projection: CUSTOMERS.CustID, CUSTOMERS.Cname, SUM(ORDERITEMS.Qty)
Instructions: Display the customer id, customer name, and total quantity of parts ordered 
by the customer who has ordered the greatest quantity. 
For this query you will sum the quantity for all order items of all orders 
associated with each customer to determine which customer has ordered the most quantity.
*/

GO


SELECT TOP 1
    CUSTOMERS.CustID,
    CUSTOMERS.Cname,
    SUM(ORDERITEMS.Qty) AS TotalQuantity
FROM CUSTOMERS
    INNER JOIN ORDERS ON CUSTOMERS.CustID = ORDERS.CustID
    INNER JOIN ORDERITEMS ON ORDERS.OrderID = ORDERITEMS.OrderID
GROUP BY CUSTOMERS.CustID, CUSTOMERS.Cname
ORDER BY TotalQuantity DESC;

GO



PRINT 'What is the dollar total for each of the salespeople?' + CHAR(10) 
PRINT 'Calculate totals for all salespeople (even if they have no sales).' + CHAR(10)
/*
Columns to display: SALESPERSONS.EmpID, SALESPERSONS.Ename, SUM(ORDERITEMS.Qty*INVENTORY.Price) 
Display the total dollar value that each and every sales person has sold.
List in dollar value descending.
NOTE: You need to include all salespeople, not just those salespeople with orders;
so you cannot do a simple inner JOIN. The outer JOIN picks up all salespeople.  
The warning statement is because of the NULL and can be disregarded.
*/

GO


SELECT SALESPERSONS.EmpID,
    SALESPERSONS.Ename,
    SUM(ORDERITEMS.Qty * INVENTORY.Price) AS DollarTotal
FROM SALESPERSONS
    LEFT OUTER JOIN ORDERS
        ON SALESPERSONS.EmpID = ORDERS.EmpID
    LEFT OUTER JOIN ORDERITEMS
        ON ORDERS.OrderID = ORDERITEMS.OrderID
    LEFT OUTER JOIN INVENTORY
        ON ORDERITEMS.PartID = INVENTORY.PartID
GROUP BY SALESPERSONS.EmpID, SALESPERSONS.Ename
ORDER BY DollarTotal DESC;

GO
