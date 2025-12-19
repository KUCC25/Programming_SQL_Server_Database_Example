USE Con;

DROP PROCEDURE IF EXISTS dbo.InsConNo;

GO

CREATE PROCEDURE dbo.InsConNo
(
 @ConId		INT,
 @No			VARCHAR(MAX)
)
AS
BEGIN;

DECLARE @NoTab	TABLE (Note	VARCHAR(MAX));
DECLARE @NoVal	VARCHAR(MAX);

INSERT INTO @NoTab (Note)
SELECT value
	FROM STRING_SPLIT(@No, ',');

DECLARE NoteCursor CURSOR FOR 
	SELECT Note FROM @NoTab;

OPEN NoteCursor
FETCH NEXT FROM NoteCursor INTO @NoVal;

WHILE @@FETCH_STATUS = 0
 BEGIN;
	INSERT INTO dbo.ConNo (ContactId, Notes)
		VALUES (@ConId, @NoVal);

	FETCH NEXT FROM NoteCursor INTO @NoVal;

 END;

CLOSE NoteCursor;
DEALLOCATE NoteCursor;

SELECT * FROM dbo.ConNo
	WHERE ContactId = @ConId
ORDER BY NoteId DESC;

END;

DECLARE @TempNotes	ContactNote;

INSERT INTO @TempNotes (Note)
VALUES
('Hi, Peter called.'),
('Quick note to let you know Jo wants you to ring her. She rang at 14:30.'),
('Terri asked about the quote, I have asked her to ring back tomorrow.');

EXEC dbo.InsConNo
	@ConId = 23,
	@No = @TempNotes;
