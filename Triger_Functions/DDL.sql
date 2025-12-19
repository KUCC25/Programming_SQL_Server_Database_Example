Use WideWorldImporters-Pluralsight;
GO

CREATE OR ALTER TRIGGER TDB_PreventTableDropOrAlter
ON DATABASE
FOR DROP_TABLE,ALTER_TABLE
AS
BEGIN
 PRINT 'DROP and ALTER table events are not allowed. Disable trigger TDB_PreventTableDropOrAlter to complete action.'
 ROLLBACK
END

DROP TABLE Application.AuditLog;

ALTER TABLE Application.People ADD TwitterHandle nvarchar(100);

DISABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;

ALTER TABLE Application.People ADD TwitterHandle nvarchar(100);

ENABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;
GO

CREATE TABLE Application.AuditLogDDL
( 
 Id INT IDENTITY,  
 EventTime DATETIME,
 EventType NVARCHAR(100),
 LoginName NVARCHAR(100),
 Command NVARCHAR(MAX) 
)
GO

CREATE TRIGGER AuditLogDDLEvents
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
 SET NOCOUNT ON
 DECLARE @EventData XML = EVENTDATA()
 INSERT INTO Application.AuditLogDDL(EventTime,EventType,LoginName,Command) 
 SELECT @EventData.value('(/EVENT_INSTANCE/PostTime)[1]', 'DATETIME'),
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(100)'),
	    @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'VARCHAR(100)'),
		@EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')
END

ALTER TABLE Application.People ADD InstagramHandle nvarchar(100);

SELECT * FROM Application.AuditLogDDL;

DISABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;

ALTER TABLE Application.People ADD InstagramHandle nvarchar(100);

SELECT * FROM Application.AuditLogDDL;

ENABLE TRIGGER TDB_PreventTableDropOrAlter ON DATABASE;
GO