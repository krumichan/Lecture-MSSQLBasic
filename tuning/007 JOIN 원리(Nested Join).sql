USE BaseballData;


-- JOIN 원리.
  -- 1) Nested Loop (중첩)
  -- 2) Merge (병합)
  -- 3) Hash (해시)


-- MERGE JOIN
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;
--  실행 계획.
--  Nested Loops ---- Clustered Index Scan (Clsutered)   : C#으로 치면 foreach
--				  └- Index Seek (NonClustered)			 : C#으로 치면 Dictionary<playerId, Salary>
--
-- 위와 같은 실행 계획을 가지는데,
-- 이는 Clustered Index Scan (첫번째 집합, Leaf Page)를 순차적으로 탐색하고,
-- 거기서 얻은 playerID를 이용하여,
-- Index Seek를 수행한다.
--
--
--


-- NESTED LOOP JOIN
SELECT	TOP 5 *
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;


-- HASH JOIN
SELECT	*
FROM	salaries AS s
		INNER JOIN teams AS t
		ON s.teamID = t.teamID;



-- NESTED LOOP 강제.
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID
		OPTION(LOOP JOIN);


-- C# 적으로 설명.
/*
 * class Player {
 *	public int playerId;
 *	// ...
 * }
 * 
 * class Salary {
 *	public int palyerId;
 *	// ...
 * }
 * 
 * void Main() {
 *	Random rand = new Random();
 *	List<Player> players = new List<Player>();
 *  for (int i = 0; i < 1000; ++i) {
 *		if (rand.Next(0, 2) == 0) continue;
 *		players.Add(new Player() { playerId = i });
 *	}
 *
  *	List<Salary> salaries = new List<Salary>();
 *  for (int i = 0; i < 1000; ++i) {
 *		if (rand.Next(0, 2) == 0) continue;
 *		salaries.Add(new Salary() { playerId = i });
 *	}
 *
 *	// 1. playerId가 players와 salaries 둘 다 있을 경우 정보를 추출.
 *  //   ⇒ 2중 for문을 수행한다.
 *  //      Nested(중첩) Loop(반복)
 *  //      즉, 첫 번째 집합을 반복시키면서,
 *  //          두 번째 집합에서 무언가를 찾는 것이다.
 *	List<int> result = new List<int>();
 *  // O(N^2)
 *	foreach (Player p in players) {
 *      // 만약, salaries가 Dictionary<int, Salary> 구조였다면, 
 *      // salaries.TryGetValue(p.playerId)를 이용하여 '1'번에 찾을 수 있다.
 *      // 즉, O(N^2) ⇒ O(N) 이 되는 셈.
 *		foreach (Salary s in salaries) {
 *			if (s.playerId == p.playerId) {
 *				result.Add(p.playerId);
 *				break;
 *			}
 *		}
 *	}
 *
 */

-- 위의 코드 예시를 보면,
-- Nested Loop는 매우 불리한 것 처럼 보일 수 있다.
-- 하지만,
-- 경우에 따라서 매우 빠르게 끝날 수 있는데,
-- 예를 들어,
-- SELECT TOP 5 * FROM ...
-- 을 수행한다고 하면?
-- 위 코드에서
-- foreach (Salary s in salaries)
-- 를 순차적으로 5번 수행하고 끝내버리면 된다.


-- Nested Loop
--  : 두 개의 집합이 있을 경우, 2중 for문을 수행하며,
--    외부(첫번째 집합)에서 내부(두번째 집합)를 하나씩 탐색을 하는 것이다.
-- 내부(두번째 집합)를 빠르게 탐색하고 끝낼 수 있다면( ex) TOP 5 등 )
-- 높은 효율을 보여주지만,
-- 그렇지 않으면 끔찍한 효율을 보여준다.
--