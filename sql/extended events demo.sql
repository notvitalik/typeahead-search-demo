SELECT TOP (1000) [CustomerId]
      ,[FirstName]
      ,[LastName]
      ,[Email]
      ,[Phone]
      ,[City]
      ,[State]
      ,[IsActive]
      ,[CreatedAt]
      ,[FirstNameKey]
      ,[LastNameKey]
      ,[EmailKey]
  FROM [TypeAheadDemo].[dbo].[Customers]
  WHERE [LastName] LIKE 'D%'


  SELECT @@SERVERNAME AS ServerName;
SELECT local_net_address, local_tcp_port
FROM sys.dm_exec_connections
WHERE session_id = @@SPID;


SELECT [FirstName],COUNT(*)
FROM [TypeAheadDemo].[dbo].[Customers]
GROUP BY [FirstName]
ORDER BY [FirstName] ASC


SELECT [LastName],COUNT(*)
FROM [TypeAheadDemo].[dbo].[Customers]
GROUP BY [LastName]
ORDER BY [LastName] ASC

INSERT INTO [TypeAheadDemo].dbo.Customers ([FirstName]
      ,[LastName]
      ,[Email]
      ,[Phone]
      ,[City]
      ,[State]
      ,[IsActive]
      ,[CreatedAt]     
     )
VALUES ('Baba','Blacksheep','bababs@example.com',1234567890,'BestCity','HA',1,GETDATE())

SELECT * FROM dbo.Customers WHERE [FirstName]='Baba'


UPDATE STATISTICS dbo.Customers WITH FULLSCAN;
GO

SET STATISTICS IO, TIME ON;
GO

EXEC sys.sp_recompile N'dbo.usp_CustomerTypeahead_Sniff';
GO


EXEC dbo.usp_CustomerTypeahead_Sniff @q = N'BLACK', @limit = 10; -- rare
GO
EXEC [TypeAheadDemo].[dbo].[usp_CustomerTypeahead_Sniff] @q = N'SMI',   @limit = 10; -- common/dense
GO


SELECT * FROM [TypeAheadDemo].[dbo].[Customers]
WHERE [LastName] LIKE '%Bas%'



SELECT * FROM [TypeAheadDemo].[dbo].[Customers]
WHERE [LastName] LIKE '%Bas%'


SELECT * FROM [TypeAheadDemo].[dbo].[Customers]
WHERE [LastName] LIKE 'Bas%'


DECLARE @q NVARCHAR(64) = N'Bas';
SELECT TOP(100) [CustomerId],[Email],[LastNameKey],[City]
FROM [TypeAheadDemo].[dbo].[Customers]
WHERE LastNameKey LIKE UPPER(@q) + N'%';

DECLARE @q NVARCHAR(64) = N'is';
SELECT TOP(300) [CustomerId],[Email],[FirstName],[LastName]
FROM [TypeAheadDemo].[dbo].[Customers]
WHERE LastNameKey LIKE N'%'+ UPPER(@q) + N'%'


DECLARE @q NVARCHAR(64) = N'a';
SELECT TOP(300) [CustomerId],[Email],[FirstName],[LastName],ROW_NUMBER() OVER (PARTITION BY FirstName ORDER BY Email DESC) AS [rn]
FROM [TypeAheadDemo].[dbo].[Customers]
WHERE LastNameKey LIKE N'%'+ UPPER(@q) + N'%'
AND FirstNameKey NOT LIKE N'%'+ UPPER(@q) + N'%'


SELECT TOP(300) [CustomerId],[Email],[FirstName],[LastName],ROW_NUMBER() OVER (PARTITION BY FirstName ORDER BY Email DESC) AS [rn]
FROM [TypeAheadDemo].[dbo].[Customers]
WHERE LastNameKey LIKE '%A%'
AND FirstNameKey NOT LIKE '%A%'


SELECT eqs.query_hash , est.text,*
FROM sys.dm_exec_query_stats eqs
CROSS APPLY sys.dm_exec_sql_text (eqs.sql_handle)  est
WHERE est.text LIKE N'%XE_DEMO_LONGRUN_20260209%'

--''%a%''
--AND FirstNameKey NOT LIKE ''%a%'''

SELECT 1

/* XE_DEMO_LONGRUN_20260209 */
SELECT TOP (300) [CustomerId],[Email],[FirstName],[LastName],
       ROW_NUMBER() OVER (PARTITION BY FirstName ORDER BY Email DESC) AS rn
FROM [TypeAheadDemo].[dbo].[Customers]
WHERE LastNameKey LIKE '%A%'
  AND FirstNameKey NOT LIKE '%A%';
--0x3ED94D8062DEE82E
--0x3ED94D8062DEE82E--4528736114107672622
SELECT CAST(0x3ED94D8062DEE82E AS BIGINT)

  SELECT TOP (20)
       qs.last_execution_time,
       qs.execution_count,
       qs.query_hash,
       qs.query_plan_hash,
       SUBSTRING(st.text,
                 (qs.statement_start_offset/2)+1,
                 ((CASE qs.statement_end_offset WHEN -1 THEN DATALENGTH(st.text)
                       ELSE qs.statement_end_offset END - qs.statement_start_offset)/2)+1
       ) AS stmt_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE st.dbid = DB_ID(N'TypeAheadDemo')
  AND st.text LIKE N'%XE_DEMO_LONGRUN_20260209%'
ORDER BY qs.last_execution_time DESC;













