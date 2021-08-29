

-- ① DATABASE(=Schema) 생성.
CREATE DATABASE GameDB;


-- ② 작업 DATABASE 지정.
USE GameDB;


-- TABLE 생성(CREATE) / 삭제(DROP) / 변경(ALTER)

-- ③ TABLE 생성(CREATE).
-- CREATE TABLE [테이블명]([열이름] [자료형] [DEFAULT 기본값] [NULL | NOT NULL], ... )
CREATE TABLE accounts (
	accountID	INTEGER		NOT NULL
,	accountName	VARCHAR(10) NOT NULL
,	coins		INTEGER		DEFAULT 0
,	createdTime	DATETIME
--,	PRIMARY KEY (accountID)
);


-- ④ TABLE 삭제(DELETE).
DROP TABLE accounts;


-- ⑤ TABLE 변경(ALTER).
-- 열 추가(ADD)
ALTER TABLE		accounts
ADD				lastEnterTime	DATETIME;
-- 열 삭제(DROP)
ALTER TABLE		accounts
DROP COLUMN		lastEnterTime;
-- 열 변경(ALTER)
ALTER TABLE		accounts
ALTER COLUMN	accountName		VARCHAR(20) NOT NULL;


-- 제약 (CONSTRAINT)
-- NOT NULL
-- UNIQUE
-- PRIMARY KEY (★)
-- FOREIGN KEY

-- 제약 추가(ADD)
ALTER TABLE		accounts
ADD PRIMARY KEY	(accountID);
-- 제약 추가(ADD) 및 이름 설정.
ALTER TABLE		accounts
ADD CONSTRAINT	PK_Account PRIMARY KEY (accountID);

-- 제약 삭제(DROP)
ALTER TABLE		accounts
DROP CONSTRAINT	PK_Account;


-- PRIMARY KEY를 설정하면 INDEXING 처리되어 훨씬 빠르게 처리 가능.
SELECT	*
FROM	accounts
WHERE	accountID = 1111;
