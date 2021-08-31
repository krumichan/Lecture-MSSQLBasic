USE BaseballData;


-- JOIN ����.
  -- 1) Nested Loop (��ø)
  -- 2) Merge (����)
  -- 3) Hash (�ؽ�)


-- MERGE JOIN
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;
--  ���� ��ȹ.
--  Nested Loops ---- Clustered Index Scan (Clsutered)   : C#���� ġ�� foreach
--				  ��- Index Seek (NonClustered)			 : C#���� ġ�� Dictionary<playerId, Salary>
--
-- ���� ���� ���� ��ȹ�� �����µ�,
-- �̴� Clustered Index Scan (ù��° ����, Leaf Page)�� ���������� Ž���ϰ�,
-- �ű⼭ ���� playerID�� �̿��Ͽ�,
-- Index Seek�� �����Ѵ�.
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



-- NESTED LOOP ����.
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID
		OPTION(LOOP JOIN);


-- C# ������ ����.
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
 *	// 1. playerId�� players�� salaries �� �� ���� ��� ������ ����.
 *  //   �� 2�� for���� �����Ѵ�.
 *  //      Nested(��ø) Loop(�ݺ�)
 *  //      ��, ù ��° ������ �ݺ���Ű�鼭,
 *  //          �� ��° ���տ��� ���𰡸� ã�� ���̴�.
 *	List<int> result = new List<int>();
 *  // O(N^2)
 *	foreach (Player p in players) {
 *      // ����, salaries�� Dictionary<int, Salary> �������ٸ�, 
 *      // salaries.TryGetValue(p.playerId)�� �̿��Ͽ� '1'���� ã�� �� �ִ�.
 *      // ��, O(N^2) �� O(N) �� �Ǵ� ��.
 *		foreach (Salary s in salaries) {
 *			if (s.playerId == p.playerId) {
 *				result.Add(p.playerId);
 *				break;
 *			}
 *		}
 *	}
 *
 */

-- ���� �ڵ� ���ø� ����,
-- Nested Loop�� �ſ� �Ҹ��� �� ó�� ���� �� �ִ�.
-- ������,
-- ��쿡 ���� �ſ� ������ ���� �� �ִµ�,
-- ���� ���,
-- SELECT TOP 5 * FROM ...
-- �� �����Ѵٰ� �ϸ�?
-- �� �ڵ忡��
-- foreach (Salary s in salaries)
-- �� ���������� 5�� �����ϰ� ���������� �ȴ�.


-- Nested Loop
--  : �� ���� ������ ���� ���, 2�� for���� �����ϸ�,
--    �ܺ�(ù��° ����)���� ����(�ι�° ����)�� �ϳ��� Ž���� �ϴ� ���̴�.
-- ����(�ι�° ����)�� ������ Ž���ϰ� ���� �� �ִٸ�( ex) TOP 5 �� )
-- ���� ȿ���� ����������,
-- �׷��� ������ ������ ȿ���� �����ش�.
--