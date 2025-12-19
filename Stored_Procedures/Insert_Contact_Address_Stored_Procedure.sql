USE Con;

DROP PROCEDURE IF EXISTS dbo.InsConAdd;

GO

CREATE PROCEDURE dbo.InsConAdd
(
 @ConId		INT,
 @HouNum	VARCHAR(200),
 @Str		VARCHAR(200),
 @Cit			VARCHAR(200),
 @Pos		VARCHAR(20)
)
AS
BEGIN;

SET NOCOUNT ON;

DECLARE @AddId	INT;

SELECT @Str = UPPER(LEFT(@Str, 1)) + LOWER(RIGHT(@Str, LEN(@Str) -1));
SELECT @Cit = UPPER(LEFT(@Cit, 1)) + LOWER(RIGHT(@Cit, LEN(@Cit) - 1));

INSERT INTO dbo.ConAdd (ContactId, HouseNumber, Street, City, Postcode)
	VALUES (@ConId, @HouNum, @Str, @Cit, @Pos);

SELECT @AddId = SCOPE_IDENTITY();

SELECT ContactId, AddressId, HouseNumber, Street, City, Postcode
	FROM dbo.ConAdd
WHERE ContactId = @ConId;

SET NOCOUNT OFF;

END;

EXEC dbo.InsConAdd
	@ConId = 24,
	@HouNum = '10',
	@Str = 'Downing Street',
	@Cit = 'London',
	@Pos = 'SW1 2AA';