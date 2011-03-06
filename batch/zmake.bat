@echo off
REM This file is a frame to execute make with ant and zmake called from Rhapsody or direct
REM The current dir is either the directory where the INPUT is located or one level to inner directory.
REM This file should located inside a sandbox.
echo zmake.bat %1 %2 %3

set LOG=%2
if "%LOG%" equ "" set LOG=CON

set ERRLOG=%3
if "%ERRLOG%" equ "" set ERRLOG=CON

echo Logfile=%LOG%, Errlog=%ERRLOG%

REM clears ERRLOG
echo - >%ERRLOG%

echo zmake.bat %1 %2 %3 >>%LOG%

if "%1" == "" goto :help
set INPUT=%1
::set INPUTDIR=%2
REM to store actual directory to submit restoring on end, this is because calling from Rhapsody as onother current dir
set _ENTRYDIR=%CD%

REM test input. If it is called from Rhapsody the current dir is one inner.
if exist ..\%INPUT% cd ..
REM to show in output:
cd
if not exist %INPUT% goto :errorCurDir

REM a tmp will be created parallel to current dir.
if "%TMP_ZBNFJAX%" == "" set TMP_ZBNFJAX=..\tmp
if not exist %TMP_ZBNFJAX% mkdir %TMP_ZBNFJAX%
REM delete tmp content only in test cases:
::if exist %TMP_ZBNFJAX%\*.* del %TMP_ZBNFJAX%\*.* /F /Q

:: echo %JAVA_HOME%
REM calling Zmake to convert %INPUT% to ANT.xml, JAX_EXE see setANT_HOME.bat
if exist %TMP_ZBNFJAX%\zmake_ant.xml del %TMP_ZBNFJAX%\zmake_ant.xml 
echo %ZMAKE_EXE% %INPUT% -tmp=%TMP_ZBNFJAX% -tmpantxml:_ant_%INPUT%.xml -zbnf4ant=xsl/ZmakeStd.zbnf -xslt4ant=xsl/ZmakeStd.xslp --rlevel:333 --report:%TMP_ZBNFJAX%/_Zmake_%INPUT%.log 1>>%LOG% 2>>%ERRLOG%
%ZMAKE_EXE% %INPUT% -tmp=%TMP_ZBNFJAX% -tmpantxml:_ant_%INPUT%.xml -zbnf4ant=xsl/ZmakeStd.zbnf -xslt4ant=xsl/ZmakeStd.xslp --rlevel:333 --report:%TMP_ZBNFJAX%/_Zmake_%INPUT%.log 1>>%LOG% 2>>%ERRLOG%
if errorlevel 1 goto :errorZmake

echo calling ANT: 
call %ANT_HOME%\bin\ant -f %TMP_ZBNFJAX%/_ant_%INPUT%.xml -DcurDir=%CD% 1>>%LOG% 2>>%ERRLOG%
if errorlevel 1 goto :errorAnt

echo restore current dir: %_ENTRYDIR%
cd %_ENTRYDIR%

if "%LOG%" neq "CON" type %LOG%
if "%ERRLOG%" neq "CON" type %ERRLOG%
exit /B 0

:errorZmake
:errorAnt
if "%LOG%" neq "CON" type %LOG%
if "%ERRLOG%" neq "CON" type %ERRLOG%
echo -ERROR, log-output see %LOG% and %ERRLOG%
cd %_ENTRYDIR%
if "%@NO_PAUSE%" equ "" pause
  exit /B 4

:errorCurDir
  echo ERROR %INPUT% not found, curDir=%CD%
  if "%@NO_PAUSE%" equ "" pause
exit /B 5  

:help
echo antmake_rpy.bat calls zmake and than ant.
echo usage: antmake_rpy.bat ZMAKEFILE
echo ZMAKEFILE contains the rules for making in textual form, see antmake_rpy.zbnf
::echo DIR path to actual dir with \ on end, at example ..\ to select the parent dir
echo it uses a %TMP_ZBNFJAX% folder in current directory.
if "%@NO_PAUSE%" equ "" pause
exit /B 1 
