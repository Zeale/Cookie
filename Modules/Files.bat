:: This module will be included in the initial program.
@echo off
IF NOT DEFINED Cookie.HeadLoaded (
	ECHO %~n0%~x0 is an extension of Cookie.bat and, therefore, must be called from Cookie.bat.
	TIMEOUT /T 10
	GOTO :EOF
)

:Head
ENDLOCAL
IF /I NOT %mode%=="files" (
	CLS
	ECHO You have entered [91mFile Mode[0m.
	ECHO To leave [91mFile Mode[0m, type [92mexit[0m.
	ECHO Type [92mhelp[0m and press enter for a list of commands.
	SET mode="files"
	ECHO.
)
ECHO Please enter a command below.
ECHO.
SET /P command=""
IF /I "%command%"=="back" (
	cls
	EXIT /B
)
IF /I "%command%"=="exit" (
	cls
	EXIT /B
)
IF /I "%command%"=="cls" GOTO ClearScreen
IF /I "%command%"=="clrscrn" GOTO ClearScreen
IF /I "%command%"=="clearscreen" GOTO ClearScreen
IF /I "%command%"=="delete" GOTO Delete
IF /I "%command%"=="delete" GOTO Delete
IF /I "%command%"=="move" (
	SETLOCAL enableDelayedExpansion
	ECHO Enter the file that you wish to move. (Use backslashes in the path name.^)
	ECHO.
	SET /P file=""
	IF NOT EXIST "!file!" (
		ECHO The given file does not exist.
		ECHO Exiting the move command.
		PAUSE
		ENDLOCAL
		GOTO Head
	)
	ECHO Enter the path to the directory that you wish to move the file to. (Use backslashes in the path name.^)
	SET /P dir=""
	IF NOT EXIST !dir!\NUL (
		IF NOT EXIST !dir! (
			ECHO The directory given does not exist.
			PAUSE
			ENDLOCAL
			GOTO Head
		) ELSE (
			ECHO The directory path given points to a file, not a directory...
			PAUSE
			ENDLOCAL
			GOTO Head
		)
	)
	MOVE "!file!" "!dir!" || ECHO The move operation failed. && ECHO The move operation succeeded.
	ENDLOCAL
	GOTO Head
)
IF /I "%command%"=="copy" (
	:: Allows us to access variables inside the IF statement.
	SETLOCAL enableDelayedExpansion
	ECHO Enter the name of the file you wish to copy below. (AKA the source file^)
	ECHO [107;90mNOTE: PLEASE only use BACKSLASHES (\^) as a path separator.[0m
	ECHO Type [92m^<back^>[0m or [92m^|back^|[0m to go back.
	ECHO.
	SET /P sfile=""
	IF /I !sfile!==^<back^> GOTO Head
	IF /I !sfile!==^|back^| GOTO Head
	IF NOT EXIST "!sfile!" (
		ECHO [91mThe source file, [95m!sfile![91m, could not be found
		ECHO Press a key to continue...[0m
		PAUSE > NUL
		ENDLOCAL
		GOTO Head
	) ELSE (
		:: Check if the given path is a directory...
		:: The NUL file exists in ALL directories, (it's not a real file^), but since files can't hold any other files inside them, NUL doesn't exist inside files.
		:: Therefore, if sfile is a file, the following if will return false and we can continue our command.
		IF EXIST "!sfile!\NUL" (
			ECHO [91mThe source file, [95m!sfile![91m, is actually a directory... Copying has been aborted.
			ECHO Press a key to continue...[0m
			PAUSE > NUL
			ENDLOCAL
			GOTO Head
		)
		:: Now we need a place to copy to...
		ECHO Type the name of the file that you wish to copy the data to. (AKA the destination file.^) [97mA couple things to note:[0m
		ECHO [91m1. [93mAll the contents of the source file will be copied to the ^
destination file.
		ECHO [91m2. [93mIf the destination file does not exist, it will be created.
		ECHO [91m3. [93mIf the destination file already exists, [94m everything inside it will be overwritten, [93m(as this program doesn't *yet* support appending^).[92m
		SET /P dfile=""
		IF EXIST "!dfile!" (
			:: Check if dfile is a directory. Same thing as above.
			IF EXIST "!dfile!\NUL" (
				ECHO [91mThe destination file, [95m!dfile![91m, is actually a directory... Copying has been aborted.
				ECHO Press a key to continue...[0m
				PAUSE > NUL
				ENDLOCAL
				GOTO Head
			) ELSE ECHO The destination file, [92m!dfile![0m, is being overwritten...
		) ELSE ECHO The destination file, [92m!dfile![0m, is being created.
		TYPE !sfile! > !dfile!
		ECHO The copy process has finished.
		ECHO [91mThe file, [92m!dfile![91m, should be a copy of the file, [92m!sfile![91m.[0m
		ENDLOCAL
		ECHO Please press a key to continue...
		PAUSE > NUL
		GOTO Head
	)
)
ECHO [91mThe command, [95m%command%[91m, was unrecognized.[0m
GOTO Head

:ClearScreen
cls
ECHO [96mScreen cleared![0m
ECHO.
ECHO.
GOTO Head

:Delete
SETLOCAL enableDelayedExpansion
ECHO Enter the path of the file/directory that you wish to delete below. (Use backslashes to indicate nested items. e.g., C:\folder\file.txt)
ECHO Type [92m^<back^>[0m or [92m^|back^|[0m to go back.
ECHO.
SET /P file=""
IF !file!==^<back^> GOTO Head
IF !file!==^|back^| GOTO Head
DEL !file! && ECHO The delete operation returned successfully. || ECHO The delete operation returned unsuccessfully.
ENDLOCAL
GOTO Head
