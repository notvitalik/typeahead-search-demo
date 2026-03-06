USE TypeAheadDemo;
GO

-- First names
CREATE TABLE dbo.FirstNames
(
    FirstNameId INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL
);
INSERT dbo.FirstNames (FirstName)
VALUES
(N'Abhi'),(N'John'),(N'Jane'),(N'Michael'),(N'Sarah'),(N'David'),(N'Emily'),
(N'Chris'),(N'Alex'),(N'Priya'),(N'Raj'),(N'Anita'),(N'Maria'),(N'Luis'),
(N'Chen'),(N'Wei'),(N'Fatima'),(N'Omar'),(N'Noah'),(N'Olivia'),(N'Liam'),
(N'Emma'),(N'Sophia'),(N'Isabella'),(N'James'),(N'Benjamin'),(N'Lucas');
GO

-- Last names
CREATE TABLE dbo.LastNames
(
    LastNameId INT IDENTITY(1,1) PRIMARY KEY,
    LastName NVARCHAR(50) NOT NULL
);
INSERT dbo.LastNames (LastName)
VALUES
(N'Basu'),(N'Smith'),(N'Johnson'),(N'Williams'),(N'Brown'),(N'Jones'),
(N'Garcia'),(N'Miller'),(N'Davis'),(N'Rodriguez'),(N'Martinez'),
(N'Hernandez'),(N'Lopez'),(N'Gonzalez'),(N'Wilson'),(N'Anderson'),
(N'Thomas'),(N'Taylor'),(N'Moore'),(N'Jackson'),(N'Martin'),(N'Lee'),
(N'Perez'),(N'Thompson'),(N'White'),(N'Harris'),(N'Sanchez');
GO

-- Cities / States (keep it small; repeats are fine)
CREATE TABLE dbo.Cities
(
    CityId INT IDENTITY(1,1) PRIMARY KEY,
    City NVARCHAR(100) NOT NULL
);
INSERT dbo.Cities (City)
VALUES
(N'New York'),(N'Boston'),(N'Hartford'),(N'Chicago'),(N'San Francisco'),
(N'Austin'),(N'Dallas'),(N'Seattle'),(N'Miami'),(N'Atlanta'),(N'Phoenix');
GO

CREATE TABLE dbo.States
(
    StateId INT IDENTITY(1,1) PRIMARY KEY,
    State NVARCHAR(50) NOT NULL
);
INSERT dbo.States (State)
VALUES
(N'NY'),(N'MA'),(N'CT'),(N'IL'),(N'CA'),(N'TX'),(N'WA'),(N'FL'),(N'GA'),(N'AZ');
GO
