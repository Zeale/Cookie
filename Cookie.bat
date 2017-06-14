@echo off
goto Head

Welcome to COOKIE. A couple of notes here before the program starts.

1. If you find any characters in this document that appear as boxes, (specifically this:  character),
   then don't worry; that's the escape character. It's used to change the foreground and background color
   of text, along with some other things such as underlining text, or making it bold. You can check out
   'https://stackoverflow.com/a/38617204' for a list of color codes and their outputs.

2. The program starts in this file and immediately goes to the head label below, so all of these "notes"
   don't get processed as batch commands.
   
   NOTE: that the :Head label directly leads into the :Command label; there are no needs for goto
   statements since the :Command label directly proceeds the :Head label. After :Head is done, :Command is
   run.

3. All my "TODO" markings have been stated with 4 semicolons, rather than only two. This makes them slightly
   easier to find.


:Head
:: Display our little title
echo Welcome to [91;1mCookie[0m!
echo.
:::: TODO Extract to an initialization file.

echo Initializing [91mData[0m
SET adminMode=FALSE
SET debugMode=FALSE

echo Initializing [94mPowershell[0m
:: Call random powershell cmd to wake it up.
powershell "start-sleep -m 0"

echo.
echo [93;101;1mDONE[0m [93m:D[0m

powershell "sleep -m 1500"

:: Scroll down (move text up) by one line each call (each second). This occurs five times. At last the program
:: will clear the screen to keep the "Please enter cmd" text at a good location for the viewer.
echo [1S
powershell "sleep -m 750"
echo [1S
powershell "sleep -m 750"
echo [1S
powershell "sleep -m 750"
echo [1S
powershell "sleep -m 750"
echo [1S
powershell "sleep -m 750"
cls

:: Query user for their command.
:Command
echo [97;1mPlease enter your command below.[0m
echo.
SET /P command=""

IF /I "%command%"=="admin" (
   SET adminMode=TRUE
   goto Command
)
