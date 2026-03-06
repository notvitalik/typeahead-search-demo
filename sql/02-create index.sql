CREATE NONCLUSTERED INDEX IX_Customers_LastNameKey
ON dbo.Customers (LastNameKey, FirstNameKey)
INCLUDE (CustomerId, Email, City, State)
WITH (DATA_COMPRESSION = PAGE);
GO

CREATE NONCLUSTERED INDEX IX_Customers_EmailKey
ON dbo.Customers (EmailKey)
INCLUDE (CustomerId, FirstName, LastName)
WITH (DATA_COMPRESSION = PAGE);
GO


CREATE NONCLUSTERED INDEX IX_Customers_FirstNameKey
ON dbo.Customers (FirstNameKey, LastNameKey)
INCLUDE (CustomerId, Email, City, State)
WITH (DATA_COMPRESSION = PAGE);
GO


EXEC sp_helpindex 'dbo.Customers';
