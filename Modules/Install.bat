:: This module will be included in the initial program.
@echo off
IF NOT DEFINED Cookie.HeadLoaded (
	ECHO %~n0%~x0 is an extension of Cookie.bat and, therefore, must be called from Cookie.bat.
	TIMEOUT /T 10
	GOTO :EOF
)
SET filename=%~1
IF /I "%filename:~-4%"==".bat" SET "filename=%filename:~0,-4%"
IF EXIST "c:\Windows\System32\Zeale\Cookie\Modules\%filename%.bat" DEL "c:\Windows\System32\Zeale\Cookie\Modules\%filename%.bat"
ECHO.
ECHO.
ECHO [91m Cookie will now attempt to install the given file. Progress and other information will be displayed in green.[92m
@echo on
CALL bitsadmin.exe /transfer Cookie-Install-%filename% "https://raw.githubusercontent.com/Zeale/Cookie/master/Modules/%filename%.bat" c:\Windows\System32\Zeale\Cookie\Modules\%filename%.bat
@echo off
ECHO [0m