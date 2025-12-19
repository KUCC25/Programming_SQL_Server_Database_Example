USE master;  
GO

CREATE LOGIN login_test WITH PASSWORD = 'abc123!'; 
GO  

GRANT VIEW SERVER STATE TO login_test;  
GO  

CREATE OR ALTER TRIGGER LimitConnectionsForUser  
ON ALL SERVER  
FOR LOGON  
AS  
BEGIN  
IF ORIGINAL_LOGIN()= 'login_test' AND  
    (SELECT COUNT(*) FROM sys.dm_exec_sessions  
            WHERE is_user_process = 1 AND  
                original_login_name = 'login_test') > 2
    ROLLBACK;  
END;  

CREATE DATABASE AuditLogDB;
GO

USE AuditLogDB;
GO

CREATE TABLE LogonEventData
(
    LogonTime datetime,
    SPID int,
    HostName nvarchar(50),
	AppName nvarchar(100),
    LoginName nvarchar(50),
    ClientHost nvarchar(50)
);
GO

CREATE OR ALTER TRIGGER SuccessfulLogonAudit
ON ALL SERVER WITH EXECUTE AS 'RYANB-DEV\Ryan' 
FOR LOGON
AS
BEGIN
    DECLARE @LogonTriggerData xml,
        @EventTime datetime,
        @SPID int,
		@LoginName nvarchar(50),
        @ClientHost nvarchar(50),
        @LoginType nvarchar(50),
        @HostName nvarchar(50),
        @AppName nvarchar(100);
     
    SET @LogonTriggerData = EventData();
     
    SET @EventTime = @LogonTriggerData.value('(/EVENT_INSTANCE/PostTime)[1]', 'datetime');
	SET @SPID = @LogonTriggerData.value('(/EVENT_INSTANCE/SPID)[1]', 'int');
    SET @LoginName = @LogonTriggerData.value('(/EVENT_INSTANCE/LoginName)[1]', 'nvarchar(50)');
    SET @ClientHost = @LogonTriggerData.value('(/EVENT_INSTANCE/ClientHost)[1]', 'nvarchar(50)');
    SET @HostName = HOST_NAME();
    SET @AppName = APP_NAME();
     
    INSERT INTO AuditLogDB.dbo.LogonEventData
    ( 
		LogonTime, SPID, HostName, AppName, LoginName, ClientHost
    )
    VALUES
    (
		@EventTime,	@SPID, @HostName, @AppName, @LoginName, @ClientHost
    )
END
GO

SELECT * FROM AuditLogDB.dbo.LogonEventData
ORDER BY LogonTime DESC;

sp_settriggerorder @triggername = 'SuccessfulLogonAudit', @order = 'first', 
	@stmttype = 'LOGON', @namespace = 'SERVER';
GO

sp_settriggerorder @triggername = 'LimitConnectionsForUser', @order = 'last', 
	@stmttype = 'LOGON', @namespace = 'SERVER';
GO








DROP TRIGGER LimitConnectionsForUser ON ALL SERVER;
DROP TRIGGER SuccessfulLogonAudit ON ALL SERVER;

DROP DATABASE AuditLogDB;

DROP LOGIN login_test;