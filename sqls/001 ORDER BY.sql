

-- ORDER BY
-- �����Ͽ� �˻�.

-- �� ���� ���� ����.
SELECT		*
FROM		players
WHERE		birthYear IS NOT NULL
-- ORDER BY	birthYear DESC; -- ��������
ORDER BY	birthYear ASC;  -- ��������


-- �� ���� ���� ����.
SELECT		*
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC;


-- �� ���� �˻�.
-- TOP �� ��� T-SQL������ ��ȿ.
SELECT		TOP 10 *
-- SELECT		TOP (10) *
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC;


-- �� ���� �ۼ�Ʈ �˻�.
SELECT		TOP 1 PERCENT *
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC;


-- �� ���� ���� �˻�.
-- �Ʒ� ���ô� 100~200 �˻�.
SELECT		*
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC
-- OFFSET 100 ROWS : 100���� �ǳ� �ٰ�,
-- FETCH NEXT 100 : �� ���� 100�� ���.
-- SQL ǥ�� �������� �ٸ� DB������ ��� ����.
OFFSET		100 ROWS FETCH NEXT 100	ROWS ONLY;