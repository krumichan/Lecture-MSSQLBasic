USE Northwind;

-- ���� INDEX COLUMN ����.
-- INDEX(A, B, C)

-- Non-Clustered
--      1
--   2  3  4

-- Clustered
--      1
--   2  3  4


-- Heap Table[ {Page} {Page} ]

-- Bookmark Lookup
-- Bookmark Lookup�� ���� INDEX Ž������
-- SCAN�� ���� ��쵵 �����Ѵ�.


-- Bookmark Lookup�� ����ȭ�ϸ� ����ȭ�� ���ϱ�?
-- �װ� �ƴϴ�.
-- Leaf Page Ž���� ������ �����ϱ� �����̴�.
-- [����, ����] INDEX.
-- (56 Human)�� ã�´ٰ� ������ ��,
--      1
--   2  3  4 [ (56 Human) (56 Human) (56 Human) (56 Human) (56 Human) ... ]
-- ���� ���� Leaf Page�� �����Ǿ� �ִٰ� �����ϸ�,
-- (56 Human)�� ����ġ �� ������, Leaf Page�� Ž���� �ʿ��ϴ�.
-- ����, (56~60 Human)ó�� ���� Ž���� �� ���, ������ ��������.


SELECT	*
INTO	TestOrders
FROM	Orders;


DECLARE @i INT = 1;
DECLARE @emp INT;
SELECT @emp = MAX(EmployeeID) FROM Orders;

-- Dummy Data�� �ø���.
WHILE	(@i < 1000)
BEGIN
		INSERT INTO TestOrders(CustomerID, EmployeeID, OrderDate)
		SELECT	CustomerID, @emp + @i, OrderDate
		FROM	Orders;
		SET		@i = @i + 1;
END

SELECT	COUNT(*)
FROM	TestOrders;


-- INDEX ����
CREATE NONCLUSTERED INDEX idx_emp_ord
ON TestOrders(EmployeeID, OrderDate);

CREATE NONCLUSTERED INDEX idx_ord_emp
ON TestOrders(OrderDate, EmployeeID);


SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- ��� INDEX�� �� ������ ?

-- ���� �б�: 5
-- ��� �ð�: 0ms
-- ���� ��ȹ(Ctrl + L) ����.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_emp_ord))
WHERE	EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');

-- ���� �б�: 5
-- ��� �ð�: 0ms
-- ���� ��ȹ(Ctrl + L) ����.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');


-- ���� Ȯ��.
-- EmployeeID		,	   OrderDate
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-06 00:00:00	-- (X)
-- (X) ���� 3�� Ž��.
SELECT		*
FROM		TestOrders
ORDER BY	EmployeeID, OrderDate;

--  OrderDate		   ,  EmployeeID
--  1997-01-01 00:00:00,      1
--  1997-01-01 00:00:00,      1
--  1997-01-06 00:00:00,      1				-- (X)
-- (X) ���� 3�� Ž��.
SELECT		*
FROM		TestOrders
ORDER BY	OrderDate, EmployeeID;


-- Non-Clustered���� '='�� ã�� ���,
-- 1. INDEX(OrderDate, EmployeeID)
-- 2. INDEX(EmployeeID, OrderDate)
-- ���� �� INDEX�� ���� ���̴� ������.


-- ���� ������ ã�´ٸ�?

-- ���� �б�: 5
-- EmployeeID		,	   OrderDate
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-06 00:00:00	-- (X)
-- (X) ���� 3�� Ž��.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_emp_ord))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';

-- ���� �б�: 16
--  OrderDate		   ,  EmployeeID
--  1997-01-01 00:00:00,      1
--  1997-01-01 00:00:00,      1
--  1997-01-01 00:00:00,      10
--  1997-01-01 00:00:00,      10
--  1997-01-01 00:00:00,      11
--  ...
--  1997-01-06 00:00:00,      1				-- (X)
-- (X) ���� ����� ���� OrderDate�� �о�� �Ѵ�.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';


-- ��,
-- [!] INDEX(A, B, C)�� �����Ͽ��� ���,
-- ���� INDEX( A �� )�� BETWEEN(����)�� ����ϸ�,
-- ���� INDEX( B, C )�� INDEX�� ����� ����ϴ� �Ͱ� ����.
-- ����,
-- BETWEEN(����)�� ����� ���,
-- �ش� IDNEX�� �������� ������ ���� ����.
-- �׷��ٸ�,
-- BETWEEN ���� �� ���� ��, INDEX ������ �ٲٸ� �ȴ°ɱ�?
-- �װ� �� �ƴ� ������,
-- �ش� INDEX�� ���� ���ǿ��� ���Ǵ� INDEX���,
-- ��ü���� ���������� ������ �� ���������� �ִ�.
-- ���������,
-- ���������� Ȯ���Ͽ� �Ǵ��Ͽ��� �Ѵ�.


-- BETWEEN ������ ���� ���,
-- IN-LIST�� ��ü�ϴ� ���� ����ϴ� ���� ����.

-- ���� �б�: 16
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';
-- ���� �б�: 11
-- ���� �бⰡ �� ���� ������,
-- ���������� INDEX SEEK�� OR�� ���� �����ϴµ�,
-- �Ȱ��� QUERY��
-- OrderDate = '19970101'
-- OrderDate = '19970102'
-- OrderDate = '19970103'
-- ���� ���� �� �� �����ϴ� ���� �� �� �ִ�.
-- �̷��� OR ������ ���� ���ຸ�� �� ���� Ž���� ������ ���̴�.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate IN ('19970101', '19970102', '19970103');



-- ���� ������ �۴ٰ� �ؼ� IN-LIST�� ���� ���,
-- ���� �������� �� �ִ´�.

-- ���� �б�: 5
SELECT	*
FROM	TestOrders WITH(INDEX(idx_emp_ord))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';
-- ���� �б�: 11
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate IN ('19970101', '19970102', '19970103');

-- ���� ����,
-- ������ 5 -> 11�� �þ ���� �� �� �ִ�.


-- ������ ���
-- 1. ���� COLUMN INDEX( ����, ���� ) ������ Ž�� COST�� ������ �� �� �ִ�.
-- 2. BETWEEN, �ε�ȣ(>, <) ���� ���࿡ �� ���, ������ INDEX ����� ����Ѵ�.
-- 3. BETWEEN�� ������ ���� ���, IN-LIST�� ��ü�ϸ� COST�� �� ������ �� �ִ�. (���࿡ BETWEEN)
-- 4. ���� =, ���� BETWEEN  �� ���, �ƹ��� ������ ���� ������ IN-LIST�� ���� �ʴ� ���� ����.
