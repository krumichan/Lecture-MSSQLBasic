USE BaseballData;

-- Window Function
-- ( Window��� �ؼ� ���� Windows������ �Ǵ� �� �ƴϴ�. )
-- ����� Sub ������ �������,
-- �� �ະ�� ����� �Ͽ� Scalar(���� ����)���� ����ϴ� �Լ�.


-- ���������� ���� GROUPING�� ����ϴ�.
-- SUM, COUNT, AVG ���� ���� �Լ�.
SELECT		*
FROM		salaries
ORDER BY	salary DESC;

SELECT		playerID, MAX(salary)
FROM		salaries
GROUP BY	playerID
ORDER BY	MAX(salary) DESC;


-- Window �Լ�.
-- ~OVER([PARTITION BY] [ORDER BY] [ROWS])
-- ( ORDER BY�� �־ �������� DEFAULT�� ����. )
-- PARTITION BY : OVER�� ������ ������ ��� ���� ���ΰ� ���Ѵ�. ( DEFAULT ��ü )
-- ORDER BY		: �Լ� ����� ����� ��, ��� ������ ������ ������ ���Ѵ�.
-- ROW			: OVER�� ����� ������ ������ ��� ���� ���ΰ� ���Ѵ�.
--     - (DEFAULT) FRAME - FIRST ~ CURRENT ����
--     ex) 1, 2, 3, 4, 5, 6 �� �ִٰ� �����Ѵ�.
--         '1' �࿡���� FIRST�� '1', CURRENT�� '1'�̱� ������, ['1']�� ������ ���Եȴ�.
--         '2' �࿡���� FIRST�� '1', CURRENT�� '2'�̱� ������, ['1', '2']�� ������ ���Եȴ�.
--         '3' �࿡���� FIRST�� '1', CURRENT�� '3'�̱� ������, ['1', '2', '3']�� ������ ���Եȴ�.
--         ��, FIRST_VALUE(), LAST_VALUE()�� ������ ���,
--         FIRST_VALUE()�� FIRST�� �ش��ϴ� '1'�� VALUE�� ������,
--         LAST_VALUE()�� CURRENT(LAST�� ��)�� �ش��ϴ� ���� �ȴ�.

-- ��ü DATA�� ���� ������ �����ϰ� ������ ǥ���Ѵ�.
SELECT	*
-- OVER���� ORDER BY�� OVER �������� ����Ѵ�.
,		ROW_NUMBER()	OVER(ORDER BY salary DESC) -- ��#��ȣ
,		RANK()			OVER(ORDER BY salary DESC) -- ��ŷ( 1, 2, 2, 4, 5 ... ��� )
,		DENSE_RANK()	OVER(ORDER BY salary DESC) -- ��ŷ( 1, 2, 2, 3, 4 ... ��� )
,		NTILE(100)		OVER(ORDER BY salary DESC) -- ����% ǥ��
FROM	salaries;

-- playerID �� ������ ���� ǥ���Ѵ�.
SELECT		*
,			RANK()	OVER(PARTITION BY playerID ORDER BY salary DESC)
FROM		salaries
ORDER BY	playerID;


-- LAG(�ٷ� ����), LEAD(�ٷ� ����)
-- ��, ��ŷ�� ���� ���,
-- 1, 2, 3, 4, 5�� �ִٰ� �Ѵ�.
-- 2�� �������� LAG:LEAD�� 1:3 �� �ȴ�.
-- 3�� �������� LAG:LEAD�� 2:4 �� �ȴ�.
SELECT		*
,			RANK()			OVER(PARTITION BY playerID ORDER BY salary DESC)
,			LAG(salary)		OVER(PARTITION BY playerID ORDER BY salary DESC) AS prevSalary
,			LEAD(salary)	OVER(PARTITION BY playerID ORDER BY salary DESC) AS nextSalary
FROM		salaries
ORDER BY	playerID;


-- FIRST_VALUE, LAST_VALUE
SELECT		*
,			RANK()				OVER (PARTITION BY playerID ORDER BY salary DESC)
,			FIRST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC) AS best
,			LAST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC) AS worst
FROM		salaries
ORDER BY	playerID;
SELECT		*
,			RANK()				OVER (PARTITION BY playerID ORDER BY salary DESC)
-- UNBOUNDED PRECEDING : �����ϰ� ������ ���� �ȴ�.( ��, �� ó�� )
-- CURRENT : ���� ��ġ.
,			FIRST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS best
-- UNBOUNDED FOLLOWING : �����ϰ� �ڷ� ���� �ȴ�. ( �� , �� �� )
,			LAST_VALUE(salary)	OVER (PARTITION BY playerID ORDER BY salary DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS worst
FROM		salaries
ORDER BY	playerID;
