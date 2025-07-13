--level task c 
--task 7



-- Function to check if a number is prime
CREATE FUNCTION dbo.IsPrime(@num INT) RETURNS BIT AS
BEGIN
    DECLARE @i INT, @isPrime BIT;
    SET @isPrime = 1;

    IF @num <= 1
        SET @isPrime = 0;
    ELSE IF @num = 2
        SET @isPrime = 1;
    ELSE IF @num % 2 = 0
        SET @isPrime = 0;
    ELSE
    BEGIN
        SET @i = 3;
        WHILE @i * @i <= @num AND @isPrime = 1
        BEGIN
            IF @num % @i = 0
                SET @isPrime = 0;
            SET @i = @i + 2;
        END
    END
    RETURN @isPrime;
END;
GO

-- Generate prime numbers and concatenate them
WITH Numbers AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS num
    FROM master..spt_values s1, master..spt_values s2
),
PrimeNumbers AS (
    SELECT num
    FROM Numbers
    WHERE dbo.IsPrime(num) = 1
)
SELECT STRING_AGG(CAST(num AS VARCHAR), '&  ') AS PrimeNumbers
FROM PrimeNumbers;
GO