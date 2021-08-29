USE	BaseballData;

-- SubQuery (��������/��������)
-- SQL ��ɹ� �ȿ� �����ϴ� �Ϻ� SELECT

-- ������ ��������� ���� ������ ������ ����.
-- �Ʒ��� ���� 2���� ���� �ؾ���.
SELECT		TOP 1 *
FROM		salaries
ORDER BY	salary DESC;
SELECT		*
FROM		players
WHERE		playerID = 'rodrial01';

-- ���� ���� �� ���� ����.
-- ������ subquery ( subquery�� ����� �ϳ�. )
SELECT	*
FROM	players
WHERE	playerID = (	SELECT		TOP 1 playerID
						FROM		salaries
						ORDER BY	salary DESC);


-- ������
-- IN�� ����Ѵ�.
-- IN : ���� ��� �߿� �ϳ��� ������ ���.
SELECT	*
FROM	players
WHERE	playerID IN (	SELECT		TOP 20 playerID
						FROM		salaries
						ORDER BY	salary DESC);


-- SELECT���� ���.
SELECT	(	SELECT	COUNT(*)
			FROM	players) AS playerCount
,		(	SELECT	COUNT(*)
			FROM	batting) AS battingCount;


-- INSERT���� ���.
-- subquery�� ()�� �� �� ������� �Ѵ�.
INSERT INTO	salaries
VALUES		(2020, 'KOR', 'NL', 'jongseon', (SELECT MAX(salary) FROM salaries));


-- �� INSERT SELECT
INSERT INTO salaries
SELECT		2020, 'KOR', 'NL', 'jongseon2', (SELECT MAX(salary) FROM salaries);


-- �� INSERT SELECT ( ���� TABLE DATA ���� ���� )
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



-- ����Ʈ ���� Ÿ�ݿ� ������ ������ ���.
-- ( battingpost�� players�� ��� �����ϴ� player�� ����. )
SELECT	*
FROM	players
WHERE	playerID IN (	SELECT	playerID
						FROM	battingpost);

-- ������� Subquery
-- EXISTS, NOT EXISTS
-- EXISTS�� IN���� Ȯ�强�� ����.
SELECT			*
FROM			players
WHERE EXISTS	(	SELECT	playerID
					FROM	battingpost
					WHERE	battingpost.playerID = players.playerID );

-- IN�� EXISTS
-- [F5] ���� ��, [Ctrl + L]�� ���� "�����ȹ"�� ����,
-- IN�� EXISTS�� ���� �����ϰ� ����Ǵ� ���� Ȯ�� ����.
