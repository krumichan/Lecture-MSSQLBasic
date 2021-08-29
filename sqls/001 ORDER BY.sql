

-- ORDER BY
-- 정렬하여 검색.

-- ① 단일 조건 정렬.
SELECT		*
FROM		players
WHERE		birthYear IS NOT NULL
-- ORDER BY	birthYear DESC; -- 내림차순
ORDER BY	birthYear ASC;  -- 오름차순


-- ② 여러 조건 정렬.
SELECT		*
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC;


-- ③ 상위 검색.
-- TOP 의 경우 T-SQL에서만 유효.
SELECT		TOP 10 *
-- SELECT		TOP (10) *
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC;


-- ④ 상위 퍼센트 검색.
SELECT		TOP 1 PERCENT *
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC;


-- ⑤ 임의 영역 검색.
-- 아래 예시는 100~200 검색.
SELECT		*
FROM		players
WHERE		birthYear IS NOT NULL
ORDER BY	birthYear DESC, birthMonth DESC, birthDay DESC
-- OFFSET 100 ROWS : 100개는 건너 뛰고,
-- FETCH NEXT 100 : 그 다음 100개 출력.
-- SQL 표준 구문으로 다른 DB에서도 사용 가능.
OFFSET		100 ROWS FETCH NEXT 100	ROWS ONLY;