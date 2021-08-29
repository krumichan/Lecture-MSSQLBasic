USE BaseballData;


-- INSERT DELETE UPDATE

SELECT		*
FROM		salaries
ORDER BY	yearID DESC;


-- �� version 1
-- INSERT INTO [���̺��] VALUES [��, ...]
-- DATA�� �������� error�� �߻��Ѵ�.
INSERT INTO	salaries
VALUES		(2020, 'KOR', 'NL', 'tester', 90000000);


-- �� version 2
-- INSERT INTO [���̺��](��, ...) VALUES (��, ...)
INSERT INTO	salaries (yearID, teamID, playerID, lgID, salary)
VALUES		(2020, 'KOR', 'tester2', 'NL', 80000000);
INSERT INTO	salaries (yearID, teamID, playerID, lgID) -- salary�� null�� ����Ѵ�.
VALUES		(2020, 'KOR', 'tester3', 'NL');


-- DELETE FROM [���̺��] : [���̺�]�� ��� ������ ����.
-- DELETE FORM [���̺��] WHERE [����]
DELETE FROM	salaries
WHERE		playerID = 'tester3';


-- UPDATE [���̺��] SET [�� = ��, ] WHERE [����]
-- SET�� '='�� ����
-- WHERE�� '='�� ��
UPDATE	salaries
SET		salary = salary * 2
,		yearID = yearID + 1
WHERE	teamID = 'KOR';


DELETE FROM	salaries
WHERE		yearID >= 2020;


-- DELETE vs UPDATE
-- ������ vs ������
-- ( ������ : delete flag�� ������. )
-- Data ���� ��û � �����ϱ� ���� DELETE�� �ƴ� delete flag�� UPDATE �ϴ� ��.
