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


exec RemoveForeignKey
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
ADD CONSTRAINT fk_key FOREIGN KEY(Id) REFERENCES Crystals(Id)
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
proc_RemoveForeginKey
 

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
RAISEERROR('the version given if out of range', 16, 1)
return -1
end

if(@version>5)
begin
RAISEERROR('the version given if out of range', 16, 1)
return -1
end
if(ISNUMERIC(@version)=0)
begin
RAISEERROR('the version given should be an int', 16, 1)
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
				fetch next from cursor_unde_procedures into @procedure_name
			end
		while @current > @version
		begin
			fetch next from cursor2_procedures into @procedure_name
			exec @procedure_name
			set @current = @current-1
		end
	close cursor2_procedures
	end
	exec updateDBUpdateDBVersion @version 
go