USE BaseballData;


-- �����Լ�
-- COUNT
-- SUM
-- AVG
-- MIN
-- MAX


-- �� �� ���� ����.
-- *�� ���� �� �ִ� ���� COUNT�� �����ϴ�.
SELECT	COUNT(*) -- 16564
FROM	players;


-- �����Լ��� NULL�� �����Ѵ�.
SELECT	COUNT(birthYear) -- 16323
FROM	players;


-- �� �ߺ� ����.
SELECT	DISTINCT birthCity
FROM	players;


-- �� DISTINCT�� ����.
-- year, month, day�� ���� �ٸ� �͸� ��µȴ�.
SELECT		DISTINCT birthYear, birthMonth, birthDay
FROM		players
ORDER BY	birthYear;


-- �� �������� DISTINCT COUNT
-- �Ʒ� �� ����� ���� ������,
-- COUNT�� ���� ����ǰ� DISTINCT�� �ϱ� ����.
SELECT	DISTINCT COUNT(birthCity) -- 16108
FROM	players;
SELECT	COUNT(birthCity) -- 16108
FROM	players;


-- �� �ùٸ� DISTINCT COUNT
-- �����Լ�(DISTINCT ����)
SELECT	COUNT(DISTINCT birthCity)
FROM	players;


-- �� �������� ��� weight. (�Ŀ��)
SELECT	AVG(weight)
FROM	players;
SELECT	SUM(weight) / COUNT(weight)
FROM	players;


-- �� �������� ��� weight. (�Ŀ��)
-- weight�� null�� ��� 0���� ���.
SELECT	AVG(CASE WHEN weight IS NULL THEN 0 ELSE weight END)
FROM	players;


-- MIN / MAX
SELECT	MIN(weight), MAX(weight)
FROM	players;
