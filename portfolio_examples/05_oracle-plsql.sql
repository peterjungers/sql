/*
Peter Jungers
SQL Portfolio Examples 5
Oracle PL/SQL
*/



/*
Instructions: Create a .sql file that contains the CREATE TABLE statements to 
build the SalesDB tables. Include the primary keys, foreign keys, and domain 
constraints shown in the Database Design section in your CREATE TABLE 
statements. The order of statements is important.
*/


CREATE TABLE CUSTOMERS (
    custid  NUMBER(4)   NOT NULL,
    cname   CHAR(25)    NOT NULL,
    credit  CHAR(1)     NOT NULL,
    CONSTRAINT CUSTOMERS_pk PRIMARY KEY (custid),
    CONSTRAINT CUSTOMERS_ck
        CHECK (credit IN ('A', 'B', 'C', 'a', 'b', 'c'))
);

CREATE TABLE SALESPERSONS (
    empid   NUMBER(4)       NOT NULL,
    ename   CHAR(15)        NOT NULL,
    rank    NUMBER(2)       NOT NULL,
    salary  DECIMAL(8, 2)   DEFAULT 1000    NOT NULL,
    CONSTRAINT SALESPERSONS_pk PRIMARY KEY (empid),
    CONSTRAINT rank_ck
        CHECK (rank IN (1, 2, 3)),
    CONSTRAINT salary_ck
        CHECK (salary >= 1000)
);

CREATE TABLE INVENTORY (
    partid      NUMBER(4)       NOT NULL,
    description CHAR(12)        NOT NULL,
    stockqty    NUMBER(4)       NOT NULL,
    reorderpnt  NUMBER(4)       NOT NULL,
    price       DECIMAL(8, 2)   NOT NULL,
    CONSTRAINT INVENTORY_pk PRIMARY KEY (partid)
);

CREATE TABLE ORDERS (
    orderid     NUMBER(4)   NOT NULL,
    empid       NUMBER(4)   NOT NULL,
    custid      NUMBER(4)   NOT NULL,
    salesdate   DATE        DEFAULT SYSDATE     NOT NULL,
    CONSTRAINT ORDERS_pk PRIMARY KEY (orderid),
    CONSTRAINT ORDERS_fk_SALESPERSONS
        FOREIGN KEY (empid) REFERENCES SALESPERSONS (empid),
    CONSTRAINT ORDERS_fk_CUSTOMERS
        FOREIGN KEY (custid) REFERENCES CUSTOMERS (custid)
);

CREATE TABLE ORDERITEMS (
    orderid     NUMBER(4)   NOT NULL,
    detail      NUMBER(2)   NOT NULL,
    partid      NUMBER(4)   NOT NULL,
    qty         NUMBER(6)   NOT NULL,
    CONSTRAINT ORDERITEMS_pk PRIMARY KEY (orderid, detail),
    CONSTRAINT ORDERITEMS_fk_ORDERS
        FOREIGN KEY (orderid) REFERENCES ORDERS (orderid),
    CONSTRAINT ORDERITEMS_fk_INVENTORY
        FOREIGN KEY (partid) REFERENCES INVENTORY (partid)
);



/*
Add a new salesperson 
Columns to display: none 
Instructions: Write an INSERT query to insert a new salesperson into the database with the following attribute values.
empid should be one greater than the largest existing empid (no hard-coding, use SELECT)
ename should be your name (hard-code your name here) 
rank should be whichever rank is associated with the lowest-paid salesperson (use SELECT).
salary is to be 9% more than the lowest-paid salesperson (another SELECT clause). 
*/


INSERT INTO SALESPERSONS (
    empid,
    ename,
    rank,
    salary
)
VALUES (
    (
    SELECT NVL(MAX(SALESPERSONS.empid), 0) + 1 FROM SALESPERSONS
    ),
    'Peter Jungers',
    (
    SELECT DISTINCT rank
    FROM SALESPERSONS
    WHERE SALESPERSONS.salary =
        (SELECT MIN(SALESPERSONS.salary) FROM SALESPERSONS)
    ),
    (
    SELECT MIN(SALESPERSONS.salary) + (MIN(SALESPERSONS.salary) * .09)
    FROM SALESPERSONS
    )
);

COMMIT;



/*
Clean up the orders
Columns to display: none 
Instructions: Write a DELETE query to delete rows from the ORDERS table that are not associated 
with any rows in ORDERITEMS (i.e. remove the orders with no line items). 
*/


DELETE FROM ORDERS
WHERE ORDERS.orderid IN (
    SELECT ORDERS.orderid
    FROM ORDERS
    WHERE NOT EXISTS (
        SELECT *
        FROM ORDERITEMS
        WHERE ORDERITEMS.orderid = ORDERS.orderid
    )
);

COMMIT;
