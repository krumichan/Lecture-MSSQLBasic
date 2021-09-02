USE BaseballData;

-- SORTING �߻�.
-- 1) SORT MERGE JOIN
    -- ����: �˰��� Ư�� ��, MERGE�ϱ� ���� SORTING�� �����Ѵ�.
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX



-- 1) ����.

-- 2) ORDER BY
--  ����: college ������ ������ �ؾ��ϱ� ������ SORTING �߻�.
--        ( INDEX�� ���� ������ �밡��. )
SELECT		*
FROM		players
ORDER BY	college;


-- 3) GROUP BY
--  ����: college���� grouping�Ͽ� �����ϱ� ���� SORTING �߻�.
SELECT		college, COUNT(college)
FROM		players
WHERE		college LIKE 'C%'
GROUP BY	college;


-- 4) DISTINCT
--  ����: �ߺ��� �����ϱ� ���Ͽ� ������ ���� SORTING �߻�.
SELECT	DISTINCT college
FROM	players
WHERE	college LIKE 'C%';


-- 5) UNION
--  ����: ������ ��ĥ ��, �ߺ��� �����ϴµ�, �� �ߺ��� ������ ���� SORTING �߻�.
-- ���࿡ �ߺ��� �ֵ� ���� ��� ���� �����,
-- UNION ALL�� ����ϴ� ���� �ξ� ȿ�����̴�.
SELECT	college
FROM	players
WHERE	college LIKE 'B%'
UNION
SELECT	college
FROM	players
WHERE	college LIKE 'C%';


-- 6) ���� WINDOW FUNCTION
--  ����: ���踦 ���� college ������ ������ �ʿ䰡 �־ SORTING �߻�.
SELECT	ROW_NUMBER() OVER (ORDER BY college)
FROM	players;


-- 7) MIN MAX
--  MIN MAX ���� ���踦 ���� SORTING�� ����.



-- INDEX�� �� Ȱ���ϸ� SORTING�� ���� ���� �� �ִ�.
-- ( INDEX ���� ��, �̹� SORTING�� ����Ǿ� �ֱ� �����̴�. )

-- batting Table�� playerID, yearID, stint ������ INDEX�� �����Ǿ� �ִ�.
-- �Ʒ��� ���� ��ȹ�� �� ���, INDEX�� ���� SORTING�� �߻����� ������ �� �� �ִ�.
SELECT		*
FROM		batting
ORDER BY	playerID, yearID;



-- ������ ��� --
-- Sorting( ���� )�� ���δ�.

-- O(N * LogN) �� DATABASE�� DATA�� ���� ��Ӿ��ϰ� ����.
-- �ʹ� �뷮�� �ż� ���� MEMORY�� ������ ���� ���� ���, DISK���� Ž���Ѵ�.
-- SORTING�� ���� �Ͼ���� �ľ��ϰ� �־�� �Ѵ�.
-- ���� ������,
-- QUERY�� �ۼ��� ��,
-- SORTING�� ���� �ʿ�����,
-- ���� �ʿ��� ���, INDEX ����� ����غ��� �Ѵ�.

-- SORTING �߻�.
-- 1) SORT MERGE JOIN
    -- ����: �˰��� Ư�� ��, MERGE�ϱ� ���� SORTING�� �����Ѵ�.
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX
