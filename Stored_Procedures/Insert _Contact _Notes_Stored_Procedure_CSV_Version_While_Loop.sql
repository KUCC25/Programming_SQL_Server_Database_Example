USE Con;

IF EXISTS(SELECT 1 FROM sys.procedures WHERE [name] = 'InsConNo')
 BEGIN;
	DROP PROCEDURE dbo.InsConNo;
 END;

GO

CREATE PROCEDURE dbo.InsConNo
(
 @ConId		INT,
 @No			VARCHAR(MAX)
)
AS
BEGIN;

DECLARE @NoteTable	TABLE (Note	VARCHAR(MAX));
DECLARE @NoteValue	VARCHAR(MAX);

INSERT INTO @NoteTable (Note)
SELECT value
	FROM STRING_SPLIT(@Notes, ',');

WHILE ((SELECT COUNT(*) FROM @NoteTable) > 0)
 BEGIN;

	SELECT TOP 1 @NoteValue = Note FROM @NoteTable;

	INSERT INTO dbo.ContactNotes (ContactId, Notes)
		VALUES (@ContactId, @NoteValue);

	DELETE FROM @NoteTable WHERE Note = @NoteValue;

 END;

SELECT * FROM dbo.ConNo
	WHERE ContactId = @ContactId
ORDER BY NoteId DESC;

END;
