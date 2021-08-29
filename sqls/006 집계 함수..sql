USE BaseballData;


-- 집계함수
-- COUNT
-- SUM
-- AVG
-- MIN
-- MAX


-- ① 총 행의 갯수.
-- *을 붙일 수 있는 것은 COUNT가 유일하다.
SELECT	COUNT(*) -- 16564
FROM	players;


-- 집계함수는 NULL을 무시한다.
SELECT	COUNT(birthYear) -- 16323
FROM	players;


-- ② 중복 제거.
SELECT	DISTINCT birthCity
FROM	players;


-- ③ DISTINCT의 범위.
-- year, month, day가 전부 다른 것만 출력된다.
SELECT		DISTINCT birthYear, birthMonth, birthDay
FROM		players
ORDER BY	birthYear;


-- ③ 옳지않은 DISTINCT COUNT
-- 아래 두 결과가 같은 이유는,
-- COUNT가 먼저 연산되고 DISTINCT를 하기 때문.
SELECT	DISTINCT COUNT(birthCity) -- 16108
FROM	players;
SELECT	COUNT(birthCity) -- 16108
FROM	players;


-- ④ 올바른 DISTINCT COUNT
-- 집계함수(DISTINCT 집합)
SELECT	COUNT(DISTINCT birthCity)
FROM	players;


-- ⑤ 선수들의 평균 weight. (파운드)
SELECT	AVG(weight)
FROM	players;
SELECT	SUM(weight) / COUNT(weight)
FROM	players;


-- ⑥ 선수들의 평균 weight. (파운드)
-- weight이 null인 경우 0으로 취급.
SELECT	AVG(CASE WHEN weight IS NULL THEN 0 ELSE weight END)
FROM	players;


-- MIN / MAX
SELECT	MIN(weight), MAX(weight)
FROM	players;
