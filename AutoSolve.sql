CREATE OR ALTER PROCEDURE dbo.AutoSolver

/**************************************************************
Procedure:          dbo.AutoSolver
Create Date:        2021-12-26
Author:             Tomaz Kastrun
Description:        Initialize and solves the game Tower of 
                    Hanoi for the given number of rings.
                    All steps are temporarely stored in log.
Procedure output:	[dbo].[Hanoi_log]
Parameter(s):       @rings - number of rings 

Usage:
		EXEC dbo.Autosolver
			 @rings = 4

ToDO:
					- Optimization for end result on rod 2 or 3
************************************************************* */

	@rings TINYINT
AS
BEGIN

	drop table if exists dbo.hanoi_log;
	
	CREATE TABLE dbo.hanoi_log
	(id int identity(1,1) NOT NULL
	,rodd varchar(10)
	,f_rod int
	,t_rod int
	)

	EXEC dbo.INIT_Hanoi 
		@rings = @rings;

	-- init set of @T2_count and @T3_count
	DECLARE @t2_count INT = -1 
	DECLARE @t3_count INT = -1

	DECLARE @from INT  
	DECLARE @to INT  

	WHILE (@t2_count <= @rings) OR (@t3_count <=  @rings)
	BEGIN

		DECLARE @t1 INT = (Select TOP 1 ISNULL(t1,0) from hanoi WHERE t1 <> 0 ORDER BY ID ASC)
		DECLARE @t2 INT = (Select TOP 1 ISNULL(t2,0) from hanoi WHERE t2 <> 0 ORDER BY ID ASC)
		DECLARE @t3 INT = (Select top 1 ISNULL(t3,0) from hanoi WHERE t3 <> 0 ORDER BY ID ASC)

		INSERT INTO dbo.hanoi_log (rodd, f_rod, t_rod)
		SELECT TOP 1
			 cast(right(t.rod,1) as varchar(10)) + ';' + cast(right(f.rod,1) as varchar(10)) as rodd
			,right(f.rod,1) AS from_rod
			,right(t.rod,1) as To_rod
			--,CAST(right(f.rod,1) as int) + cast(right(t.rod,1) as int) as suma_f
		FROM (
				SELECT ISNULL(@t1,0) as val, 't1' as rod, 'from' as pot
				union 
				SELECT ISNULL(@t2,0), 't2' as rod, 'from' as pot
				union 
				SELECT ISNULL(@t3,0), 't3' as rod, 'from' as pot
		) as f
		cross join (
				SELECT ISNULL(@t1,0) as val, 't1' as rod, 'to' as pot
				union 
				SELECT ISNULL(@t2,0), 't2' as rod, 'to' as pot
				union 
				SELECT ISNULL(@t3,0), 't3' as rod, 'to' as pot
		) as t
		WHERE
			f.rod <> t.rod
		AND f.val <> 0
		AND (t.val > f.val OR t.val = 0)
		AND CAST(right(f.rod,1) as varchar(10)) + ';' + cast(right(t.rod,1) as varchar(10)) NOT IN (SELECT rodd from dbo.hanoi_log where id = (SELECT max(id) from hanoi_log)) --last
		AND CAST(right(f.rod,1) as varchar(10)) + ';' + cast(right(t.rod,1) as varchar(10)) NOT IN (SELECT rodd from dbo.hanoi_log where id = (SELECT max(id)-1 from hanoi_log)) --before_last
		ORDER BY CAST(right(f.rod,1) as int) + cast(right(t.rod,1) as int)  desc

		DECLARE @max_id INT = (select max(id) from dbo.hanoi_log)

		SET @from = (SELECT f_rod FROM dbo.hanoi_log WHERE id = @max_id)
		SET @to = (SELECT t_rod FROM dbo.hanoi_log WHERE id = @max_id)
		

		EXEC dbo.PLAY_Hanoi 
			 @from = @from
			,@to = @to


	   	SET @t2_count  = (SELECT COUNT(t2) FROM dbo.Hanoi WHERE t2 <> 0)
		SET @t3_count  = (SELECT COUNT(t3) FROM dbo.Hanoi WHERE t3 <> 0)				
				

		IF (@t2_count = 0) AND (@t3_count = 0)
			BEGIN
				BREAK  			
			END
		END
			 
END;
GO

