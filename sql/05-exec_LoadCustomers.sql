--EXEC dbo.usp_LoadCustomers @TotalRows = 10000000, @BatchSize = 250000;

SELECT COUNT(*) FROM [dbo].[Customers]

--EXEC dbo.usp_LoadCustomers @TotalRows = 2000000, @BatchSize = 250000;

ALTER INDEX IX_Customers_LastNameKey ON dbo.Customers REBUILD WITH (DATA_COMPRESSION = PAGE);
ALTER INDEX IX_Customers_EmailKey    ON dbo.Customers REBUILD WITH (DATA_COMPRESSION = PAGE);
GO
