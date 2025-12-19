USE Con;

DROP PROCEDURE IF EXISTS dbo.InsConRo;

GO

CREATE PROCEDURE dbo.InsConRo
(
 @ConId	INT,
 @RoTit	VARCHAR(200)
)
AS
BEGIN;

DECLARE @RoleId		INT;
		
BEGIN TRY;

BEGIN TRANSACTION;

	IF NOT EXISTS(SELECT 1 FROM dbo.Rol WHERE RoleTitle = @RoTit)
	 BEGIN;
		INSERT INTO dbo.Rol (RoleTitle)
			VALUES (@RoTit);
	 END;

	SELECT @RoleId = RoleId FROM dbo.Rol WHERE RoleTitle = @RoTit;

	IF NOT EXISTS(SELECT 1 FROM dbo.C WHERE ContactId = @ConId AND RoleId = @RoleId)
	 BEGIN;
		INSERT INTO dbo.C (ContactId, RoleId)
			VALUES (@ConId, @RoleId);
	 END;

COMMIT TRANSACTION;
	
SELECT	C.ContactId, C.FirstName, C.LastName, R.RoleTitle
	FROM dbo.Contacts C
		INNER JOIN dbo.C CR
			ON C.ContactId = CR.ContactId
		INNER JOIN dbo.Rol R
			ON CR.RoleId = R.RoleId
WHERE C.ContactId = @ConId;

END TRY
BEGIN CATCH;
	IF (@@TRANCOUNT > 0)
	 BEGIN;
		ROLLBACK TRANSACTION;
	 END;
	PRINT 'Error occurred in ' + ERROR_PROCEDURE() + ' ' + ERROR_MESSAGE();
	RETURN -1;
END CATCH;

RETURN 0;

END;

DECLARE @RetVal INT;

EXEC @RetVal = dbo.InsConRo 
	@ConId = 22,
	@RoTit = 'Actor';

PRINT 'RetVal = ' + CONVERT(VARCHAR(10), @RetVal);