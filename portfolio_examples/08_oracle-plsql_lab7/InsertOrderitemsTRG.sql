/*
Peter Jungers
SQL Portfolio Examples 8
Oracle PL/SQL
*/



/*
InsertOrderitemsTRG
Trigger runs before an insert on the ORDERITEMS table.  Dynamically calculates 
the new Detail value for the specified OrderID and assigns it to :NEW.Detail
(overriding any invalid or NULL values).  Update the INVENTORY table to reduce
StockQty by the :NEW.Qty value for this row.  Determines whether a custom 
exception resulted from that operation; if so, it raises a custom exception.
*/


CREATE OR REPLACE TRIGGER InsertOrderitemsTRG
BEFORE INSERT ON ORDERITEMS
FOR EACH ROW

DECLARE
    v_Detail ORDERITEMS.Detail%TYPE;
    
    x_UpdateError EXCEPTION;
    PRAGMA EXCEPTION_INIT(x_UpdateError, -20000);
    
BEGIN
    -- Create new ORDERITEMS.Detail value
    SELECT NVL(MAX(Detail) + 1, 1)
    INTO v_Detail
    FROM ORDERITEMS
    WHERE OrderID = :NEW.OrderID;
    
    :NEW.Detail := v_Detail;
 
    -- Run UPDATE on INVENTORY.StockQty
    UPDATE INVENTORY
    SET StockQty = StockQty - :NEW.Qty
    WHERE PartID = :NEW.PartID;
    
EXCEPTION
    WHEN x_UpdateError THEN
        DBMS_OUTPUT.PUT_LINE('Transaction canceled: ' ||
            'Unable to update INVENTORY.StockQty');
        RAISE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
END;
