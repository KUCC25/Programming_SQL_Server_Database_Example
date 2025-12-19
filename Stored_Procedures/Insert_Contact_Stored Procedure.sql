USE Con;

GO

DROP PROCEDURE IF EXISTS dbo.InsCon;

GO

CREATE PROCEDURE dbo.InsCon
(
 @F				VARCHAR(40),
 @L				VARCHAR(40),
 @D			DATE = NULL,
 @A	BIT,
 @C			INT OUTPUT
)
AS
BEGIN;

SET NOCOUNT ON;

IF NOT EXISTS (SELECT 1 FROM dbo.Con
				WHERE FirstName = @F AND @L = LastName
					AND DateOfBirth = @D)
 BEGIN;
	INSERT INTO dbo.Con (FirstName, LastName, DateOfBirth, AllowContactByPhone)
		VALUES (@F, @L, @D, @A);

	SELECT @ContactId = SCOPE_IDENTITY();
 END;

EXEC dbo.SelectContact @ContactId = @ContactId;

SET NOCOUNT OFF;

END;

GO