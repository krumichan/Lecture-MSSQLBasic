

USE BaseballData;

-- string 관련 참고.
-- 참고 사이트 : https://docs.microsoft.com/en-us/sql/t-sql/functions/substring-transact-sql?view=sql-server-ver15

-- ① 간단한 문자 출력.
SELECT	'Hello World';
-- ?????.
SELECT	'안녕하세요.';
-- N을 붙임으로써 유니코드임을 알려준다.
SELECT	N'안녕하세요.';


-- ② 문자열 이어 붙이기.
SELECT	'Hello ' + 'World';


-- ③ 문자열 잘라쓰기.
-- 시작 위치는 0이 아닌 1이다.
SELECT	SUBSTRING('20200425', 1, 4); -- 2020


-- ④ 공백 지우기.
SELECT	TRIM('       HelloWorld'); -- HelloWorld


SELECT	nameFirst + ' ' + nameLast AS fullName
FROM	players
WHERE	nameFirst IS NOT NULL AND nameLast IS NOT NULL;