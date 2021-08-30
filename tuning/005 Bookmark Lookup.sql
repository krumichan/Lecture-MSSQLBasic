USE Northwind;

-- Bookmark Lookup

-- Index Scan vs Index Seek
-- Idnex Scan이 항상 나쁜 건 아니고,
-- Index Skke가 항상 좋은 건 아니다.
-- INDEX를 활용하는데 왜 늦어질 수 있는 걸까?

-- Non-Clustered
--      1
--  2 3 4 5 6   - LEAF PAGE


-- Clustered
--      1
--  2 3 4 5 6   - LEAF PAGE

-- Heap Table[ {Page} {Page} ]

-- Clustered의 경우 INDEX SEEK가 느릴 수 없다.
-- NonClustered의 경우, DATA가 LEAF PAGE에 없다.
-- 따라서, 한 번 더 검색을 해야한다.
   -- 1) RID → Heap Table ( Bookmark Lookup )
   -- 2) Key → Clustered


SELECT	*
INTO	TestOrders
FROM	Orders;
SELECT	* FROM TestOrders;

CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID);

-- INDEX 번호.
SELECT	index_id
,		name
FROM	sys.indexes
WHERE	object_id = object_id('TestOrders');
-- INDEX 조회.
DBCC IND('Northwind', 'TestOrders', 2);
--       920
--  840  888  889 -- LEAF PAGE
-- Heap Table[ {Page} {Page} ]

SET STATISTICS TIME ON;		-- query 실행 소요 시간.
SET STATISTICS IO ON;		-- query 실행 읽기/쓰기 횟수.
SET STATISTICS PROFILE ON;	-- 실제 실행 순서.



-- 기본 탐색.
-- TABLE SCAN: 내부적으로 INDEX SEEK보다 빠르다고 판단하여 SCAN을 수행.
-- 논리적 읽기: 20
SELECT	*
FROM	TestOrders
WHERE	CustomerID = 'QUICK';

-- 기본 탐색. (강제 INDEX 수행)
-- 논리적 읽기: 30
-- RID Loopup을 28번 수행한다. ( 'QUICK'이 28행 존재하기 때문. )
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK';

-- 위의 예처럼, INDEX를 사용한 것이 더 느려질 때도 있다.
-- INDEX를 사용함으로, 'RID Lookup' 수행에 시간이 더 걸려버린 경우이다.
-- ( Heap Table에 있는 Page가 memory에 없을수도 있는데 이 경우,
--   하드 디스크까지 갔다오기 때문에 더 느려진 것. )


-- 기본 탐색 + 조건 추가.
-- RID Lookup을 28번 수행한다.
-- Non-Clustered의 Leaf Page에서는 ShipVia 정보를 알 수 없기 때문에,
-- 'QUICK' 28번 탐색을 결국 전부 수행한다.
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK'
AND		ShipVia = 3;


DROP INDEX TestOrders.Orders_Index01;


-- Covered Index
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID, ShipVia);

-- INDEX 수정 후 탐색.
-- RID Lookup을 8번 수행한다.
-- Leaf Page에 ShipVia 정보까지 있기 때문에,
-- 8번만 탐색해도 알 수 있게 된다.
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK'
AND		ShipVia = 3;


-- Q) 조건1 AND 조건2가 필요하면,
--    INDEX(조건1, 조건2)를 추가하면 된는 건가?
-- ⇒ 답은 틀리다!
--    DML(INSERT, UPDATE, DELETE) 작업 부하가 증가하게 된다.
--    조건이 늘어나므로 인해,
--    DATA 추가/삭제/갱신 시, INDEX 갱신에 시간이 더욱 걸리게 된다.

DROP INDEX TestOrders.Orders_Index01;


-- 실제로 key 자체는 CustomerID만 활용하지만,
-- Leaf Page에 ShipVia의 값을 포함시키겠다는 의미.
CREATE NONCLUSTERED INDEX Orders_Index01
ON TestOrders(CustomerID) INCLUDE (ShipVia);


-- RID Lookup을 8번 수행한다.
-- Leaf Page에서 ShipVia의 값을 일단 알고 있기 때문에,
-- Heap Table을 전부 탐색하는 것이 아닌,
-- ShipVia를 참고하여 Heap Table을 탐색할 수 있다.
SELECT	*
FROM	TestOrders  WITH(INDEX(Orders_Index01))
WHERE	CustomerID = 'QUICK'
AND		ShipVia = 3;


-- 위와 같은 노력에도 답이 없다면,
-- Clustered Index 활용을 고려한다.
-- 단점은  Clustered Index는 Table 당 1개만 사용할 수 있다.

-- 결론 --

-- Non-Clustered Index가 악영향을 주는 경우는 ?
  -- Bookmark Lookup이 심각한 부하를 발생시킬 경우이다.
-- 대안은?
  -- 옵션1) Covered Index ( 검색할 모든 Column을 포함시킨다. )
  -- 옵션2) Index에 INCLUDE로 Hint를 남긴다.
  -- 옵션3) Clustered 사용을 고려한다.
           -- 단, 1번만 사용할 수 있으며,
		   -- 경우에 따라서는 Non-Clustered에 악영향을 줄수도 있다.
		   -- ( Clustered를 사용할 경우,
		   --   Non-Clustered는 Heap Table을 사용하지 않는데,
		   --   Clustered의 IndexLevel이 높다면,
		   --   Heap Table을 사용하는 것보다 효율이 떨어질수도 있기 때문이다. )
