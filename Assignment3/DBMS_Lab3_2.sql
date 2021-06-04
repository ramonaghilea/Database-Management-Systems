

use EuropeanCities


-- reproduce the following concurrency issues under pessimistic isolation levels:
-- dirty reads, non-repeatable reads, phantom reads, and a deadlock (4 different scenarios);
-- you can use stored procedures and / or stand-alone queries; find solutions to solve / workaround
-- the concurrency issues (grade 9);


-- DIRTY READ

PRINT @@TRANCOUNT

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

-- SOLUTION
-- SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRANSACTION
	
	SELECT *
	FROM City
	WHERE CityName = 'Barcelona'

	WAITFOR DELAY '00:00:15'

	SELECT *
	FROM City
	WHERE CityName = 'Barcelona'

COMMIT TRANSACTION



SELECT *
FROM City



-- NON-REPEATABLE READS


BEGIN TRANSACTION
	UPDATE City
	SET PopulationNumber = 200000
	WHERE CityName = 'Mons'

COMMIT TRANSACTION


UPDATE City
SET PopulationNumber = 100000
WHERE CityName = 'Mons'



-- PHANTOM READ

BEGIN TRANSACTION

	INSERT INTO Book
	VALUES('Thinking fast and slow', 'Daniel Kahneman', convert(datetime, '2011-09-01'))

COMMIT TRANSACTION



DELETE
FROM Book
WHERE BookName = 'Thinking fast and slow'




-- DEADLOCK

-- SOLUTION
-- SET DEADLOCK_PRIORITY HIGH

BEGIN TRANSACTION
	
	UPDATE Landmark
	SET LandmarkName = 'Louvre Museum 2'
	WHERE LandmarkId = 3

	WAITFOR DELAY '00:00:10'

	UPDATE Book
	SET BookName = 'Origins 2'
	WHERE BookId = 5

COMMIT TRAN





-- reproduce the update conflict under an optimistic isolation level (grade 10).
  

SET TRANSACTION ISOLATION LEVEL SNAPSHOT 


BEGIN TRANSACTION

	SELECT *
	FROM Country
	WHERE CountryName = 'Belgium'
	-- the value is 11460000 because it has not been updated yet

	WAITFOR DELAY '00:00:10'

	-- now when trying to update the same resource that T1 has updated and obtained a lock on - T2 is suspended
	UPDATE Country
	SET PopulationNumber = PopulationNumber + 15
	WHERE CountryName = 'Belgium'

COMMIT TRANSACTION