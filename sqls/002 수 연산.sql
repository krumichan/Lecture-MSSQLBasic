

-- ����.
-- + - * / % ��� ����.


USE BaseballData;


-- �� ������ ����.
-- �Ʒ� ������ ���� ������ ���� ���� ����.
-- FROM �� WHERE �� SELECT �� ORDER BY ������,
-- koreanAge�� ���ǵǱ� ���� WHERE���� �����Ѵ�.
SELECT		2021 - birthYear AS koreanAge
FROM		players
WHERE		deathYear IS NULL
AND			birthYear IS NOT NULL
-- AND			koreanAge <= 80 : ������ ����.
AND			(2021 - birthYear) <= 80
ORDER BY	koreanAge;


-- �� NULL�� ������ ����
-- ����� NULL�̴�.
-- NULL ������ ������ NULL�� ���´�.
SELECT	2021 - NULL;


-- �� ����/�Ǽ� ����.
SELECT	3 / 2;		-- ����� 1 ( ����/������ ������. )
SELECT	3.0 / 2;	-- ����� 1.5
SELECT	3 / 0;		-- ERROR(0 ������) �߻�.


-- �� ���� ����.
-- ���� ����Ʈ : https://docs.microsoft.com/en-us/sql/t-sql/functions/sin-transact-sql?view=sql-server-ver15
-- �ݿø� ����. ( 3.141 )
SELECT	ROUND(3.141423231, 3);
-- N���� ����. ( 8 )
SELECT	POWER(2, 3);
-- �ڻ��� ����. (1)
SELECT	COS(0);