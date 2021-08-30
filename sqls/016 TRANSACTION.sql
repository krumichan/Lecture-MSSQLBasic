USE GameDB;

SELECT	*
FROM	accounts;

DELETE	accounts;

-- TRANSACTION을 명시하지 않을 경우, 자동으로 COMMIT을 수행한다.
INSERT INTO accounts VALUES (1, 'jongseon', 100, GETUTCDATE());


-- BEGIN TRAN;
-- BEGIN TRANSACTION;

-- COMMIT;		-- 임시로 변경된 내용을 실제로 적용한다.
-- ROLLBACK;	-- 임시로 변환된 내용을 파기하고, 원래대로 되돌린다.


BEGIN TRAN;
	INSERT INTO accounts VALUES (2, 'jongseon2', 100, GETUTCDATE());	
ROLLBACK;
SELECT * FROM accounts;

BEGIN TRAN;
	INSERT INTO accounts VALUES (2, 'jongseon2', 100, GETUTCDATE());	
COMMIT;
SELECT * FROM accounts;


-- try-catch 응용
-- 하기 두 개의 INSERT 문을 수행할 경우,
-- 본래라면 '3'에 해당하는 INSERT 문만 실행된다.
-- 하지만, TRANSACTION을 이용하면,
-- '2'에 해당하는 INSERT 문이 실패했기 때문에,
-- '3'에 해당하는 INSERT 문 또한 실행되지 않는다.
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO accounts VALUES (2, 'jongseon2', 100, GETUTCDATE());
		INSERT INTO accounts VALUES (3, 'jongseon3', 100, GETUTCDATE());
	COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0 -- 현재 활성화 된 TRANSACTION 수를 반환.
		ROLLBACK
	PRINT('ROLLBACK 수행.')
END CATCH;


-- TRANSACTION 사용할 때 주의할 점
-- TRANSACTION SCOPE에서는 꼭 '원자적'으로 실행될 QUERY만 넣어야 한다.
-- C# : List<Player> List<Salary> '원자적' 수행 → lock을 걸고 수행 → writelock( 상호배타 lock ), readlock( 공유 lock )

-- TRANSACTION은 '원자적' 수행을 이루기 위해 실행 도중 LOCK을 걸어두는데,
-- 만약, '원자적'으로 실행할 필요가 없는 QUERY까지 다 넣어서 실행에 시간이 많이 걸릴 경우,
-- LOCK으로 인해 다른 CONNECTOR들이 QUERY 실행 시, 대기상태에 들어가버린다.
