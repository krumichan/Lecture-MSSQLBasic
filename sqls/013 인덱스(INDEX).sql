USE GameDB;
CREATE TABLE accounts (
	accountID	INTEGER		NOT NULL
,	accountName	VARCHAR(10) NOT NULL
,	coins		INTEGER		DEFAULT 0
,	createdTime	DATETIME
,	CONSTRAINT PK_Account PRIMARY KEY (accountID)
);

-- PRIMARY KEY는 거의 무조건 Clustered Index로 생성한다.
-- Non-Clustered Index로 PRIMARY KEY로 사용하는 경우는 없는 듯?

-- CREATE (CLUSTERED) INDEX
CREATE INDEX i1 ON accounts(accountName);
CREATE CLUSTERED INDEX i1 ON accounts(accountName); -- 위와 동일.

-- CREATE UNIQUE INDEX : INDEX가 겹치는 것이 없다는 것까지 보장.
CREATE UNIQUE INDEX i1 ON accounts(accountName);
-- 그룹 인덱스( 여러 column을 조합하여 INDEX 구성).
CREATE UNIQUE INDEX gi1 ON accounts(accountName, coins);


-- DROP INDEX
DROP INDEX accounts.i1;
