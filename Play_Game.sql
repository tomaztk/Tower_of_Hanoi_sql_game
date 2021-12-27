USE TowerHanoi;
GO

/* *********************
Initialize the game; Select number of Rings to play
********************* */


EXEC dbo.INIT_Hanoi
    @rings = 4;
GO



/* *********************
Playing the game
********************* */

EXEC dbo.PLAY_Hanoi
     @from = 1
    ,@to = 2;
GO



/* **********************************
Sample Game-play from start to end
********************************** */
EXEC dbo.INIT_Hanoi 4;
GO

EXEC dbo.PLAY_Hanoi 1,3;
GO
EXEC dbo.PLAY_Hanoi 1,2;
GO
EXEC dbo.PLAY_Hanoi 3,2;
GO
EXEC dbo.PLAY_Hanoi 1,3;
GO
EXEC dbo.PLAY_Hanoi 2,1;
GO
EXEC dbo.PLAY_Hanoi 2,3;
GO
EXEC dbo.PLAY_Hanoi 1,3;
GO
EXEC dbo.PLAY_Hanoi 1,2;
GO
EXEC dbo.PLAY_Hanoi 3,1;
GO
EXEC dbo.PLAY_Hanoi 3,2;
GO
EXEC dbo.PLAY_Hanoi 1,2;
GO
EXEC dbo.PLAY_Hanoi 2,3;
GO
EXEC dbo.PLAY_Hanoi 2,1;
GO
EXEC dbo.PLAY_Hanoi 3,1;
GO
EXEC dbo.PLAY_Hanoi 3,2;
GO
EXEC dbo.PLAY_Hanoi 1,3;
GO
EXEC dbo.PLAY_Hanoi 1,2;
GO
EXEC dbo.PLAY_Hanoi 3,2;
GO


/* **********************************
Invalid moves; 
1) empty rod to empty rod
2) bigger ring on smaller ring
********************************** */

EXEC dbo.INIT_Hanoi 4;
GO
--1
exec play_hanoi 2,3
exec play_hanoi 3,3

--2
exec play_hanoi 1,3
exec play_hanoi 1,3