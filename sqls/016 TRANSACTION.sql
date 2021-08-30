USE GameDB;

SELECT	*
FROM	accounts;

DELETE	accounts;

-- TRANSACTION�� ������� ���� ���, �ڵ����� COMMIT�� �����Ѵ�.
INSERT INTO accounts VALUES (1, 'jongseon', 100, GETUTCDATE());


-- BEGIN TRAN;
-- BEGIN TRANSACTION;

-- COMMIT;		-- �ӽ÷� ����� ������ ������ �����Ѵ�.
-- ROLLBACK;	-- �ӽ÷� ��ȯ�� ������ �ı��ϰ�, ������� �ǵ�����.


BEGIN TRAN;
	INSERT INTO accounts VALUES (2, 'jongseon2', 100, GETUTCDATE());	
ROLLBACK;
SELECT * FROM accounts;

BEGIN TRAN;
	INSERT INTO accounts VALUES (2, 'jongseon2', 100, GETUTCDATE());	
COMMIT;
SELECT * FROM accounts;


-- try-catch ����
-- �ϱ� �� ���� INSERT ���� ������ ���,
-- ������� '3'�� �ش��ϴ� INSERT ���� ����ȴ�.
-- ������, TRANSACTION�� �̿��ϸ�,
-- '2'�� �ش��ϴ� INSERT ���� �����߱� ������,
-- '3'�� �ش��ϴ� INSERT �� ���� ������� �ʴ´�.
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO accounts VALUES (2, 'jongseon2', 100, GETUTCDATE());
		INSERT INTO accounts VALUES (3, 'jongseon3', 100, GETUTCDATE());
	COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 -- ���� Ȱ��ȭ �� TRANSACTION ���� ��ȯ.
		ROLLBACK
	PRINT('ROLLBACK ����.')
END CATCH;


-- TRANSACTION ����� �� ������ ��
-- TRANSACTION SCOPE������ �� '������'���� ����� QUERY�� �־�� �Ѵ�.
-- C# : List<Player> List<Salary> '������' ���� �� lock�� �ɰ� ���� �� writelock( ��ȣ��Ÿ lock ), readlock( ���� lock )

-- TRANSACTION�� '������' ������ �̷�� ���� ���� ���� LOCK�� �ɾ�δµ�,
-- ����, '������'���� ������ �ʿ䰡 ���� QUERY���� �� �־ ���࿡ �ð��� ���� �ɸ� ���,
-- LOCK���� ���� �ٸ� CONNECTOR���� QUERY ���� ��, �����¿� ��������.
