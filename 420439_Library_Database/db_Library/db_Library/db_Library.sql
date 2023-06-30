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

	declare @sql nvarchar(1000)='
		alter database [db_Library]
		modify file (Name='''+@logical_name+''',newname='''+@new_logical_name+''')
		';

	EXEC(@sql)

	set @sql ='USE [db_Library]
		alter database db_Library SET Single_User With Rollback immediatle;
		User [Tempdb];

		DROP Database db_Library';
	EXEC(@sql);
end
if not exists(select * from sys.databases where name='db_Library')
begin
	create database [db_Library]
	on
	(Name='db_Library_Data',
		Filename='D:\myProjects\Parscoder.com\420439\420439_Library_Database\db_Library_Data.mdf',
		Size=10mb,
		MaxSize=100MB,
		FileGrowth=5mb)
		Log ON
	(Name='db_Library_Log',
		Filename='D:\myProjects\Parscoder.com\420439\420439_Library_Database\db_Library_Log.ldf',
		Size=10mb,
		MaxSize=100MB,
		FileGrowth=5mb)
End


create table dbo.db_Library.Books(
	[Id] int identity(1,1)
)
