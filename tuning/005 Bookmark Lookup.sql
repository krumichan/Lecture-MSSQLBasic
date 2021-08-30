USE Northwind;

-- Bookmark Lookup

-- Index Scan vs Index Seek
-- Idnex Scan�� �׻� ���� �� �ƴϰ�,
-- Index Skke�� �׻� ���� �� �ƴϴ�.
-- INDEX�� Ȱ���ϴµ� �� �ʾ��� �� �ִ� �ɱ�?

-- Non-Clustered
--      1
--  2 3 4 5 6   - LEAF PAGE


-- Clustered
--      1
--  2 3 4 5 6   - LEAF PAGE

-- Heap Table[ {Page} {Page} ]

-- Clustered�� ��� INDEX SEEK�� ���� �� ����.
-- NonClustered�� ���, DATA�� LEAF PAGE�� ����.
-- ����, �� �� �� �˻��� �ؾ��Ѵ�.
   -- 1) RID �� Heap Table ( Bookmark Lookup )
   -- 2) Key �� Clustered


SELECT	*
INTO	TestOrders
FROM	Orders;
SELECT	* FROM TestOrders;

CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- INDEX ��ȣ.
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('TestOrders');
-- INDEX ��ȸ.
DBCC IND('Northwind', 'TestOrders', 2);
--       920
--  840  888  889 -- LEAF PAGE
-- Heap Table[ {Page} {Page} ]

SET STATISTICS TIME ON;		-- query ���� �ҿ� �ð�.
SET STATISTICS IO ON;		-- query ���� �б�/���� Ƚ��.
SET STATISTICS PROFILE ON;	-- ���� ���� ����.



-- �⺻ Ž��.
-- TABLE SCAN: ���������� INDEX SEEK���� �����ٰ� �Ǵ��Ͽ� SCAN�� ����.
-- ���� �б�: 20
SELECT	*
FROM	TestOrders
WHERE	CustomerID = 'QUICK';

-- �⺻ Ž��. (���� INDEX ����)
-- ���� �б�: 30
-- RID Loopup�� 28�� �����Ѵ�. ( 'QUICK'�� 28�� �����ϱ� ����. )
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK';

-- ���� ��ó��, INDEX�� ����� ���� �� ������ ���� �ִ�.
-- INDEX�� ���������, 'RID Lookup' ���࿡ �ð��� �� �ɷ����� ����̴�.
-- ( Heap Table�� �ִ� Page�� memory�� �������� �ִµ� �� ���,
--   �ϵ� ��ũ���� ���ٿ��� ������ �� ������ ��. )


-- �⺻ Ž�� + ���� �߰�.
-- RID Lookup�� 28�� �����Ѵ�.
-- Non-Clustered�� Leaf Page������ ShipVia ������ �� �� ���� ������,
-- 'QUICK' 28�� Ž���� �ᱹ ���� �����Ѵ�.
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK'
AND		ShipVia = 3;


DROP INDEX TestOrders.Orders_Index01;


-- Covered Index
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID, ShipVia);

-- INDEX ���� �� Ž��.
-- RID Lookup�� 8�� �����Ѵ�.
-- Leaf Page�� ShipVia �������� �ֱ� ������,
-- 8���� Ž���ص� �� �� �ְ� �ȴ�.
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK'
AND		ShipVia = 3;


-- Q) ����1 AND ����2�� �ʿ��ϸ�,
--    INDEX(����1, ����2)�� �߰��ϸ� �ȴ� �ǰ�?
-- �� ���� Ʋ����!
--    DML(INSERT, UPDATE, DELETE) �۾� ���ϰ� �����ϰ� �ȴ�.
--    ������ �þ�Ƿ� ����,
--    DATA �߰�/����/���� ��, INDEX ���ſ� �ð��� ���� �ɸ��� �ȴ�.

DROP INDEX TestOrders.Orders_Index01;


-- ������ key ��ü�� CustomerID�� Ȱ��������,
-- Leaf Page�� ShipVia�� ���� ���Խ�Ű�ڴٴ� �ǹ�.
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID) INCLUDE (ShipVia);


-- RID Lookup�� 8�� �����Ѵ�.
-- Leaf Page���� ShipVia�� ���� �ϴ� �˰� �ֱ� ������,
-- Heap Table�� ���� Ž���ϴ� ���� �ƴ�,
-- ShipVia�� �����Ͽ� Heap Table�� Ž���� �� �ִ�.
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK'
AND		ShipVia = 3;


-- ���� ���� ��¿��� ���� ���ٸ�,
-- Clustered Index Ȱ���� ����Ѵ�.
-- ������  Clustered Index�� Table �� 1���� ����� �� �ִ�.

-- ��� --

-- Non-Clustered Index�� �ǿ����� �ִ� ���� ?
  -- Bookmark Lookup�� �ɰ��� ���ϸ� �߻���ų ����̴�.
-- �����?
  -- �ɼ�1) Covered Index ( �˻��� ��� Column�� ���Խ�Ų��. )
  -- �ɼ�2) Index�� INCLUDE�� Hint�� �����.
  -- �ɼ�3) Clustered ����� ����Ѵ�.
           -- ��, 1���� ����� �� ������,
		   -- ��쿡 ���󼭴� Non-Clustered�� �ǿ����� �ټ��� �ִ�.
		   -- ( Clustered�� ����� ���,
		   --   Non-Clustered�� Heap Table�� ������� �ʴµ�,
		   --   Clustered�� IndexLevel�� ���ٸ�,
		   --   Heap Table�� ����ϴ� �ͺ��� ȿ���� ���������� �ֱ� �����̴�. )
