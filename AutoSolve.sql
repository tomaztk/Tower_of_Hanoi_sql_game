CREATE OR ALTER PROCEDURE dbo.AutoSolver
	
/*
Kremsnita!

Usage:
	exec dbo.Autosolver 4


*/

	@rings TINYINT
AS
BEGIN

	drop table if exists dbo.hanoi_log
	create table dbo.hanoi_log
	(id int identity(1,1)
	,rodd varchar(10)
	,f_rod int
	,t_rod int
	,ts_move datetime
	)

	EXEC dbo.INIT_Hanoi 
		@rings = @rings;

	-- init set of @T2_count and @T3_count
	DECLARE @t2_count INT = (SELECT COUNT(t2) FROM dbo.Hanoi WHERE t2 <> 0)
	DECLARE @t3_count INT = (SELECT COUNT(t3) FROM dbo.Hanoi WHERE t3 <> 0)


	WHILE (@t2_count <> @rings OR @t3_count <> @rings)
	BEGIN

		--declare @from int = 1
		--declare @to int = 2

		DECLARE @t1 INT = (Select TOP 1 ISNULL(t1,0) from hanoi WHERE t1 <> 0 ORDER BY ID ASC)
		DECLARE @t2 INT = (Select TOP 1 ISNULL(t2,0) from hanoi WHERE t2 <> 0 ORDER BY ID ASC)
		DECLARE @t3 INT = (Select top 1 ISNULL(t3,0) from hanoi WHERE t3 <> 0 ORDER BY ID ASC)





		
		EXEC dbo.PLAY_Hanoi 
			 @from = @from
			,@to = @to

		--insert into log
		INSERT INTO dbo.hanoi_log
		SELECT 
			CAST(@to AS VARCHAR(10)) + ';' +CAST(@from AS VARCHAR(10)) as rodd
			,@from as f_rod
			,@to as t_rod
			,getdate() as ts_move
	
		SET @t2_count  = (SELECT COUNT(t2) FROM dbo.Hanoi WHERE t2 <> 0)
		SET @t3_count  = (SELECT COUNT(t3) FROM dbo.Hanoi WHERE t3 <> 0)
	END

END;
GO



