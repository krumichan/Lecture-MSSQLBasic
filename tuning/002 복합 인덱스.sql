USE Northwind;


-- �ֹ� �� ���� Ȯ��.
SELECT		*
FROM		[Order Details]
ORDER BY	OrderID;


-- �ӽ� TEST TABLE�� ����� DATA ����.
SELECT	*
INTO	TestOrderDetails
FROM	[Order Details];
SELECT	*
FROM	TestOrderDetails;


-- ���� INDEX �߰�.
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID);


-- INDEX ���� Ȯ��.
EXEC sp_helpindex 'TestOrderDetails';


-- ���� �� [Ctrl + L] Ŭ��.
-- "INDEX SEEK" �� �Ǹ�.
-- "INDEX SCAN" �� Index Full Scan���� ������.

-- INDEX ���� TEST 1 ( OrderID, ProductID �Ѵ� ���. )
-- INDEX SEEK ���. �� �Ǹ�.
SELECT	*
FROM	TestOrderDetails
WHERE	OrderID = 10248 AND ProductID = 11;
--WHERE	ProductID = 11 AND OrderID = 10248; -- ������ �ٲ㵵 ��� ����.


-- INDEX ���� TEST 2 ( OrderID�� ���. )
-- INDEX SEEK ���. �� �Ǹ�.
SELECT	*
FROM	TestOrderDetails
WHERE	OrderID = 10248;


-- INDEX ���� TEST 3 ( ProductID�� ���. )
-- INDEX SCAN(Table Scan) ���. �� ����.
-- ( INDEX�� Ȱ������ ����. )
SELECT	*
FROM	TestOrderDetails
WHERE	ProductID = 11;


-- ���� ������ ������ INDEX�� ����� �ִµ�,
--CREATE INDEX Index_TestOrderDetails
--ON TestOrderDetails(OrderID, ProductID);
-- ���� ������ ���� "OrderID", "ProductID"�̴�.
-- ��, OrderID�� �������� ã��,
--     OrderID���� ��ġ�� ���� ������
--     ProductID�� �������� ã�� ���̴�.


-- INDEX ����.
DBCC IND('Northwind', 'TestOrderDetails', 2);
-- INDEX LEVEL�� Ȯ���غ��� 0�� 1�� �ִ�.
-- ��,
--            XXX
--  XXX XXX XXX XXX XXX XXX
-- ���� ���� ������ �Ǿ��ִ�.
--DBCC PAGE('Northwind', 1, XXX, 3);
-- ���� PAGE ������ Ȯ���� ����,
-- ORDER BY OrderID, ProductID ó�� ���ĵǾ� �ִ� ���� Ȯ���� �� �ִ�.
-- ��, OrderID�� ���� �����ϰ� �� �ȿ��� ���� ���,
-- ProductID �������� ������ ���� �� �� �ִ�.
-- ���� ������,
--   ( OrderID, ProductID ) �Ǵ� ( ProductID, OrderID ) �� �˻��� ��� GOOD
--   ( OrderID ) �� �˻��� ��� GOOD
--   ( ProductID ) �� �˻��� ��� BAD
-- ���� ���� ����� ������ ���̴�.

-- ���������
-- INDEX( A, B )�� �������� ���,
-- INDEX( A )�� ��� ��� ����.
-- ������ B �˻��� �ʿ��� ���,
-- INDEX( B )�� ������ �ʿ䰡 �ִ�.


-- INDEX�� DATA�� �߰�/����/���� �Ǿ �����Ǿ�� ��.

DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES ( 10248, 100 + @i, 10, 1, 0);
	SET @i = @i + 1;
END;

-- INDEX ����.
DBCC IND('Northwind', 'TestOrderDetails', 2);
--              XXX
--  XXX [XXX] XXX XXX XXX XXX XXX
-- ���� ���� [XXX]ó�� ���ο� PAGE�� ������ ���� �� �� �ִ�.
-- �ϳ��� PAGE�� �ʹ� �������� 2���� �и��� ���̴�.

-- ��� : PAGE�� ���� ������ ���ٸ�,
--        PAGE ����(SPLIT)�� �߻��Ѵ�.

-- ���� �׽�Ʈ
SELECT	LastName
INTO	TestEmployees
FROM	Employees;
SELECT * FROM TestEmployees;

-- INDEX �߰�.
CREATE INDEX Index_TestEmployees
ON TestEmployees(LastName);

-- INDEX SCAN�� �߻��ع�����.
-- ��, ������ ���°� �ƴ�,
-- �����Ͽ� ����� ��� INDEX�� ������� �ʴ´�.
-- ( ���� ���, �׳� �ڸ��� ���� �ƴ�,
--   �������� �������� ���,
--   INDEX�� ������ �ҿ� �������� �ȴ�. )
SELECT	*
FROM	TestEmployees
WHERE	SUBSTRING(LastName, 1, 2) = 'Bu';


-- ���� ���� �Ʒ��� ���� ����ϸ� �ȴ�.
-- ( ���� ������ �ƴ� ���� �˻��̱� ����. )
-- INDEX SEEK
SELECT	*
FROM	TestEmployees
WHERE	LastName LIKE 'Bu%';


-- ���� ���
-- ���� INDEX(A, B)�� ����� �� ���� ���� ( A��B ���� �˻� )
-- INDEX ��� ��, DATA �߰��� ���Ͽ� PAGE�� ���� ������ �������� ����(SPLIT) �ȴ�.
-- (KEY) ������ �� ������ ��.
