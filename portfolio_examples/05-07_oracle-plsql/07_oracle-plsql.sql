/*
Peter Jungers
SQL Portfolio Examples 7
Oracle PL/SQL
*/



/*
Write a PL/SQL program that includes an SQL statement that finds the
partid, description, and price of the highest priced item in our inventory.
Format your output line as "Part Number <vPartid> described as <vDescription>
is the highest priced item in inventory at <vPrice>". Do not handle the
case of there being two parts with the same, highest price - save that for
the next question. Use the OTHERS EXCEPTION to display the SQLERRM. Your
output line should look like the following:
Part Number 9999 described as XXXXXX is the highest priced item in
inventory at $9999.99
*/


SET SERVEROUTPUT ON;

DECLARE
    vPartID INVENTORY.PartID%TYPE;
    vDescription INVENTORY.Description%TYPE;
    vPrice INVENTORY.Price%TYPE;
    
BEGIN
    SELECT INVENTORY.PartID,
        INVENTORY.Description,
        INVENTORY.Price
    INTO vPartID,
        vDescription,
        vPrice
    FROM INVENTORY
    WHERE INVENTORY.Price = (
        SELECT MAX(INVENTORY.Price)
        FROM INVENTORY
    );
    
    DBMS_OUTPUT.PUT_LINE('Part Number ' || vPartID ||
        ' described as ' || RTRIM(vDescription) ||
        ' is the highest priced item in inventory at ' ||
        LTRIM(TO_CHAR(vPrice, '$999,999.99')));
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        
END;



/*
What would happen if there were two or more items that have that same
highest price? (Let's say that the highest price is $80 and there are two
or more items that have that price.) Write the PL/SQL program that would
handle this situation. This requires using a CURSOR and a LOOP with a FETCH.
Use the OTHERS EXCEPTION to display the SQLERRM. Test your code for more
than one item with the highest price. Update your table in order to test
this condition (you can change a price in one of the already existing
partid's to match the maximum price, or INSERT a new row).
*/


SET SERVEROUTPUT ON;

DECLARE
    CURSOR c_inventory IS 
        SELECT INVENTORY.PartID,
            INVENTORY.Description,
            INVENTORY.Price
        FROM INVENTORY
        WHERE INVENTORY.Price = (
            SELECT MAX(INVENTORY.Price)
            FROM INVENTORY
        );
        
    max_price_row c_inventory%ROWTYPE;
    
BEGIN
    OPEN c_inventory;
    FETCH c_inventory INTO max_price_row;
    WHILE c_inventory%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Part Number ' || max_price_row.PartID ||
            ' described as ' || RTRIM(max_price_row.Description) ||
            ' is the highest priced item in inventory at ' ||
            LTRIM(TO_CHAR(max_price_row.Price, '$999,999.99')));
        FETCH c_inventory INTO max_price_row;
    END LOOP;
    CLOSE c_inventory;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    
END;
        
        

/*
Write a PL/SQL program with no CURSOR to input a custid and then
display the customer's name and the total amount of all the customer's
orders. The output for each test should be two values: the customer's
name and the total amount the customer has ordered. Test your program
with a good customer id, a customer id that does not exist in the database,
and a customer id that exists in the database but has no orders. Be sure
to distinguish between a nonexistent customer and a customer that exists
but has no orders (i.e. display different output for each situation).
Use the NO_DATA_FOUND and OTHERS EXCEPTION handlers.
*/


SET SERVEROUTPUT ON;

DECLARE
    vCustID CUSTOMERS.CustID%TYPE;
    vCname CUSTOMERS.Cname%TYPE;
    vTotalAmount INVENTORY.Price%TYPE;
    
BEGIN
    vCustID := &EnterCustID;

    SELECT CUSTOMERS.Cname, SUM(INVENTORY.Price) AS TotalAmount
    INTO vCname, vTotalAmount
    FROM CUSTOMERS
        LEFT JOIN ORDERS ON
            CUSTOMERS.CustID = ORDERS.CustID
        LEFT JOIN ORDERITEMS ON
            ORDERS.OrderID = ORDERITEMS.OrderID
        LEFT JOIN INVENTORY ON
            ORDERITEMS.PartID = INVENTORY.PartID
    WHERE CUSTOMERS.CustID = vCustID
    GROUP BY CUSTOMERS.Cname;
    
    IF vTotalAmount IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE(vCname || TO_CHAR(vTotalAmount, '$999,999.99'));
    ELSE
        DBMS_OUTPUT.PUT_LINE(RTRIM(vCname) ||
            ' (CustID ' || vCustID || ') has not placed any orders');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('CustID does not exists');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
END;



/*
Write a PL/SQL program using a CURSOR for the same problem as above.
Do all the same tests and hopefully get the same results! Use the
NO_DATA_FOUND and OTHERS exception handlers. The customer that has no
orders can be checked using %ROWCOUNT in a condition.
*/


SET SERVEROUTPUT ON;

DECLARE
    vCustID CUSTOMERS.CustID%TYPE;

    CURSOR c_cust_amount IS
        SELECT CUSTOMERS.Cname,
            SUM(INVENTORY.Price) AS TotalAmount
        FROM CUSTOMERS
            LEFT JOIN ORDERS ON
                CUSTOMERS.CustID = ORDERS.CustID
            LEFT JOIN ORDERITEMS ON
                ORDERS.OrderID = ORDERITEMS.OrderID
            LEFT JOIN INVENTORY ON
              ORDERITEMS.PartID = INVENTORY.PartID
        WHERE CUSTOMERS.CustID = vCustID
        GROUP BY CUSTOMERS.Cname;
        
    cust_row   c_cust_amount%ROWTYPE;
        
    
BEGIN
    vCustID := &EnterCustID;
    
    OPEN c_cust_amount;
    FETCH c_cust_amount INTO cust_row;
    IF c_cust_amount%FOUND THEN
        IF cust_row.TotalAmount IS NOT NULL THEN
            DBMS_OUTPUT.PUT_LINE(cust_row.Cname ||
                TO_CHAR(cust_row.TotalAmount, '$999,999.99'));
        ELSE
            DBMS_OUTPUT.PUT_LINE(RTRIM(cust_row.Cname) ||
                ' (CustID ' || vCustID || ') has not placed any orders');
        END IF;
    ELSE RAISE NO_DATA_FOUND;
    END IF;
    CLOSE c_cust_amount;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('CustID does not exist');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    
END;



/*
Write a PL/SQL program to input a custid (&Custid). Display the
customer’s name, and the orderid, salesdate, and total value of each
order for that customer. Produce the output in descending order by total
value of each order. This output will produce one or more lines for the
customer, depending on how many orders that customer has made. Test your
program with a good custid, a custid that is not in the CUSTOMERS table,
and one that is in the CUSTOMERS table but has no orders. Be sure to
distinguish between the customer that does not exist and a customer that
exists but has no orders (as above: display different output for each
situation). Use the NO_DATA_FOUND and OTHERS exception handlers.
*/


SET SERVEROUTPUT ON;

DECLARE
    vCustID CUSTOMERS.CustID%TYPE;
    
    CURSOR c_cust_orders IS
        SELECT CUSTOMERS.CustID,
            CUSTOMERS.Cname,
            ORDERS.OrderID,
            ORDERS.Salesdate,
            NVL(SUM(INVENTORY.Price), 0) AS TotalValue
        FROM CUSTOMERS
            LEFT JOIN ORDERS
                ON CUSTOMERS.Custid = ORDERS.CustID
            LEFT JOIN ORDERITEMS
                ON ORDERS.Orderid = ORDERITEMS.OrderID
            LEFT JOIN INVENTORY
                ON ORDERITEMS.PartID = INVENTORY.PartID
        WHERE CUSTOMERS.CustID = vCustID
        GROUP BY CUSTOMERS.CustID,
            CUSTOMERS.Cname,
            ORDERS.OrderID,
            ORDERS.Salesdate
        ORDER BY TotalValue DESC;
        
    cust_row   c_cust_orders%ROWTYPE;
    
BEGIN
    vCustID := &EnterCustID;
    
    OPEN c_cust_orders;
    FETCH c_cust_orders INTO cust_row;
    IF cust_row.CustID IS NOT NULL THEN
        IF cust_row.OrderID IS NOT NULL THEN
            WHILE c_cust_orders%FOUND LOOP
                DBMS_OUTPUT.PUT_LINE(RPAD(cust_row.Cname, 27) ||
                    RPAD(cust_row.OrderID, 6) ||
                    RPAD(TO_CHAR(cust_row.Salesdate, 'MM/DD/YY'), 10) ||
                    TO_CHAR(cust_row.TotalValue, '$999,999.99'));
                FETCH c_cust_orders INTO cust_row;
            END LOOP;
        ELSE
            DBMS_OUTPUT.PUT_LINE(RTRIM(cust_row.Cname) ||
                ' (CustID ' || vCustID || ') has not placed any orders');
        END IF;    
    ELSE RAISE NO_DATA_FOUND;
    END IF;
    CLOSE c_cust_orders;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('That CustID does not exist');
        CLOSE c_cust_orders;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);

END;
