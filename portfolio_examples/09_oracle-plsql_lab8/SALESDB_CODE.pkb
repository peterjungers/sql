/*
Peter Jungers
SQL Portfolio Examples 9
Oracle PL/SQL
*/



CREATE OR REPLACE PACKAGE BODY SALESDB_CODE AS

    -----------------------------------------------------------
    -- Function calculates and returns SUM(Price*Qty) for a given OrderID
    
    FUNCTION GET_ORDERTOTAL(argOrderID NUMBER) RETURN NUMBER IS
    
        v_Dummy NUMBER;
        v_ReturnValue NUMBER;
        
    BEGIN
        -- Determine if argOrderID exists
        SELECT ORDERS.OrderID
        INTO v_Dummy
        FROM ORDERS
        WHERE ORDERS.OrderID = argOrderID;
        
        IF v_Dummy IS NULL THEN
            RAISE NO_DATA_FOUND;
        END IF;
    
        -- If argOrderID exists, return its SUM(INVENTORY.Price * ORDERITEMS.Qty)
        SELECT NVL(SUM(INVENTORY.Price * ORDERITEMS.Qty), 0)
        INTO v_ReturnValue
        FROM INVENTORY
            LEFT JOIN ORDERITEMS
                ON INVENTORY.PartID = ORDERITEMS.PartID
        WHERE ORDERITEMS.OrderID = argOrderID;
        
        RETURN v_ReturnValue;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid OrderID');
            RETURN -1;
        
    END GET_ORDERTOTAL;
    
    -----------------------------------------------------------
    /*
    Function calculates and returns SUM(Price*Qty) for a given EmpID, 
    subtracting Salary
    */
    
    FUNCTION GET_PROFITABILITY(argEmpID NUMBER) RETURN NUMBER IS
    
        v_ReturnValue NUMBER;
        
    BEGIN
        SELECT PROFIT_TABLE.Profitability
        INTO v_ReturnValue
        FROM (
            SELECT SALESPERSONS.EmpID,
                NVL(SUM(INVENTORY.Price * ORDERITEMS.Qty), 0)
                    - SALESPERSONS.Salary AS Profitability
            FROM SALESPERSONS
                LEFT JOIN ORDERS
                    ON SALESPERSONS.EmpID = ORDERS.EmpID
                LEFT JOIN ORDERITEMS
                    ON ORDERS.OrderID = ORDERITEMS.OrderID
                LEFT JOIN INVENTORY
                    ON ORDERITEMS.PartID = INVENTORY.PartID
            GROUP BY SALESPERSONS.EmpID,
                SALESPERSONS.Salary
        ) PROFIT_TABLE
        WHERE PROFIT_TABLE.EmpID = argEmpID;
        
        RETURN v_ReturnValue;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid EmpID');
            RETURN -1;
            
    END GET_PROFITABILITY;
    
    -----------------------------------------------------------
    /*
    Function determines what the new Detail value should be for a
    given OrderID
    */
    
    FUNCTION GET_NEWDETAIL(argOrderID NUMBER) RETURN NUMBER IS
    
        v_Dummy NUMBER;
        v_ReturnValue NUMBER;
        
    BEGIN
        -- Determine if argOrderID exists
        SELECT ORDERS.OrderID
        INTO v_Dummy
        FROM ORDERS
        WHERE ORDERS.OrderID = argOrderID;
        
        IF v_Dummy IS NULL THEN
            RAISE NO_DATA_FOUND;
        END IF;
    
        -- If argCustID exists, return new Detail value
        SELECT NVL(MAX(ORDERITEMS.Detail), 0) + 1
        INTO v_ReturnValue
        FROM ORDERS
            LEFT JOIN ORDERITEMS ON
                ORDERS.OrderID = ORDERITEMS.OrderID
        WHERE ORDERS.OrderID = argOrderID;
        
        RETURN v_ReturnValue;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Invalid OrderID');
            RETURN -2;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error:' || SQLERRM);
            RETURN -1;
            
    END GET_NEWDETAIL;
    
    -----------------------------------------------------------
    /*
    Procedure adds a new line item and reduces the corresponding Stockqty
    for the specified PartID.  If it results in negative, fail and ROLLBACK;
    otherwise COMMIT transaction.
    Note: no validation steps needed; assume inputs are good.
    */
    
    PROCEDURE ADDLINEITEM(argOrderID NUMBER, argPartID NUMBER, argQty NUMBER)
        IS
        
        v_UpdatedStockQty NUMBER;
        v_Detail NUMBER;
        x_NegativeStockQty EXCEPTION;
        
    BEGIN
        -- Get new ORDERITEMS.Detail value
        v_Detail := SALESDB_CODE.GET_NEWDETAIL(argOrderID);
    
        -- INSERT arguments into ORDERITEMS
        INSERT INTO ORDERITEMS (
            OrderID,
            Detail,
            PartID,
            Qty
        )
        VALUES (
            argOrderID,
            v_Detail,
            argPartID,
            argQty
        );
        
        -- Run UPDATE on INVENTORY.StockQty
        UPDATE INVENTORY
        SET StockQty = StockQty - argQty
        WHERE PartID = argPartID;
        
        -- Determine if updated INVENTORY.StockQty < 0
        SELECT INVENTORY.StockQty
        INTO v_UpdatedStockQty
        FROM INVENTORY
        WHERE PartID = argPartID;
        
        IF v_UpdatedStockQty < 0 THEN
            RAISE x_NegativeStockQty;
        ELSE
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Transaction successful! New line item:');
            DBMS_OUTPUT.PUT_LINE('OrderID: ' || argOrderID);
            DBMS_OUTPUT.PUT_LINE('Detail: ' || v_Detail);
            DBMS_OUTPUT.PUT_LINE('PartID: ' || argPartID);
            DBMS_OUTPUT.PUT_LINE('Quantity desired: ' || argQty);
        END IF;
        
    EXCEPTION
        WHEN x_NegativeStockQty THEN
            DBMS_OUTPUT.PUT_LINE('Transaction cancelled:');
            DBMS_OUTPUT.PUT_LINE('Quantity desired would reduce ' ||
                'StockQty of PartID ' || argPartID || ' to less than zero');
            ROLLBACK;
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error' || SQLERRM);
     
    END ADDLINEITEM;

END SALESDB_CODE;
