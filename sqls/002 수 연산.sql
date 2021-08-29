

-- 연산.
-- + - * / % 사용 가능.


USE BaseballData;


-- ① 간단한 연산.
-- 아래 에러가 나는 이유는 실행 순서 문제.
-- FROM → WHERE → SELECT → ORDER BY 순으로,
-- koreanAge가 정의되기 전에 WHERE문을 수행한다.
SELECT		2021 - birthYear AS koreanAge
FROM		players
WHERE		deathYear IS NULL
AND			birthYear IS NOT NULL
-- AND			koreanAge <= 80 : 에러가 난다.
AND			(2021 - birthYear) <= 80
ORDER BY	koreanAge;


-- ② NULL을 포함한 연산
-- 결과는 NULL이다.
-- NULL 연산은 무조건 NULL이 나온다.
SELECT	2021 - NULL;


-- ③ 정수/실수 연산.
SELECT	3 / 2;		-- 결과는 1 ( 정수/정수는 정수다. )
SELECT	3.0 / 2;	-- 결과는 1.5
SELECT	3 / 0;		-- ERROR(0 나누기) 발생.


-- ④ 각종 연산.
-- 참고 사이트 : https://docs.microsoft.com/en-us/sql/t-sql/functions/sin-transact-sql?view=sql-server-ver15
-- 반올림 연산. ( 3.141 )
SELECT	ROUND(3.141423231, 3);
-- N제곱 연산. ( 8 )
SELECT	POWER(2, 3);
-- 코사인 연산. (1)
SELECT	COS(0);