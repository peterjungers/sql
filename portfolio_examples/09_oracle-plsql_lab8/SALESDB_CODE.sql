/*
Peter Jungers
SQL Portfolio Examples 9
Oracle PL/SQL
*/



-----------------------------------------------------------
/*
Test FUNCTION GET_ORDERTOTAL
Function calculates and returns SUM(Price*Qty) for a given OrderID
*/

-- Valid OrderID
SELECT SALESDB_CODE.GET_ORDERTOTAL(6099)
FROM DUAL;
-- Invalid OrderID (returns -1)
SELECT SALESDB_CODE.GET_ORDERTOTAL(1000)
FROM DUAL;
-- Valid OrderID with no ORDERITEMS
SELECT SALESDB_CODE.GET_ORDERTOTAL(6107)
FROM DUAL;

-----------------------------------------------------------
/*
Test FUNCTION GET_PROFITABILITY
Function calculates and returns SUM(Price*Qty) for a given EmpID, 
subtracting Salary
*/

-- Valid EmpID with ORDERS
SELECT SALESDB_CODE.GET_PROFITABILITY(101)
FROM DUAL;
-- Valid EmpID with no ORDERS
SELECT SALESDB_CODE.GET_PROFITABILITY(110)
FROM DUAL;
-- Invalid EmpID (returns -1)
SELECT SALESDB_CODE.GET_PROFITABILITY(1)
FROM DUAL;

-----------------------------------------------------------
/*
Test FUNCTION GET_NEWDETAIL
Function determines what the new Detail value should be for a
given OrderID
*/

-- Valid OrderID with ORDERITEMS
SELECT SALESDB_CODE.GET_NEWDETAIL(6099)
FROM DUAL;
-- Valid OrderID with no ORDERITEMS (returns 1)
SELECT SALESDB_CODE.GET_NEWDETAIL(6107)
FROM DUAL;
-- Invalid OrderID (returns -2)
SELECT SALESDB_CODE.GET_NEWDETAIL(1000)
FROM DUAL;
        
-----------------------------------------------------------
/*
Test PROCEDURE ADDLINEITEM
Procedure adds a new line item and reduces the corresponding Stockqty
for the specified PartID.  If it results in negative, fail and ROLLBACK;
otherwise COMMIT transaction.
Note: no validation steps needed; assume inputs are good.
*/

-- Valid quantity desired (1)
BEGIN
    SALESDB_CODE.ADDLINEITEM(6099, 1001, 1);
END;
ROLLBACK;
-- Invalid quantity desired (101)
BEGIN
    SALESDB_CODE.ADDLINEITEM(6099, 1001, 101);
END;
