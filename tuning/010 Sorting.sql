USE BaseballData;

-- SORTING 발생.
-- 1) SORT MERGE JOIN
    -- 원인: 알고리즘 특성 상, MERGE하기 전에 SORTING을 수행한다.
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX



-- 1) 생략.

-- 2) ORDER BY
--  원인: college 순서로 정렬을 해야하기 때문에 SORTING 발생.
--        ( INDEX가 없기 때문에 노가다. )
SELECT		*
FROM		players
ORDER BY	college;


-- 3) GROUP BY
--  원인: college끼리 grouping하여 집계하기 위해 SORTING 발생.
SELECT		college, COUNT(college)
FROM		players
WHERE		college LIKE 'C%'
GROUP BY	college;


-- 4) DISTINCT
--  원인: 중복을 제거하기 위하여 모으기 위해 SORTING 발생.
SELECT	DISTINCT college
FROM	players
WHERE	college LIKE 'C%';


-- 5) UNION
--  원인: 집합을 합칠 때, 중복을 제거하는데, 그 중복을 모으기 위해 SORTING 발생.
-- 만약에 중복이 있든 없는 상관 없는 경우라면,
-- UNION ALL을 사용하는 것이 훨씬 효율적이다.
SELECT	college
FROM	players
WHERE	college LIKE 'B%'
UNION
SELECT	college
FROM	players
WHERE	college LIKE 'C%';


-- 6) 순위 WINDOW FUNCTION
--  원인: 집계를 위해 college 순으로 정렬할 필요가 있어서 SORTING 발생.
SELECT	ROW_NUMBER() OVER (ORDER BY college)
FROM	players;


-- 7) MIN MAX
--  MIN MAX 또한 집계를 위해 SORTING을 수행.



-- INDEX를 잘 활용하면 SORTING의 수를 줄일 수 있다.
-- ( INDEX 생성 시, 이미 SORTING이 수행되어 있기 때문이다. )

-- batting Table은 playerID, yearID, stint 순으로 INDEX가 생성되어 있다.
-- 아래의 실행 계획을 볼 경우, INDEX로 인해 SORTING이 발생되지 않음을 알 수 있다.
SELECT		*
FROM		batting
ORDER BY	playerID, yearID;



-- 오늘의 결론 --
-- Sorting( 정렬 )을 줄인다.

-- O(N * LogN) → DATABASE는 DATA의 수가 어마머아하게 많다.
-- 너무 용량이 거서 가용 MEMORY로 감당이 되지 않을 경우, DISK까지 탐색한다.
-- SORTING이 언제 일어나는지 파악하고 있어야 한다.
-- 위의 이유로,
-- QUERY를 작성할 시,
-- SORTING이 정말 필요한지,
-- 정말 필요할 경우, INDEX 사용을 고려해봐야 한다.

-- SORTING 발생.
-- 1) SORT MERGE JOIN
    -- 원인: 알고리즘 특성 상, MERGE하기 전에 SORTING을 수행한다.
-- 2) ORDER BY
-- 3) GROUP BY
-- 4) DISTINCT
-- 5) UNION
-- 6) RANKING WINDOWS FUNCTION
-- 7) MIN MAX
