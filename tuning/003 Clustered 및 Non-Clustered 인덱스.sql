USE Northwind;

-- INDEX 종류
-- Clustered(영한 사전) vs Non-Clustered( 색인 )

-- Clustered
    -- Leaf Page = Data Page
	-- DATA는 Clustered Index의 key 순서로 정렬된다.

-- Non-Clustered ? ( Clustered Index 유무에 따라 다르게 동작. )
-- 1) Clustered Index가 없는 경우.
    -- DATA는 Heap Table이라는 곳에 저장.
	-- Heap RID란 Heap Table의 RID이다.
	-- ⇒ RID를 이용하여 Heap Table에 접근 후 DATA를 추출한다.
-- 2) Clustered Index가 있는 경우.
    -- Heap Table이 없음. Leaf Table에 실제 DATA가 있다.
	-- Heap RID는 없으며, Clustered Index의 실제 key 값을 가지고 있다.



-- 임시 Test Table을 만들고 DATA 복사.
SELECT	*
INTO	TestOrderDetails
FROM	[Order Details];
SELECT * FROM TestOrderDetails;

-- Non-Clustered INDEX 추가.
CREATE INDEX Index_OrderDetails
ON TestOrderDetails(OrderID, ProductID);

-- INDEX 정보.
EXEC sp_helpindex 'TestOrderDetails';
-- INDEX 번호 찾기.
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('TestOrderDetails');
-- INDEX 조회.
-- PageType 1(DATA PAGE) 2(INDEX PAGE)
--  ⇒ DATA를 담고 있는가? INDEX를 담고 있는가?
--  Non-Clustered의 경우 2(INDEX PAGE)를 담고 있다.
DBCC IND('Northwind', 'TestOrderDetails', 2);
--           XXX
-- XXX XXX XXX XXX XXX XXX XXX
-- 위와 같은 구조.

-- Heap RID가 존재한다.
-- Heap RID([Page Address(4)][File ID(2)][Slot(2)] ROW)
-- Heap Table[ {Page} {Page} {Page} {Page} ]
-- DBCC PAGE('Northwind', 1, XXX, 3);


-- Clustered INDEX 추가.
CREATE CLUSTERED INDEX Index_OrderDetails_Clustered
ON TestOrderDetails(OrderID);

-- INDEX 정보.
EXEC sp_helpindex 'TestOrderDetails';
-- ROOT가 아닌 다른 것을 검색해본다.
-- 확인 결과, 'Heap RID'가 없어진 것을 볼 수 있다.
-- 또한, UNIQUIFIER이 생겼는데,
-- CLUSTERED INDEX의 경우, PRIMARY KEY와 다르게
-- 같은 VALUE라도 같은 (key)를 설정할 수 있다.
-- 때문에 이를 내부적으로 구별하기 위하여 'UNIQUIFIER'을 설정한다.
-- DBCC PAGE('Northwind', 1, XXX, 3);

-- INDEX 조회.
-- PageType 1(DATA PAGE) 2(INDEX PAGE)
--  ⇒ DATA를 담고 있는가? INDEX를 담고 있는가?
--  Clustered의 경우 1(DATA PAGE)를 담고 있다.
DBCC IND('Northwind', 'TestOrderDetails', 1);
