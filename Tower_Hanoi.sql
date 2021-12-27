USE [master];
GO

CREATE DATABASE TowerHanoi;
GO


USE TowerHanoi;
GO

CREATE OR ALTER PROCEDURE dbo.INIT_Hanoi

/**************************************************************
Procedure:          dbo.INIT_Hanoi
Create Date:        2021-12-25
Author:             Tomaz Kastrun
Description:        Creates a table that stores the number of
					rings used in the game with three rods.
					Table name is dbo.Hanoi and is used to
					to store the moves.
 
Procedure output:	[dbo].[Hanoi]
Parameter(s):       @rings - Number of rings; e.g.: 5 = 5 rings 
					on 3 rods; Type: TINYINT (max 255 rings!)
Usage:              EXEC dbo.INIT_Hanoi
                        @rings = 5
ChangeLog:

ToDO:
					Align Drawing!
************************************************************* */

	@rings TINYINT

AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @j INT = 1

	DROP TABLE IF EXISTS dbo.Hanoi;

	DECLARE @TableCreate NVARCHAR(1000) = 
	'DROP TABLE IF EXISTS dbo.Hanoi; 
	CREATE TABLE dbo.Hanoi (
	 ID TINYINT IDENTITY(1,1) NOT NULL
	,T1 TINYINT NOT NULL
	,T2 TINYINT NOT NULL
	,T3 TINYINT NOT NULL
	)

	'

	WHILE (@rings >= @j)
	BEGIN
		SET @TableCreate = @TableCreate + ' 
			INSERT INTO dbo.Hanoi(T1, T2, T3) VALUES ('+CAST(@j AS varchar(10))+',0,0)
			'
		SET @j = @j+1
	END

	EXEC sp_executesql @tableCreate


		DECLARE @max INT = @rings*4
		
		SELECT 
			 REPLICATE(' ',(@max - T1*2)/2) + REPLICATE('#', T1*2) + REPLICATE(' ',(@max - T1*2)/2)  AS T1
			,REPLICATE(' ',(@max - T2*2)/2) + REPLICATE('#', T2*2) + REPLICATE(' ',(@max - T2*2)/2)  AS T2
			,REPLICATE(' ',(@max - T3*2)/2) + REPLICATE('#', T3*2) + REPLICATE(' ',(@max - T3*2)/2)  AS T3 
		FROM hanoi
		ORDER BY ID ASC


END;
GO



CREATE OR ALTER PROCEDURE dbo.PLAY_Hanoi

/**************************************************************
Procedure:          dbo.PLAY_Hanoi
Create Date:        2021-12-25
Author:             Tomaz Kastrun
Description:        Creates a table that stores the number of
					rings used in the game with three rods.
					Table name is dbo.Hanoi and is used to
					to store the moves.
 
Procedure output:	[dbo].[Hanoi]
Parameter(s):       @from - rod number taking the first ring 
					@to - rod number putting the same ring

Usage:
		EXEC dbo.PLAY_Hanoi
			 @from = 1
			,@to = 2

ToDO:
					- Align Drawing of tower!
					- Stop / finish the game
                    - Rings different ASCII Char!
************************************************************* */

	 @from INT
	,@to INT
AS
BEGIN

		SET NOCOUNT ON;

		-- internal values

		DECLARE @from_variable VARCHAR(10) = (select column_name from information_Schema.columns where  table_name = 'hanoi' and table_Schema = 'dbo' and ordinal_position = (@from + 1))
		print @from_variable
		DECLARE @to_variable VARCHAR(10) = (select column_name from information_Schema.columns where  table_name = 'hanoi' and table_Schema = 'dbo' and ordinal_position = (@to + 1))
		print @to_variable

		-- FROM position
		DECLARE @from_position NVARCHAR(1000)
		SET @from_position =  'SELECT top 1 ID FROM dbo.hanoi where '+@from_Variable+' <> '''' order by id asc'

		DROP TABLE IF EXISTS #from_pos
		CREATE table #from_pos  (val int)
		INSERT INTO #from_pos
		EXEC sp_executesql @from_position

		-- FROM value
		DECLARE @from_value NVARCHAR(1000)
		SET @from_value =  'SELECT top 1 '+@from_variable+' FROM dbo.hanoi where '+@from_Variable+' <> '''' order by id asc'

		DROP TABLE IF EXISTS #from_val
		CREATE table #from_val  (val int)
		INSERT INTO #from_val
		EXEC sp_executesql @from_value


		-- TO position
		DECLARE @to_position NVARCHAR(1000)
		SET @to_position =  'SELECT top 1 ID FROM dbo.hanoi where '+@to_variable+' = '''' order by id desc'

		DROP TABLE IF EXISTS #to_pos
		CREATE table #to_pos  (val int)
		INSERT INTO #to_pos
		EXEC sp_executesql @to_position


		-- TO value
		DECLARE @to_value NVARCHAR(1000)
		SET @to_value =  'SELECT top 1 '+@to_variable+' FROM dbo.hanoi where '+@to_variable+' = '''' order by id desc'

		DROP TABLE IF EXISTS #to_val
		CREATE table #to_val  (val int)
		INSERT INTO #to_val
		EXEC sp_executesql @to_value


		-- TO Prev Value
		DECLARE @prev_to_val NVARCHAR(1000)
		SET @prev_to_val = 'select top 1 '+@to_variable+' from hanoi where  '+@to_variable +' <> 0 order by id asc'

		DROP TABLE IF EXISTS #to_prev_val
		CREATE table #to_prev_val  (val int)
		INSERT INTO #to_prev_val
		EXEC sp_executesql @prev_to_val

        -- number of rings!
		declare @rings int = (select COUNT(*) from dbo.hanoi)
		declare @max int = @rings*4

        -- check Tower 2 and Tower 3
        DECLARE @t2 INT = (SELECT COUNT(T2) FROM Hanoi WHERE T2 <> 0)
        DECLARE @t3 INT = (SELECT COUNT(T3) FROM Hanoi WHERE T3 <> 0)
    

			--- internal update
			-- add rules for update!!!!

			-- add rules for update!!!!
			IF ((SELECT ISNULL(val,0) FROM #to_prev_val) < (SELECT val FROM #from_val))
			BEGIN
				SELECT 'Wrong Move'
			END
            ELSE            
			BEGIN
                IF ((SELECT ISNULL(val,0) FROM #to_val) = 0 AND  (SELECT ISNULL(val,0) FROM #from_val) = 0)
                BEGIN
                    SELECT 'Invalid Move'
                END
                ELSE
                    BEGIN
                        --update FROM pos/value
                        DECLARE @update_from NVARCHAR(1000)
                        SET @update_from = 'update dbo.hanoi set '+@from_variable+' = (select '' '' ) WHERE ID =  (SELECT val FROM #from_pos) '
                        print @update_from
                        EXEC sp_executesql @update_from


                        --update TO pos/value
                        DECLARE @update_to NVARCHAR(1000)
                        SET @update_to = 'update dbo.hanoi set '+@to_variable+' = (select val from #from_Val) WHERE ID = (SELECT val FROM #to_pos)'
                        print @update_to
                        EXEC sp_executesql @update_to

                        IF (@T2 = @rings OR @T3 = @rings)
                        BEGIN
                           SELECT 'Game Won!'
                            -- Initialize New Game
                           EXEC dbo.INIT_Hanoi @rings
                        END

                    END
			END

		
			SELECT 
				 REPLICATE(' ',(@max - T1*2)/2) + REPLICATE('#', T1*2) + REPLICATE(' ',(@max - T1*2)/2)  AS T1
				,REPLICATE(' ',(@max - T2*2)/2) + REPLICATE('#', T2*2) + REPLICATE(' ',(@max - T2*2)/2)  AS T2
				,REPLICATE(' ',(@max - T3*2)/2) + REPLICATE('#', T3*2) + REPLICATE(' ',(@max - T3*2)/2)  AS T3 
			FROM dbo.hanoi
			ORDER BY ID ASC

END;
GO