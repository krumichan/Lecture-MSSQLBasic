USE BaseballData;


-- RDBMS (Relational 관계형 )
-- 데이터를 집합으로 간주.

-- 복수의 테이블을 다루는 방법

-- 커리어 평균 연봉이 3000000 이상인 선수들의 playerID
SELECT		playerID, AVG(salary)
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000


-- 12월에 태어난 선수들의 playerID
SELECT	playerID, birthMonth
FROM	players
WHERE	birthMonth = 12;


-- [커리어 평균 연봉이 3000000 이상] || [12월에 태어난] 선수.
-- ## UNION ( 중복 제거)
-- ( 합집합 )
-- UNION을 사용할 경우, UNION 대상이 되는 결과의 COLUMN이 일치하여야 한다.
-- ( 안그러면 같은 열에 분류가 다른 DATA가 합쳐진다. )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
UNION
SELECT		playerID
FROM		players
WHERE		birthMonth = 12;


-- ## UNION ALL ( 중복 허용 )
-- ( 합집합 )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
UNION ALL
SELECT		playerID
FROM		players
WHERE		birthMonth = 12
ORDER BY	playerID;


-- [커리어 평균 연봉이 3000000 이상] && [12월에 태어난] 선수.
-- ## INTERSECT
-- ( 교집합 )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
INTERSECT
SELECT		playerID
FROM		players
WHERE		birthMonth = 12;


-- [커리어 평균 연봉이 3000000 이상] - [12월에 태어난] 선수.
-- ## EXCEPT
-- ( 차집합 )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
EXCEPT
SELECT		playerID
FROM		players
WHERE		birthMonth = 12;
