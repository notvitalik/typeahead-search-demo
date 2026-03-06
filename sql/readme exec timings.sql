--1 Warm cache:

EXEC dbo.usp_CustomerTypeahead @q=N'smi', @limit=10;
EXEC dbo.usp_CustomerTypeahead @q=N'bas', @limit=10;
EXEC dbo.usp_CustomerTypeahead @q=N'user12@', @limit=10;


--2 measure:

SET STATISTICS IO, TIME ON;
EXEC dbo.usp_CustomerTypeahead @q=N'smi', @limit=10;
EXEC dbo.usp_CustomerTypeahead @q=N'bas', @limit=10;
EXEC dbo.usp_CustomerTypeahead @q=N'user12@', @limit=10;
SET STATISTICS IO, TIME OFF;

--SQL Server parse and compile time: 
--   CPU time = 0 ms, elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.
--SQL Server parse and compile time: 
--   CPU time = 4 ms, elapsed time = 4 ms.
--Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
--Table 'Customers'. Scan count 2, logical reads 53, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 4 ms,  elapsed time = 5 ms.
--SQL Server parse and compile time: 
--   CPU time = 0 ms, elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.
--SQL Server parse and compile time: 
--   CPU time = 4 ms, elapsed time = 5 ms.
--Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
--Table 'Customers'. Scan count 2, logical reads 51, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 4 ms,  elapsed time = 6 ms.
--SQL Server parse and compile time: 
--   CPU time = 0 ms, elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.
--SQL Server parse and compile time: 
--   CPU time = 3 ms, elapsed time = 3 ms.
--Table 'Customers'. Scan count 1, logical reads 14, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 0 ms,  elapsed time = 0 ms.

-- SQL Server Execution Times:
--   CPU time = 7 ms,  elapsed time = 3 ms.

--Completion time: 2026-01-31T09:04:00.6511748-05:00
