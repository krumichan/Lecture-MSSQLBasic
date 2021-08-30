USE BaseballData;

-- Window Function
-- ( Window라고 해서 딱히 Windows에서만 되는 건 아니다. )
-- 행들의 Sub 집합을 대상으로,
-- 각 행별로 계산을 하여 Scalar(단일 고정)값을 출력하는 함수.


-- 느낌상으로 보면 GROUPING과 비슷하다.
-- SUM, COUNT, AVG 등의 집계 함수.
SELECT		*
FROM		salaries
ORDER BY	salary DESC;

SELECT		playerID, MAX(salary)
FROM		salaries
GROUP BY	playerID
ORDER BY	MAX(salary) DESC;


-- Window 함수.
-- ~OVER([PARTITION BY] [ORDER BY] [ROWS])
-- ( ORDER BY만 넣어도 나머지는 DEFAULT로 들어간다. )
-- PARTITION BY : OVER을 수행할 범위를 어떻게 나눌 것인가 정한다. ( DEFAULT 전체 )
-- ORDER BY		: 함수 결과를 출력할 때, 어떻게 정렬을 수행할 것인지 정한다.
-- ROW			: OVER의 결과를 추출할 범위를 어떻게 나눌 것인가 정한다.
--     - (DEFAULT) FRAME - FIRST ~ CURRENT 범위
--     ex) 1, 2, 3, 4, 5, 6 이 있다고 가정한다.
--         '1' 행에서는 FIRST도 '1', CURRENT도 '1'이기 때문에, ['1']만 범위에 포함된다.
--         '2' 행에서는 FIRST는 '1', CURRENT는 '2'이기 때문에, ['1', '2']가 범위에 포함된다.
--         '3' 행에선느 FIRST는 '1', CURRENT는 '3'이기 때문에, ['1', '2', '3']이 범위에 포함된다.
--         즉, FIRST_VALUE(), LAST_VALUE()를 수행할 경우,
--         FIRST_VALUE()는 FIRST에 해당하는 '1'의 VALUE가 되지만,
--         LAST_VALUE()는 CURRENT(LAST가 됨)에 해당하는 값이 된다.

-- 전체 DATA를 연봉 순서로 나열하고 순위를 표기한다.
SELECT	*
-- OVER내의 ORDER BY는 OVER 내에서만 사용한다.
,		ROW_NUMBER()	OVER(ORDER BY salary DESC) -- 행#번호
,		RANK()			OVER(ORDER BY salary DESC) -- 랭킹( 1, 2, 2, 4, 5 ... 방식 )
,		DENSE_RANK()	OVER(ORDER BY salary DESC) -- 랭킹( 1, 2, 2, 3, 4 ... 방식 )
,		NTILE(100)		OVER(ORDER BY salary DESC) -- 상위% 표시
FROM	salaries;

-- playerID 별 순위를 따로 표시한다.
SELECT		*
,			RANK()	OVER(PARTITION BY playerID ORDER BY salary DESC)
FROM		salaries
ORDER BY	playerID;


-- LAG(바로 이전), LEAD(바로 다음)
-- 즉, 랭킹을 예로 들면,
-- 1, 2, 3, 4, 5가 있다고 한다.
-- 2를 기준으로 LAG:LEAD는 1:3 이 된다.
-- 3을 기준으로 LAG:LEAD는 2:4 가 된다.
SELECT		*
,			RANK()			OVER(PARTITION BY playerID ORDER BY salary DESC)
,			LAG(salary)		OVER(PARTITION BY playerID ORDER BY salary DESC) AS prevSalary
,			LEAD(salary)	OVER(PARTITION BY playerID ORDER BY salary DESC) AS nextSalary
FROM		salaries
ORDER BY	playerID;


-- FIRST_VALUE, LAST_VALUE
SELECT		*
,			RANK()				OVER (PARTITION BY playerID ORDER BY salary DESC)
,			FIRST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC) AS best
,			LAST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC) AS worst
FROM		salaries
ORDER BY	playerID;
SELECT		*
,			RANK()				OVER (PARTITION BY playerID ORDER BY salary DESC)
-- UNBOUNDED PRECEDING : 무한하게 앞으로 가면 된다.( 즉, 맨 처음 )
-- CURRENT : 현재 위치.
,			FIRST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS best
-- UNBOUNDED FOLLOWING : 무한하게 뒤로 가면 된다. ( 즉 , 맨 끝 )
,			LAST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS worst
FROM		salaries
ORDER BY	playerID;
