@ECHO off
GOTO Head

Welcome to COOKIE. A couple of notes here before the program starts.

1. If you find any characters in this document that appear as boxes (or red circles, if you're on github), (specifically this:  character),
	then don't worry; that's an escape character, (literally the character "Escape"). It's used to change the foreground and background color
	of text, along with some other things such as underlining text, or making it bold. You can check out
	'https://stackoverflow.com/a/38617204' for a list of color codes and their outputs.

2. The program starts in this file and immediately goes to the head label below, so all of these "notes"
	don't get processed as batch commands.
	
	NOTE: that the :Head label directly leads into the :Command label; there are no needs for GOTO
	statements since the :Command label directly proceeds the :Head label. After :Head is done, :Command is
	run.

3. All my "TODO" markings have been stated with 4 semicolons, rather than only two. This makes them slightly
	easier to find.

4. NOTE: If you find a "^" character infornt of any closing parentheses inside an if block, don't remove it.
	It's used to escape the parenthesis.
	
		Remember that batch parses for syntax errors before it begins execution. Batch parses the following IF statement...
	
		IF EXIST "C:\Potato\NUL" (
			ECHO This is a message.
			:: () <- Ha ha lol. This crashes batch.
		)
	
		...like so:
	
		1. Read the 'IF EXIST "C:\..."'
			• Batch recognizes the IF block and makes sure that the code inside it is syntactically correct. 
			(It won't check for syntax errors inside nested IF blocks yet.)
		2. Read the ECHO statement.
			• This is a valid statement; move on.
		3. Read the "comment."
			• Batch sees the opening parenthesis and finds it ok, then it sees the closing parenthesis and 
			closes the IF block... We can get around this by escaping it, using "^)" instead of ")".
		4. Read the closing parenthesis on the bottom line.
			• "There is a parenthesis here. The author must've made a mista-"
		



:Head
:: Make sure we don't load things twice
IF DEFINED Cookie.HeadLoaded (
	IF "%Cookie.HeadLoaded%"=="TRUE" GOTO Command
)
IF NOT EXIST "%WINDIR%\System32\Zeale\Cookie\Modules" (
	MD "%WINDIR%\System32\Zeale\Cookie\Modules" && SET Cookie.AdminMode=TRUE || (
		ECHO Please run Cookie in administrator privileges for access to modules.
		ECHO Press a key to continue.....
		PAUSE > NUL
		SET Cookie.AdminMode=FALSE
	)
) ELSE (
	IF EXIST "%WINDIR%\System32\Zeale\TempFolder" RMDIR /S /Q "%WINDIR%\System32\Zeale\TempFolder"
	
	MD "%WINDIR%\System32\Zeale\TempFolder" && SET Cookie.AdminMode=TRUE || (
		ECHO Please run Cookie in administrator privileges for access to modules.
		ECHO Press a key to continue.....
		PAUSE > NUL
		SET Cookie.AdminMode=FALSE
	)
	IF EXIST "%WINDIR%\System32\Zeale\TempFolder" RMDIR /S /Q "%WINDIR%\System32\Zeale\TempFolder"
)
:: Display our little title
ECHO Welcome to [91;1mCookie[0m!
ECHO.
:::: TODO Extract to an initialization file.

ECHO Initializing [91mGlobal Variables[0m
SET adminMode=FALSE
SET debugMode=FALSE
SET mode=none
::::
:: THE FOLLOWING VARIABLES SHOULD BE TREATED AS IF THEY WERE PRIVATE TO THE HEAD LABEL
::::
SET Cookie.HeadLoaded=TRUE

ECHO Initializing [94mPowershell[0m
:: Call random powershell cmd to wake it up.
powershell "start-sleep -m 0"

IF %Cookie.AdminMode%==TRUE (
	IF NOT EXIST Zeale\Cookie\Modules\Install.bat (
		CALL bitsadmin.exe /transfer Cookie-Load-Installer "https://raw.githubusercontent.com/Zeale/Cookie/master/Modules/Install.bat" c:\Windows\System32\Zeale\Cookie\Modules\Install.bat
	)
)
ECHO.
ECHO [93;1mDONE[0m [93;1m:D[0m

TIMEOUT /T 1 >NUL

:: Scroll down (move text up) by one line each call (each second). This occurs five times. At last the program
:: will clear the screen to keep the "Please enter cmd" text at a good location for the viewer.
::
:: The user can push a key to end from a single timeout call.
TIMEOUT /T 1 >NUL
ECHO Press a key to continue...
PAUSE > NUL
CLS

:: Query user for their command.
:Command

ECHO [97;1mPlease enter your command below.[0m
ECHO.
SET /P command=""

IF /I "%command%"=="exit" (
	SET /P check="Are you sure???... (Y/N?)   "
	IF /I "!check!"=="Y" EXIT /B
	IF /I "!check!"=="N" (
		ECHO Aborted exit...
		GOTO Command
	)
)

IF /I "%command%"=="admin" (
	IF /I "%adminMode%"=="TRUE" (
		SET adminMode=FALSE
		ECHO Disabled [93madminMode[0m.
		GOTO Command
	) ELSE (
		SET adminMode=TRUE
		ECHO Enabled [93madminMode[0m.
		GOTO Command
	)
)

IF /I "%command%"=="debug" (
	IF /I "%debugMode%"=="TRUE" (
		SET debugMode=FALSE
		ECHO Disabled [93mdebugMode[0m.
		GOTO Command
	) ELSE (
		SET debugMode=TRUE
		ECHO Enabled [93mdebugMode[0m.
		GOTO Command
	)
)

IF /I "%command%"=="title" GOTO Title

IF /I "%command%"=="cls" GOTO ClearScreen
IF /I "%command%"=="clrscrn" GOTO ClearScreen
IF /I "%command%"=="clearscreen" GOTO ClearScreen

IF /I "%command%"=="files" CALL "Zeale\Cookie\Modules\Files.bat"

IF %Cookie.AdminMode%==TRUE (
	IF /I "%command:~0,9%"=="uninstall" (
		GOTO Uninstall
	)
	IF /I "%command:~0,7%"=="modules" (
		SETLOCAL enableDelayedExpansion
		SET module="%command:~8%"
		GOTO Modules
	)
	IF /I "%command:~0,6%"=="module" (
		SETLOCAL enableDelayedExpansion
		SET module="%command:~7%"
		GOTO Modules
	)
	IF /I "%command:~0,4%"=="mods" (
		SETLOCAL enableDelayedExpansion
		SET module="%command:~5%"
		GOTO Modules
	)
	IF /I "%command:~0,3%"=="mod" (
		SETLOCAL enableDelayedExpansion
		SET module="%command:~4%"
		GOTO Modules
	)

	IF /I "%command:~0,7%"=="install" (
		CALL "%~dp0\Modules\Install.bat" "%command:~8%"
		GOTO Command
	)
) ELSE (
	ECHO [91mYou must run Cookie as an administrator to use this command.[0m
)

IF /I "%command%"=="color" GOTO Color


ECHO The command, [92m%command%[0m, was unrecognized.
ECHO.
GOTO Command

:ClearScreen
cls
ECHO [96mScreen cleared![0m
ECHO.
ECHO.
GOTO Command

:Title
ECHO Please enter the title you want to set. (Enter [92m^<random^>[0m or [92m^|random^|[0m for a random title.)
ECHO Enter [92m^<back^>[0m (or [92m^|back^|[0m) to go back.
ECHO.
SETLOCAL enableDelayedExpansion
SET /P title=""
IF /I !title!==^<back^> GOTO Command
IF /I !title!==^|back^| GOTO Command
:::: TODO generate random title upon user request.
TITLE !title!
ENDLOCAL
GOTO Command

:Color
cls
SETLOCAL enableDelayedExpansion
ECHO Please select an option:
ECHO.
ECHO 1: Enter a hex color code.
ECHO 2: Select colors from a list.
ECHO.
ECHO.
SET /P option=""
IF "!option!"=="1" (
	CLS
	ECHO Please enter a Hex color code below.
	ECHO.
	SET /P color=""
	COLOR !color! || ECHO TEST
	pause
	ECHO Colors have been set!
	GOTO Command
)

ENDLOCAL
GOTO Command

:Modules
IF EXIST Zeale\Cookie\Modules\!module!.bat (
	:: Module names can't have spaces, so there is no need for these quotes, but if something changes later...
	CALL "Zeale\Cookie\Modules\!module!.bat"
	:: Once they're done with that module, execution will come back here. Then we go to Command.
	ENDLOCAL
	GOTO Command
)
IF NOT !module!1==1 (
	IF EXIST Zeale\Cookie\Modules\!module! (
		CALL "Zeale\Cookie\Modules\!module!"
		ENDLOCAL
		GOTO Command
	)
)

IF EXIST Zeale\Cookie\Modules\!module!.exe (
	CALL "Zeale\Cookie\Modules\!module!.exe"
	ENDLOCAL
	GOTO Command
)
ECHO [91mThe module specified could not be found.[0m
ENDLOCAL
GOTO Command

:Uninstall
SET param=%command:~10%
IF /I "%param:~-4%"==".bat" (
	IF EXIST %WINDIR%\System32\Zeale\Cookie\Modules\%param% (DEL /Q /F "%WINDIR%\System32\Zeale\Cookie\Modules\%param%")
) ELSE (
	IF /I "%param:~-4%"==".exe" (
		IF EXIST %WINDIR%\System32\Zeale\Cookie\Modules\%param% (DEL /Q /F "%WINDIR%\System32\Zeale\Cookie\Modules\%param%")
	) ELSE (
		IF EXIST "%WINDIR%\System32\Zeale\Cookie\Modules\%param%.bat" (DEL /Q /F "%WINDIR%\System32\Zeale\Cookie\Modules\%param%.bat") ELSE (
			IF EXIST "%WINDIR%\System32\Zeale\Cookie\Modules\%param%.exe" (DEL /Q /F "%WINDIR%\System32\Zeale\Cookie\Modules\%param%.exe") ELSE (
				ECHO [91mThe Module was not found...[0m
				ECHO Press a key to continue...
				PAUSE > NUL
				GOTO Command
			)
		)
	)
)
ECHO [92mThe module was successfully deleted![0m
ECHO Press a key to continue...
PAUSE > NUL
GOTO Command
