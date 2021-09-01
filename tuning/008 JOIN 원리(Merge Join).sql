USE BaseballData;

-- Merge( :4GU ) JOIN = Sort Merge( A$7D :4GU ) JOIN
-- Ao, Sorting HD Merge8& <vG`GQ4Y.



-- Merge Join <vG`.
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;





--	class Player : IComparable<Player> {
--		public int playerId;
--		public int CompareTo(Player other) {
--			if (playerId == other.playerId) return 0;
--			return (playerId > other.playerId) ? 1 : -1;
--	}
--
--  class Salary : IComparable<Salary> {
--		public int playerId;
--		public int CompareTo(Salary other) {
--			if (playerId == other.playerId) return 0;
--			return (playerId > other.playerId) ? 1 : -1;
--	}
--
--
--
--  void Main() {
--		List<Player> players = new List<Player>();
--		player.Add(new Player() { playerId = 0 });
--		player.Add(new Player() { playerId = 9 });
--		player.Add(new Player() { playerId = 1 });
--		player.Add(new Player() { playerId = 3 });
--		player.Add(new Player() { playerId = 4 });
--
--		List<Salary> salaries = new List<Salary>();
--		salaries.Add(new Salary() { playerId = 0 });
--		salaries.Add(new Salary() { playerId = 5 });
--		salaries.Add(new Salary() { playerId = 0 });
--		salaries.Add(new Salary() { playerId = 2 });
--		salaries.Add(new Salary() { playerId = 9 });
--
--		// 14\0h : Sorting.  ( @L9L A$7D5G>n @V@88i Skip )
--		// @O9]@{@N Sorting <S55 : O( N * Log(N) )
--		players.Sort();
--		salaries.Sort();
--
--		// One-To-Many( 0!A$: OUTER4B A_:9 DATA0! >x4Y. )
--		// 24\0h) Merge
--		// OUTER [ 0, 1, 3, 4, 9 ] -- players
--		// INNER [ 0, 0, 2, 5, 9 ] -- salaries
--		
--		int pPivot = 0;  // Players Index @'D!.
--		int sPivot = 0;  // Salaries Index @'D!.
--
--		// Merge =C, Pivot @'D!@G 0*@; :q13GO?), <}@Z0! @[@: BJ@G Pivot 0*@; +1 GQ4Y.
--		// OUTER?M INNER@G 0" Pivot @'D!@G 0*@L 00@; 0f?l, INNER@G Pivot 0*@; +1 GQ4Y.
--
--      // 1Bw.
--		// O [ 0(P), 1, 3, 4, 9 ]
--		// I [ 0(P), 0, 2, 5, 9 ]   --- O[0] == I[0]   -- GO3*@G DATA8& C#@=.
--
--      // 2Bw.
--		// O [ 0(P), 1, 3, 4, 9 ]
--		// I [ 0, 0(P), 2, 5, 9 ]   --- O[0] == I[1]   -- GO3*@G DATA8& C#@=.
--
--      // 3Bw.
--		// O [ 0(P), 1, 3, 4, 9 ]
--		// I [ 0, 0, 2(P), 5, 9 ]   --- O[0] < I[2]    -- E=;v =GFP. (O Cx@L 4u @[@84O 0 Cx@G Pivot + 1)
--
--      // 4Bw.
--		// O [ 0, 1(P), 3, 4, 9 ]
--		// I [ 0, 0, 2(P), 5, 9 ]   --- O[1] < I[2]    -- E=;v =GFP. (0 Cx@L 4u @[@84O 0 Cx@G Pivot + 1)
--
--      // 5Bw.
--		// O [ 0, 1, 3(P), 4, 9 ]
--		// I [ 0, 0, 2(P), 5, 9 ]   --- O[2] > I[2]    -- E=;v =GFP. (I Cx@L 4u @[@84O I Cx@G Pivot + 1)
--
--      // 6Bw.
--		// O [ 0, 1, 3(P), 4, 9 ]
--		// I [ 0, 0, 2, 5(P), 9 ]   --- O[2] < I[3]    -- E=;v =GFP. (O Cx@L 4u @[@84O O Cx@G Pivot + 1)  ....
--
--		// @G;gDZ5e
--		// =C0# :9@b55: O(N + M)  <- 12@e@L :|8% 0M!
--		List<int> result = new List<int>();
--		while (pPivot < players.Count && sPivot < salaries.Count) {
--			int pId = players[pPivot];
--			int sId = salaries[sPivot];
--
--			// OUTER == INNER
--			if (pId == sId) {
--				result.Add(pId);
--				sPivot++;
--			// OUTER < INNER
--			} else if (pId < sId) {
--				pPivot++;
--			// OUTER > INNER
--			} else {
--				sPivot++;
--			}
--		}
--
--
--		// 88>`@G 0f?l.
--		// Many-To-Many( 0!A$: OUTER4B A_:9 DATA0! @V4Y. )
--		// OUTER [ 0, 0, 0, 0, 0 ] -- players
--		// INNER [ 0, 0, 0, 0, 0 ] -- salaries
--		// =C0# :9@b55: O(N * M)


SET STATISTICS TIME ON;
SET STATISTICS IO ON;
SET STATISTICS PROFILE ON;

-- Non-Clustered
--       1
--    2  3  4

-- Clustered
--       1
--    2  3  4

-- Heap Table[ {Page} {Page} ]

-- Merge Join ( Many - To - Many )
-- @O@O@L Random Access8& <vG`GO4B 0M@L >F4Q, Clustred Scan HD A$7D@; <vG`.
SELECT	*
FROM	players AS p
		INNER JOIN salaries AS s
		ON p.playerID = s.playerID;


-- MERGE JOIN55 A60G@L :Y4B4Y.
-- 1. OUTER0! UNIQUE GX>_GQ4Y. ( ONE-TO-MANY, OUTER0! PK 6G4B Unique 5n. )



SELECT	*
FROM	schools AS s -- schoolID0! PK7N A$7D5G>n @V1b 6'9.?! Sorting@; <vG`GOAv >J4B4Y.
		INNER JOIN schoolsplayers AS p -- PK0! playersID, schoolID <x@87N A$7D5G>n @V1b 6'9.?!, 0a19 playerID8& @|:N <xH8GX>_GT. --> Sorting GJ?d.
		ON s.schoolID = p.schoolID;



-- 0a7P --
--
-- (Sort) Merge Join
-- 1. >gBJ A}GU@; Sorting(A$7D) HD Merge(:4GU)GQ4Y.
    -- A}GU@L @L9L A$7D5H ;sEB6s8i Sort4B ;}7+GQ4Y. ( F/Hw, Clustered7N 908.@{ A$7D@L 5H ;sEB6s8i Best Case0! 5H4Y. )
    -- A$7DGR DATA0! 3J9+ 89@: 0f?l, :q?k@L 8E?l Au0!GQ4Y.  "! Bw6s8. HASH JOIN@L 4u H?@2@{@87N 5H4Y.
-- 2. Random Access @'AV7N <vG`GOAv >J4B4Y.
-- 3. MANY-TO-MANY :84Y4B ONE-TO-MANY JOIN?! H?0z@{@L4Y.
    -- PK, UNIQUE ;sEB.
    