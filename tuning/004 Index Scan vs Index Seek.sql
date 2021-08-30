USE Northwind;

-- INDEX ���� ��� (Access)
-- Index Scan vs Index Seek

-- Index Scan�� ���ڱ� ������ 100% ���۰� �ƴϴ�.

CREATE TABLE TestAccess (
	id		INT			NOT NULL
,	name	NCHAR(50)	NOT NULL
,	dummy	NCHAR(1000)	NULL
);
GO


CREATE CLUSTERED INDEX TestAccess_CI
ON TestAccess(id);
GO

CREATE NONCLUSTERED INDEX TestAccess_NCI
ON TestAccess(name);
GO

DECLARE @i INT;
SET @i = 1;

WHILE (@i <= 500)
BEGIN
	INSERT INTO TestAccess
	VALUES (@i, 'Name' + CONVERT(VARCHAR, @i), 'Hello World ' + CONVERT(VARCHAR, @i));
	SET @i = @i + 1;
END


-- INDEX ����.
EXEC sp_helpindex 'TestAccess';

-- INDEX ��ȣ.
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('TestAccess');

-- ��ȸ.
DBCC IND('Northwind', 'TestAccess', 1);
DBCC IND('Northwind', 'TestAccess', 2);

-- CLUSTERED(1) : id
--             XXX
-- XXX XXX XXX XXX XXX ~ XXX (169)

-- NONCLUSTERED(2) : name
--             XXX
-- XXX XXX XXX XXX XXX ~ XXX (15)

-- ���� �б�
-- �� ���� DATA�� ã�� ���� ���� PAGE ��.
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- ���� ��, [ Ctrl + L ] Ŭ��.
-- INDEX SCAN = LEAF PAGE�� ���������� �˻�.
-- ���� �б� 169��.
-- ROOT(1��) �� LEAF ��ȸ(N��) = �� 169��.
SELECT	*
FROM	TestAccess;

-- ���� ��, [ Ctrl + L ] Ŭ��.
-- INDEX SEEK
-- ���� �б� 2��.
-- ROOT(1��) �� �´� LEAF(1��) = �� 2��.
SELECT	*
FROM	TestAccess
WHERE	id = 104;


-- INDEX SEEK + KEY LOOKUP
-- ���� �б� 4��.
-- ROOT(1��) �� �´� LEAF(1��): id �� ����.  ( Non-Clustered ���� )
-- ROOT(1��) �� ������ id���� �´� LEAF(1��) ( Clustered ���� )
-- = �� 4��.
SELECT	*
FROM	TestAccess
WHERE	name = 'name5';


-- INDEX SCAN + KEY LOOKUP
-- Ƚ��: N * 2 + @
-- SCAN �ӿ��� 0ms�� �����.
-- ���� �б� 13��.
-- ROOT(1��) �� ���� LEAFŽ�� (5��): id �� ����. ( Non-Clustered ���� )
-- ROOT(1��) �� ������ id���� �´� LEAF(N��)     ( Clustered ���� )
-- = �� 13��.
-- name�� �������� order by�� �ߴµ�,
-- name�� Non-Clustered Index�̴�. ( Index�� �̹� ���ĵǾ� �ִ� ���̴�. )
-- ����, ���ĵǾ� �ִ� LEAF�鿡�� ���������� TOP 5�� �����ϱ� ������,
-- ������ ����� ���� �� �ִ�.
SELECT		TOP 5 *
FROM		TestAccess
ORDER BY	name;
