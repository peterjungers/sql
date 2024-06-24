/*
Peter Jungers
SQL Portfolio Examples 8
Oracle PL/SQL
*/



/*
Test7
Script executes Lab7 with various combinations of input values to verify 
functionality in different scenarios.  Should work the same as Test6.sql
*/


SET SERVEROUTPUT ON;

/*
Variables tested:
@Lab7 v_CustID v_OrderID v_PartID v_QtyDesired
*/

/*
Test 1
Valid v_CustID, v_OrderID, v_PartID, v_QtyDesired
CustID has placed order with given OrderID
v_QtyDesired would not result in INVENTORY.StockQty < 0
PASS
*/
-- Check ORDERITEMS before running test:
SELECT *
FROM ORDERITEMS
WHERE ORDERITEMS.OrderID = 6099;
-- Check INVENTORY before running test:
SELECT *
FROM INVENTORY
WHERE PartID = 1001;
-- Test:
@Lab7 1 6099 1001 1;
-- Verify new ORDERITEMS row:
SELECT *
FROM ORDERITEMS
WHERE ORDERITEMS.OrderID = 6099;
--Verify INVENTORY.StockQty reduced by 1:
SELECT *
FROM INVENTORY
WHERE PartID = 1001;
-- Reset tables to original values
ROLLBACK;

/*
Test 2
Invalid v_CustID, other values all valid
FAIL
*/
@Lab7 -1 6099 1001 1;

/*
Test 3
Invalid v_OrderID, other values all valid
FAIL
*/
@Lab7 1 -1 1001 1;

/*
Test 4
Valid v_CustID, v_OrderID, v_PartID, v_QtyDesired
CustID has NOT placed order with given OrderID
FAIL
*/
@Lab7 1 6109 1001 1;

/*
Test 5
Invalid v_QtyDesired (<= 0), other values all valid
FAIL
*/
@Lab7 1 6099 1001 0;

/*
Test 6
When Tests 1–5 pass, insert row for an OrderId that
has NULL ORDERITEMS.Detail (which is true of OrderID 6107)
PASS
*/
-- Check ORDERITEMS before running test (will be NULL):
SELECT *
FROM ORDERITEMS
WHERE ORDERITEMS.OrderID = 6107;
-- Test:
@Lab7 15 6107 1001 1;
-- Verify ORDERITEMS.Detail is correctly set to 1
SELECT *
FROM ORDERITEMS
WHERE ORDERITEMS.OrderID = 6107;
-- Reset table to original values
ROLLBACK;

/*
Test 7
When Tests 1–6 pass:
Invalid v_QtyDesired (v_QtyDesired would reduce INVENTORY.StockQty
to less than zero)
FAIL: entire transaction is rolled back
*/
@Lab7 1 6099 1001 101;
