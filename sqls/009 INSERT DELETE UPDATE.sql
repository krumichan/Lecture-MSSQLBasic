USE BaseballData;


-- INSERT DELETE UPDATE

SELECT		*
FROM		salaries
ORDER BY	yearID DESC;


-- ① version 1
-- INSERT INTO [테이블명] VALUES [값, ...]
-- DATA를 빼먹으면 error가 발생한다.
INSERT INTO	salaries
VALUES		(2020, 'KOR', 'NL', 'tester', 90000000);


-- ② version 2
-- INSERT INTO [테이블명](열, ...) VALUES (값, ...)
INSERT INTO	salaries (yearID, teamID, playerID, lgID, salary)
VALUES		(2020, 'KOR', 'tester2', 'NL', 80000000);
INSERT INTO	salaries (yearID, teamID, playerID, lgID) -- salary는 null을 허용한다.
VALUES		(2020, 'KOR', 'tester3', 'NL');


-- DELETE FROM [테이블명] : [테이블]의 모든 데이터 삭제.
-- DELETE FORM [테이블명] WHERE [조건]
DELETE FROM	salaries
WHERE		playerID = 'tester3';


-- UPDATE [테이블명] SET [열 = 값, ] WHERE [조건]
-- SET의 '='는 대입
-- WHERE의 '='는 비교
UPDATE	salaries
SET		salary = salary * 2
,		yearID = yearID + 1
WHERE	teamID = 'KOR';


DELETE FROM	salaries
WHERE		yearID >= 2020;


-- DELETE vs UPDATE
-- 물삭제 vs 논리삭제
-- ( 논리삭제 : delete flag를 설정함. )
-- Data 복구 신청 등에 대응하기 위해 DELETE가 아닌 delete flag를 UPDATE 하는 것.
