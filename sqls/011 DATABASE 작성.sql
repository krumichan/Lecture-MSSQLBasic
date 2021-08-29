

-- �� DATABASE(=Schema) ����.
CREATE DATABASE GameDB;


-- �� �۾� DATABASE ����.
USE GameDB;


-- TABLE ����(CREATE) / ����(DROP) / ����(ALTER)

-- �� TABLE ����(CREATE).
-- CREATE TABLE [���̺��]([���̸�] [�ڷ���] [DEFAULT �⺻��] [NULL | NOT NULL], ... )
CREATE TABLE accounts (
	accountID	INTEGER		NOT NULL
,	accountName	VARCHAR(10) NOT NULL
,	coins		INTEGER		DEFAULT 0
,	createdTime	DATETIME
--,	PRIMARY KEY (accountID)
);


-- �� TABLE ����(DELETE).
DROP TABLE accounts;


-- �� TABLE ����(ALTER).
-- �� �߰�(ADD)
ALTER TABLE		accounts
ADD				lastEnterTime	DATETIME;
-- �� ����(DROP)
ALTER TABLE		accounts
DROP COLUMN		lastEnterTime;
-- �� ����(ALTER)
ALTER TABLE		accounts
ALTER COLUMN	accountName		VARCHAR(20) NOT NULL;


-- ���� (CONSTRAINT)
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY (��)
-- FOREIGN KEY

-- ���� �߰�(ADD)
ALTER TABLE		accounts
ADD PRIMARY KEY	(accountID);
-- ���� �߰�(ADD) �� �̸� ����.
ALTER TABLE		accounts
ADD CONSTRAINT	PK_Account PRIMARY KEY (accountID);

-- ���� ����(DROP)
ALTER TABLE		accounts
DROP CONSTRAINT	PK_Account;


-- PRIMARY KEY�� �����ϸ� INDEXING ó���Ǿ� �ξ� ������ ó�� ����.
SELECT	*
FROM	accounts
WHERE	accountID = 1111;
