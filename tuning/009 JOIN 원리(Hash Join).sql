USE Northwind;


-- HASH JOIN


SELECT	*
INTO	TestOrders
FROM	Orders;
SELECT	*
INTO	TestCustomers
FROM	Customers;

SELECT	*
FROM	Orders;
SELECT	*
FROM	Customers;
-- CustomerID 로 결합한다.


-- HASH MATCH
-- Data Count가 적은 Table을 Hash Table로 만든다.
-- 이유는 Data Count가 많으면 Hash Table을 만드는 것 자체가
-- 비용이 많이들어 더욱 비효율적으로 변한다.
SELECT	*
FROM	TestOrders AS o
		INNER JOIN TestCustomers AS c
		ON o.CustomerID = c.CustomerID;


-- 강제로 NESTED LOOP를 사용하면?
-- INNER에서 Table Spool <- Table Scan 으로 비용이 발생한다.
-- ( ON o.CustomerID = c.CustomerID 조건을 찾는 것에 시간이 소요되는 것. )
-- INNER TABLE에 INDEX가 없기 때문이다.
SELECT	*
FROM	TestOrders AS o
		INNER JOIN TestCustomers AS c
		ON o.CustomerID = c.CustomerID
		OPTION (FORCE ORDER, LOOP JOIN);


-- 강제로 MERGE JOIN을 사용하면?
-- 양쪽 TABLE 전부 SORTING을 수행한다.
--  문제점
--   1. OUTER, INNER 모두 SORTING이 필요.
--   2. MANY-TO-MANY 구조로 SCAN 비용 발생.
SELECT	*
FROM	TestOrders AS o
		INNER JOIN TestCustomers AS c
		ON o.CustomerID = c.CustomerID
		OPTION (FORCE ORDER, MERGE JOIN);



-- HASH TABLE 운용 구조를 C# Code 적으로 표시한 경우.
-- 
--	class Player {
--		public int playerId;
--	}
-- 
--	class Salary {
--		public int playerId;
--	}
-- 
--	// 41 % 10 = 1 (key)
--  // 51 % 10 = 1 (key)
--  // 41 탐색 요청 -> 1 (key)을 이용하여 탐색.
--
--	// HashTable [0 List] [1 List] [2 List] [3 List] [4] ...
--  // 공간을 희생하여 속도를 높힌다.
--  // 동일한 값 -> 동일한 Bucket (yes)
--  // 동일한 Bucket -> 동일한 값 (no)
--	class HashTable {
--		int _bucketCount;
--		List<int>[] _buckets;
--
--		public HashTable(int bucketCount = 100) {
--			_bucketCount = bucketCount;
--			_buckets = new List<int>[bucketCount];
--			for (int i = 0; i < bucketCount; ++i) {
--				_buckets[i] = new List<int>();
--			}
--		}
--
--		public void Add(int value) {
--			int key = value % _bucketCount;
--			_buckets[key].Add(value);
--		}
--
--		public void Find(int value) {
--			int key = value % _bucketCount;
--			return _buckets[key].Contains(value);
--		}
--	}
--
--
--	void Main() {
--		Random rand = new Random();
--		
--		List<Player> players = new List<Player>();
--		for (int i = 0; i < 10000; ++i) {
--			if (rand.Next(0, 2) == 0) continue;
--			players.Add(new Player() { playerId = i });
--		}
--
-- 		List<Salary> salaries = new List<Salary>();
--		for (int i = 0; i < 10000; ++i) {
--			if (rand.Next(0, 2) == 0) continue;
--			salaries.Add(new Salary() { playerId = i });
--		}
-- 
-- 
--		// 임시 Hash Table 사용.
--		HashTable hash = new HashTable();
--		foreawch (Salary s in salaries) hash.Add(s.playerId);
-- 
--		// 결과 추출.
--		List<int> result = new List<int>();
--		foreach (Player p in players) {
--			if (hash.Find(p.playerId)) result.Add(p.playerId);
--		} 
-- 



-- 오늘의 결론 --

-- Hash Join
--  1) Sorting이 필요 없다.
--    -- Data가 너무 많아서 Merge가 부담될 때, Hash가 대단이 될 수 있다.
--  2) INDEX의 유무에 영향을 받지 않는다. ★★★★★
--    -- Nested Loop / Merge와 비교하여 확실한 장점이다.
--    -- Hash Table 생성에 드는 비용을 고려해야 한다. ( 수행빈도가 높은 QUERY일 경우, INDEX가 더 효율적이다. )
--  3) RANDOM ACCESS 위주로 수행되지 않는다.
--  4) Data Count가 적은 Table을 Hash Table로 만드는 것이 유리하다.
