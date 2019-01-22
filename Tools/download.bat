@echo off

rem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rem		Download 1.0
rem
rem		DOWNLOAD FILES FROM SERVER TO LOCAL
rem     IN ORDER TO PUT ON SD CARD AND
rem     LOAD ON OUR EMBEDDED SYSTEMS
rem     PE: Raspberry
rem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

echo Download 1.0 

rem If configurated in local machine, use System values
set FORCE_LOCAL = %1
IF FORCE_LOCAL equ "LOCAL" GOTO FORCE_LOCAL_SETTING
IF %DONWLOAD_EXIST% equ "" GOTO NO_GLOBAL_SETTING

rem Global setting will be used so first parameter is FILENAME
echo Using System setting.
set FILENAME=%1

:RUN
IF "%FILENAME%" == "" GOTO USAGE
echo Running scp -P %PORT% %DUSER%@%IP_SRC%:%SRC%/%FILENAME% %DST%
scp -P %PORT% %DUSER%@%IP_SRC%:%SRC%/%FILENAME% %DST%
echo end Download 1.0
GOTO END


:FORCE_LOCAL_SETTING
echo Forced to use input setting.
rem If Input setting is forced, FILENAME is second parameter
set FILENAME=%2
set DUSER =%3
set IP_SRC=%4
set SRC=%5
set PORT=%6
set DST=%7
GOTO RUN

:NO_GLOBAL_SETTING
echo No System setting was found.
rem If not forced to input setting and no global exist, 
rem filename is first parameter
set FILENAME=%1
set DUSER =%2
set IP_SRC=%3
set SRC=%4
set PORT=%5
set DST=%6


:USAGE
echo USAGE:
echo At least filename must be passed as a parameter.
GOTO END


:END



