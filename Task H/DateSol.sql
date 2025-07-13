IF OBJECT_ID('dbo.DateAttributes', 'U') IS NOT NULL
    DROP TABLE dbo.DateAttributes;
GO

CREATE TABLE dbo.DateAttributes (
    SKDateKey INT NOT NULL,
    Date DATE NOT NULL PRIMARY KEY,
    DateCalendar DATE NOT NULL,
    CalendarDay INT NOT NULL,
    CalendarMonth INT NOT NULL,
    CalendarQuarter INT NOT NULL,
    CalendarYear INT NOT NULL,
    DayNameLong NVARCHAR(20) NOT NULL,
    DayNameShort NVARCHAR(3) NOT NULL,
    DayNumberOfWeek INT NOT NULL,
    DayNumberOfYear INT NOT NULL,
    DaySuffix NVARCHAR(2) NOT NULL,
    FiscalWeek INT NULL,
    FiscalPeriod INT NULL,
    FiscalQuarter INT NULL,
    FiscalYear INT NULL,
    FiscalYearPeriod NVARCHAR(7) NULL
);
GO

IF OBJECT_ID('dbo.PopulateDateAttributes', 'P') IS NOT NULL
    DROP PROCEDURE dbo.PopulateDateAttributes;
GO

CREATE PROCEDURE dbo.PopulateDateAttributes
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartOfYear DATE = DATEFROMPARTS(YEAR(@InputDate), 1, 1);
    DECLARE @EndOfYear DATE = DATEFROMPARTS(YEAR(@InputDate), 12, 31);
    DECLARE @TargetYear INT = YEAR(@InputDate);

    DELETE FROM dbo.DateAttributes
    WHERE CalendarYear = @TargetYear;

    -- The CTE (DateSeries) is now defined directly before the INSERT...SELECT statement.
    ;WITH DateSeries AS (
        SELECT @StartOfYear AS DateValue
        UNION ALL
        SELECT DATEADD(day, 1, DateValue)
        FROM DateSeries
        WHERE DateValue < @EndOfYear
    )
    INSERT INTO dbo.DateAttributes (
        SKDateKey,
        Date,
        DateCalendar,
        CalendarDay,
        CalendarMonth,
        CalendarQuarter,
        CalendarYear,
        DayNameLong,
        DayNameShort,
        DayNumberOfWeek,
        DayNumberOfYear,
        DaySuffix,
        FiscalWeek,
        FiscalPeriod,
        FiscalQuarter,
        FiscalYear,
        FiscalYearPeriod
    )
    SELECT
        CONVERT(INT, CONVERT(VARCHAR(8), ds.DateValue, 112)) AS SKDateKey,
        ds.DateValue AS Date,
        ds.DateValue AS DateCalendar,
        DAY(ds.DateValue) AS CalendarDay,
        MONTH(ds.DateValue) AS CalendarMonth,
        DATEPART(qq, ds.DateValue) AS CalendarQuarter,
        YEAR(ds.DateValue) AS CalendarYear,
        DATENAME(dw, ds.DateValue) AS DayNameLong,
        LEFT(DATENAME(dw, ds.DateValue), 3) AS DayNameShort,
        DATEPART(weekday, ds.DateValue) AS DayNumberOfWeek,
        DATEPART(dy, ds.DateValue) AS DayNumberOfYear,
        CASE
            WHEN DAY(ds.DateValue) IN (11, 12, 13) THEN 'th'
            WHEN RIGHT(DAY(ds.DateValue), 1) = '1' THEN 'st'
            WHEN RIGHT(DAY(ds.DateValue), 1) = '2' THEN 'nd'
            WHEN RIGHT(DAY(ds.DateValue), 1) = '3' THEN 'rd'
            ELSE 'th'
        END AS DaySuffix,
        NULL AS FiscalWeek,
        NULL AS FiscalPeriod,
        NULL AS FiscalQuarter,
        NULL AS FiscalYear,
        NULL AS FiscalYearPeriod
    FROM DateSeries AS ds -- Referencing the CTE directly
    OPTION (MAXRECURSION 366);

END;
GO