/*
Peter Jungers
SQL Portfolio Examples 8
Oracle PL/SQL
*/



/*
AddLineItemSP
Script creates a stored procedure which will be executed by Lab7.sql to create
a new row in the ORDERITEMS table.  Procedure will accept three input parameters
(OrderID, PartID, Qty) which will be used to INSERT a row into ORDERITEMS - 
deliberately omitting the Detail value (see InsertOrderitemsTRG; value will be
calculated and set in that trigger).  Determines whether a custom 
exception resulted from that operation; if so, it raises a custom exception and
executes ROLLBACK.  If not, it displays a success message and executes COMMIT.
*/


CREATE OR REPLACE PROCEDURE AddLineItemSP(
    p_OrderID ORDERITEMS.OrderID%TYPE,
    p_PartID ORDERITEMS.PartID%TYPE,
    p_QtyDesired ORDERITEMS.Qty%TYPE
    )
    IS
    
    x_InsertError EXCEPTION;
    PRAGMA EXCEPTION_INIT(x_InsertError, -20000);
    
BEGIN
    INSERT INTO ORDERITEMS(OrderID, PartID, Qty)
        VALUES(p_OrderID, p_PartID, p_QtyDesired);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transaction successful! ' ||
        'Line item has been added.');
    
EXCEPTION
    WHEN x_InsertError THEN
        DBMS_OUTPUT.PUT_LINE('Transaction canceled: ' ||
            'Line item could not be added to database');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
END AddLineItemSP;
