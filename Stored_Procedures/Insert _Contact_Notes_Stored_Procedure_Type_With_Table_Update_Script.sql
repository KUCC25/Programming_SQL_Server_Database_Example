USE Cont;

DROP PROCEDURE IF EXISTS dbo.InsConNo;

GO

CREATE PROCEDURE dbo.InsConNo
(
 @ConId		INT,
 @No			ConNo READONLY
)
AS
BEGIN;

DECLARE @TemNot ConNo;

INSERT INTO @TemNot (Note)
SELECT Note FROM @No;

UPDATE @TemNot SET Note = 'Pre: ' + Note;

INSERT INTO dbo.ConNot (ContactId, Notes)
	SELECT @ConId, Note
		FROM @No;

SELECT * FROM dbo.ConNot
	WHERE ContactId = @ConId
ORDER BY NoteId DESC;

END;

DECLARE @TemNot	ConNo;

INSERT INTO @TemNot (Note)
VALUES
('Hi, Peter called.'),
('Quick note to let you know Jo wants you to ring her. She rang at 14:30.'),
('Terri asked about the quote, I have asked her to ring back tomorrow.');

EXEC dbo.InsConNo
	@ConId = 23,
	@No = @TemNot;
