
 /* 여러줄 주석 */
 -- 한줄 주석

 -- SQL (RDBMS를 조작하기 위한 명령어 )
 -- +@ T-SQL

 -- CRUD ( Create-Read-Update-Delete )


 -- ① 제일 기본적인 검색.
 SELECT	*
 FROM	players;


 -- ② 임의의 Column을 지정하여 검색.
 -- AS xxx : 임의의 Column의 별칭을 xxx 로 지정.
 SELECT	nameFirst AS name, nameLast, birthYear
 FROM	players;


 -- ③ 조건을 추가하여 검색.
 SELECT	nameFirst AS name, nameLast, birthYear
 FROM	players
 WHERE	birthYear = 1896;


 -- ④ 여러 조건을 추가하여 검색.
 -- AND 의 우선순위가 OR 보다 높다.
 SELECT	nameFirst AS name, nameLast, birthYear, birthCountry
 FROM	players
 WHERE	(birthYear = 1974
 OR		birthCountry != 'USA')
 AND	weight > 185;


 -- ⑤ NULL 인지 확인.
 SELECT	*
 FROM	players
 -- WHERE deathYear IS NOT NULL;
 WHERE	deathYear IS NULL;


 -- ⑥ pattern 검색.
 -- % 임의의 문자열
 -- _ 임의의 문자열 1개.
 SELECT	*
 FROM	players
 WHERE	birthCity LIKE 'NEW%';