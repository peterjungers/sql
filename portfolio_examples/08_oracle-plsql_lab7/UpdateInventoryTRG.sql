/*
Peter Jungers
SQL Portfolio Examples 8
Oracle PL/SQL
*/



/*
UpdateInventoryTRG
Trigger runs before an update on the INVENTORY table.  Determines whether the 
resulting StockQty value is less than zero; if so, it raises a custom exception.
*/


CREATE OR REPLACE TRIGGER UpdateInventoryTRG
BEFORE UPDATE ON INVENTORY
FOR EACH ROW
    
DECLARE
    x_NegativeStockQty EXCEPTION;
    PRAGMA EXCEPTION_INIT(x_NegativeStockQty, -20000);
    
BEGIN
    IF :NEW.StockQty < 0 THEN
        RAISE x_NegativeStockQty;
    END IF;
    
EXCEPTION
    WHEN x_NegativeStockQty THEN
        DBMS_OUTPUT.PUT_LINE('Transaction canceled: ' ||
            'Quantity desired would reduce INVENTORY.StockQty of ' ||
            'INVENTORY.PartID ' || :NEW.PartID || ' to less than zero');
        RAISE;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
END;
