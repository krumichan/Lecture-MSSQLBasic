USE Northwind;


-- 주문 상세 정보 확인.
SELECT		*
FROM		[Order Details]
ORDER BY	OrderID;


-- 임시 TEST TABLE을 만들고 DATA 복사.
SELECT	*
INTO	TestOrderDetails
FROM	[Order Details];
SELECT	*
FROM	TestOrderDetails;


-- 복합 INDEX 추가.
CREATE INDEX Index_TestOrderDetails
ON TestOrderDetails(OrderID, ProductID);


-- INDEX 정보 확인.
EXEC sp_helpindex 'TestOrderDetails';


-- 실행 후 [Ctrl + L] 클릭.
-- "INDEX SEEK" ⇒ 훌륭.
-- "INDEX SCAN" ⇒ Index Full Scan으로 안좋음.

-- INDEX 적용 TEST 1 ( OrderID, ProductID 둘다 사용. )
-- INDEX SEEK 사용. ⇒ 훌륭.
SELECT	*
FROM	TestOrderDetails
WHERE	OrderID = 10248 AND ProductID = 11;
--WHERE	ProductID = 11 AND OrderID = 10248; -- 순서를 바꿔도 상관 없음.


-- INDEX 적용 TEST 2 ( OrderID만 사용. )
-- INDEX SEEK 사용. ⇒ 훌륭.
SELECT	*
FROM	TestOrderDetails
WHERE	OrderID = 10248;


-- INDEX 적용 TEST 3 ( ProductID만 사용. )
-- INDEX SCAN(Table Scan) 사용. ⇒ 끔찍.
-- ( INDEX를 활용하지 못함. )
SELECT	*
FROM	TestOrderDetails
WHERE	ProductID = 11;


-- 위의 이유는 생성한 INDEX에 비밀이 있는데,
--CREATE INDEX Index_TestOrderDetails
--ON TestOrderDetails(OrderID, ProductID);
-- 위의 순서를 보면 "OrderID", "ProductID"이다.
-- 즉, OrderID를 기준으로 찾고,
--     OrderID에서 겹치는 것이 있으면
--     ProductID를 기준으로 찾는 것이다.


-- INDEX 정보.
DBCC IND('Northwind', 'TestOrderDetails', 2);
-- INDEX LEVEL을 확인해보면 0과 1만 있다.
-- 즉,
--            XXX
--  XXX XXX XXX XXX XXX XXX
-- 위와 같은 구조로 되어있다.
--DBCC PAGE('Northwind', 1, XXX, 3);
-- 위의 PAGE 정보를 확인해 보면,
-- ORDER BY OrderID, ProductID 처럼 정렬되어 있는 것을 확인할 수 있다.
-- 즉, OrderID를 먼저 정렬하고 그 안에서 같은 경우,
-- ProductID 기준으로 정렬한 것을 알 수 있다.
-- 위의 이유로,
--   ( OrderID, ProductID ) 또는 ( ProductID, OrderID ) 로 검색할 경우 GOOD
--   ( OrderID ) 로 검색할 경우 GOOD
--   ( ProductID ) 로 검색할 경우 BAD
-- 위와 같은 결과가 나오는 것이다.

-- 결론적으로
-- INDEX( A, B )로 생성했을 경우,
-- INDEX( A )는 없어도 상관 없다.
-- 하지만 B 검색이 필요할 경우,
-- INDEX( B )를 생성할 필요가 있다.


-- INDEX는 DATA가 추가/갱신/삭제 되어도 유지되어야 함.

DECLARE @i INT = 0;
WHILE @i < 50
BEGIN
	INSERT INTO TestOrderDetails
	VALUES ( 10248, 100 + @i, 10, 1, 0);
	SET @i = @i + 1;
END;

-- INDEX 정보.
DBCC IND('Northwind', 'TestOrderDetails', 2);
--              XXX
--  XXX [XXX] XXX XXX XXX XXX XXX
-- 위와 같이 [XXX]처럼 새로운 PAGE가 생성된 것을 볼 수 있다.
-- 하나의 PAGE가 너무 많아져서 2개로 분리된 것이다.

-- 결론 : PAGE에 여유 공간이 없다면,
--        PAGE 분할(SPLIT)이 발생한다.

-- 가공 테스트
SELECT	LastName
INTO	TestEmployees
FROM	Employees;
SELECT * FROM TestEmployees;

-- INDEX 추가.
CREATE INDEX Index_TestEmployees
ON TestEmployees(LastName);

-- INDEX SCAN이 발생해버린다.
-- 즉, 원본을 쓰는게 아닌,
-- 가공하여 사용할 경우 INDEX가 적용되지 않는다.
-- ( 예를 들어, 그냥 자르는 것이 아닌,
--   역순으로 돌려버릴 경우,
--   INDEX의 정렬이 소용 없어지게 된다. )
SELECT	*
FROM	TestEmployees
WHERE	SUBSTRING(LastName, 1, 2) = 'Bu';


-- 위의 예를 아래와 같이 사용하면 된다.
-- ( 임의 가공이 아닌 순수 검색이기 때문. )
-- INDEX SEEK
SELECT	*
FROM	TestEmployees
WHERE	LastName LIKE 'Bu%';


-- 최종 결론
-- 복합 INDEX(A, B)를 사용할 때 순서 주의 ( A→B 순서 검색 )
-- INDEX 사용 시, DATA 추가로 인하여 PAGE의 여유 공간이 없어지면 분할(SPLIT) 된다.
-- (KEY) 가공할 때 주의할 것.
