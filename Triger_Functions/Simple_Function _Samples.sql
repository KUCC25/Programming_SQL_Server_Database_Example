SELECT MONTH(GETDATE()) AS [MONTH], YEAR(GETDATE()) AS [YEAR];
GO


CREATE OR ALTER FUNCTION dbo.SuperAdd_scaler(@a INT, @b INT)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	RETURN @a + @b;
END;
GO

select dbo.SuperAdd_scaler(2,2);
GO

select dbo.SuperAdd_scaler('a',3);
GO

CREATE OR ALTER FUNCTION dbo.FiscalYearEnding(@SaleDate DATETIME, @FiscalEndMonth INT = 6)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @saleMonth INT = MONTH(@SaleDate);
	DECLARE @saleYear INT = YEAR(@SaleDate);
	DECLARE @fiscalYear INT = @saleYear;

	IF(@saleMonth > @FiscalEndMonth AND @FiscalEndMonth != 1) 
	BEGIN
		SET @fiscalYear = @saleYear + 1;
	END;

	RETURN @fiscalYear;
END;
GO

SELECT '2019-01-01' SampleDate, dbo.FiscalYearEnding('2019-01-01',1) FiscalYear; -- 2019
SELECT '2019-07-01' SampleDate, dbo.FiscalYearEnding('2019-07-01',6) FiscalYear; -- 2020
SELECT '2019-07-01' SampleDate, dbo.FiscalYearEnding('2019-07-01',7) FiscalYear; -- 2019
SELECT '2019-12-01' SampleDate, dbo.FiscalYearEnding('2019-05-01',4) FiscalYear; -- 2020
SELECT '2019-12-01' SampleDate, dbo.FiscalYearEnding('2019-12-01',12) FiscalYear; -- 2019

SELECT TOP 100 OrderId, OrderDate, dbo.FiscalYearEnding(OrderDate, DEFAULT) as FiscalSaleYear from Sales.Orders
 WHERE OrderDate > '2013-06-28'
GO

SELECT TOP 100 OrderId, OrderDate, dbo.FiscalYearEnding(OrderDate, DEFAULT) as FiscalSaleYear from Sales.Orders
 WHERE YEAR(OrderDate) > 2015
GO

SELECT TOP 100 OrderId, OrderDate, dbo.FiscalYearEnding(OrderDate, DEFAULT) as FiscalSaleYear from Sales.Orders
 WHERE dbo.FiscalYearEnding(OrderDate,DEFAULT) > 2015
GO



