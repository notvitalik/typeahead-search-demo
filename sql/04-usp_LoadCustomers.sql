--ALTER INDEX IX_Customers_LastNameKey ON dbo.Customers DISABLE;
--ALTER INDEX IX_Customers_EmailKey ON dbo.Customers DISABLE;
--GO



CREATE OR ALTER PROCEDURE dbo.usp_LoadCustomers
    @TotalRows  BIGINT = 10000000,
    @BatchSize  INT    = 250000
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Inserted BIGINT = 0;

    DECLARE @FirstCnt INT = (SELECT COUNT(*) FROM dbo.FirstNames);
    DECLARE @LastCnt  INT = (SELECT COUNT(*) FROM dbo.LastNames);
    DECLARE @CityCnt  INT = (SELECT COUNT(*) FROM dbo.Cities);
    DECLARE @StateCnt INT = (SELECT COUNT(*) FROM dbo.States);

    WHILE @Inserted < @TotalRows
    BEGIN
        DECLARE @ThisBatch INT =
            CASE WHEN (@TotalRows - @Inserted) < @BatchSize THEN CAST(@TotalRows - @Inserted AS INT) ELSE @BatchSize END;

        ;WITH N AS
        (
            -- Generates @ThisBatch rows cheaply
            SELECT TOP (@ThisBatch)
                   ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
            FROM sys.all_objects a
            CROSS JOIN sys.all_objects b
        ),
        X AS
        (
            SELECT
                n,
                -- deterministic-ish randomness based on row number + offset (faster than NEWID per row)
                ABS(CHECKSUM(@Inserted + n)) AS h
            FROM N
        )
        INSERT dbo.Customers (FirstName, LastName, Email, Phone, City, State, IsActive, CreatedAt)
        SELECT
            fn.FirstName,
            ln.LastName,
            CONCAT(N'user', @Inserted + x.n, N'@example.com') AS Email,
            CONCAT(N'555', RIGHT(CONCAT(N'0000000', CAST((@Inserted + x.n) % 10000000 AS NVARCHAR(10))), 7)) AS Phone,
            c.City,
            s.State,
            CASE WHEN (x.h % 20) = 0 THEN 0 ELSE 1 END AS IsActive,   -- ~5% inactive
            DATEADD(DAY, -1 * (x.h % 3650), SYSUTCDATETIME()) AS CreatedAt -- up to ~10 years back
        FROM X x
        JOIN dbo.FirstNames fn ON fn.FirstNameId = (x.h % @FirstCnt) + 1
        JOIN dbo.LastNames  ln ON ln.LastNameId  = (x.h % @LastCnt)  + 1
        JOIN dbo.Cities     c  ON c.CityId       = (x.h % @CityCnt)  + 1
        JOIN dbo.States     s  ON s.StateId      = (x.h % @StateCnt) + 1;

        SET @Inserted += @ThisBatch;

        -- Lightweight progress output
        PRINT CONCAT('Inserted: ', @Inserted, ' / ', @TotalRows);
    END
END
GO
