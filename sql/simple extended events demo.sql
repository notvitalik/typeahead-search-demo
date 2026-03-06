SELECT TOP (300) [CustomerId],[Email],[FirstName],[LastName],
       ROW_NUMBER() OVER (PARTITION BY FirstName ORDER BY Email DESC) AS rn
FROM [TypeAheadDemo].[dbo].[Customers]
WHERE LastNameKey LIKE '%A%'
  AND FirstNameKey NOT LIKE '%A%';


  SELECT 1

  SELECT * FROM fn_my_permissions(NULL, 'SERVER') 
WHERE permission_name = 'VIEW SERVER STATE';