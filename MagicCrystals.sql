Create database MagicCrystals
go
use MagicCrystals
go

CREATE TABLE CrystalShops
(Id INT PRIMARY KEY IDENTITY,
Name varchar(150),
City varchar(150),
Address varchar(150),
CrystalStock int)

CREATE TABLE CrystalType
(Id INT PRIMARY KEY IDENTITY,
Size int,
Color varchar(50))

CREATE TABLE Crystals
(Id INT PRIMARY KEY IDENTITY,
Name varchar(150),
Price int,
TypeId int foreign key references CrystalType(Id),
ShopsId int foreign key references CrystalShops(Id))

CREATE TABLE Employees
(Id INT PRIMARY KEY IDENTITY,
Name varchar(150),
Age int,
ShopsId int foreign key references CrystalShops(Id))

CREATE TABLE Customers
(Id INT PRIMARY KEY IDENTITY,
Name varchar(50),
Address varchar(150),
Zipcode varchar(150))

CREATE TABLE SoldProducts
(Customers_Id int foreign key references Customers(Id),
Shops_Id int foreign key references CrystalShops(Id),
constraint PK_Sells PRIMARY KEY(Customers_Id,Shops_Id))

-- Insert data into 4 tables
INSERT into CrystalShops values ('Crystals of Arad', 'Arad', 'Str. Romanei, Nr. 13', 1085)
INSERT INTO CrystalShops values ('Crystals of Cluj', 'Cluj', 'Str. Siretului, Nr. 23', 2083)
INSERT INTO CrystalShops values ('Crystals of Brasov', 'Brasov', 'Str. Libertatii, Nr. 12', 572)
INSERT INTO CrystalShops values ('Crystals of Bucuresti', 'Bucuresti', 'Str. Magnoliei, Nr. 1', 1785)
INSERT INTO CrystalShops values ('Crystals of Timisoara', 'Timisoara', 'Str. Lalelei, Nr. 3', 2135)
SELECT * from CrystalShops

INSERT INTO CrystalType values (30, 'Black')
INSERT INTO CrystalType values (25, 'Red')
INSERT INTO CrystalType values (37, 'Blue')
INSERT INTO CrystalType values (42, 'Orange')
INSERT INTO CrystalType values (12, 'Rose')
SELECT * from CrystalType

INSERT INTO Crystals values ('Amethyst', 30, 1, 1)
INSERT INTO Crystals values ('Ruby', 23, 2, 1)
INSERT INTO Crystals values ('Quartz', 82, 3, 1)
INSERT INTO Crystals values ('Citrine', 152, 4, 2)
SELECT * from Crystals

INSERT INTO Customers values ('Raul Ion', 'Str. Siretului, Nr. 4', '500507')
INSERT INTO Customers values ('Cosmin Bogdan', 'Str. Magnoliei, Nr. 7', '302323') 
INSERT INTO Customers values ('Paul Sebastian', 'Str. Lacurilor, Nr. 18A', '123132')
SELECT * from Customers
-- Update data for at least 1 table
update Crystals 
SET Price = Price-5 
WHERE Price between 40 and 160 and TypeId IS NOT NULL
SELECT * from Crystals



-- Delete data for at least 1 table
DELETE from Crystals 
WHERE name LIKE '%ua%' or Price > 300
SELECT * from Crystals

-- UNION
SELECT  Name, City 
FROM CrystalShops
WHERE Name like '%a%'
union all
SELECT Name, City 
FROM CrystalShops
where ID > 1
--INTERSECT
SELECT  Name, City 
FROM CrystalShops
WHERE Name like '%o%'
intersect
SELECT Name, City 
FROM CrystalShops
where ID > 2
--EXCEPT
SELECT  Name, City 
FROM CrystalShops
WHERE Name like '%o%'
except
SELECT Name, City 
FROM CrystalShops
where Id > 2

--INNER JOIN with 3 tables
--using at least one composed condition with AND, OR, NOT in the WHERE clause (1/2)
SELECT s.Name, c.Name 
FROM CrystalShops s INNER JOIN (Crystals c INNER JOIN CrystalType t on t.Id = c.Id) on s.Id = c.Id 
where c.Price > 15 and c.TypeId IS NOT NULL

--LEFT JOIN
--using at least one composed condition with AND, OR, NOT in the WHERE clause (2/2)
select s.CrystalStock, c.Price
FROM CrystalShops s LEFT JOIN Crystals c on s.Id = c.Id 
where s.CrystalStock > 10 or c.Price > 0

--RIGHT JOIN
select s.Address , c.Price
FROM CrystalShops s RIGHT JOIN Crystals c on s.Id = c.Id 
where s.Address IS NOT NULL

--FULL JOIN
select s.Address, s.City, c.Name
FROM CrystalShops s FULL JOIN Crystals c on s.Id = c.Id
where c.Name LIKE '%y%'

--Query using IN to introduce a subquery in the WHERE clause using DISTINCT
select distinct s.Address, s.City, s.Id
FROM CrystalShops s
where s.Address IS NOT NULL and s.Id in (select c.Id from Crystals c)
--Query using EXISTS to introduce a subquery in the WHERE clause using TOP and ORDER BY(1/2)
select top 3 s.Address, s.City, s.Id
FROM CrystalShops s
where s.City IS NOT NULL and EXISTS (select c.Id from Crystals c where c.Id = s.Id)
order by s.City
--Query with a subquery in the FROM clause using ORDER BY(2/2)
select s.Id, s.Name
FROM (select c.Name, c.Price, c.Id from Crystals c INNER JOIN CrystalShops s on c.Id = s.Id) s
order by s.Name
--Query with GROUP BY clause using HAVING clause(1/2)
select s.CrystalStock, SUM(c.Price)
from CrystalShops s INNER JOIN Crystals c on c.Id = s.Id
group by s.CrystalStock 
having SUM(c.Price)>20
--Query with GROUP BY clause using HAVING clause(2/2)
select c.Price , AVG(s.CrystalStock)
from CrystalShops s INNER JOIN Crystals c on c.Id = s.Id
group by c.Price
having AVG(s.CrystalStock)>0
--Query with GROUP BY clause
select t.Color, MAX(c.Price)
from Crystals c INNER JOIN CrystalType t on t.Id = c.Id
group by t.Color
having MAX(c.Price)>25


drop database MagicCrystals

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

-- Add a column
create procedure proc_AddColumn
AS 
alter table Customers
add PhoneNumber varchar(10)
PRINT 'PhoneNumber column added'
GO

exec proc_AddColumn
select * from Customers

-- Remove a column
create procedure proc_RemoveColumn
AS
alter table Customers
drop column PhoneNumber
PRINT 'PhoneNumber column removed'
GO
exec proc_RemoveColumn
select * from Customers

--add DEFAULT constraint
create procedure proc_AddConstraint
AS
alter table Customers
add constraint def_1 DEFAULT 300300 for Zipcode
PRINT 'Constraint def_1 added'
GO
exec proc_AddConstraint

--remove DEFAULT constraint
create procedure proc_RemoveConstraint
AS
alter table Customers
drop constraint def_1
PRINT 'Constraint def_1 removed'
GO
exec proc_RemoveConstraint

--create table
create procedure proc_CreateTable
AS
create table Directors (
Id INT PRIMARY KEY,
Name varchar(50),
Age INT)
PRINT 'Table Directors Created'
GO
exec proc_CreateTable
select * from Directors

--drop table 
create procedure proc_DropTable
AS
drop table Directors 
PRINT 'Table Directors Removed'
GO
exec proc_DropTable

--add foreign key
create procedure proc_AddForeignKey
AS 
alter table Directors
ADD CONSTRAINT fk_key FOREIGN KEY(Id) REFERENCES CrystalShops(Id)
PRINT 'ForeignKey added'
GO
exec proc_AddForeignKey

--remove foreign key
create procedure proc_RemoveForeignKey
AS
alter table Directors
DROP CONSTRAINT fk_key
PRINT 'ForeignKey removed'
GO
exec proc_RemoveForeignKey
 

create table DBVersion(
versionNo INT)

create procedure UpdateDBVersion(@update_version INT)
AS
delete from DBVersion
insert into DBVersion(versionNo) values(@update_version)
GO

--create procedure main to change the version
create procedure main(@version INT)
AS
	if(@version<0)
	begin
		RAISERROR('the version given if out of range', 16, 1)
		return -1
	end

	if(@version>4)
	begin
		RAISERROR('the version given if out of range', 16, 1)
		return -1
	end
	if(ISNUMERIC(@version)=0)
	begin
		RAISERROR('the version given should be an int', 16, 1)
		return -1
	end

	--we add the procedures to a table, we create a variable to hold the current version and we declare a cursor to loop through the table of procedures
	declare @proc_result table(proc_name varchar(30))
		insert into @proc_result select name from sys.objects where type like 'P' and (name like 'pro%')
	declare cursor_procedures cursor for 
		select proc_name from @proc_result
	declare @current int
	set @current = (select versionNo from DBVersion)

	print('Current version: ')
	print(@current)
	--if we don't have to do anything
	if (@current = @version)
	begin
	print('The given version in already applied!')
	return -1
	end

	declare @procedure_name varchar(30)

	--if we have to apply some procedures
	if (@current < @version)
	begin
		declare @i int
		set @i = 1
		open cursor_procedures
		while @i <= @current
		begin
			set @i = @i+1
			fetch next from cursor_procedures into @procedure_name
		end
		while @i<= @version
		begin
			set @i = @i+1
			fetch next from cursor_procedures into @procedure_name
			exec @procedure_name
		end
		close cursor_procedures
	end

	--if we have to undo some procedures
	if (@current > @version)
	begin
		declare cursor_undo_procedures cursor for
		select proc_name from @proc_result
		open cursor_undo_procedures
		declare @j int
		set @j = 0
		declare @offset int
		set @offset= 8-@current
		while @j < @offset
		begin 
			set @j = @j+1
			fetch next from cursor_undo_procedures into @procedure_name
		end
		while @current > @version
		begin
			fetch next from cursor2_procedures into @procedure_name
			exec @procedure_name
			set @current = @current-1
		end
		close cursor2_procedures
	end
	exec UpdateDBVersion @version 
go
exec main 1
exec main 2
exec main 3
exec main 4
exec main 4
exec main 3
exec main 2
exec main 1
exec main 0
exec main 5
exec main 'test'
