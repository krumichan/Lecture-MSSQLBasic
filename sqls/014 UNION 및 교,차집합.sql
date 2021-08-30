USE BaseballData;


-- RDBMS (Relational ������ )
-- �����͸� �������� ����.

-- ������ ���̺��� �ٷ�� ���

-- Ŀ���� ��� ������ 3000000 �̻��� �������� playerID
SELECT		playerID, AVG(salary)
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000


-- 12���� �¾ �������� playerID
SELECT	playerID, birthMonth
FROM	players
WHERE	birthMonth = 12;


-- [Ŀ���� ��� ������ 3000000 �̻�] || [12���� �¾] ����.
-- ## UNION ( �ߺ� ����)
-- ( ������ )
-- UNION�� ����� ���, UNION ����� �Ǵ� ����� COLUMN�� ��ġ�Ͽ��� �Ѵ�.
-- ( �ȱ׷��� ���� ���� �з��� �ٸ� DATA�� ��������. )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
UNION
SELECT		playerID
FROM		players
WHERE		birthMonth = 12;


-- ## UNION ALL ( �ߺ� ��� )
-- ( ������ )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
UNION ALL
SELECT		playerID
FROM		players
WHERE		birthMonth = 12
ORDER BY	playerID;


-- [Ŀ���� ��� ������ 3000000 �̻�] && [12���� �¾] ����.
-- ## INTERSECT
-- ( ������ )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
INTERSECT
SELECT		playerID
FROM		players
WHERE		birthMonth = 12;


-- [Ŀ���� ��� ������ 3000000 �̻�] - [12���� �¾] ����.
-- ## EXCEPT
-- ( ������ )
SELECT		playerID
FROM		salaries
GROUP BY	playerID
HAVING		AVG(salary) >= 3000000
EXCEPT
SELECT		playerID
FROM		players
WHERE		birthMonth = 12;
