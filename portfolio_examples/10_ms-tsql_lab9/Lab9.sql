/*
Peter Jungers
SQL Portfolio Examples 10
Oracle PL/SQL
*/



USE PeterJ



/*
--------------------------------------------------------------------------------
CUSTOMERS.CustID validation
Determines if CUSTOMERS.CustID exists
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateCustID')
    BEGIN 
        DROP PROCEDURE ValidateCustID; 
    END;
-- END IF;
GO

CREATE PROCEDURE ValidateCustID 
    @v_CustID SMALLINT,
    @v_ReturnValue VARCHAR(3) OUTPUT 
AS 
    BEGIN 
        SET @v_ReturnValue = 'NO';  -- Initialize
        SELECT @v_ReturnValue = 'YES' 
        FROM   CUSTOMERS
        WHERE  CustID = @v_CustID;
    END;
GO


-- Testing block for ValidateCustID:

-- BEGIN
--     DECLARE @v_ReturnValue VARCHAR(3);  -- Holds value returned from procedure
--     PRINT '----- ValidateCustID tests -----';
--     PRINT '';
--     -- Test 1—Valid CustID:
--     EXECUTE ValidateCustID 1, @v_ReturnValue OUTPUT;
--     PRINT 'Test 1—Valid CustID:';
--     PRINT 'Valid CustID 1 exists: ' + @v_ReturnValue;
--     PRINT '';
--     -- Test 2—Invalid CustID:
--     PRINT 'Test 2—Invalid CustID:';
--     EXECUTE ValidateCustID -1, @v_ReturnValue OUTPUT;
--     PRINT 'Invalid CustID -1 exists: ' + @v_ReturnValue;
--     PRINT '';
--     PRINT '--------- End of tests ---------';
-- END;
-- GO



/*
--------------------------------------------------------------------------------
ORDERS.OrderID validation
Determines if ORDERS.OrderID exists and if CustID/OrderID is a valid pairing
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateOrderID')
    BEGIN
        DROP PROCEDURE ValidateOrderID;
    END;
-- END IF;
GO

CREATE PROCEDURE ValidateOrderID
    @v_CustID SMALLINT,
    @v_OrderID SMALLINT,
    @v_ReturnValue VARCHAR(3) OUTPUT
AS 
    BEGIN
        SET @v_ReturnValue = 'NO';  -- Initialize
        SELECT @v_ReturnValue = 'YES'
        FROM ORDERS
        WHERE CustID = @v_CustID
            AND OrderID = @v_OrderID;
    END;
GO


/*
Testing block for ValidateOrderID:
(Note: CustID has already been validated by ValidateCustID, so no
need to re-validate that in tests below)
*/

-- BEGIN    
--     DECLARE @v_ReturnValue VARCHAR(3);  -- Holds value returned from procedure
--     PRINT '----- ValidateOrderID tests -----';
--     PRINT '';
--     -- Test 1—Valid CustID, valid OrderID:
--     EXECUTE ValidateOrderID 1, 6099, @v_ReturnValue OUTPUT;
--     PRINT 'Test 1—Valid CustID, valid OrderID:';
--     PRINT 'CustID 1 with OrderID 6099 exists: ' + @v_ReturnValue;
--     PRINT '';
--     -- Test 2—Valid CustID, invalid OrderID:
--     EXECUTE ValidateOrderID 1, -1, @v_ReturnValue OUTPUT;
--     PRINT 'Test 2—Valid CustID, invalid OrderID:';
--     PRINT 'CustID 1 with OrderID -1 exists: ' + @v_ReturnValue;
--     PRINT '';
--     -- Test 3—Valid CustID, valid OrderID, but invalid CustID/OrderID pairing:
--     EXECUTE ValidateOrderID 1, 6107, @v_ReturnValue OUTPUT;
--     PRINT 'Test 3—Valid CustID, valid OrderID, but invalid CustID/OrderID pairing:';
--     PRINT 'CustID 1 with OrderID 6107 exists: ' + @v_ReturnValue;
--     PRINT '';
--     PRINT '--------- End of tests ---------';
-- END;
-- GO



/*
--------------------------------------------------------------------------------
INVENTORY.PartID validation
Determines if INVENTORY.PartID exists 
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidatePartID')
    BEGIN
        DROP PROCEDURE ValidatePartID;
    END;
-- END IF;
GO

CREATE PROCEDURE ValidatePartID 
    @v_PartID SMALLINT,
    @v_ReturnValue VARCHAR(3) OUTPUT
AS 
    BEGIN 
        SET @v_ReturnValue = 'NO';  -- Initialize
        SELECT @v_ReturnValue = 'YES'
        FROM INVENTORY
        WHERE PartID = @v_PartID;
    END;
GO


-- Testing block for ValidatePartID

-- BEGIN 
--     DECLARE @v_ReturnValue VARCHAR(3);  -- Holds value returned from procedure
--     PRINT '----- ValidatePartID tests -----';
--     PRINT '';
--     -- Test 1—Valid PartID:
--     EXECUTE ValidatePartID 1001, @v_ReturnValue OUTPUT;
--     PRINT 'Test 1—Valid PartID:';
--     PRINT 'Valid PartID 1001 exists: ' + @v_ReturnValue;
--     PRINT '';
--     -- Test 2—Invalid PartID:
--     PRINT 'Test 2—Invalid PartID:';
--     EXECUTE ValidatePartID -1, @v_ReturnValue OUTPUT;
--     PRINT 'Invalid PartID -1 exists: ' + @v_ReturnValue;
--     PRINT '';
--     PRINT '--------- End of tests ---------';
-- END;
-- GO



/*
--------------------------------------------------------------------------------
Input quantity validation
Verifies that Qty is not zero or less
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateQty')
    BEGIN
        DROP PROCEDURE ValidateQty;
    END;
-- END IF;
GO

CREATE PROCEDURE ValidateQty 
    @v_Qty SMALLINT,
    @v_ReturnValue VARCHAR(3) OUTPUT
AS 
    BEGIN 
        IF @v_Qty <= 0
            SET @v_ReturnValue = 'NO'
        ELSE
            SET @v_ReturnValue = 'YES'
        -- END IF;
    END;
GO


-- Testing block for ValidateQty

-- BEGIN
--     DECLARE @v_ReturnValue VARCHAR(3);  -- Holds value returned from procedure
--     PRINT '----- ValidateQty tests -----';
--     PRINT '';
--     -- Test 1—Qty < 0:
--     EXECUTE ValidateQty -1, @v_ReturnValue OUTPUT;
--     PRINT 'Test 1—Qty < 0:';
--     PRINT 'Qty of -1 is valid: ' + @v_ReturnValue;
--     PRINT '';
--     -- Test 2—Qty = 0:
--     PRINT 'Test 2—Qty = 0:';
--     EXECUTE ValidateQty 0, @v_ReturnValue OUTPUT;
--     PRINT 'Qty of 0 is valid: ' + @v_ReturnValue;
--     PRINT '';
--     -- Test 3—Qty > 0:
--     PRINT 'Test 3—Qty > 0:';
--     EXECUTE ValidateQty 1, @v_ReturnValue OUTPUT;
--     PRINT 'Qty of 1 is valid: ' + @v_ReturnValue;
--     PRINT '';
--     PRINT '--------- End of tests ---------';  
-- END;
-- GO



/*
--------------------------------------------------------------------------------
Determines new ORDERITEMS.Detail value
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'GetNewDetail')
    BEGIN
        DROP PROCEDURE GetNewDetail;
    END;
-- END IF;
GO

CREATE PROCEDURE GetNewDetail 
    @v_OrderID SMALLINT,
    @v_NewDetail SMALLINT OUTPUT
AS 
    BEGIN 
        -- Use @v_Orderid (input) to get @v_NewDetail (output):
        SET @v_NewDetail = (
            SELECT ISNULL(MAX(Detail), 0) + 1
            FROM ORDERITEMS
            WHERE OrderID = @v_OrderID
        );
    END;
GO


/*
Testing block for GetNewDetail
(Note: OrderID has already been validated by ValidateOrderID, so no
need to re-validate that in tests below)
*/

-- BEGIN    
--     DECLARE @v_NewDetail SMALLINT;  -- Holds value returned from procedure

--     PRINT '----- GetNewDetail tests -----';
--     PRINT '';

--     -- Test 1—OrderID with existing ORDERITEMS:
--     PRINT 'Test 1—OrderID with existing ORDERITEMS:';
--         -- Query existing Detail column for OrderID 6099 (will have values 1–5):
--         SELECT Detail AS 'OrderID 6099 Detail'
--         FROM ORDERITEMS
--         WHERE ORDERITEMS.OrderID = 6099;
--         -- Test new Detail value (will be 6):
--         EXECUTE GetNewDetail 6099, @v_NewDetail OUTPUT;
--     PRINT 'New Detail value: ' + CAST(@v_NewDetail AS CHAR);
--     PRINT '';
    
--     -- Test 2—OrderID with no existing ORDERITEMS:
--     PRINT 'Test 2—OrderID with no existing ORDERITEMS:';
--         -- Query existing Detail column for OrderID 6107 (will be NULL):
--         SELECT Detail AS 'OrderID 6107 Detail'
--         FROM ORDERITEMS
--         WHERE ORDERITEMS.OrderID = 6107;
--         -- Test new Detail value (will be 1):
--         EXECUTE GetNewDetail 6107, @v_NewDetail OUTPUT;
--     PRINT 'New Detail value: ' + CAST(@v_NewDetail AS CHAR);

--     PRINT '';
--     PRINT '--------- End of tests ---------';  
-- END;
-- GO



/*
--------------------------------------------------------------------------------
INVENTORY trigger for an UPDATE:
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'InventoryUpdateTRG')
    BEGIN
        DROP TRIGGER InventoryUpdateTRG;
    END;
-- END IF;
GO

CREATE TRIGGER InventoryUpdateTRG
    ON INVENTORY
    FOR UPDATE
AS
    DECLARE @v_StockQty SMALLINT;
    BEGIN 
        -- Compare (SELECT Stockqty FROM INSERTED) to zero
        SELECT @v_StockQty = (SELECT StockQty FROM INSERTED);
        IF @v_StockQty < 0
            -- This error gets sent back to OrderitemsInsertTRG
            RAISERROR(
                'Error in InventoryUpdateTRG', 1, 1
            ) WITH SETERROR;
    END;
GO


-- Testing block for InventoryUpdateTRG

-- BEGIN
--     PRINT '----- InventoryUpdateTRG tests -----';
--     PRINT '';

--     -- Test 1—UPDATE StockQty < 0 (fails):
--     PRINT 'Test 1—UPDATE StockQty < 0 (fails):'
--         UPDATE INVENTORY
--         SET StockQty = -1
--         WHERE PartID = 1001;

--         IF @@ERROR <> 0
--             -- Error message via InventoryUpdateTRG prints
--             PRINT 'StockQty cannot be less than zero';
--         --END IF;
--         PRINT '';

--     -- Test 2—UPDATE StockQty = 0 (succeeds):
--     PRINT 'Test 2—UPDATE StockQty = 0 (succeeds):'
--         UPDATE INVENTORY
--         SET StockQty = 0
--         WHERE PartID = 1001;

--         IF @@ERROR <> 0
--             PRINT 'StockQty cannot be less than zero';
--         ELSE
--             PRINT 'StockQty of 0 is valid';
--         --END IF;
--         PRINT '';

--     -- Test 3—UPDATE StockQty > 0 (succeeds):
--     PRINT 'Test 3—UPDATE StockQty > 0 (succeeds):'
--         UPDATE INVENTORY
--         SET StockQty = 1
--         WHERE PartID = 1001;

--         IF @@ERROR <> 0
--             PRINT 'StockQty cannot be less than zero';
--         ELSE
--             PRINT 'StockQty of 1 is valid';
--         --END IF;
--         PRINT '';

--     PRINT '';
--     PRINT '--------- End of tests ---------';
-- END;
-- GO



/*
--------------------------------------------------------------------------------
ORDERITEMS trigger for an INSERT:
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'OrderitemsInsertTRG')
    BEGIN
        DROP TRIGGER OrderitemsInsertTRG;
    END;
-- END IF;
GO

CREATE TRIGGER OrderitemsInsertTRG
    ON ORDERITEMS
    FOR INSERT
AS

    DECLARE @v_PartID SMALLINT;
    DECLARE @v_Qty SMALLINT;
    DECLARE @v_StockQty SMALLINT;

    BEGIN 
        -- Get new values for @v_PartID and @v_Qty from the INSERTED table
        SET @v_PartID = (SELECT PartID FROM INSERTED)
        SET @v_Qty = (SELECT Qty FROM INSERTED)
        -- Set new @v_StockQty for this @v_PartID (@v_StockQty - @v_Qty)
        SET @v_StockQty = (
            SELECT StockQty
            FROM INVENTORY
            WHERE PartID = @v_PartID
        ) - @v_Qty;

        -- Run UPDATE on INVENTORY.StockQty
        UPDATE INVENTORY
        SET StockQty = @v_StockQty
        WHERE PartID = @v_PartID;
        -- This error comes from InventoryUpdateTRG and gets sent to AddLineItem
        IF (@@ERROR <> 0)
            RAISERROR(
                'Error in OrderitemsInsertTRG', 1, 1
            ) WITH SETERROR;
    END;
GO


/*
Testing block for OrderItemsInsertTrg
(Note: All INSERTED values will have already been tested for validity,
so all that is tested below is that the new StockQty calculations don't
throw an error, and that InventoryUpdateTRG is being called and working
correctly)
*/

-- BEGIN
--     PRINT '----- OrderItemsInsertTrg tests -----';
--     PRINT '';

--     -- Test 1—INSERT succeeds:
--     PRINT 'INSERT succeeds:'
--         INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
--         VALUES (6099, 7, 1001, 1);

--         IF @@ERROR <> 0
--             PRINT 'Error in OrderItemsInsertTrg Test 1';
--         ELSE
--             PRINT 'OrderItemsInsertTrg Test 1 succeeded';
--         --END IF;
--         PRINT '';

--     -- Test 2—INSERT fails via InventoryUpdateTRG error:
--     PRINT 'Test 2—INSERT fails via InventoryUpdateTRG error:'
--         INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
--         VALUES (6099, 6, 1001, 101);

--         IF @@ERROR <> 0
--             -- Error message via InventoryUpdateTRG prints
--             -- Error message via OrderItemsInsertTrg prints
--             PRINT 'Error in OrderItemsInsertTrg Test 2';
--         --END IF;
--         PRINT '';

--     PRINT '';
--     PRINT '--------- End of tests ---------';
-- END;
-- GO



/* 
--------------------------------------------------------------------------------
The TRANSACTION, this procedure calls GetNewDetail and performs an INSERT
to the ORDERITEMS table which in turn performs an UPDATE to the INVENTORY table.
Error handling determines COMMIT/ROLLBACK.
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'AddLineItem')
    BEGIN
        DROP PROCEDURE AddLineItem;
    END;
-- END IF;
GO

CREATE PROCEDURE AddLineItem
    @v_OrderID SMALLINT,
    @v_PartID SMALLINT,
    @v_Qty SMALLINT
AS

    DECLARE @v_NewDetail SMALLINT;

    BEGIN
        BEGIN TRANSACTION
            EXECUTE GetNewDetail @v_OrderID, @v_NewDetail OUTPUT;
            INSERT INTO ORDERITEMS
                VALUES (@v_OrderID, @v_NewDetail, @v_PartID, @v_Qty);
            
            IF (@@ERROR <> 0) -- Error trying to insert via INSERT or UPDATE triggers
                BEGIN
                    PRINT 'Error inserting row from AddLineItem';
                    PRINT 'Transaction canceled';
                    ROLLBACK TRANSACTION;
                END;
            ELSE -- No errors!
                BEGIN
                    PRINT 'Successful transaction!';
                    COMMIT TRANSACTION;
                END;
        -- END TRANSACTION;
    END;
GO


-- AddLineItem tests done via Lab9proc at Lab9Grading.sql



/* 
--------------------------------------------------------------------------------
Puts all of the previous together to produce a solution for Lab9 done in
SQL Server. This stored procedure accepts the 4 pieces of input: 
Custid, Orderid, Partid, and Qty (in that order please). It validates all the 
data and does the transaction processing by calling the previously written and 
tested modules.
--------------------------------------------------------------------------------
*/


IF EXISTS (SELECT name FROM sys.objects WHERE name = 'Lab9proc')
    BEGIN
        DROP PROCEDURE Lab9proc;
    END;
-- END IF;
GO

CREATE PROCEDURE Lab9proc
    @v_CustID SMALLINT,
    @v_OrderID SMALLINT,
    @v_PartID SMALLINT,
    @v_Qty SMALLINT
AS

    DECLARE @v_ReturnValue VARCHAR(3);
    DECLARE @v_ErrorFlag SMALLINT;

    BEGIN
        SET @v_ErrorFlag = 0;

        -- Validate CustID
        EXECUTE ValidateCustID @v_CustID, @v_ReturnValue OUTPUT;
        IF @v_ReturnValue = 'NO'
            BEGIN
                SET @v_ErrorFlag = 1;
                PRINT 'CustID ' + CAST(@v_CustID AS VARCHAR) + ' does not exist';
            END;
        ELSE
            PRINT 'CustID ' + CAST(@v_CustID AS VARCHAR) + ' is valid';
        -- END IF;

        -- Validate OrderID and OrderID/CustID pairing
        EXECUTE ValidateOrderID @v_CustID, @v_OrderID, @v_ReturnValue OUTPUT;
        IF @v_ReturnValue = 'NO'
            BEGIN
                SET @v_ErrorFlag = 1;
                PRINT 'CustID ' + CAST(@v_CustID AS VARCHAR)
                    + ' with OrderID ' + CAST(@v_OrderID AS VARCHAR)
                    + ' does not exist';
            END;
        ELSE
            PRINT 'CustID ' + CAST(@v_CustID AS VARCHAR)
                + ' with OrderID ' + CAST(@v_OrderID AS VARCHAR)
                + ' is valid';
        -- END IF;

        -- Validate PartID
        EXECUTE ValidatePartID @v_PartID, @v_ReturnValue OUTPUT;
        IF @v_ReturnValue = 'NO'
            BEGIN
                SET @v_ErrorFlag = 1;
                PRINT 'PartID ' + CAST(@v_PartID AS VARCHAR) + ' does not exist';
            END;
        ELSE
            PRINT 'PartID ' + CAST(@v_PartID AS VARCHAR) + ' is valid';
        -- END IF;

        -- Validate that Qty > 0
        EXECUTE ValidateQty @v_Qty, @v_ReturnValue OUTPUT;
        IF @v_ReturnValue = 'NO'
            BEGIN
                SET @v_ErrorFlag = 1;
                PRINT 'Qty ' + CAST(@v_Qty AS VARCHAR) + ' must be greater than zero';
            END;
        ELSE
            PRINT 'Qty ' + CAST(@v_Qty AS VARCHAR) + ' is valid';
        -- END IF;
        PRINT '';

    	-- IF everything validates, we can do the TRANSACTION:
        IF @v_ErrorFlag = 0
            EXECUTE AddLineItem @v_OrderID, @v_PartID, @v_Qty;
        ELSE -- report error messages
            PRINT 'Transaction canceled';
    END;
GO 


-- Tests for Lab9proc done at Lab9Grading.sql
