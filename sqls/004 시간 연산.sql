USE BaseballData;


-- DATE		��/��/��
-- TIME		��/��/��
-- DATETIME	��/��/��/��/��/��

IF NOT EXISTS
	(SELECT * FROM information_schema.tables WHERE table_name='DateTimeTest')
CREATE TABLE DateTimeTest (
	time	DATETIME
)
GO

INSERT INTO DateTimeTest (time)
VALUES		( '20200425 05:04' )
,			( CAST('20200425 05:03:21' AS DATETIME) )
,			( CURRENT_TIMESTAMP )
GO

SELECT	*
FROM	DateTimeTest
GO


-- �� DateTime ĳ����
-- Casting Format ����.
-- YYYYMMDD
-- YYYYMMDD hh:mm:ss.nnn
-- YYYY-MM-DDThh:mm
SELECT	CAST('20200425' AS DATETIME);
SELECT	CAST('20200425 05:03:21' AS DATETIME);


-- �� ���� �ð�
-- �Ʒ��� �ſ� �����ѵ�,
-- ����ϴ� �ӽ� �ð��� �������� �ϱ� ����.
SELECT	GETDATE();
SELECT	CURRENT_TIMESTAMP;


-- �� ���� ���� �˻�.
SELECT	*
FROM	DateTimeTest
-- WHERE	time >= CAST( '20100101' AS DATETIME )
WHERE	time >= '20100101';


-- �� UTC �ð�( ������ ���� �ð� ) ���.
-- GMT ( Greenwich Mean Time )
SELECT	GETUTCDATE();


-- �� �ð� ����( ���ϱ�/���� ).
SELECT	DATEADD(YEAR, 1, '20200426');
SELECT	DATEADD(DAY, 6, '20200426');
SELECT	DATEADD(SECOND, -123323, '20200426');


-- �� �� �ð��� ����.
SELECT	DATEDIFF(SECOND, '20200426', '20200503'); -- 604800
SELECT	DATEDIFF(SECOND, '20200826', '20200503'); -- -9936000
SELECT	DATEDIFF(DAY, '20200426', '20200503');


-- �� �Ϻ� ����.
SELECT	DATEPART(DAY, '20200826');
SELECT	YEAR('20200826');
SELECT	MONTH('20200826');
SELECT	DAY('20200826');
