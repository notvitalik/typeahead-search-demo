CREATE OR ALTER PROCEDURE dbo.usp_CustomerTypeahead
    @q NVARCHAR(64),
    @limit INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    -- Guardrails
    SET @q = LTRIM(RTRIM(@q));
    IF @q IS NULL OR LEN(@q) < 2
    BEGIN
        SELECT TOP (0)
            CustomerId,
            DisplayText,
            SecondaryText
        FROM (VALUES (CAST(NULL AS BIGINT), CAST(NULL AS NVARCHAR(200)), CAST(NULL AS NVARCHAR(200)))) v(CustomerId, DisplayText, SecondaryText);
        RETURN;
    END

    IF @limit IS NULL OR @limit < 1 SET @limit = 10;
    IF @limit > 50 SET @limit = 50;

    DECLARE @qKey NVARCHAR(64) = UPPER(@q);

    -- Email mode (fast seek on IX_Customers_EmailKey)
    IF CHARINDEX(N'@', @q) > 0
    BEGIN
        SELECT TOP (@limit)
            c.CustomerId,
            CONCAT(c.FirstName, N' ', c.LastName) AS DisplayText,
            c.Email AS SecondaryText
        FROM dbo.Customers c
        WHERE c.EmailKey LIKE @qKey + N'%'
        ORDER BY c.EmailKey, c.CustomerId;
        RETURN;
    END

    -- Name mode (fast seek on IX_Customers_LastNameKey)
    -- Primary: LastName prefix. Secondary: FirstName prefix (optional)
    SELECT TOP (@limit)
        c.CustomerId,
        CONCAT(c.FirstName, N' ', c.LastName) AS DisplayText,
        CONCAT(c.City, CASE WHEN c.State IS NULL THEN N'' ELSE CONCAT(N', ', c.State) END) AS SecondaryText
    FROM dbo.Customers c
    WHERE c.LastNameKey LIKE @qKey + N'%'
       OR c.FirstNameKey LIKE @qKey + N'%'
    ORDER BY
        CASE 
            WHEN c.LastNameKey LIKE @qKey + N'%' THEN 0
            WHEN c.FirstNameKey LIKE @qKey + N'%' THEN 1
            ELSE 2
        END,
        c.LastNameKey,
        c.FirstNameKey,
        c.CustomerId;
END
GO
