@ECHO off
GOTO Head

Welcome to COOKIE. A couple of notes here before the program starts.

1. If you find any characters in this document that appear as boxes, (specifically this:  character),
	then don't worry; that's the escape character. It's used to change the foreground and background color
	of text, along with some other things such as underlining text, or making it bold. You can check out
	'https://stackoverflow.com/a/38617204' for a list of color codes and their outputs.

2. The program starts in this file and immediately goes to the head label below, so all of these "notes"
	don't get processed as batch commands.
	
	NOTE: that the :Head label directly leads into the :Command label; there are no needs for GOTO
	statements since the :Command label directly proceeds the :Head label. After :Head is done, :Command is
	run.

3. All my "TODO" markings have been stated with 4 semicolons, rather than only two. This makes them slightly
	easier to find.


:Head
:: Make sure things haven't already been loaded.
IF DEFINED Cookie.HeadLoaded (
	IF "%Cookie.HeadLoaded%"=="TRUE" GOTO Command
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

ECHO.
ECHO [93;1mDONE[0m [93;1m:D[0m

TIMEOUT /T 1 >NUL

:: Scroll down (move text up) by one line each call (each second). This occurs five times. At last the program
:: will clear the screen to keep the "Please enter cmd" text at a good location for the viewer.
::
:: The user can push a key to end from a single timeout call.
ECHO [1S
TIMEOUT /T 1 >NUL
ECHO [1S
TIMEOUT /T 1 >NUL
ECHO [1S
TIMEOUT /T 1 >NUL
ECHO [1S
TIMEOUT /T 1 >NUL
ECHO [1S
TIMEOUT /T 1 >NUL
CLS

:: Query user for their command.
:Command

ECHO [97;1mPlease enter your command below.[0m
ECHO.
SET /P command=""

IF /I "%command%"=="admin" (
	SET adminMode=TRUE
	GOTO Command
)

IF /I "%command%"=="debug" (
	SET debugMode=TRUE
	GOTO Command
)

IF /I "%command%"=="files" CALL "Resources/Files.bat"

ECHO The command, [92m%command%[0m, was unrecognized.
ECHO.
GOTO Command
