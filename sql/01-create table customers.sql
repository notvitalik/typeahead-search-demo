CREATE TABLE dbo.Customers
(
    CustomerId     BIGINT IDENTITY(1,1) NOT NULL,
    
    FirstName      NVARCHAR(50) NOT NULL,
    LastName       NVARCHAR(50) NOT NULL,
    Email          NVARCHAR(255) NOT NULL,
    Phone          NVARCHAR(20) NULL,
    
    City           NVARCHAR(100) NULL,
    State          NVARCHAR(50) NULL,
    
    IsActive       BIT NOT NULL DEFAULT (1),
    CreatedAt      DATETIME2(0) NOT NULL DEFAULT SYSUTCDATETIME(),

    -- Normalized search keys (PERSISTED so they can be indexed)
    FirstNameKey AS UPPER(LTRIM(RTRIM(FirstName))) PERSISTED,
    LastNameKey  AS UPPER(LTRIM(RTRIM(LastName)))  PERSISTED,
    EmailKey     AS UPPER(LTRIM(RTRIM(Email)))     PERSISTED,

    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerId)
);
GO
