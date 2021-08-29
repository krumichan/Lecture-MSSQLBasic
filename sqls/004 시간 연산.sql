USE BaseballData;


-- DATE		연/월/일
-- TIME		시/분/초
-- DATETIME	연/월/일/시/분/초

IF NOT EXISTS
	(SELECT * FROM information_schema.tables WHERE table_name='DateTimeTest')
CREATE TABLE DateTimeTest (
	time	DATETIME
)
GO

INSERT INTO DateTimeTest (time)
VALUES		( '20200425 05:04' )
,			( CAST('20200425 05:03:21' AS DATETIME) )
,			( CURRENT_TIMESTAMP )
GO

SELECT	*
FROM	DateTimeTest
GO


-- ① DateTime 캐스팅
-- Casting Format 권장.
-- YYYYMMDD
-- YYYYMMDD hh:mm:ss.nnn
-- YYYY-MM-DDThh:mm
SELECT	CAST('20200425' AS DATETIME);
SELECT	CAST('20200425 05:03:21' AS DATETIME);


-- ② 현재 시간
-- 아래는 매우 위험한데,
-- 사용하는 머신 시간을 기준으로 하기 때문.
SELECT	GETDATE();
SELECT	CURRENT_TIMESTAMP;


-- ③ 조건 연도 검색.
SELECT	*
FROM	DateTimeTest
-- WHERE	time >= CAST( '20100101' AS DATETIME )
WHERE	time >= '20100101';


-- ④ UTC 시간( 전국가 공용 시간 ) 사용.
-- GMT ( Greenwich Mean Time )
SELECT	GETUTCDATE();


-- ⑤ 시간 연산( 더하기/빼기 ).
SELECT	DATEADD(YEAR, 1, '20200426');
SELECT	DATEADD(DAY, 6, '20200426');
SELECT	DATEADD(SECOND, -123323, '20200426');


-- ⑥ 두 시간의 차이.
SELECT	DATEDIFF(SECOND, '20200426', '20200503'); -- 604800
SELECT	DATEDIFF(SECOND, '20200826', '20200503'); -- -9936000
SELECT	DATEDIFF(DAY, '20200426', '20200503');


-- ⑦ 일부 추출.
SELECT	DATEPART(DAY, '20200826');
SELECT	YEAR('20200826');
SELECT	MONTH('20200826');
SELECT	DAY('20200826');
