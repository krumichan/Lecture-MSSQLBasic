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
-- CustomerID �� �����Ѵ�.


-- HASH MATCH
-- Data Count�� ���� Table�� Hash Table�� �����.
-- ������ Data Count�� ������ Hash Table�� ����� �� ��ü��
-- ����� ���̵�� ���� ��ȿ�������� ���Ѵ�.
SELECT	*
FROM	TestOrders AS o
		INNER JOIN TestCustomers AS c
		ON o.CustomerID = c.CustomerID;


-- ������ NESTED LOOP�� ����ϸ�?
-- INNER���� Table Spool <- Table Scan ���� ����� �߻��Ѵ�.
-- ( ON o.CustomerID = c.CustomerID ������ ã�� �Ϳ� �ð��� �ҿ�Ǵ� ��. )
-- INNER TABLE�� INDEX�� ���� �����̴�.
SELECT	*
FROM	TestOrders AS o
		INNER JOIN TestCustomers AS c
		ON o.CustomerID = c.CustomerID
		OPTION (FORCE ORDER, LOOP JOIN);


-- ������ MERGE JOIN�� ����ϸ�?
-- ���� TABLE ���� SORTING�� �����Ѵ�.
--  ������
--   1. OUTER, INNER ��� SORTING�� �ʿ�.
--   2. MANY-TO-MANY ������ SCAN ��� �߻�.
SELECT	*
FROM	TestOrders AS o
		INNER JOIN TestCustomers AS c
		ON o.CustomerID = c.CustomerID
		OPTION (FORCE ORDER, MERGE JOIN);



-- HASH TABLE ��� ������ C# Code ������ ǥ���� ���.
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
--  // 41 Ž�� ��û -> 1 (key)�� �̿��Ͽ� Ž��.
--
--	// HashTable [0 List] [1 List] [2 List] [3 List] [4] ...
--  // ������ ����Ͽ� �ӵ��� ������.
--  // ������ �� -> ������ Bucket (yes)
--  // ������ Bucket -> ������ �� (no)
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
--		// �ӽ� Hash Table ���.
--		HashTable hash = new HashTable();
--		foreawch (Salary s in salaries) hash.Add(s.playerId);
-- 
--		// ��� ����.
--		List<int> result = new List<int>();
--		foreach (Player p in players) {
--			if (hash.Find(p.playerId)) result.Add(p.playerId);
--		} 
-- 



-- ������ ��� --

-- Hash Join
--  1) Sorting�� �ʿ� ����.
--    -- Data�� �ʹ� ���Ƽ� Merge�� �δ�� ��, Hash�� ����� �� �� �ִ�.
--  2) INDEX�� ������ ������ ���� �ʴ´�. �ڡڡڡڡ�
--    -- Nested Loop / Merge�� ���Ͽ� Ȯ���� �����̴�.
--    -- Hash Table ������ ��� ����� ����ؾ� �Ѵ�. ( ����󵵰� ���� QUERY�� ���, INDEX�� �� ȿ�����̴�. )
--  3) RANDOM ACCESS ���ַ� ������� �ʴ´�.
--  4) Data Count�� ���� Table�� Hash Table�� ����� ���� �����ϴ�.
