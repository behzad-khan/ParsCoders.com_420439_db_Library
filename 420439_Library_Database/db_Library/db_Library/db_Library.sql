if Exists(select * from sys.databases where name='db_Library')
begin	
	DECLARE @logical_name varchar(100),@new_logical_name varchar(100)

	SELECT @logical_name=f.name 
	FROM sys.master_files f
	INNER JOIN sys.databases d ON d.database_id = f.database_id
	where  d.name='db_Library' and f.type_desc='ROWS'

	if right(@logical_name,1)='1' 
	begin
		set @new_logical_name = left(@logical_name,len(@logical_name)-1);
	end
	else
	begin
		set @new_logical_name=@logical_name+'1';
	end

	DECLARE @DatabaseName nvarchar(50)= N'db_Library'
	DECLARE @SQL nvarchar(max)

	SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
	FROM MASTER..SysProcesses
	WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId

	--SELECT @SQL 
	EXEC(@SQL)
	
	set @sql ='
		use master;
		alter database [db_Library]
		modify file (Name='''+@logical_name+''',newname='''+@new_logical_name+''')
		';

	EXEC(@sql)
	--alter database db_library set online
	set @sql ='USE [master];
		alter database db_Library SET Single_User With Rollback immediate;
		Use [Tempdb];

		DROP Database db_Library';
	EXEC(@sql);
end

if not exists(select * from sys.databases where name='db_Library')
begin

	-- this turns on advanced options and is needed to configure xp_cmdshell
	EXEC sp_configure 'show advanced options', '1'
	RECONFIGURE
	-- this enables xp_cmdshell
	EXEC sp_configure 'xp_cmdshell', '1' 
	RECONFIGURE


	DECLARE @cmd NVARCHAR(MAX) = 
		'xp_cmdshell ''del "D:\myProjects\ParsCoder.com\420439\ParsCoders.com_420439_db_Library\420439_Library_Database\db_Library_Data.mdf"''';

	DECLARE @iFileExists INT

	EXEC master..xp_fileexist 'D:\myProjects\ParsCoder.com\420439\ParsCoders.com_420439_db_Library\420439_Library_Database\db_Library_Data.mdf', 
	 @iFileExists OUTPUT
	-- print @iFileExists
	if( @iFileExists=1)
	begin
		EXEC (@cmd)
	end
	EXEC master..xp_fileexist 'D:\myProjects\ParsCoder.com\420439\ParsCoders.com_420439_db_Library\420439_Library_Database\db_Library_Data.ldf', 
	 @iFileExists OUTPUT

	if( @iFileExists=1)
	begin
		set @cmd  = 
			'xp_cmdshell ''del "D:\myProjects\ParsCoder.com\420439\ParsCoders.com_420439_db_Library\420439_Library_Database\db_Library_Log.ldf"''';
		EXEC (@cmd)
	end

	create database [db_Library]
	on
	(Name='db_Library_Data',
		Filename='D:\myProjects\ParsCoder.com\420439\ParsCoders.com_420439_db_Library\420439_Library_Database\db_Library_Data.mdf',
		Size=10mb,
		MaxSize=100MB,
		FileGrowth=5mb)
		Log ON
	(Name='db_Library_Log',
		Filename='D:\myProjects\ParsCoder.com\420439\ParsCoders.com_420439_db_Library\420439_Library_Database\db_Library_Log.ldf',
		Size=10mb,
		MaxSize=100MB,
		FileGrowth=5mb)
End

--use [db_library]

--declare @cmd varchar(4000)
declare cmds cursor for
select 'drop table ['+table_name+']' 
from INFORMATION_SCHEMA.TABLES 
where TABLE_CATALOG='db_Library' and TABLE_NAME in ('Books','BookCopies', 'Publishers', 'Authers', 'AutherBookCopies',
                     'Category','BookCategories', 'People','Users', 'Staffs', 'Readers',
					 'ReserveBookCopiess', 'BorrowBookCopies', 'StaffHoldBookCopies', 'BookCount', 'BookCopyLogs' )

open cmds
while 1=1
BEGIN
	fetch cmds into @cmd
	if @@FETCH_STATUS!=0 BREAK
	EXEC(@cmd)
END
close cmds;
deallocate cmds;

create table db_Library.dbo.Categories(
	[CategoryId] int not null identity(1,1),
	[Title] nvarchar(150) not null,
	Constraint PK_Categories Primary Key ([CategoryId])
)

create table db_Library.dbo.Books(
	[BookId] int not null identity(1,1),
	[CategoryId] int null Constraint [FK_Books_Categories] Foreign Key References [dbo].[Categories]([CategoryId]),
	[Title] nvarchar(200) not null,
	primary key ([BookId])
);

create table db_Library.dbo.BookCategoreis(
	[BookId] int not null constraint [FK_BookCategories_Books] Foreign Key References [dbo].[Books]([BookId]),
	[CategoryId] int not null constraint [FK_BookCategories_Categories] Foreign Key References [dbo].[Categories]([CategoryId]),
	Constraint PK_BookCategories Primary Key ([BookId],[CategoryId])
)

create table db_Library.dbo.Publishers(
	[PublisherId] int not null identity(1,1),
	[Name] nvarchar(150) not null,
	[Address] nvarchar(2000)null,
	Constraint [PK_Publishers] Primary KEY([PublisherId])
)

create table db_Library.dbo.BookCopies(
	[ISBN] varchar(100) not null,
	[BookId] int not null constraint [FK_BookCopies_Books] Foreign Key References [dbo].[Books]([BookId]),
	[PublisherId] int not null constraint [FK_BookCopies_PublisherId] Foreign Key References [dbo].[Publishers]([PublisherId]),
	[PublishDate] datetime null,
	[EditedVersion] int null,
	[Price] decimal null,
	Constraint [PK_BookCopies] Primary KEY ([ISBN])
)

create table db_Library.dbo.People(
	[PersonId] int not null identity(1,1),
	[Name] nvarchar(150) not null,
	[Family] nvarchar (150) not null,
	[PhoneNo] varchar(20) null,
	[Email] varchar(150) null,
	[Address] nvarchar(2000) null,
	constraint PK_People Primary KEY ([PersonId])
)

create table db_Library.dbo.Authers(
	[AutherId] int unique not null constraint [FK_Authers_People] Foreign key References [dbo].[People](PersonId),

)

create table db_Library.dbo.Staffs(
	[StaffId] int unique not null constraint [FK_Staffs_People] Foreign Key References [dbo].[People]([PersonId]),
)

create table db_Library.dbo.Readers(
	[ReaderId] int unique not null constraint [FK_Readers_People] Foreign Key References [dbo].[People]([PersonId])
)

create table db_Library.dbo.Users(
	[ReaderId] int unique not null constraint [FK_Users_People] Foreign Key References [dbo].[People]([PersonId])
)

create table db_Library.dbo.BorrowBookCopies(
	[BorrowId] int not null identity(1,1),
	[ISBN] varchar(100) not null Constraint [FK_BorrowBookCopies_BookCopies] Foreign Key References [dbo].[BookCopies]([ISBN]),
	[StaffId] int not null constraint [FK_BorrowBookCopies_Staffs] foreign key References [dbo].[Staffs]([StaffId]),
	[ReaderId] int not null constraint [FK_BorrowBookCopies_Readers] foreign key References [dbo].[Readers]([ReaderId]),
	[BorrowedDateTime] Datetime not null,
	[DeadlineDateTime] datetime null,
	[ReturnDateTime]datetime null,
	Constraint [PK_BorrowBookCopies] Primary Key ([BorrowId])
)

create table db_Library.dbo.ReserveBookCopies(
	[ReserveId] int not null Identity(1,1),
	[ISBN] varchar(100) not null Constraint [FK_ReserveBookCopies_BookCopies] Foreign Key References [dbo].[BookCopies]([ISBN]),
	[StaffId] int not null constraint [FK_ReserveBookCopies_Staffs] foreign key References [dbo].[Staffs]([StaffId]),
	[ReaderId] int not null constraint [FK_ReserveBookCopies_Readers] foreign key References [dbo].[Readers]([ReaderId]),
	[ReserveDateTime] datetime not null,
	[BorrowId] int null constraint [FK_ReserveBookCopies_BorrowBookCopies] foreign key References [dbo].[BorrowBookCopies]([BorrowId]),
	Constraint [PK_ReserveBookCopies] Primary Key ([ReserveId])
)

create table db_Library.dbo.StaffHoldBookCopies(
	[StaffId] int not null constraint [FK_StaffHoldBookCopies_Staffs] Foreign Key References [dbo].[Staffs]([StaffId]),
	[ISBN] varchar(100) not null Constraint [FK_StafffHoldBookCopies_BookCopies] Foreign Key references [dbo].[BookCopies]([ISBN]),
	Constraint [PK_StaffHoldBookCopies] Primary Key ([StaffId],[ISBN])
)

create table db_Library.dbo.AutherBookCopies(
	[AutherId] int not null Constraint [FK_AutherBookCopies_Authers] Foreign Key References [dbo].[Authers]([AutherId]),
	[ISBN] varchar(100) not null Constraint [FK_AutherBookCopies_BookCopies] Foreign Key References [dbo].[BookCopies]([ISBN]),
	[OrderNumber] int null,
	Constraint [PK_AutherBookCopies] Primary Key ([AutherId], [ISBN])
)

Create Table db_Library.dbo.BookCount(
	[Count] int null
)

Create Table db_Library.dbo.BookCopyLogs(
	[ISBN] varchar(100) not null,
	[BookId] int not null constraint [FK_BookCopyLogs_Books] Foreign Key References [dbo].[Books]([BookId]),
	[PublisherId] int not null constraint [FK_BookCopyLogs_PublisherId] Foreign Key References [dbo].[Publishers]([PublisherId]),
	[PublishDate] datetime null,
	[Price] decimal null,
	[DeletedStaffId] int not null constraint [FK_BookCopyLogs_Staffs] Foreign Key References [dbo].[Staffs]([StaffId]),
	[DeletedDateTime] datetime not null,
	Constraint [PK_BookCopyLogs] Primary KEY ([ISBN])
)