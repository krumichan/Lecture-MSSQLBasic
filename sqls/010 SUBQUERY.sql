USE	BaseballData;

-- SubQuery (서브쿼리/하위쿼리)
-- SQL 명령문 안에 지정하는 하부 SELECT

-- 연봉이 역대급으로 높은 선수의 정보를 추출.
-- 아래와 같이 2개를 실행 해야함.
SELECT		TOP 1 *
FROM		salaries
ORDER BY	salary DESC;
SELECT		*
FROM		players
WHERE		playerID = 'rodrial01';

-- 위의 예를 한 번에 실행.
-- 단일행 subquery ( subquery의 결과가 하나. )
SELECT	*
FROM	players
WHERE	playerID = (	SELECT		TOP 1 playerID
						FROM		salaries
						ORDER BY	salary DESC);


-- 다중행
-- IN을 사용한다.
-- IN : 여러 결과 중에 하나라도 포함할 경우.
SELECT	*
FROM	players
WHERE	playerID IN (	SELECT		TOP 20 playerID
						FROM		salaries
						ORDER BY	salary DESC);


-- SELECT에서 사용.
SELECT	(	SELECT	COUNT(*)
			FROM	players) AS playerCount
,		(	SELECT	COUNT(*)
			FROM	batting) AS battingCount;


-- INSERT에서 사용.
-- subquery를 ()로 한 번 감싸줘야 한다.
INSERT INTO	salaries
VALUES		(2020, 'KOR', 'NL', 'jongseon', (SELECT MAX(salary) FROM salaries));


-- ① INSERT SELECT
INSERT INTO salaries
SELECT		2020, 'KOR', 'NL', 'jongseon2', (SELECT MAX(salary) FROM salaries);


-- ② INSERT SELECT ( 임의 TABLE DATA 전부 복사 )
IF NOT EXISTS
	(SELECT * FROM information_schema.tables WHERE table_name = 'salaries_temp')
CREATE TABLE salaries_temp (
	yearID		INT
,	playerID	VARCHAR(9)
,	salary		INT NOT NULL
);

INSERT INTO	salaries_temp
SELECT		yearID, playerID, salary FROM salaries;

DROP TABLE salaries_temp;



-- 포스트 시즌 타격에 참여한 선수들 목록.
-- ( battingpost와 players에 모두 존재하는 player를 추출. )
SELECT	*
FROM	players
WHERE	playerID IN (	SELECT	playerID
						FROM	battingpost);

-- 상관관계 Subquery
-- EXISTS, NOT EXISTS
-- EXISTS가 IN보다 확장성이 높다.
SELECT			*
FROM			players
WHERE EXISTS	(	SELECT	playerID
					FROM	battingpost
					WHERE	battingpost.playerID = players.playerID );

-- IN과 EXISTS
-- [F5] 실행 후, [Ctrl + L]을 통해 "실행계획"을 보면,
-- IN과 EXISTS는 완전 동일하게 실행되는 것을 확인 가능.
