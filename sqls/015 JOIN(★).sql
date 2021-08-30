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


-- JOIN( ���� )

-- CROSS JOIN( ���� ���� )
-- CROSS JOIN ����� Table���� �����ϸ� ���ս�Ų��.
-- ���� : Data�� �������� Cost�� �ſ� ��������.
-- 3table * 3table = 9table.
-- ��, (N Table) * (M Table) = (N*M Table) �̴�.
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
-- �� ���� TABLE�� ���η� �����Ѵ�.
-- ( ���� ������ 'ON' ������ �̿��Ѵ�. )
-- ex) 'playerID'�� players, salaries ���ʿ� �� ������, ��ġ�ϴ� ���.
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;


-- OUTER JOIN
-- LEFT / RIGHT
-- ��� ���ʿ��� DATA�� �����ϴ� ���,
-- ��� ��å�� �������� �ϴ°�?

-- LEFT JOIN
-- �� ���� TABLE�� ���η� �����Ѵ�.
-- ( ���� ������ 'ON' ������ �̿��Ѵ�. )
-- ex) playerID�� ����(players)�� ������ ������ ǥ���ϸ�,
-- ������(salaries)�� ������ ������ ������ NULL�� ǥ��.
SELECT	*
FROM	players AS p
		LEFT JOIN salaries AS s
		ON p.playerID = s.playerID;

-- RIGHT JOIN
-- �� ���� TABLE�� ���η� �����Ѵ�.
-- ( ���� ������ 'ON' ������ �̿��Ѵ�. )
-- ex) playerID�� ������(players)�� ������ ������ ǥ���ϸ�,
-- ����(salaries)�� ������ ������ ������ NULL�� ǥ��.
SELECT	*
FROM	players AS p
		RIGHT JOIN salaries AS s
		ON p.playerID = s.playerID;
