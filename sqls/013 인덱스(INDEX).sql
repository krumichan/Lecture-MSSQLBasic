USE GameDB;
CREATE TABLE accounts (
	accountID	INTEGER		NOT NULL
,	accountName	VARCHAR(10) NOT NULL
,	coins		INTEGER		DEFAULT 0
,	createdTime	DATETIME
,	CONSTRAINT PK_Account PRIMARY KEY (accountID)
);

-- PRIMARY KEY�� ���� ������ Clustered Index�� �����Ѵ�.
-- Non-Clustered Index�� PRIMARY KEY�� ����ϴ� ���� ���� ��?

-- CREATE (CLUSTERED) INDEX
CREATE INDEX i1 ON accounts(accountName);
CREATE CLUSTERED INDEX i1 ON accounts(accountName); -- ���� ����.

-- CREATE UNIQUE INDEX : INDEX�� ��ġ�� ���� ���ٴ� �ͱ��� ����.
CREATE UNIQUE INDEX i1 ON accounts(accountName);
-- �׷� �ε���( ���� column�� �����Ͽ� INDEX ����).
CREATE UNIQUE INDEX gi1 ON accounts(accountName, coins);


-- DROP INDEX
DROP INDEX accounts.i1;
