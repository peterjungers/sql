/*
Peter Jungers
SQL Portfolio Examples 6
Oracle PL/SQL
*/



/*
Which sales people have NOT sold anything? Use a correlated subquery.
Columns to display: SALESPERSONS.ename 
Instructions: Display all employees that are not involved with an order, i.e. 
where the empid of the sales person does not appear in the ORDERS table.  
Display the names in alphabetical order.  Do not use joins at all - use 
sub-queries only. 
*/

SELECT SALESPERSONS.ename
FROM SALESPERSONS
WHERE NOT EXISTS (
    SELECT *
    FROM ORDERS
    WHERE ORDERS.empid = SALESPERSONS.empid
)
ORDER BY SALESPERSONS.ename;



/*
Who is our most profitable salesperson?
Columns to display: SALESPERSONS.empid, SALESPERSONS.ename, (SUM(ORDERITEMS.qty*INVENTORY.price) - SALESPERSONS.salary) 
Instructions: A salesperson's profit (or loss) is the difference between what the person sold and what the person earns ((SUM(ORDERITEMS.qty*INVENTORY.price) - SALESPERSONS.salary)).
If the value is positive then there is a profit, otherwise there is a loss.  
The most profitable salesperson, therefore, is the person with the greatest profit or smallest loss. 
Display the most profitable salesperson. 
*/


SELECT PLACE_TABLE.empid,
    PLACE_TABLE.ename,
    PLACE_TABLE.Profit
FROM (
    SELECT SALESPERSONS.empid,
        SALESPERSONS.ename,
        TO_CHAR(NVL(SUM(ORDERITEMS.qty * INVENTORY.price), 0) - SALESPERSONS.salary, '$9,999.99')
            AS Profit, -- Make orders 0 for employees with NULL orders in order to subtract salary
        DENSE_RANK() OVER (ORDER BY NVL(SUM(ORDERITEMS.qty * INVENTORY.price), 0) - SALESPERSONS.salary DESC)
            AS Place
    FROM SALESPERSONS
        LEFT JOIN ORDERS
            ON SALESPERSONS.empid = ORDERS.empid
        LEFT JOIN ORDERITEMS
            ON ORDERS.orderid = ORDERITEMS.orderid
        LEFT JOIN INVENTORY
            ON ORDERITEMS.partid = INVENTORY.partid
    GROUP BY SALESPERSONS.empid,
        SALESPERSONS.ename,
        SALESPERSONS.salary
) PLACE_TABLE
WHERE PLACE_TABLE.Place = 1;



/*
Give a raise to our best salesperson(s).
Columns to display: none 
Instructions: Write an UPDATE query to increase the value of 
the SALESPERSONS.salary column by 9% for the most profitable salesperson(s).
*/


UPDATE SALESPERSONS
SET SALESPERSONS.salary = SALESPERSONS.salary + (SALESPERSONS.salary * .09)
WHERE SALESPERSONS.empid = (
    SELECT PLACE_TABLE.empid
    FROM (
        SELECT SALESPERSONS.empid,
        DENSE_RANK() OVER (ORDER BY NVL(SUM(ORDERITEMS.qty * INVENTORY.price), 0) - SALESPERSONS.salary DESC)
            AS Place
        FROM SALESPERSONS
            LEFT JOIN ORDERS
                ON SALESPERSONS.empid = ORDERS.empid
         LEFT JOIN ORDERITEMS
                ON ORDERS.orderid = ORDERITEMS.orderid
         LEFT JOIN INVENTORY
                ON ORDERITEMS.partid = INVENTORY.partid
        GROUP BY SALESPERSONS.empid,
            SALESPERSONS.ename,
         SALESPERSONS.salary
    ) PLACE_TABLE
    WHERE PLACE_TABLE.Place = 1
);

COMMIT;
