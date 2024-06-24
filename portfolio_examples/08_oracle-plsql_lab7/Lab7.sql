/*
Peter Jungers
SQL Portfolio Examples 8
Oracle PL/SQL
*/



/*
Lab7
Script accepts four input parameters via numeric-ampersand substitution and
performs a series of validations (identical to Lab6).  But instead of modifying
data it will simply execute the AddLineItemSP procedure, passing values for 
input parameters: (OrderID, PartID, Qty).
*/


DECLARE
    v_CustID CUSTOMERS.CustID%TYPE;
    v_OrderID ORDERS.OrderID%TYPE;
    v_PartID INVENTORY.PartID%TYPE;
    
    v_QtyDesired ORDERITEMS.Qty%TYPE;
    v_Dummy NUMBER;
    
    x_NoSuchCustID EXCEPTION;
    x_NoSuchOrderID EXCEPTION;
    x_NoSuchCustOrder EXCEPTION;
    x_NoSuchPartID EXCEPTION;
    x_NegativeQtyDesired EXCEPTION;
    
BEGIN
    v_CustID := &1;
    v_OrderID := &2;
    v_PartID := &3;
    v_QtyDesired := &4;
    
    -- Verify v_CustID exists in CUSTOMERS
    BEGIN
        SELECT CUSTOMERS.CustID
        INTO v_Dummy
        FROM CUSTOMERS
        WHERE CUSTOMERS.CustID = v_CustID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE x_NoSuchCustID;
    END;
    
    -- Verify v_OrderID exists in ORDERS
    BEGIN
        SELECT ORDERS.OrderID
        INTO v_Dummy
        FROM ORDERS
        WHERE ORDERS.OrderID = v_OrderID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE x_NoSuchOrderID;
    END;
    
    -- Verify v_CustID has placed v_OrderID
    BEGIN
        SELECT CUSTOMERS.CustID
        INTO v_Dummy
        FROM CUSTOMERS
        JOIN ORDERS
            ON CUSTOMERS.CustID = ORDERS.CustID
        WHERE CUSTOMERS.CustID = v_CustID
            AND ORDERS.OrderID = v_OrderID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE x_NoSuchCustOrder;
    END;
    
    -- Verify v_PartID exists in INVENTORY
    BEGIN
        SELECT INVENTORY.PartID
        INTO v_Dummy
        FROM INVENTORY
        WHERE INVENTORY.PartID = v_PartID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE x_NoSuchPartID;
    END;
    
    -- Verify v_QtyDesired > 0
    IF v_QtyDesired <= 0 THEN
        RAISE x_NegativeQtyDesired;
    END IF;
    
    -- Call stored procedure
    AddLineItemSP(v_OrderID, v_PartID, v_QtyDesired);
    
EXCEPTION
    WHEN x_NoSuchCustID THEN
        DBMS_OUTPUT.PUT_LINE('CustID ' || v_CustID || ' does not exist');
    WHEN x_NoSuchOrderID THEN
        DBMS_OUTPUT.PUT_LINE('OrderID ' || v_OrderID || ' does not exist');
    WHEN x_NoSuchCustOrder THEN
        DBMS_OUTPUT.PUT_LINE('CustID ' || v_CustID ||
            ' has no order with OrderID ' || v_OrderID);
    WHEN x_NoSuchPartID THEN
        DBMS_OUTPUT.PUT_LINE('PartID ' || v_PartID || ' does not exist');
    WHEN x_NegativeQtyDesired THEN
        DBMS_OUTPUT.PUT_LINE('Quantity desired must be greater than zero');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    
END;
