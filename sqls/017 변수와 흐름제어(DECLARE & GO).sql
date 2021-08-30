USE BaseballData;


----------- ���� -----------
-- @�� ���� �ʿ�� ������,
-- Ȥ�ó� �ٸ� table�� �̸��� ��ĥ �� �ֱ� ������,
-- �ٿ��ִ°� ����.
DECLARE @i AS INT = 10;

DECLARE @j AS INT;
SET @j = 20;


-- ����) ���� �ְ� ������ ���� ������ �̸���?
--DECLARE @firstName AS NVARCHAR(15);
--DECLARE @lastName AS NVARCHAR(15);
--SELECT	@firstName = (	SELECT TOP 1 nameFirst
--						FROM		players AS p
--									INNER JOIN salaries AS s
--									ON p.playerID = s.playerID
--						ORDER BY	s.salary DESC);

-- SQL Server�� ����.
DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);
SELECT		TOP 1 @firstName = p.nameFirst, @lastName = p.nameLast
FROM		players AS p
			INNER JOIN salaries AS s
			ON p.playerID = s.playerID
ORDER BY	s.salary DESC;
SELECT @firstName + ' ' + @lastName AS FullName;



----------- ��ġ(batch) -----------
GO
-- ��ġ(GO)�� �̿��Ͽ� ������ SCOPE ���� ����. ( {} )
DECLARE @i AS INT = 10;

-- ��ġ(GO)�� �̿��Ͽ� ����Ǵ� ������ �з��� �� ����.

-- �Ʒ��� ���� ����,
-- ���� ��ġ(GO)�� ���ٸ�,
-- salaries�� Ž���� ������� ������,
-- ��ġ(GO)�� ���� ���,
-- salaries�� Ž���� �����.
SELECT	*
FOM		players;
GO
SELECT	*
FROM	salaries;



----------- �帧 ���� -----------

GO
DECLARE @i AS INT = 10;

-- IF ���� QUERY ����
IF @i = 10
	PRINT('BINGO!');
ELSE
	PRINT('NO!');

-- IF ���� QUERY ����
IF @i = 10
	BEGIN
	PRINT('CONGRATURATION!');
	PRINT('BINGO!');
	END
ELSE
	BEGIN
	PRINT('NO!');
	END

-- WHILE
GO
DECLARE @i AS INT = 0;
WHILE @i <= 10
	BEGIN
	PRINT @i;
	SET @i = @i + 1;
	IF @i = 6 BREAK; -- CONTINUE �� ����.
END;



----------- ���̺� ���� -----------
-- �ӽ÷� ����� TABLE�� ������ ���� �� �ִ�.
-- DECLARE�� ����Ͽ� tempdb database�� �ӽ� ����.

GO
DECLARE @test TABLE
(
	name	VARCHAR(50)	NOT NULL
,	salary	INT			NOT NULL
);

INSERT INTO @test
SELECT	p.nameFirst + ' ' + p.nameLast, s.salary
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;

SELECT	*
FROM	@test;
