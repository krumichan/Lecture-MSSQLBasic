USE BaseballData;


----------- 변수 -----------
-- @를 붙일 필요는 없지만,
-- 혹시나 다른 table과 이름이 겹칠 수 있기 때문에,
-- 붙여주는게 좋다.
DECLARE @i AS INT = 10;

DECLARE @j AS INT;
SET @j = 20;


-- 예제) 역대 최고 연봉을 받은 선수의 이름은?
--DECLARE @firstName AS NVARCHAR(15);
--DECLARE @lastName AS NVARCHAR(15);
--SELECT	@firstName = (	SELECT TOP 1 nameFirst
--						FROM		players AS p
--									INNER JOIN salaries AS s
--									ON p.playerID = s.playerID
--						ORDER BY	s.salary DESC);

-- SQL Server만 지원.
DECLARE @firstName AS NVARCHAR(15);
DECLARE @lastName AS NVARCHAR(15);
SELECT		TOP 1 @firstName = p.nameFirst, @lastName = p.nameLast
FROM		players AS p
			INNER JOIN salaries AS s
			ON p.playerID = s.playerID
ORDER BY	s.salary DESC;
SELECT @firstName + ' ' + @lastName AS FullName;



----------- 배치(batch) -----------
GO
-- 배치(GO)를 이용하여 변수의 SCOPE 설정 가능. ( {} )
DECLARE @i AS INT = 10;

-- 배치(GO)를 이용하여 실행되는 묶음을 분류할 수 있음.

-- 아래의 예를 보면,
-- 본래 배치(GO)가 없다면,
-- salaries의 탐색이 실행되지 않지만,
-- 배치(GO)가 있을 경우,
-- salaries의 탐색이 실행됨.
SELECT	*
FOM		players;
GO
SELECT	*
FROM	salaries;



----------- 흐름 제어 -----------

GO
DECLARE @i AS INT = 10;

-- IF 단일 QUERY 실행
IF @i = 10
	PRINT('BINGO!');
ELSE
	PRINT('NO!');

-- IF 다중 QUERY 실행
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
	IF @i = 6 BREAK; -- CONTINUE 도 가능.
END;



----------- 테이블 변수 -----------
-- 임시로 사용할 TABLE을 변수로 만들 수 있다.
-- DECLARE를 사용하여 tempdb database에 임시 저장.

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
