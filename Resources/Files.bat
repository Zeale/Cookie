@echo off
IF NOT DEFINED Cookie.HeadLoaded (
	ECHO Files.bat is an extension of Cookie.bat and, therefore, must be called from Cookie.bat.
	TIMEOUT /T 10
	GOTO :EOF
)

:Head
IF /I NOT %mode%==files (
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
IF /I "%command%"=="back" EXIT /B
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
		ECHO [91mThe file, [95m!sfile![91m, could not be found
		ECHO Press a key to continue...[0m
		PAUSE > NUL
		ENDLOCAL
		GOTO Head
	) ELSE (
		:: Now we need a place to copy to...
		ECHO Type the name of the file that you wish to copy the data to. (AKA the destination file.^) [97mA couple things to note:[0m
		ECHO [91m1. [93mAll the contents of the source file will be copied to the ^
destination file.
		ECHO [91m2. [93mIf the destination file does not exist, it will be created.
		ECHO [91m3. [93mIf the destination file already exists, [94m everything inside it will be overwritten, [93m(as this program doesn't *yet* support appending^).[92m
		SET /P dfile=""
		IF EXIST "!dfile!" (ECHO The destination file, [92m!dfile![0m, is being overwritten...) ELSE ECHO The destination file, [92m!dfile![0m, is being created.
		TYPE !sfile! > !dfile!
		ECHO The copy process has finished.
		ECHO [91mThe file, [92m!dfile![91m, should be a copy of the file, [92m!sfile![91m.[0m
		ENDLOCAL
		ECHO Please press a key to continue...
		PAUSE > NUL
	)
)
GOTO Head
