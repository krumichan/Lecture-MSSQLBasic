USE Northwind;

-- INDEX ����
-- Clustered(���� ����) vs Non-Clustered( ���� )

-- Clustered
    -- Leaf Page = Data Page
	-- DATA�� Clustered Index�� key ������ ���ĵȴ�.

-- Non-Clustered ? ( Clustered Index ������ ���� �ٸ��� ����. )
-- 1) Clustered Index�� ���� ���.
    -- DATA�� Heap Table�̶�� ���� ����.
	-- Heap RID�� Heap Table�� RID�̴�.
	-- �� RID�� �̿��Ͽ� Heap Table�� ���� �� DATA�� �����Ѵ�.
-- 2) Clustered Index�� �ִ� ���.
    -- Heap Table�� ����. Leaf Table�� ���� DATA�� �ִ�.
	-- Heap RID�� ������, Clustered Index�� ���� key ���� ������ �ִ�.



-- �ӽ� Test Table�� ����� DATA ����.
SELECT	*
INTO	TestOrderDetails
FROM	[Order Details];
SELECT * FROM TestOrderDetails;

-- Non-Clustered INDEX �߰�.
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- INDEX ����.
EXEC sp_helpindex 'TestOrderDetails';
-- INDEX ��ȣ ã��.
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('TestOrderDetails');
-- INDEX ��ȸ.
-- PageType 1(DATA PAGE) 2(INDEX PAGE)
--  �� DATA�� ��� �ִ°�? INDEX�� ��� �ִ°�?
--  Non-Clustered�� ��� 2(INDEX PAGE)�� ��� �ִ�.
DBCC IND('Northwind', 'TestOrderDetails', 2);
--           XXX
-- XXX XXX XXX XXX XXX XXX XXX
-- ���� ���� ����.

-- Heap RID�� �����Ѵ�.
-- Heap RID([Page Address(4)][File ID(2)][Slot(2)] ROW)
-- Heap Table[ {Page} {Page} {Page} {Page} ]
-- DBCC PAGE('Northwind', 1, XXX, 3);


-- Clustered INDEX �߰�.
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

-- INDEX ����.
EXEC sp_helpindex 'TestOrderDetails';
-- ROOT�� �ƴ� �ٸ� ���� �˻��غ���.
-- Ȯ�� ���, 'Heap RID'�� ������ ���� �� �� �ִ�.
-- ����, UNIQUIFIER�� ����µ�,
-- CLUSTERED INDEX�� ���, PRIMARY KEY�� �ٸ���
-- ���� VALUE�� ���� (key)�� ������ �� �ִ�.
-- ������ �̸� ���������� �����ϱ� ���Ͽ� 'UNIQUIFIER'�� �����Ѵ�.
-- DBCC PAGE('Northwind', 1, XXX, 3);

-- INDEX ��ȸ.
-- PageType 1(DATA PAGE) 2(INDEX PAGE)
--  �� DATA�� ��� �ִ°�? INDEX�� ��� �ִ°�?
--  Clustered�� ��� 1(DATA PAGE)�� ��� �ִ�.
DBCC IND('Northwind', 'TestOrderDetails', 1);
