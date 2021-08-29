USE BaseballData;


-- ����
-- 2004�⵵ ������ �Ҽ����� ������ �������� Ÿ�� ����
SELECT	*
FROM	batting
WHERE	yearID = 2004 AND teamID = 'BOS';

-- 2004�⵵ ������ �Ҽ����� �����ؼ� ���� Ȩ�� ����
SELECT	SUM(HR)
FROM	batting
WHERE	yearID = 2004 AND teamID = 'BOS';

-- Q) 2004�⵵�� ���� ���� Ȩ���� ���� ����?
-- �� Grouping �ʿ�.
SELECT		*
FROM		batting
WHERE		yearID =2004
ORDER BY	teamID;

-- Group By�� ���� �Լ� �Ǵ� Gourping ��� �����ϴ�.
-- �Ʒ��� error�� �߻��Ѵ�.
SELECT		playerID
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID;


-- �� ������ Grouping
SELECT		teamID
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID;


-- �� ���� �Լ� Grouping
SELECT		teamID, COUNT(hr) AS homeRuns
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID;


-- �� 2004�⵵�� ���� ���� Ȩ���� ���� ����?
SELECT		TOP 1 teamID, SUM(hr) AS homeRuns
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID
ORDER BY	homeRuns DESC;


-- �� 2004�⵵�� 200 Ȩ�� �̻��� ���� ����?
SELECT		teamID, SUM(hr) AS homeRuns
FROM		batting
WHERE		yearID = 2004
GROUP BY	teamID
HAVING		SUM(hr) >= 200
ORDER BY	teamID;


-- ���� ���� : FROM �� WHERE �� GROUP BY �� HAVING �� SELECT �� ORDER BY


-- �� ���� ������ ���� ���� Ȩ���� ���� ����?
SELECT		TOP 1 teamID, yearID, SUM(hr) AS homeRuns
FROM		batting
GROUP BY	teamID, yearID -- yeamID�� yearID�� ��� ���� ROW�� GROUPING
ORDER BY	homeRuns DESC;
