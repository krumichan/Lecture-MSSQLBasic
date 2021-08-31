USE Northwind;

-- 복합 INDEX COLUMN 순서.
-- INDEX(A, B, C)

-- Non-Clustered
--      1
--   2  3  4

-- Clustered
--      1
--   2  3  4


-- Heap Table[ {Page} {Page} ]

-- Bookmark Lookup
-- Bookmark Lookup을 통한 INDEX 탐색보다
-- SCAN이 빠른 경우도 존재한다.


-- Bookmark Lookup을 최적화하면 최적화는 끝일까?
-- 그건 아니다.
-- Leaf Page 탐색은 여전히 존재하기 때문이다.
-- [레벨, 종족] INDEX.
-- (56 Human)을 찾는다고 가정할 때,
--      1
--   2  3  4 [ (56 Human) (56 Human) (56 Human) (56 Human) (56 Human) ... ]
-- 위와 같이 Leaf Page가 구성되어 있다고 가정하면,
-- (56 Human)과 불일치 할 때까지, Leaf Page의 탐색이 필요하다.
-- 만약, (56~60 Human)처럼 범위 탐색을 할 경우, 더더욱 심해진다.


SELECT	*
INTO	TestOrders
FROM	Orders;


DECLARE @i INT = 1;
DECLARE @emp INT;
SELECT @emp = MAX(EmployeeID) FROM Orders;

-- Dummy Data를 늘린다.
WHILE	(@i < 1000)
BEGIN
		INSERT INTO TestOrders(CustomerID, EmployeeID, OrderDate)
		SELECT	CustomerID, @emp + @i, OrderDate
		FROM	Orders;
		SET		@i = @i + 1;
END

SELECT	COUNT(*)
FROM	TestOrders;


-- INDEX 생성
CREATE NONCLUSTERED INDEX idx_emp_ord
ON TestOrders(EmployeeID, OrderDate);

CREATE NONCLUSTERED INDEX idx_ord_emp
ON TestOrders(OrderDate, EmployeeID);


SET STATISTICS TIME ON;
SET STATISTICS IO ON;

-- 어느 INDEX가 더 빠를까 ?

-- 논리적 읽기: 5
-- 경과 시간: 0ms
-- 실행 계획(Ctrl + L) 동일.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_emp_ord))
WHERE	EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');

-- 논리적 읽기: 5
-- 경과 시간: 0ms
-- 실행 계획(Ctrl + L) 동일.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1 AND OrderDate = CONVERT(DATETIME, '19970101');


-- 직접 확인.
-- EmployeeID		,	   OrderDate
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-06 00:00:00	-- (X)
-- (X) 까지 3번 탐색.
SELECT		*
FROM		TestOrders
ORDER BY	EmployeeID, OrderDate;

--  OrderDate		   ,  EmployeeID
--  1997-01-01 00:00:00,      1
--  1997-01-01 00:00:00,      1
--  1997-01-06 00:00:00,      1				-- (X)
-- (X) 까지 3번 탐색.
SELECT		*
FROM		TestOrders
ORDER BY	OrderDate, EmployeeID;


-- Non-Clustered에서 '='로 찾을 경우,
-- 1. INDEX(OrderDate, EmployeeID)
-- 2. INDEX(EmployeeID, OrderDate)
-- 위의 두 INDEX의 성능 차이는 없었다.


-- 만약 범위로 찾는다면?

-- 논리적 읽기: 5
-- EmployeeID		,	   OrderDate
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-01 00:00:00
--     1			, 1997-01-06 00:00:00	-- (X)
-- (X) 까지 3번 탐색.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_emp_ord))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';

-- 논리적 읽기: 16
--  OrderDate		   ,  EmployeeID
--  1997-01-01 00:00:00,      1
--  1997-01-01 00:00:00,      1
--  1997-01-01 00:00:00,      10
--  1997-01-01 00:00:00,      10
--  1997-01-01 00:00:00,      11
--  ...
--  1997-01-06 00:00:00,      1				-- (X)
-- (X) 까지 상당한 수의 OrderDate를 읽어야 한다.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';


-- 즉,
-- [!] INDEX(A, B, C)로 구성하였을 경우,
-- 선행 INDEX( A 등 )에 BETWEEN(범위)를 사용하면,
-- 후행 INDEX( B, C )는 INDEX의 기능을 상실하는 것과 같다.
-- 따라서,
-- BETWEEN(범위)을 사용할 경우,
-- 해당 IDNEX는 후행으로 보내는 것이 좋다.
-- 그렇다면,
-- BETWEEN 같은 비교 등장 시, INDEX 순서만 바꾸면 된는걸까?
-- 그건 또 아닌 이유는,
-- 해당 INDEX가 여러 조건에서 사용되는 INDEX라면,
-- 전체적인 시점에서는 오히려 더 느려질수도 있다.
-- 결과적으로,
-- 종합적으로 확인하여 판단하여야 한다.


-- BETWEEN 범위가 작을 경우,
-- IN-LIST로 대체하는 것을 고려하는 것이 좋다.

-- 논리적 읽기: 16
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';
-- 논리적 읽기: 11
-- 논리적 읽기가 더 낮은 이유는,
-- 내부적으로 INDEX SEEK를 OR를 통해 수행하는데,
-- 똑같은 QUERY를
-- OrderDate = '19970101'
-- OrderDate = '19970102'
-- OrderDate = '19970103'
-- 위와 같이 세 번 수행하는 것을 알 수 있다.
-- 이러한 OR 수행이 범위 수행보다 더 적은 탐색을 수행한 것이다.
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate IN ('19970101', '19970102', '19970103');



-- 물론 범위가 작다고 해서 IN-LIST를 쓰는 경우,
-- 더욱 안좋아질 수 있는다.

-- 논리적 읽기: 5
SELECT	*
FROM	TestOrders WITH(INDEX(idx_emp_ord))
WHERE	EmployeeID = 1
AND		OrderDate BETWEEN '19970101' AND '19970103';
-- 논리적 읽기: 11
SELECT	*
FROM	TestOrders WITH(INDEX(idx_ord_emp))
WHERE	EmployeeID = 1
AND		OrderDate IN ('19970101', '19970102', '19970103');

-- 위와 같이,
-- 오히려 5 -> 11로 늘어난 것을 볼 수 있다.


-- 오늘의 결론
-- 1. 복합 COLUMN INDEX( 선행, 후행 ) 순서가 탐색 COST에 영향을 줄 수 있다.
-- 2. BETWEEN, 부등호(>, <) 등이 선행에 들어갈 경우, 후행은 INDEX 기능을 상실한다.
-- 3. BETWEEN의 범위가 적을 경우, IN-LIST로 대체하면 COST가 더 낮아질 수 있다. (선행에 BETWEEN)
-- 4. 선행 =, 후행 BETWEEN  일 경우, 아무런 문제가 없기 때문에 IN-LIST를 쓰지 않는 것이 좋다.
