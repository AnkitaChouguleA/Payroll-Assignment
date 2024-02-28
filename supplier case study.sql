use master
go

/*************************************************
Name	:Code for supplier DB
Author	:Ankita Chougule
Data	:21-09-2023 

purpose	:This Script will Create DB and few table in it info supply

**************************************************/
--Create Database
create database Supplier
go

--change DB Context
use Supplier
go

select * from sys.tables

--SupplierMaster
create table SupplierMaster
(
	SID		int				primary key,
	NAME	varchar(40)		not null,
	CITY	char(6)			not null,
	GRADE	Tinyint			not null check(GRADE>0 and GRADE<=4)
)
go

--see The DB
select * from SupplierMaster
go

--see the schema
sp_help SupplierMaster
go

--insert The value in table
insert into SupplierMaster values (10,'Usman khan','Delhi',1)
insert into SupplierMaster values (20,'NItish k','mumbai',2)
insert into SupplierMaster values (30,'Ram','USA',1)
insert into SupplierMaster values (40,'RAj','HYD',4)
insert into SupplierMaster values (50,'Akshay','Nagar',3)
insert into SupplierMaster values (60,'Iwser','Nasik',4)
go

--PartMaster
create table PartMaster
(
	PID			TinyInt			Primary Key,
	NAME		Varchar(40)		NOT NULL,
	PRICE		Money			NOT NULL,
	CATEGORY	Tinyint			NOT NULL,
	QTYONHAND	Integer			NULL
)
go

--read the Data
Select * from PartMaster
go

--insert The data
insert into PartMaster values(1,'Light',1000,1,1200)
insert into PartMaster values(2,'Batteries',5600,1,500)
insert into PartMaster values(3,'Engine',67000,2,4000)
insert into PartMaster values(4,'Tyres',2400,3,5000)
insert into PartMaster values(5,'Tubes',700,3,7800)
go

insert into PartMaster values(6,'Screws',12,2,200)
insert into PartMaster values(7,'Mirrors',450,2,3450)
go

--SupplyDetails
create table SupplyDetails
(
	PID				TinyInt		not null Foreign Key references PartMaster(PID), 
	SID				Integer		not null Foreign Key references SupplierMaster(SID),
	DATEOFSUPPLY	DateTime	NOT NULL,
	CITY			Varchar(40)	NOT NULL,
	QTYSUPPLIED		Integer		NOT NULL
)
go

--read the data
select * from SupplyDetails
go

--insert tha data
insert into SupplyDetails values (2,30,'2019/4/21','Pune',45)
insert into SupplyDetails values (3,10,'2019/5/23','mumbai',25)
insert into SupplyDetails values (1,40,'2019/5/27','Kolkata',120)
insert into SupplyDetails values (5,50,'2019/6/29','Pune',45)
go
insert into SupplyDetails values (6,30,'2019/7/9','Sagali',100)
insert into SupplyDetails values (7,20,'2019/7/10','Delhi',30)
go 
insert into SupplyDetails values (3,10,'2019/7/9','Sagali',2)
insert into SupplyDetails values (7,20,'2019/7/10','Delhi',3)
go
insert into SupplyDetails values (1,40,'2023/3/9','bangalore',100)
insert into SupplyDetails values (2,60,'2023/10/10','Punjab',100)
go
insert into SupplyDetails values (1,40,'2020/6/9','Nashik',75)
insert into SupplyDetails values (2,60,'2020/6/10','Nagpur',105)
go

-- 1.	List the month-wise average supply of parts supplied for all parts. Provide the information only if the average is higher than 20.
select month(DATEOFSUPPLY) as SupplyMonth, AVG(QTYSUPPLIED) as avgSupply from SupplyDetails
group by month(DATEOFSUPPLY)
having AVG(QTYSUPPLIED) > 20

-- 2.	List the names of the Suppliers who do not supply part with PID ‘1’.
select NAME from SupplierMaster SM 
join SupplyDetails SD 
on SM.SID = SD.SID 
where SD.PID != 1
order by NAME

--or
select name from SupplierMaster 
where SID not in 
(select SID from SupplyDetails where PID = 1)
order by NAME

--3.	List the part id, name, price and difference between price and average price of all parts.
select P.PID, P.NAME, P.PRICE, s.avgprice, P.PRICE - avg(s.avgprice) over() as priceDifference 
from PartMaster P
inner join (
	select pid , avg(PRICE) as avgprice
	from PartMaster
	group by PID
) s 
on p.PID = s.PID

--SELECT p.PID, p.NAME, p.PRICE,s.AvgPrice, p.PRICE - s.AvgPrice AS PriceDifference
--FROM PartMaster p
--INNER JOIN (
--    SELECT PID, AVG(PRICE) AS AvgPrice
--    FROM PartMaster
--    GROUP BY PID
--) s ON p.PID = s.PID;

--4.	List the names of the suppliers who have supplied at least one part where the quantity supplied is lower than 10.
select SM.NAME, SD.QTYSUPPLIED from SupplierMaster SM
join SupplyDetails SD 
ON SM.SID = SD.SID
where SD.QTYSUPPLIED < 10

--5.	List the names of the suppliers who live in a city where no supply has been made.
select * from SupplierMaster SM 
where CITY not in (select distinct city from SupplyDetails)

--6.	List the names of the parts which have not been supplied in the month of May 2019.
select PID, name from PartMaster where PID 
not in (select PID from SupplyDetails where datepart(month,DATEOFSUPPLY) = 5 and year(DATEOFSUPPLY) = 2019)

--7.	List name and Price category for all parts. Price category has to be displayed as “Cheap” if price is less than 100, 
--     “Medium” if the price is greater than or equal to 100 and less than 500, and “Costly” if the price is greater than or equal to 500.
select NAME, price, 
	CASE
		when PRICE < 100 then 'Cheap'
		when price >= 100 and PRICE < 500 then 'Medium'
		else 'Costly'
	end as PriceCategory
from PartMaster

--8.	List the most recent supply details with information on Product name, price and no. of days elapsed since the latest supply.
select PM.NAME as [Product Name] ,PRICE as [Product price],
DATEDIFF(DAY,SD.DATEOFSUPPLY, GETDATE()) AS DaysSinceLastSupply
from SupplyDetails SD
inner join PartMaster PM
ON SD.PID = PM.PID
where sd.DATEOFSUPPLY = (select max(DATEOFSUPPLY) from SupplyDetails)

select * from SupplyDetails
select * from PartMaster

--9.	List the names of the suppliers who have supplied exactly 100 units of part P1.
select * from SupplierMaster SM
inner join SupplyDetails sd 
on sm.SID = sd.SID
where pid = 1 and QTYSUPPLIED = 100

--10.	List the names of the parts supplied by more than one supplier.
select name 
from PartMaster
where pid in (select pid from SupplyDetails group by pid having count(distinct sid) > 1)

--11.	List the names of the parts whose price is less than the average price of parts.
select NAME from PartMaster PM
where price < (select avg(PRICE) from PartMaster)

SELECT PM.NAME, PM.PRICE, 
(SELECT AVG(PRICE) FROM PartMaster) AS AveragePrice
FROM PartMaster PM
WHERE PM.PRICE < (SELECT AVG(PRICE) FROM PartMaster);

--12.	List the category-wise number of parts; exclude those where the sum of price is > 100 and less than 500. List in the descending order of sum.
select CATEGORY, count(*) as NumOfParts, SUM(PRICE) from PartMaster 
group by CATEGORY
having sum(price) > 100 and sum(PRICE) > 500
order by sum(PRICE) desc --no such records

select CATEGORY, count(*) as NumOfParts, SUM(PRICE) from PartMaster 
group by CATEGORY
having sum(price) > 3000 and sum(PRICE) < 6000
order by sum(PRICE) desc

--13.	List the supplier name, part name and supplied quantity for all supplies made between 1st and 15th of June 2020.
select sm.NAME, pm.NAME, sd.QTYSUPPLIED from SupplyDetails Sd
inner join PartMaster pm on sd.PID = pm.PID
inner join SupplierMaster sm on sd.SID = sm.SID
where sd.DATEOFSUPPLY between '2020-06-01' and '2020-06-15'

--14.	For all products supplied by Supplier S10, List the part name and total quantity.
select pm.NAME, sum(sd.QTYSUPPLIED) from SupplyDetails sd
inner join PartMaster pm
on sd.PID = pm.PID
where sd.SID = 10
group by pm.NAME

-- 15. For the part with the minimum price, List the latest supply details (Supplier Name, Part id, Date of supply, Quantity Supplied).
WITH MinPricePart AS (
    SELECT TOP 1 *
    FROM PartMaster
    ORDER BY PRICE ASC
)
SELECT sm.NAME AS SupplierName, sd.PID, sd.DATEOFSUPPLY, sd.QTYSUPPLIED
FROM SupplyDetails sd
INNER JOIN SupplierMaster sm ON sd.SID = sm.SID
INNER JOIN MinPricePart p ON sd.PID = p.PID
ORDER BY sd.DATEOFSUPPLY DESC;
--or
select SM.NAME AS [Supplier Name], pm.PID as [Part id], sd.DATEOFSUPPLY as [Date of supply], sd.QTYSUPPLIED as [Quantity Supplied]
from SupplierMaster  SM
INNER JOIN SupplyDetails SD ON SM.SID = SD.SID
inner join PartMaster PM on SD.PID = PM.PID
WHERE PM.PID = 
	(SELECT PID FROM PartMaster WHERE PRICE = 
			(SELECT MIN(PRICE) FROM PartMaster))