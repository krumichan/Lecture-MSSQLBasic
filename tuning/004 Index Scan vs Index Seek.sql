USE Northwind;

-- INDEX 접근 방식 (Access)
-- Index Scan vs Index Seek

-- Index Scan이 나쁘긴 하지만 100% 나쁜건 아니다.

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


-- INDEX 정보.
EXEC sp_helpindex 'TestAccess';

-- INDEX 번호.
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('TestAccess');

-- 조회.
DBCC IND('Northwind', 'TestAccess', 1);
DBCC IND('Northwind', 'TestAccess', 2);

-- CLUSTERED(1) : id
--             XXX
-- XXX XXX XXX XXX XXX ~ XXX (169)

-- NONCLUSTERED(2) : name
--             XXX
-- XXX XXX XXX XXX XXX ~ XXX (15)

-- 논리적 읽기
-- ⇒ 실제 DATA를 찾기 위해 읽은 PAGE 수.
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- 실행 후, [ Ctrl + L ] 클릭.
-- INDEX SCAN = LEAF PAGE를 순차적으로 검색.
-- 논리적 읽기 169번.
-- ROOT(1번) → LEAF 순회(N번) = 총 169번.
SELECT	*
FROM	TestAccess;

-- 실행 후, [ Ctrl + L ] 클릭.
-- INDEX SEEK
-- 논리적 읽기 2번.
-- ROOT(1번) → 맞는 LEAF(1번) = 총 2번.
SELECT	*
FROM	TestAccess
WHERE	id = 104;


-- INDEX SEEK + KEY LOOKUP
-- 논리적 읽기 4번.
-- ROOT(1번) → 맞는 LEAF(1번): id 값 습득.  ( Non-Clustered 영역 )
-- ROOT(1번) → 습득한 id값에 맞는 LEAF(1번) ( Clustered 영역 )
-- = 총 4번.
SELECT	*
FROM	TestAccess
WHERE	name = 'name5';


-- INDEX SCAN + KEY LOOKUP
-- 횟수: N * 2 + @
-- SCAN 임에도 0ms에 실행됨.
-- 논리적 읽기 13번.
-- ROOT(1번) → 순차 LEAF탐색 (5번): id 값 습득. ( Non-Clustered 영역 )
-- ROOT(1번) → 습득한 id값에 맞는 LEAF(N번)     ( Clustered 영역 )
-- = 총 13번.
-- name을 기준으로 order by를 했는데,
-- name은 Non-Clustered Index이다. ( Index는 이미 정렬되어 있는 것이다. )
-- 따라서, 정렬되어 있는 LEAF들에서 순차적으로 TOP 5를 추출하기 때문에,
-- 빠르게 결과를 얻을 수 있다.
SELECT		TOP 5 *
FROM		TestAccess
ORDER BY	name;
