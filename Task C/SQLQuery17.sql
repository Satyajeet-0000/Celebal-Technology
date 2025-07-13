--level task C
--task 17

-- Step 1: Create Login
CREATE LOGIN Task
WITH PASSWORD = 'StrongPassword123';
GO

-- Step 2: Create User
USE AdventureWorks2014;
GO

CREATE USER Work
FOR LOGIN Task;
GO

-- Step 3: Grant DB_OWNER Permission
USE AdventureWorks2014;
GO

ALTER ROLE db_owner ADD MEMBER Work;
GO