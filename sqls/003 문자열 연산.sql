

USE BaseballData;

-- string ���� ����.
-- ���� ����Ʈ : https://docs.microsoft.com/en-us/sql/t-sql/functions/substring-transact-sql?view=sql-server-ver15

-- �� ������ ���� ���.
SELECT	'Hello World';
-- ?????.
SELECT	'�ȳ��ϼ���.';
-- N�� �������ν� �����ڵ����� �˷��ش�.
SELECT	N'�ȳ��ϼ���.';


-- �� ���ڿ� �̾� ���̱�.
SELECT	'Hello ' + 'World';


-- �� ���ڿ� �߶󾲱�.
-- ���� ��ġ�� 0�� �ƴ� 1�̴�.
SELECT	SUBSTRING('20200425', 1, 4); -- 2020


-- �� ���� �����.
SELECT	TRIM('       HelloWorld'); -- HelloWorld


SELECT	nameFirst + ' ' + nameLast AS fullName
FROM	players
WHERE	nameFirst IS NOT NULL AND nameLast IS NOT NULL;