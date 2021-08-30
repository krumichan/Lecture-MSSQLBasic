USE Northwind;



-- DB 정보 살펴보기
EXEC sp_helpdb 'Northwind';

-- 임시 TABLE 생성. ( INDEX TEST 용도 )
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


-- FILLFACTOR ( LEAF PAGE 공간 1%만 사용 )
--   ⇒ 전체 저장 공간을 100%라고 하면, 인위적으로 1%만 사용하게 설정하는 것.
--      ( DATA가 하나의 공간에 다 안들어가서 자체적으로 TREE 구조로 만들게 된다. )
-- PAD_INDEX ( FILLFACTOR가 중간 PAGE에도 적용되도록 한다. )
CREATE INDEX Test_Index ON Test(LastName)
WITH ( FILLFACTOR = 1, PAD_INDEX = ON );
GO



-- INDEX 번호 찾기
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('Test');

-- 2번 INDEX 정보 살펴보기
DBCC IND('Northwind', 'Test', 2);
-- 결과의 Index Level이 중요.

-- Root(2) → Branch(1) → Leaf(0)
--          xxx          -- 2
--      xxx     xxx      -- 1
--  xxx     xxx     xxx  -- 0
-- ⇒ 위와 같이, TREE 구조이다.
-- 실제 정보 : Table[ {Page} {Page} {Page} {Page} {Page} ] 와 같이 되어 있으며,
--			   RID(HEAP RID)를 이용하여 DATA를 찾는다.

-- HEAP RID( [Page Address(4)][File ID(2)][SLOT NUMBER(2)] 조합한 ROW 식별자. TABLE에서 정보 추출 )
-- (key)가 있으며, TREE 구조에서 값을 찾는데 사용된다.
-- TREE의 ROOT부터 (key) 값을 비교하며 찾는 것이다.
-- ① (key)를 이용하여 TREE의 ROOT부터 탐색 → ② 찾았을 경우 RIP(HEAP RIP) 값을 추출 → ③ RIP 값을 이용하여 '실제 정보'로부터 {Page} 추출.
DBCC PAGE('Northwind', 1/*파일번호*/, 840/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('Northwind', 1/*파일번호*/, 848/*페이지번호*/, 3/*출력옵션*/);
DBCC PAGE('Northwind', 1/*파일번호*/, 849/*페이지번호*/, 3/*출력옵션*/);

-- Random Access ( 한 건을 읽기 위하여 한 PAGE씩 접근. )
--    ⇒ ① (key)를 이용하여 TREE의 ROOT부터 탐색
-- Bookmark Lookup ( RID를 통해 행을 탐색. )
--    ⇒ ③ RIP 값을 이용하여 '실제 정보'로부터 {Page} 추출.
