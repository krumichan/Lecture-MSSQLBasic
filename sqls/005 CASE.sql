USE BaseballData;



SELECT	*, 1 AS birthSeason
FROM	players;


-- 태어난 날이 봄/여름/가을/겨울 어느거인지 ?
-- ELSE가 없을 경우,
-- ELSE에 해당하는 값은 NULL로 채워진다.
-- ① 방식1
SELECT	*
,		CASE birthMonth
			WHEN 1 THEN N'겨울'
			WHEN 2 THEN N'겨울'
			WHEN 3 THEN N'봄'
			WHEN 4 THEN N'봄'
			WHEN 5 THEN N'봄'
			WHEN 6 THEN N'여름'
			WHEN 7 THEN N'여름'
			WHEN 8 THEN N'여름'
			WHEN 9 THEN N'가을'
			WHEN 10 THEN N'가을'
			WHEN 11 THEN N'가을'
			WHEN 12 THEN N'겨울'
			ELSE N'Unknown'
		END AS birthSeason
FROM	players;


-- ② 방식2
SELECT	*
,		CASE
			WHEN birthMonth <= 2    THEN N'겨울'
			WHEN birthMonth <= 5    THEN N'봄'
			WHEN birthMonth <= 8    THEN N'여름'
			WHEN birthMonth <= 12   THEN N'가을'
			WHEN birthMonth IS NULL THEN N'Unknown'
			ELSE N'Unknown'
		END AS birthSeason
FROM	players;
