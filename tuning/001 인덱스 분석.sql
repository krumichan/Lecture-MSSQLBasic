USE Northwind;



-- DB ���� ���캸��
EXEC sp_helpdb 'Northwind';

-- �ӽ� TABLE ����. ( INDEX TEST �뵵 )
CREATE TABLE Test (
	EmployeeID	INT			NOT NULL
,	LastName	VARCHAR(20)	NOT NULL
,	FirstName	VARCHAR(20)	NOT NULL
,	HireDate	DATETIME	NULL
);
GO


INSERT INTO Test
SELECT	EmployeeID, LastName, FirstName, HireDate
FROM	Employees;

SELECT	*
FROM	Test;


-- FILLFACTOR ( LEAF PAGE ���� 1%�� ��� )
--   �� ��ü ���� ������ 100%��� �ϸ�, ���������� 1%�� ����ϰ� �����ϴ� ��.
--      ( DATA�� �ϳ��� ������ �� �ȵ��� ��ü������ TREE ������ ����� �ȴ�. )
-- PAD_INDEX ( FILLFACTOR�� �߰� PAGE���� ����ǵ��� �Ѵ�. )
CREATE INDEX Test_Index ON Test(LastName)
WITH ( FILLFACTOR = 1, PAD_INDEX = ON );
GO



-- INDEX ��ȣ ã��
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('Test');

-- 2�� INDEX ���� ���캸��
DBCC IND('Northwind', 'Test', 2);
-- ����� Index Level�� �߿�.

-- Root(2) �� Branch(1) �� Leaf(0)
--          xxx          -- 2
--      xxx     xxx      -- 1
--  xxx     xxx     xxx  -- 0
-- �� ���� ����, TREE �����̴�.
-- ���� ���� : Table[ {Page} {Page} {Page} {Page} {Page} ] �� ���� �Ǿ� ������,
--			   RID(HEAP RID)�� �̿��Ͽ� DATA�� ã�´�.

-- HEAP RID( [Page Address(4)][File ID(2)][SLOT NUMBER(2)] ������ ROW �ĺ���. TABLE���� ���� ���� )
-- (key)�� ������, TREE �������� ���� ã�µ� ���ȴ�.
-- TREE�� ROOT���� (key) ���� ���ϸ� ã�� ���̴�.
-- �� (key)�� �̿��Ͽ� TREE�� ROOT���� Ž�� �� �� ã���� ��� RIP(HEAP RIP) ���� ���� �� �� RIP ���� �̿��Ͽ� '���� ����'�κ��� {Page} ����.
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 840/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 848/*��������ȣ*/, 3/*��¿ɼ�*/);
DBCC PAGE('Northwind', 1/*���Ϲ�ȣ*/, 849/*��������ȣ*/, 3/*��¿ɼ�*/);

-- Random Access ( �� ���� �б� ���Ͽ� �� PAGE�� ����. )
--    �� �� (key)�� �̿��Ͽ� TREE�� ROOT���� Ž��
-- Bookmark Lookup ( RID�� ���� ���� Ž��. )
--    �� �� RIP ���� �̿��Ͽ� '���� ����'�κ��� {Page} ����.
