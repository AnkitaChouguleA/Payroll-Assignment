/*********************************************

Name	-		Code for School DB
Author	-		Ankita Chougule
Date	-		11/08/23

Purpose -		This script will create DB and few tables in it to store info about school

**************************************************/


create database school

sp_helpdb school

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


--change context
use school

SELECT 'select * from ' + name AS Query FROM sys.tables;


-- CourseMaster
create table CourseMaster
(
	CID				int				primary key,
	CourseName		varchar(40)		NOT null,
	Category		char(1)			NUll check(Category='B'or Category='M' or Category='A'),
	fee				smallmoney		NOT NULL check(fee > 0)	
)
go

--Schema of the table
sp_help CourseMaster
go

--read the table data 
select * from CourseMaster
go

--insert the Data in table
insert into CourseMaster values(10,'Java','B',5000)

insert into CourseMaster values(20,'Adv Java','a',25000)
insert into CourseMaster values(30,'Big DAta','A',40000)
insert into CourseMaster values(40,'SQL Server','M',20000)
insert into CourseMaster values(50,'Oracle','M',15000)
insert into CourseMaster values(60,'Python','B',15000)
insert into CourseMaster values(70,'MSBI','A',35000)
insert into CourseMaster values(80,'Data Secience','A',90000)
go

--update Data(insert into CourseMaster values(20,'Adv Java','a',25000)) 
update CourseMaster
set Category='A'
where CID=20
go

--StudentMaster
create table StudentMaster
(
	SID		TinyInt			Primary key,
	Name	varchar(40)		not null,
	Origin	Char(1)			not null check (Origin='L' or Origin='F'),
	Type	Char(1)			not null check (Type ='U' or Type='G')
)
go

--Read The Data
select * from StudentMaster
go

--insert data
insert into StudentMaster values (1,'Vishnu','F','G')
insert into StudentMaster values (2,'Durga parasad','L','U')
insert into StudentMaster values (3,'Geni','F','U')
insert into StudentMaster values (4,'Gopi Krishna','l','G')
insert into StudentMaster values (5,'Hemanat','L','G')
insert into StudentMaster values (6,'K Nitish','L','G')
insert into StudentMaster values (7,'Manisha','L','G' )
insert into StudentMaster values (8,'Priyanko','L','G')
insert into StudentMaster values (9,'RAJ','F','G')
-- Insert data
INSERT INTO StudentMaster VALUES (10, 'John Doe', 'L', 'U');
INSERT INTO StudentMaster VALUES (11, 'Jane Smith', 'F', 'G');
INSERT INTO StudentMaster VALUES (12, 'Michael Johnson', 'L', 'U');
INSERT INTO StudentMaster VALUES (13, 'Emily Davis', 'F', 'U');
INSERT INTO StudentMaster VALUES (14, 'William Brown', 'L', 'G');
INSERT INTO StudentMaster VALUES (15, 'Olivia Wilson', 'F', 'G');
INSERT INTO StudentMaster VALUES (16, 'James Lee', 'L', 'U');
INSERT INTO StudentMaster VALUES (17, 'Sophia Taylor', 'F', 'G');
INSERT INTO StudentMaster VALUES (18, 'Benjamin Clark', 'L', 'G');
INSERT INTO StudentMaster VALUES (19, 'Emma Hall', 'F', 'U');
INSERT INTO StudentMaster VALUES (20, 'Daniel White', 'L', 'U');
INSERT INTO StudentMaster VALUES (21, 'Ava Garcia', 'F', 'G');
INSERT INTO StudentMaster VALUES (22, 'Matthew Rodriguez', 'L', 'U');
INSERT INTO StudentMaster VALUES (23, 'Chloe Lopez', 'F', 'U');
INSERT INTO StudentMaster VALUES (24, 'Liam Martinez', 'L', 'G');
INSERT INTO StudentMaster VALUES (25, 'Mia Adams', 'F', 'G');
INSERT INTO StudentMaster VALUES (26, 'Ethan Hernandez', 'L', 'U');
INSERT INTO StudentMaster VALUES (27, 'Isabella Parker', 'F', 'G');
INSERT INTO StudentMaster VALUES (28, 'Noah Lewis', 'L', 'U');
INSERT INTO StudentMaster VALUES (29, 'Sophia Turner', 'F', 'G');


--How to update primay key
update StudentMaster
set SID=9

-- Delete sigal row
delete from StudentMaster where SID=10
go

--EnrollmentMaster
create table EnrollmentMaster
(
	CID		int			not null Foreign Key References CourseMaster(CID),
	SID		Tinyint		not null Foreign Key References StudentMaster(SID),
	DOE		DateTime	not null,
	FWF		bit			not null,
	Grade	Char(1)		NUll check (Grade in('O','A','B','C'))
)
go

--see the data data
select * from EnrollmentMaster
go

truncate table EnrollmentMaster

--insert The Data
insert into EnrollmentMaster values (30,1,'2022/11/29',0,'o')
insert into EnrollmentMaster values (60,2,'2022/11/29',0,'O')
insert into EnrollmentMaster values (50,1,'2019/1/31',1,'A')
go

insert into EnrollmentMaster values (80,9,'2018/11/6',0,'B')
insert into EnrollmentMaster values (70,8,'2022/10/09',1,'C')
insert into EnrollmentMaster values (40,5,'2021/1/1',1,'O')
go

insert into EnrollmentMaster values (40,9,'2021/1/6',0,'A')
insert into EnrollmentMaster values (60,8,'2021/2/9',1,'C')
insert into EnrollmentMaster values (40,5,'2021/3/1',1,'O')
go

insert into EnrollmentMaster values (40,3,'2020/3/6',1,'O')
insert into EnrollmentMaster values (50,8,'2020/4/09',0,'C')
insert into EnrollmentMaster values (40,5,'2020/5/1',0,'B')

INSERT INTO EnrollmentMaster VALUES (40, 8, '2020-06-15', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (30, 8, '2020-07-21', 0, 'C');
INSERT INTO EnrollmentMaster VALUES (20, 8, '2020-08-03', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (50, 1, '2020-09-12', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (10, 3, '2020-10-05', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (10, 7, '2020-11-19', 0, 'C');
INSERT INTO EnrollmentMaster VALUES (70, 2, '2020-12-07', 1, 'O');
INSERT INTO EnrollmentMaster VALUES (10, 5, '2021-01-15', 0, 'B');
INSERT INTO EnrollmentMaster VALUES (10, 8, '2021-02-28', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (60, 3, '2021-03-10', 1, 'A');

INSERT INTO EnrollmentMaster VALUES (30, 1, '2021-02-28', 1, 'A');
INSERT INTO EnrollmentMaster VALUES (30, 3, '2021-03-10', 1, 'A');

INSERT INTO EnrollmentMaster VALUES (80, 8, '2023-09-12', 1, 'O');


update EnrollmentMaster
set Grade = 'O' where CID = 30 and SID = 1

select * from sys.tables 
select 'Select * from ' + name  from sys.tables

Select * from CourseMaster
Select * from StudentMaster
Select * from EnrollmentMaster

select * from sys.filegroups

-- 1.List the course wise total no. of Students enrolled. Provide the information only for students of foreign origin and only if the total exceeds 10.
select c.CID,c.CourseName, COUNT(name) count_students  
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where s.Origin = 'F'
group by c.CourseName,c.CID
having COUNT(name) > 2

-- 2.List the names of the Students who have not enrolled for Java course.
select s.Name,c.CourseName 
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where c.CourseName <> 'Java'

-- 3.List the name of the advanced course where the enrollment by foreign students is the highest.
select * from 
(
select c.CID,c.CourseName, COUNT(name) as NoOfStudents,
DENSE_RANK() over (order by COUNT(name) desc) as RNno
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where s.Origin = 'F' and c.Category = 'A' 
group by c.CID,c.CourseName
) as k
where RNno = 1

-- 4.List the names of the students who have enrolled for at least one basic course in the current month.
select * from 
(
	select c.Category, s.Name,datepart(mm,e.DOE) as Enroll_month,
	DENSE_RANK() over (order by s.name desc) as RNno
	from CourseMaster c 
	join EnrollmentMaster e
	on  c.CID = e.CID 
	join StudentMaster s
	on s.SID = e.SID
	where c.Category = 'B' and 
	datepart(mm,e.DOE) = DATEPART(mm,getdate()) + 2
) as k
where RNno = 1 

-- 5.List the names of the Undergraduate, local students who have got a “O” grade in any basic course.
select distinct s.Name,s.Origin,s.Type,c.Category,e.Grade
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where s.Origin = 'L' and s.Type = 'U' and e.Grade = 'O' and c.Category = 'B'

--6.List the names of the courses for which no student has enrolled in the month of May 2020.
select CourseName from coursemaster where coursename not in
(
	select c.CourseName 
	from CourseMaster c 
	join EnrollmentMaster e
	on  c.CID = e.CID 
	join StudentMaster s
	on s.SID = e.SID
	where DATENAME(mm,e.DOE) = 'May' and DATEPART(yy,e.DOE) = 2020
) 

-- 7.List name, Number of Enrollments and Popularity for all Courses. Popularity has to be displayed as “High” if number of enrollments is higher than 50, 
-- “Medium” if greater than or equal to 20 and less than 50, and “Low” if the no. is less than 20.
select c.CourseName, COUNT(e.sid) as NoOfEnrollments,
	Case
			When COUNT(e.sid) >= 10					Then 'High'
			when COUNT(e.sid) between 5 and 9		Then 'Medium'
			else 'Low'
		END as Popularity
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
group by c.CourseName
order by NoOfEnrollments

-- 8.List the most recent enrollment details with information on Student Name, Course name and age of enrollment in days.
select s.Name,c.CourseName,DATEDIFF(day, e.DOE,GETDATE()) as EnrollmentAgeInDays
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where e.DOE = 
	(
		select max(doe) from EnrollmentMaster e,StudentMaster s where e.SID = s.SID
	)

-- 9.List the names of the Local students who have enrolled for exactly 3 basic courses. 
select s.Name, count(c.category) as NoOfCourses
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where c.Category = 'B' and s.Origin = 'L' 
group by s.Name
having count(c.category) = 3

-- 10.List the names of the Courses enrolled by all (every) students.
SELECT C.CourseName
FROM CourseMaster C
JOIN EnrollmentMaster E ON C.CID = E.CID
JOIN StudentMaster S ON E.SID = S.SID
GROUP BY C.CourseName
HAVING COUNT(DISTINCT s.SID) = (SELECT COUNT(*) FROM StudentMaster);

-- 11.For those enrollments for which fee have been waived, provide the names of students who have got ‘O’ grade.
select s.Name from
EnrollmentMaster e 
join StudentMaster s
on e.SID = s.SID
where FWF = 1 and Grade = 'O'

-- 12.List the names of the foreign, undergraduate students who have got grade ‘C’ in any basic course.
select s.Name
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where c.Category = 'B' and s.Origin = 'F' and Grade = 'C' and Type = 'U'

-- 13.List the course name, total no. of enrollments in the current month.
select c.CourseName, count(e.sid) as NoOfEnrollments
from CourseMaster c 
join EnrollmentMaster e
on  c.CID = e.CID 
join StudentMaster s
on s.SID = e.SID
where DATEPART(mm,doe) = DATEPART(mm,getdate())
group by CourseName

/*
STORED PROCEDURE
USING THE ABOVE TABLE LAYOUTS AS SCHEMA, WRITE A STORED PROCEDURE FOR THE FOLLOWING SPECIFICATIONS:
Input Parameters:
Date From (Mandatory), Date To (optional, if not specified, take the current date), & Student ID (Mandatory)  
Requirements:
Course-wise,enrollment-wise in ascending order of course name to be printed. If no enrollment exists for a given course for the period specified, 
print course name and the remarks ‘No enrollment for this period’
------------------------------------------------------------------------------------------
Enrollment Details of<Student Name > from <FromDate> To <ToDate>
Origin : 							Type:
SL.No       Course Name    Date of Enrollment    Fee Waiver?	Grade  
							      (Yes/No)
  …		…		……				……	  ……
  …		…		……				…… 	  ……
                       Total No. of Courses Enrolled: 

*/

select * from CourseMaster
select * from StudentMaster
select * from EnrollmentMaster

 /*************************************************************************************
SP_Name	: GetEnrollmentDetails  
Author	: Ankita Chougule
Date	: Mar 25th 2024
DB		: School
Purpose : It will get Course-wise, enrollment-wise details of a student.

History:
---------------------------------------------------------------------------------------
SLNo	Done by				Date of change			Remarks
---------------------------------------------------------------------------------------
1		Ankita Chougule		Mar 9th 2024			New sp

****************************************************************************************/

use school

create or alter procedure GetEnrollmentDetails
	@datefrom datetime,
	@dateto datetime null,
	@studentid tinyint
as
begin

	set nocount on; -- Add this line to suppress the row count message

	-- Check if @DateTo is NULL, then assign the current date
	if @dateto is null
	set @dateto = GETDATE()

	--declare variable to store student name
	declare @studentname varchar(40)
	declare @origin char(1)
	declare @type char(1)

	--get student details
	select @studentname = name, @origin = Origin, @type = Type from StudentMaster 
	where SID = @studentid

	--print enrollment details header
	print 'Enrollment Details of ' + @studentname + 
	' from ' + convert(varchar(10), @datefrom, 101) + 
	' to ' + convert(varchar(10), @dateto, 101)
	print 'Origin : ' + @origin + space(20) +'Type : ' + @type

	-- 3. Get enrollment details and Store the data in temp table
	select ROW_NUMBER() over(order by cm.CourseName asc) as SLNo, cm.CourseName, em.DOE,
	case when em.FWF = 1 then 'Yes' else 'No' end as FeeWaiver,
	em.Grade into #TempEnrollmentDetails
	from EnrollmentMaster em
	inner join CourseMaster cm
	on em.CID = cm.CID
	where em.SID = @studentid
	and em.DOE between @datefrom and @dateto

	--print data from #TempEnrollmentDetails
	--select * from #TempEnrollmentDetails

	-- Check if there are any enrollments for the given student and period
	if @@ROWCOUNT = 0
	begin
		print 'No enrollment for this period'
	end
	else
	begin
		-- Print enrollment details 
		print 'SL.No    Course Name		Date of Enrollment		Fee Waiver?			Grade '
	end
 
	declare @x int = 1
	declare @cnt int
	select @cnt = count(*) from #TempEnrollmentDetails
	declare @rno int
	declare @coursename varchar(40)
	declare @DateOfEnrol datetime
	declare @FeeWaiver varchar(5)
	declare @grade char(1)

	--loop start
	while (@x <= @cnt)
	begin
		select @rno = SLNo,
		@coursename = CourseName,
		@DateOfEnrol = DOE,
		@FeeWaiver = FeeWaiver,
		@grade = Grade
		from #TempEnrollmentDetails
		where slno = @x

		--print the data
		print cast(@rno as varchar) + space(10) +  @coursename +
		space(17)+ convert(varchar, @DateOfEnrol, 107) +space(15)+ @FeeWaiver +
		space(10)+@grade

		--incr
			set @x = @x + 1

	end -- loop end
	print'--------------------------------------------------------------------------------------------------'
	print'	Total No. of Courses Enrolled: ' + cast(@cnt as varchar)
end
go

exec GetEnrollmentDetails 
	@datefrom = '2020-01-01',
	@dateto = null,
	@studentid = 2



