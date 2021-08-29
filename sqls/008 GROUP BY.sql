USE BaseballData;


-- 복습
-- 2004년도 보스턴 소속으로 출전한 선수들의 타격 정보
SELECT	*
FROM	batting
WHERE	yearID = 2004 AND teamID = 'BOS';

-- 2004년도 보스턴 소속으로 출전해서 날린 홈런 개수
SELECT	SUM(HR)
FROM	batting
WHERE	yearID = 2004 AND teamID = 'BOS';

-- Q) 2004년도에 가장 많은 홈런을 날린 팀은?
-- ⇒ Grouping 필요.
SELECT		*
FROM		batting
WHERE		yearID =2004
ORDER BY	teamID;

-- Group By는 집계 함수 또는 Gourping 대상만 가능하다.
-- 아래는 error가 발생한다.
SELECT		playerID
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID;


-- ① 간단한 Grouping
SELECT		teamID
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID;


-- ② 집계 함수 Grouping
SELECT		teamID, COUNT(hr) AS homeRuns
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID;


-- ③ 2004년도에 가장 많은 홈런을 날린 팀은?
SELECT		TOP 1 teamID, SUM(hr) AS homeRuns
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID
ORDER BY	homeRuns DESC;


-- ④ 2004년도에 200 홈런 이상을 날린 팀은?
SELECT		teamID, SUM(hr) AS homeRuns
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID
HAVING		SUM(hr) >= 200
ORDER BY	teamID;


-- 실행 순서 : FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY


-- ⑤ 단일 연도에 가장 많은 홈런을 날린 팀은?
SELECT		TOP 1 teamID, yearID, SUM(hr) AS homeRuns
FROM		batting
GROUP BY	teamID, yearID -- yeamID와 yearID가 모두 같은 ROW를 GROUPING
ORDER BY	homeRuns DESC;
