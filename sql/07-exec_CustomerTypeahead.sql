EXEC dbo.usp_CustomerTypeahead @q = N'sm', @limit = 10;

EXEC dbo.usp_CustomerTypeahead @q = N'bas', @limit = 10;

EXEC dbo.usp_CustomerTypeahead @q = N'user12@', @limit = 10;


SET STATISTICS IO, TIME ON;

EXEC dbo.usp_CustomerTypeahead @q = N'sm', @limit = 10;     -- should be instant & return 0 rows now
EXEC dbo.usp_CustomerTypeahead @q = N'smi', @limit = 10;    -- should be fast
EXEC dbo.usp_CustomerTypeahead @q = N'bas', @limit = 10;    -- should be fast(er)
EXEC dbo.usp_CustomerTypeahead @q = N'user12@', @limit = 10;

SET STATISTICS IO, TIME OFF;