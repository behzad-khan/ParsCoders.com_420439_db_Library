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

