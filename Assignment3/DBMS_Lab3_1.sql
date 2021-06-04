
@@TRANCOUNT

sys.dm_tran_locks

use EuropeanCities


CREATE TABLE LogTable
(
	LogId int Primary Key identity(1,1),
	TableName VARCHAR(50),
	InsertedElement VARCHAR(300),
	LogTime datetime
)


-- create a stored procedure that inserts data in tables that are in a m:n relationship;
-- if one insert fails, all the operations performed by the procedure must be rolled back (grade 3);
CREATE OR ALTER PROCEDURE Transaction1(@cityName varchar(100), @countryName varchar(50), @population int,
											@bookName varchar(100), @author varchar(100), @dateOfPublication varchar(20))
AS
	-- validate the parameters
	-- check whether the @countryName exists in the database, table Country
	IF (NOT EXISTS (
					SELECT *
					FROM Country
					WHERE CountryName = @countryName)
		)
		BEGIN
			RAISERROR('The country does not exist in the Country table', 10, 1)
			RETURN
		END
	-- check whether the @population is a negative number
	IF (@population <= 0)
		BEGIN
			RAISERROR('The population is a negative number or 0', 10, 1)
			RETURN
		END


	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @insertedElem VARCHAR(300)

			INSERT INTO City VALUES (@cityName, @countryName, @population)
			SELECT @insertedElem = @cityName + ' ' + @countryName + ' ' + CAST(@population AS VARCHAR(10))
			INSERT INTO LogTable VALUES ('City', @insertedElem, SYSDATETIME())

			INSERT INTO Book VALUES (@bookName, @author, convert(datetime, @dateOfPublication))
			SELECT @insertedElem = @bookName + ' ' + @author + ' ' + convert(VARCHAR(10), @dateOfPublication)
			INSERT INTO LogTable VALUES ('Book', @insertedElem, SYSDATETIME())

			DECLARE @BookId INT;
			SELECT @BookId = BookId FROM Book WHERE BOOKNAME = @bookName
			INSERT INTO BookReferencesCity VALUES (@BookId, @cityName)
			SELECT @insertedElem = CAST(@BookId AS VARCHAR(50)) + ' ' + CAST(@cityName AS VARCHAR(50))
			INSERT INTO LogTable VALUES ('BookReferencesCity', @insertedElem, SYSDATETIME())

			COMMIT TRANSACTION
	END TRY


	BEGIN CATCH
		PRINT 'ERROR OCCURED! START ROLLING BACK'
		DECLARE @ErrorMessage VARCHAR(1000)
		SELECT @ErrorMessage = ERROR_MESSAGE()
		RAISERROR (@ErrorMessage, 10, 2)

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

	END CATCH



PRINT @@TRANCOUNT

EXEC Transaction1 'Gdansk', 'Poland', 120000, 'The Culture Map', 'Eleanor', '1980-10-09'
EXEC Transaction1 'Linz', 'Austria', 190000, 'The Culture Map', 'Eleanor', '1980-10-09'

SELECT *
FROM LogTable

DELETE FROM LogTable

SELECT *
FROM City

DELETE FROM City WHERE CityName = 'Gdansk'
DELETE FROM City WHERE CityName = 'Linz'

select *
from Book

DELETE FROM Book WHERE BookName = 'The Culture Map'

select *
from BookReferencesCity




-- create a stored procedure that inserts data in tables that are in a m:n relationship;
-- if an insert fails, try to recover as much as possible from the entire operation:
-- for example, if the user wants to add a book and its authors, succeeds creating the authors,
-- but fails with the book, the authors should remain in the database (grade 5);

CREATE OR ALTER PROCEDURE Transaction2(@cityName varchar(100), @countryName varchar(50), @population int,
										@cityName2 varchar(100), @countryName2 varchar(50), @population2 int,
											@bookName varchar(100), @author varchar(100), @dateOfPublication varchar(20),
											@bookName2 varchar(100), @author2 varchar(100), @dateOfPublication2 varchar(20))
AS
	-- validate the parameters
	-- check whether the @countryName exists in the database, table Country
	IF (NOT EXISTS (
					SELECT *
					FROM Country
					WHERE CountryName = @countryName)
		)
		BEGIN
			RAISERROR('The country does not exist in the Country table', 10, 1)
			RETURN
		END
	-- check whether the @population is a negative number
	IF (@population <= 0)
		BEGIN
			RAISERROR('The population is a negative number or 0', 10, 1)
			RETURN
		END


	-- check whether the @countryName2 exists in the database, table Country
	IF (NOT EXISTS (
					SELECT *
					FROM Country
					WHERE CountryName = @countryName2)
		)
		BEGIN
			RAISERROR('The country does not exist in the Country table', 10, 1)
			RETURN
		END
	-- check whether the @population2 is a negative number
	IF (@population2 <= 0)
		BEGIN
			RAISERROR('The population is a negative number or 0', 10, 1)
			RETURN
		END


	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @insertedElem VARCHAR(300)

			INSERT INTO City
			VALUES (@cityName, @countryName, @population)
			SELECT @insertedElem = @cityName + ' ' + @countryName + ' ' + CAST(@population AS VARCHAR(10))
			INSERT INTO LogTable VALUES ('City', @insertedElem, SYSDATETIME())

			INSERT INTO City
			VALUES (@cityName2, @countryName2, @population2)
			SELECT @insertedElem = @cityName2 + ' ' + @countryName2 + ' ' + CAST(@population2 AS VARCHAR(10))
			INSERT INTO LogTable VALUES ('City', @insertedElem, SYSDATETIME())

			INSERT INTO Book
			VALUES (@bookName, @author, convert(datetime, @dateOfPublication))
			SELECT @insertedElem = @bookName + ' ' + @author + ' ' + convert(VARCHAR(10), @dateOfPublication)
			INSERT INTO LogTable VALUES ('Book', @insertedElem, SYSDATETIME())

			INSERT INTO Book
			VALUES (@bookName2, @author2, convert(datetime, @dateOfPublication2))
			SELECT @insertedElem = @bookName2 + ' ' + @author2 + ' ' + convert(VARCHAR(10), @dateOfPublication2)
			INSERT INTO LogTable VALUES ('Book', @insertedElem, SYSDATETIME())
			
			DECLARE @BookId INT
			SELECT @BookId = BookId FROM Book WHERE BOOKNAME = @bookName
			DECLARE @BookId2 INT
			SELECT @BookId2 = BookId FROM Book WHERE BOOKNAME = @bookName2

			INSERT INTO BookReferencesCity
			VALUES (@BookId, @cityName)
			SELECT @insertedElem = CAST(@BookId AS VARCHAR(50)) + ' ' + CAST(@cityName AS VARCHAR(5))
			INSERT INTO LogTable VALUES ('BookReferencesCity', @insertedElem, SYSDATETIME())

			INSERT INTO BookReferencesCity
			VALUES (@BookId2, @cityName2)
			SELECT @insertedElem = CAST(@BookId2 AS VARCHAR(50)) + ' ' + CAST(@cityName2 AS VARCHAR(5))
			INSERT INTO LogTable VALUES ('BookReferencesCity', @insertedElem, SYSDATETIME())
	END TRY


	BEGIN CATCH
		PRINT 'ERROR OCCURED! COMMIT UNTIL NOW'
		DECLARE @ErrorMessage VARCHAR(1000)
		SELECT @ErrorMessage = ERROR_MESSAGE()
		RAISERROR (@ErrorMessage, 10, 2)

		COMMIT TRANSACTION
	END CATCH

	-- if no error occured
	IF @@TRANCOUNT > 0  
		COMMIT TRANSACTION



EXEC Transaction2 'Graz', 'Austria', 290000, 
					'Hallstatt', 'Austria', 290000,
					'The Culture Map', 'Eleanor', '1980-10-09',
					'Jane Eyre', 'Charlotte Bronte', '1847-10-16'

EXEC Transaction2 'Graz', 'Austria', 290000, 
					'Hallstatt', 'Austria', 290000,
					'The Culture Map', 'Eleanor', '1980-10-09',
					'The Culture Map', 'Eleanor', '1980-10-09'

SELECT *
FROM City

select *
from Book

DELETE FROM City WHERE CityName = 'Graz'
DELETE FROM City WHERE CityName = 'Hallstatt'

DELETE FROM Book WHERE BookName = 'The Culture Map'
DELETE FROM Book WHERE BookName = 'Jane Eyre'

select *
from BookReferencesCity

SELECT *
FROM LogTable

DELETE FROM LogTable




-- SAVE POINTS

CREATE OR ALTER PROCEDURE Transaction3(@cityName varchar(100), @countryName varchar(50), @population int,
										@cityName2 varchar(100), @countryName2 varchar(50), @population2 int,
											@bookName varchar(100), @author varchar(100), @dateOfPublication varchar(20),
											@bookName2 varchar(100), @author2 varchar(100), @dateOfPublication2 varchar(20))
AS

	-- validate the parameters
	-- check whether the @countryName exists in the database, table Country
	IF (NOT EXISTS (
					SELECT *
					FROM Country
					WHERE CountryName = @countryName)
		)
		BEGIN
			RAISERROR('The country does not exist in the Country table', 10, 1)
			RETURN
		END
	-- check whether the @population is a negative number
	IF (@population <= 0)
		BEGIN
			RAISERROR('The population is a negative number or 0', 10, 1)
			RETURN
		END


	-- check whether the @countryName2 exists in the database, table Country
	IF (NOT EXISTS (
					SELECT *
					FROM Country
					WHERE CountryName = @countryName2)
		)
		BEGIN
			RAISERROR('The country does not exist in the Country table', 10, 1)
			RETURN
		END
	-- check whether the @population2 is a negative number
	IF (@population2 <= 0)
		BEGIN
			RAISERROR('The population is a negative number or 0', 10, 1)
			RETURN
		END


	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @insertedElem VARCHAR(300)

			SAVE TRANSACTION tranSavepoint

			INSERT INTO City
			VALUES (@cityName, @countryName, @population)
			SELECT @insertedElem = @cityName + ' ' + @countryName + ' ' + CAST(@population AS VARCHAR(10))
			INSERT INTO LogTable VALUES ('City', @insertedElem, SYSDATETIME())

			SAVE TRANSACTION tranSavepoint

			INSERT INTO City
			VALUES (@cityName2, @countryName2, @population2)
			SELECT @insertedElem = @cityName2 + ' ' + @countryName2 + ' ' + CAST(@population2 AS VARCHAR(10))
			INSERT INTO LogTable VALUES ('City', @insertedElem, SYSDATETIME())

			SAVE TRANSACTION tranSavepoint

			INSERT INTO Book
			VALUES (@bookName, @author, convert(datetime, @dateOfPublication))
			SELECT @insertedElem = @bookName + ' ' + @author + ' ' + convert(VARCHAR(10), @dateOfPublication)
			INSERT INTO LogTable VALUES ('Book', @insertedElem, SYSDATETIME())

			SAVE TRANSACTION tranSavepoint

			INSERT INTO Book
			VALUES (@bookName2, @author2, convert(datetime, @dateOfPublication2))
			SELECT @insertedElem = @bookName2 + ' ' + @author2 + ' ' + convert(VARCHAR(10), @dateOfPublication2)
			INSERT INTO LogTable VALUES ('Book', @insertedElem, SYSDATETIME())

			SAVE TRANSACTION tranSavepoint
			
			DECLARE @BookId INT
			SELECT @BookId = BookId FROM Book WHERE BOOKNAME = @bookName
			DECLARE @BookId2 INT
			SELECT @BookId2 = BookId FROM Book WHERE BOOKNAME = @bookName2

			INSERT INTO BookReferencesCity
			VALUES (@BookId, @cityName)
			SELECT @insertedElem = CAST(@BookId AS VARCHAR(50)) + ' ' + CAST(@cityName AS VARCHAR(5))
			INSERT INTO LogTable VALUES ('BookReferencesCity', @insertedElem, SYSDATETIME())

			SAVE TRANSACTION tranSavepoint

			INSERT INTO BookReferencesCity
			VALUES (@BookId2, @cityName2)
			SELECT @insertedElem = CAST(@BookId2 AS VARCHAR(50)) + ' ' + CAST(@cityName2 AS VARCHAR(5))
			INSERT INTO LogTable VALUES ('BookReferencesCity', @insertedElem, SYSDATETIME())
	END TRY


	BEGIN CATCH
		PRINT 'ERROR OCCURED! COMMIT UNTIL NOW'
		DECLARE @ErrorMessage VARCHAR(1000)
		SELECT @ErrorMessage = ERROR_MESSAGE()
		RAISERROR (@ErrorMessage, 10, 2)

		ROLLBACK TRANSACTION tranSavepoint
	END CATCH

	COMMIT TRANSACTION


PRINT @@TRANCOUNT

EXEC Transaction3 'Graz', 'Austria', 290000, 
					'Hallstatt', 'Austria', 290000,
					'The Culture Map', 'Eleanor', '1980-10-09',
					'Jane Eyre', 'Charlotte Bronte', '1847-10-16'

EXEC Transaction3 'Graz', 'Austria', 290000, 
					'Hallstatt', 'Austria', 290000,
					'The Culture Map', 'Eleanor', '1980-10-09',
					'The Culture Map', 'Eleanor', '1980-10-09'

SELECT *
FROM City

select *
from Book

DELETE FROM City WHERE CityName = 'Graz'
DELETE FROM City WHERE CityName = 'Hallstatt'

DELETE FROM Book WHERE BookName = 'The Culture Map'
DELETE FROM Book WHERE BookName = 'Jane Eyre'

select *
from BookReferencesCity

SELECT *
FROM LogTable

DELETE FROM LogTable




-- reproduce the following concurrency issues under pessimistic isolation levels:
-- dirty reads, non-repeatable reads, phantom reads, and a deadlock (4 different scenarios);
-- you can use stored procedures and / or stand-alone queries; find solutions to solve / workaround
-- the concurrency issues (grade 9);


SELECT resource_type, request_mode, request_status, request_session_id
FROM sys.dm_tran_locks
WHERE request_owner_type = 'TRANSACTION'


-- DIRTY READ

PRINT @@TRANCOUNT


BEGIN TRANSACTION
			
	UPDATE City
	SET PopulationNumber = PopulationNumber + 100
	WHERE CityName = 'Barcelona'

	WAITFOR DELAY '00:00:10'

ROLLBACK TRANSACTION


SELECT *
FROM City



-- NON-REPEATABLE READS

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- SOLUTION
-- SET TRANSACTION ISOLATION LEVEL REPEATABLE READ


BEGIN TRANSACTION
	
	SELECT *
	FROM City
	WHERE CityName = 'Mons'

	WAITFOR DELAY '00:00:08'

	SELECT *
	FROM City
	WHERE CityName = 'Mons'

COMMIT TRANSACTION



SELECT *
FROM City
WHERE CountryName = 'Belgium'





-- PHANTOM READ

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

-- SOLUTION
-- SET TRANSACTION ISOLATION LEVEL SERIALIZABLE


BEGIN TRANSACTION

	SELECT *
	FROM Book
	WHERE BookId BETWEEN 6 AND 100

	WAITFOR DELAY '00:00:05'

	SELECT *
	FROM Book
	WHERE BookId BETWEEN 6 AND 100

COMMIT TRAN


SELECT *
FROM Book


-- DEADLOCK
-- SET DEADLOCK_PRIORITY HIGH

BEGIN TRANSACTION

	UPDATE Book
	SET BookName = 'Origins 3'
	WHERE BookId = 5

	WAITFOR DELAY '00:00:10'

	UPDATE Landmark
	SET LandmarkName = 'Louvre Museum 3'
	WHERE LandmarkId = 3

COMMIT TRAN



UPDATE Book
SET BookName = 'Origins'
WHERE BookId = 5

UPDATE Landmark
SET LandmarkName = 'Louvre Museum'
WHERE LandmarkId = 3




SELECT *
FROM Book

SELECT *
FROM Landmark



-- reproduce the update conflict under an optimistic isolation level (grade 10).


-- in order to be able to replicate the update conflict we need to allow snapshots
-- operations see the most recent committed data as of the beginning of their transaction
ALTER DATABASE EuropeanCities SET ALLOW_SNAPSHOT_ISOLATION ON


SELECT is_read_committed_snapshot_on, snapshot_isolation_state
FROM sys.databases
WHERE database_id = DB_ID('EuropeanCities')




WAITFOR DELAY '00:00:10'

BEGIN TRANSACTION

	UPDATE Country
	SET PopulationNumber = PopulationNumber + 10
	WHERE CountryName = 'Belgium'
	-- the value is 11460010

	WAITFOR DELAY '00:00:10'

COMMIT TRANSACTION





ALTER DATABASE EuropeanCities SET ALLOW_SNAPSHOT_ISOLATION OFF




SELECT *
FROM Country

UPDATE Country
SET PopulationNumber = 11460000
WHERE CountryName = 'Belgium'


SELECT @@TRANCOUNT