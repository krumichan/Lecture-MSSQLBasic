USE BaseballData;



SELECT	*, 1 AS birthSeason
FROM	players;


-- �¾ ���� ��/����/����/�ܿ� ��������� ?
-- ELSE�� ���� ���,
-- ELSE�� �ش��ϴ� ���� NULL�� ä������.
-- �� ���1
SELECT	*
,		CASE birthMonth
			WHEN 1 THEN N'�ܿ�'
			WHEN 2 THEN N'�ܿ�'
			WHEN 3 THEN N'��'
			WHEN 4 THEN N'��'
			WHEN 5 THEN N'��'
			WHEN 6 THEN N'����'
			WHEN 7 THEN N'����'
			WHEN 8 THEN N'����'
			WHEN 9 THEN N'����'
			WHEN 10 THEN N'����'
			WHEN 11 THEN N'����'
			WHEN 12 THEN N'�ܿ�'
			ELSE N'Unknown'
		END AS birthSeason
FROM	players;


-- �� ���2
SELECT	*
,		CASE
			WHEN birthMonth <= 2    THEN N'�ܿ�'
			WHEN birthMonth <= 5    THEN N'��'
			WHEN birthMonth <= 8    THEN N'����'
			WHEN birthMonth <= 12   THEN N'����'
			WHEN birthMonth IS NULL THEN N'Unknown'
			ELSE N'Unknown'
		END AS birthSeason
FROM	players;
