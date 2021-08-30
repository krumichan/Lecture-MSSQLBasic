USE GameDB;

CREATE TABLE testA (
	a	INTEGER
);
CREATE TABLE testB (
	b	VARCHAR(10)
);

-- A(1, 2, 3)
INSERT INTO testA
VALUES		(1)
,			(2)
,			(3);
-- B(a, b, c)
INSERT INTO testB
VALUES		('A')
,			('B')
,			('C');

SELECT * FROM testA;
SELECT * FROM testB;


-- JOIN( 결합 )

-- CROSS JOIN( 교차 결합 )
-- CROSS JOIN 대상이 Table들을 교차하며 결합시킨다.
-- 단점 : Data가 많아지면 Cost가 매우 높아진다.
-- 3table * 3table = 9table.
-- 즉, (N Table) * (M Table) = (N*M Table) 이다.
SELECT	*
FROM	testA
		CROSS JOIN testB;
SELECT	*
FROM	testA, testB;

---------------------------------------------------------------

USE BaseballData;

SELECT		*
FROM		players
ORDER BY	playerID;
SELECT		*
FROM		salaries
ORDER BY	playerID;


-- INNER JOIN
-- 두 개의 TABLE을 가로로 결합한다.
-- ( 결합 기준은 'ON' 조건을 이용한다. )
-- ex) 'playerID'가 players, salaries 양쪽에 다 있으며, 일치하는 경우.
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;


-- OUTER JOIN
-- LEFT / RIGHT
-- 어느 한쪽에만 DATA가 존재하는 경우,
-- 어떠한 정책을 기준으로 하는가?

-- LEFT JOIN
-- 두 개의 TABLE을 가로로 결합한다.
-- ( 결합 기준은 'ON' 조건을 이용한다. )
-- ex) playerID가 왼쪽(players)에 있으면 무조건 표시하며,
-- 오른쪽(salaries)에 없으면 오른쪽 정보는 NULL로 표시.
SELECT	*
FROM	players AS p
		LEFT JOIN salaries AS s
		ON p.playerID = s.playerID;

-- RIGHT JOIN
-- 두 개의 TABLE을 가로로 결합한다.
-- ( 결합 기준은 'ON' 조건을 이용한다. )
-- ex) playerID가 오른쪽(players)에 있으면 무조건 표시하며,
-- 왼쪽(salaries)에 없으면 오른쪽 정보는 NULL로 표시.
SELECT	*
FROM	players AS p
		RIGHT JOIN salaries AS s
		ON p.playerID = s.playerID;
