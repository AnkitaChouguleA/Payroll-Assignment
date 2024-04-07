create database Payroll

use Payroll

select * from [dbo].[Payroll]

-- Create the Division table
CREATE TABLE Division (
    Division_ID INT PRIMARY KEY IDENTITY(1,1),
    DivisionName VARCHAR(50) NOT NULL
);

-- Insert unique Division names from the imported table
INSERT INTO Division (DivisionName)
SELECT DISTINCT Division
FROM Payroll;

select * from Division

-- Create the Channel table
CREATE TABLE Channel (
    Channel_ID INT PRIMARY KEY IDENTITY(1,1),
    ChannelName VARCHAR(50) NOT NULL,
    Division_ID INT,
    FOREIGN KEY (Division_ID) REFERENCES Division(Division_ID)
);

-- Create the Channel table
CREATE TABLE Channel (
    Channel_ID INT PRIMARY KEY IDENTITY(1,1),
    ChannelName VARCHAR(50) NOT NULL,
    Division_ID INT,
    FOREIGN KEY (Division_ID) REFERENCES Division(Division_ID)
);

--insert
INSERT INTO Channel (ChannelName, Division_ID)
SELECT DISTINCT P.Channel, D.Division_ID
FROM Payroll AS P
INNER JOIN 
Division AS D ON P.Division = D.DivisionName; 

select * from Channel

-- Create the Sales Org table
CREATE TABLE SalesOrg (
    SalesOrg_id INT PRIMARY KEY IDENTITY(1, 1),
    SalesOrg VARCHAR(50) NOT NULL,
    Channel_id INT,
    FOREIGN KEY (Channel_id) REFERENCES Channel(Channel_ID)
);

-- Insert unique SalesOrg names from the Payroll table along with the associated Channel_id
INSERT INTO SalesOrg (SalesOrg, Channel_id)
SELECT DISTINCT P.SalesORG, C.Channel_ID
FROM Payroll AS P
INNER JOIN Channel AS C ON P.Channel = C.ChannelName;

-- Verify the data in the Sales Org table
SELECT * FROM SalesOrg;

-- Create the Designation table
CREATE TABLE Designation (
    Designation_ID INT PRIMARY KEY IDENTITY(1,1),
    DesignationName VARCHAR(50) NOT NULL
);

-- Insert unique Designation names from the Payrool table
INSERT INTO Designation (DesignationName)
SELECT DISTINCT Designation
FROM Payroll;

select * from Designation

-- Create the Job_Table
CREATE TABLE Job_Table (
    JobId INT PRIMARY KEY IDENTITY(1,1),
    JobTitle VARCHAR(50) NOT NULL,
    Designation_id INT,
    FOREIGN KEY (Designation_id) REFERENCES designation(Designation_id)
);

-- Insert unique Job Titles and corresponding Designation IDs from the imported table
INSERT INTO Job_Table (JobTitle, Designation_id)
SELECT DISTINCT JobTitle, D.Designation_id
FROM Payroll P
INNER JOIN designation D ON P.Designation = D.DesignationName;

select * from Job_Table

-- Create the Geography table
CREATE TABLE Geography (
    Zone_id INT PRIMARY KEY IDENTITY(1,1),
    Zone VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL
);

-- Insert unique Zone, State, and City combinations from the imported table
INSERT INTO Geography (Zone, State, City)
SELECT DISTINCT Zone, State, City
FROM Payroll;

select * from Geography

-- Create the Calendar_Table
CREATE TABLE Calendar_Table (
    TimeID INT PRIMARY KEY IDENTITY(1,1),
    Year INT NOT NULL,
    Month INT NOT NULL,
    WeeklyOff INT NOT NULL
);

-- Insert unique Year, Month, and WeeklyOff combinations from the imported table
INSERT INTO Calendar_Table (Year, Month, WeeklyOff)
SELECT DISTINCT Year, Month, WeeklyOff
FROM Payroll;

select * from Calendar_Table
-- Create the Employee table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    EmployeeName VARCHAR(255) NOT NULL,
    DateofBirth DATE NOT NULL,
    DateofJoining DATE NOT NULL,
    EMP_Salary DECIMAL(10, 2) NOT NULL,
    EMP_Allowance DECIMAL(10, 2) NOT NULL,
    EMP_Incentives_Perc DECIMAL(5, 2) NOT NULL,
    Job_ID INT NOT NULL,
    SalesOrg_id INT NOT NULL,
    Zone_id INT NOT NULL,
    Booking VARCHAR(100) NULL,
    Billing VARCHAR(100) NULL,
    Collection VARCHAR(100) NULL,
    Salary_Payable VARCHAR(100) NULL,
    Allowance_Payable VARCHAR(100) NULL,
    Incentives_Payable VARCHAR(100) NULL,
    FOREIGN KEY (Job_ID) REFERENCES Job_Table(JobId),
    FOREIGN KEY (SalesOrg_id) REFERENCES SalesOrg(SalesOrg_id),
    FOREIGN KEY (Zone_id) REFERENCES Geography(Zone_id)
);

select * from Employee
drop table Employee

CREATE VIEW JobDesignationView AS
SELECT
    J.JobID,
    J.JobTitle,
    D.DesignationName
FROM Job_Table J
JOIN Designation D ON J.Designation_id = D.Designation_ID;

select * from JobDesignationView
drop view JobDesignationView

CREATE VIEW DivisionChannelSalesOrgView AS
SELECT
    s.SalesOrg_id,
    D.DivisionName AS Division,
    C.ChannelName AS Channel,
    S.SalesOrg AS SalesOrg
FROM Division D
JOIN Channel C ON D.Division_ID = C.Division_ID
JOIN SalesOrg S ON C.Channel_ID = S.Channel_ID;

select * from DivisionChannelSalesOrgView
drop view DivisionChannelSalesOrgView

select 'Select * from ' + name  from sys.tables

Select * from Job_Table
Select * from Designation
Select * from SalesOrg

INSERT INTO Employee (EmployeeID, EmployeeName, DateofBirth, DateofJoining, EMP_Salary, EMP_Allowance, EMP_Incentives_Perc, Job_ID, SalesOrg_ID, Zone_ID, Booking, Billing, Collection)
SELECT
    EmployeeID,
    EmployeeName,
    DateofBirth,
    DateofJoining,
    EMP_Salary,
    EMP_Allowance,
    EMP_Incentives_Perc,
    (SELECT JobID FROM JobDesignationView WHERE JobTitle = Payroll.JobTitle AND DesignationName = Payroll.Designation),
    (SELECT SalesOrg_Id FROM DivisionChannelSalesOrgView WHERE Division = Payroll.Division AND Channel = Payroll.Channel AND SalesOrg = Payroll.SalesORG),
    (SELECT Zone_ID FROM Geography WHERE Zone = Payroll.Zone AND State = Payroll.State AND City = Payroll.City),
    Booking,
    Billing,
    Collection
FROM Payroll;

select * from employee

-------------------------------------------------------------------------------

select * from sys.tables

select * from sys.columns where object_id = 901578250

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Payroll';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employee';

select * from Calendar_Table

-- Create the Timesheet table
CREATE TABLE Timesheet (
    EmployeeID INT,
    Time_ID INT,
    Leaves DECIMAL(10, 2) NOT NULL,
    Attendence DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (Time_ID) REFERENCES Calendar_Table(TimeID)
);

-- Insert data into the Timesheet table from the Payroll table
INSERT INTO Timesheet (EmployeeID, Time_ID, Leaves, Attendence)
SELECT
    E.EmployeeID,
    C.TimeID,
    P.Leaves,
    P.Attendence
FROM Payroll AS P
INNER JOIN Employee AS E ON P.EmployeeID = E.EmployeeID
INNER JOIN Calendar_Table AS C ON P.Year = C.Year AND P.Month = C.Month;


---Queries
-- Calculate and update Allowance
begin tran
UPDATE Employee
SET Allowance_Payable = (t.Attendence + c.WeeklyOff) / (t.Attendence + c.WeeklyOff + t.Leaves) * E.EMP_Allowance
FROM Employee E join Timesheet t on E.EmployeeId = t.EmployeeID
	join Calendar_Table c on c.TimeID = t.Time_ID;

select * from employee

-- Calculate and update Incentives for Sales Executive
BEGIN TRAN
UPDATE Employee
SET Incentives_Payable = (
    CAST(ISNULL(E.Collection, 0) AS DECIMAL(10, 2)) / NULLIF(CAST(E.Billing AS DECIMAL(10, 2)), 0)
) * E.EMP_Incentives_Perc * E.EMP_Salary
FROM Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Sales Executive';

select * from Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Sales Executive';

-- Calculate and update Incentives for Lead Sales Executive
BEGIN TRAN
UPDATE Employee
SET Incentives_Payable = (
    CAST(ISNULL(E.Collection, 0) AS DECIMAL(10, 2)) / NULLIF(CAST(E.Billing AS DECIMAL(10, 2)), 0)
) * E.EMP_Incentives_Perc * E.EMP_Salary
FROM Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Lead Sales Executive';

select * from Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Lead Sales Executive';

-- Calculate and update Incentives for Sales Manager
BEGIN TRAN
UPDATE Employee
SET Incentives_Payable = (
    CAST(ISNULL(E.Collection, 0) AS DECIMAL(10, 2)) / NULLIF(CAST(E.Billing AS DECIMAL(10, 2)), 0)
) * E.EMP_Incentives_Perc * E.EMP_Salary
FROM Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Sales Manager';

select * from Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Sales Manager';

select * from Job_Table

-- Calculate and update Incentives for Area Sales Manager
BEGIN TRAN
DECLARE @A DECIMAL(10, 2);
DECLARE @B DECIMAL(10, 2);

-- Calculate A (SUM of Collection, handling nulls)
SELECT @A = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Collection, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Area Sales manager';
PRINT 'Value of A: ' + CAST(@A AS NVARCHAR(50));

-- Calculate B (SUM of Billing, handling nulls)
SELECT @B = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Billing, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Area Sales manager';
PRINT 'Value of B: ' + CAST(@B AS NVARCHAR(50));

-- Update Incentives_Payable
UPDATE Employee
SET Incentives_Payable = (
    CASE 
        WHEN @B = 0 THEN 0 -- Handle division by zero
        ELSE CAST(ISNULL(@A, 0) / @B AS DECIMAL(10, 2))
    END
) * E.EMP_Incentives_Perc * E.EMP_Salary
FROM Employee AS E 
JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Area Sales manager'

select * from sys.tables
select * from DivisionChannelSalesOrgView
select * from Geography

select * from Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Area Sales Manager';


-- Calculate and update Incentives for Zonal Sales Manager
BEGIN TRAN
DECLARE @A DECIMAL(10, 2);
DECLARE @B DECIMAL(10, 2);

-- Calculate A (SUM of Collection, handling nulls)
SELECT @A = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Collection, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Zonal Sales Manager';
PRINT 'Value of A: ' + CAST(@A AS NVARCHAR(50));

-- Calculate B (SUM of Billing, handling nulls)
SELECT @B = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Billing, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Zonal Sales Manager';
PRINT 'Value of B: ' + CAST(@B AS NVARCHAR(50));

-- Update Incentives_Payable
UPDATE Employee
SET Incentives_Payable = (
    CASE 
        WHEN @B = 0 THEN 0 -- Handle division by zero
        ELSE CAST(ISNULL(@A, 0) / @B AS DECIMAL(10, 2))
    END
) * E.EMP_Incentives_Perc * E.EMP_Salary
FROM Employee AS E 
JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Zonal Sales Manager'

select * from Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Zonal Sales Manager';

-- Calculate and update Incentives for Deputy General Manager - Sales                     
BEGIN TRAN
DECLARE @A DECIMAL(10, 2);
DECLARE @B DECIMAL(10, 2);

-- Calculate A (SUM of Collection, handling nulls)
SELECT @A = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Collection, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Deputy General Manager - Sales';
PRINT 'Value of A: ' + CAST(@A AS NVARCHAR(50));

-- Calculate B (SUM of Billing, handling nulls)
SELECT @B = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Billing, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Deputy General Manager - Sales';
PRINT 'Value of B: ' + CAST(@B AS NVARCHAR(50));

-- Update Incentives_Payable
UPDATE Employee
SET Incentives_Payable = (
    CASE 
        WHEN @B = 0 THEN 0 -- Handle division by zero
        ELSE CAST(ISNULL(@A, 0) / @B AS DECIMAL(10, 2))
    END
) * E.EMP_Incentives_Perc * E.EMP_Salary
FROM Employee AS E 
JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Deputy General Manager - Sales'

select * from Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Deputy General Manager - Sales';

-- Calculate and update Incentives for Vice President Sales                                
BEGIN TRAN
DECLARE @A DECIMAL(10, 2);
DECLARE @B DECIMAL(10, 2);

-- Calculate A (SUM of Collection, handling nulls)
SELECT @A = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Collection, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Vice President Sales';
PRINT 'Value of A: ' + CAST(@A AS NVARCHAR(50));

-- Calculate B (SUM of Billing, handling nulls)
SELECT @B = ISNULL(SUM(ISNULL(TRY_CAST(ISNULL(Billing, '0') AS DECIMAL(10, 2)), 0)), 0)
FROM Employee AS E
INNER JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Vice President Sales';
PRINT 'Value of B: ' + CAST(@B AS NVARCHAR(50));

-- Update Incentives_Payable
UPDATE Employee
SET Incentives_Payable = (
    CASE 
        WHEN @B = 0 THEN 0 -- Handle division by zero
        ELSE CAST(ISNULL(@A, 0) / @B AS DECIMAL(10, 2))
    END
) * E.EMP_Incentives_Perc * E.EMP_Salary
FROM Employee AS E 
JOIN Job_Table AS J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Vice President Sales'

select * from Employee E
INNER JOIN Job_Table J ON E.Job_ID = J.JobId
WHERE J.JobTitle = 'Vice President Sales';

select * from employee

-- Calculate Salary_Payable
UPDATE Employee
SET Salary_Payable = E.EMP_Salary - E.Incentives_Payable
FROM Employee E;







