USE QL;
GO

CREATE OR ALTER PROCEDURE dbo.DRAW_Hanoi

/**************************************************************
Procedure:          dbo.DRAW_Hanoi
Create Date:        2021-12-25
Author:             Tomaz Kastrun
Description:        Creates a table that stores the number of
					rings used in the game with three rods.
					Table name is dbo.Hanoi and is used to
					to store the moves.
					Table dbo.DrawHanoi is used to output the rings
					rods. 
Procedure output:	[dbo].[DrawHanoi]
Parameter(s):       @rings - Number of rings; e.g.: 5 = 5 rings 
					on 3 rods; Type: TINYINT (max 255 rings!)
Usage:              EXEC dbo.DRAW_Hanoi
                        @rings = 5
ChangeLog:

ToDO:
					Align Drawing!
************************************************************* */

	@rings TINYINT

AS
BEGIN


	DECLARE @i INT = 1
	DECLARE @j INT = 1

	DROP TABLE IF EXISTS dbo.Hanoi;

	DECLARE @TableCreate NVARCHAR(2000) = 
	'DROP TABLE IF EXISTS dbo.Hanoi; 
	CREATE TABLE dbo.Hanoi (
	 ID TINYINT IDENTITY(1,1) NOT NULL
	,T1 TINYINT NOT NULL
	,T2 TINYINT NOT NULL
	,T3 TINYINT NOT NULL
	)

	DROP TABLE IF EXISTS dbo.DrawHanoi;
	CREATE TABLE dbo.DrawHanoi (
	 ID TINYINT IDENTITY(1,1) NOT NULL
	,V1 VARCHAR(500) NOT NULL
	,V2 VARCHAR(500) NOT NULL
	,V3 VARCHAR(500) NOT NULL
	)

	'

	WHILE (@rings >= @j)
	BEGIN
		SET @TableCreate = @TableCreate + ' 
			INSERT INTO dbo.Hanoi(T1, T2, T3) VALUES ('+CAST(@j AS varchar(10))+',0,0)
			INSERT INTO dbo.DrawHanoi(V1, V2, V3) VALUES ('+CAST(REPLICATE('''#''',@j*2) AS varchar(500))+','' '','' '')
			'
		SET @j = @j+1
	END

	EXEC sp_executesql @tableCreate

	SELECT * FROM dbo.DrawHanoi
END;
GO

