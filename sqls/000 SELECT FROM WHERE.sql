
 /* ������ �ּ� */
 -- ���� �ּ�

 -- SQL (RDBMS�� �����ϱ� ���� ��ɾ� )
 -- +@ T-SQL

 -- CRUD ( Create-Read-Update-Delete )


 -- �� ���� �⺻���� �˻�.
 SELECT	*
 FROM	players;


 -- �� ������ Column�� �����Ͽ� �˻�.
 -- AS xxx : ������ Column�� ��Ī�� xxx �� ����.
 SELECT	nameFirst AS name, nameLast, birthYear
 FROM	players;


 -- �� ������ �߰��Ͽ� �˻�.
 SELECT	nameFirst AS name, nameLast, birthYear
 FROM	players
 WHERE	birthYear = 1896;


 -- �� ���� ������ �߰��Ͽ� �˻�.
 -- AND �� �켱������ OR ���� ����.
 SELECT	nameFirst AS name, nameLast, birthYear, birthCountry
 FROM	players
 WHERE	(birthYear = 1974
 OR		birthCountry != 'USA')
 AND	weight > 185;


 -- �� NULL ���� Ȯ��.
 SELECT	*
 FROM	players
 -- WHERE deathYear IS NOT NULL;
 WHERE	deathYear IS NULL;


 -- �� pattern �˻�.
 -- % ������ ���ڿ�
 -- _ ������ ���ڿ� 1��.
 SELECT	*
 FROM	players
 WHERE	birthCity LIKE 'NEW%';