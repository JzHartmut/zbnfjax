REM Task: Compilation javac and call jar inside the zbnfjax shell

REM --------------------------------------------------------------------------------------------
REM Environment variables set from zbnfjax:
REM JAVA_HOME: Directory where bin/javac is found. This java version will taken for compilation

REM ---------------------------------------------------------------------------------------------
REM Environment variables should be set as Input before calling zbnfjax or this script:
REM TMP_JAVAC: Directory for all class files and logs: The directory will be cleaned and created
REM INPUT_JAVAC: All primary input java files to compile separated with space
REM CLASSPATH_JAVAC: PATH where compiled classes are found, relativ from current dir or absolute
REM SRCPATH_JAVAC: PATH where sources are found, relativ from current dir or absolute
REM OUTPUTFILE_JAVAC: Path/file.jar relative from current diretory for the jar-file
REM MANIFEST_JAVAC: Path/file.manifest relative from currect dir for manifest file

REM delete and create the tmp_javac new. It should be empty because all content will be stored in the jar-file.
if exist %TMP_JAVAC% rmdir %TMP_JAVAC% /S /Q
mkdir %TMP_JAVAC%
mkdir %TMP_JAVAC%\bin

REM delete the result jar-file
if exist %OUTPUTFILE_JAVAC% del /F /Q %OUTPUTFILE_JAVAC%
if exist %OUTPUTFILE_JAVAC%.ERROR.txt del /F /Q %OUTPUTFILE_JAVAC%.ERROR.txt

::echo === javac -sourcepath %SRCPATH_JAVAC% -classpath %CLASSPATH_JAVAC% %INPUT_JAVAC%
echo on
%JAVA_HOME%\bin\javac.exe -deprecation -d %TMP_JAVAC%/bin -sourcepath %SRCPATH_JAVAC% -classpath %CLASSPATH_JAVAC% %INPUT_JAVAC% 1>>%TMP_JAVAC%\javac_ok.txt 2>%TMP_JAVAC%\javac_error.txt
@echo off
if not errorlevel 1 goto :okJavac
  echo ===Compiler error
  type %TMP_JAVAC%\javac_ok.txt
  type %TMP_JAVAC%\javac_error.txt
  REM show the error in a locally file:
  copy %TMP_JAVAC%\javac_ok.txt+%TMP_JAVAC%\javac_error.txt %OUTPUTFILE_JAVAC%.ERROR.txt
  REM exit only the batch level, not the cmd.exe, support batch compilation of some more sources.
  exit /B 1
:okJavac

::@echo on
if not "%JARSRC1%" == "" xcopy %JARSRC1% %TMP_JAVAC%\bin\%JARDST1% 
if not "%JARSRC2%" == "" xcopy %JARSRC2% %TMP_JAVAC%\bin\%JARDST2% 
if "%JARSRC3%" neq "" xcopy %JARSRC3% %TMP_JAVAC%\bin\%JARDST3% 
if "%JARSRC4%" neq "" xcopy %JARSRC4% %TMP_JAVAC%\bin\%JARDST4% 
@echo off

REM The jar works only correct, if the current directory contains the classfile tree:
REM store the actual directory to submit restoring on end
set ENTRYDIR=%CD%
cd %TMP_JAVAC%\bin
echo === SUCCESS compiling, generate jar: %ENTRYDIR%\%OUTPUTFILE_JAVAC%

echo on
%JAVA_HOME%\bin\jar.exe -cvfm %ENTRYDIR%\%OUTPUTFILE_JAVAC% %ENTRYDIR%\%MANIFEST_JAVAC% *  1>..\jar_ok.txt 2>..\jar_error.txt
@echo off

if exist %ENTRYDIR%\%OUTPUTFILE_JAVAC% goto :okJar
  echo === ERROR jar
  type ..\jar_ok.txt
  type ..\jar_error.txt
  REM show the error in a locally file:
  copy ..\jar_ok.txt+..\jar_error.txt %ENTRYDIR%\%OUTPUTFILE_JAVAC%.ERROR.txt
  REM exit only the batch level, not the cmd.exe, support batch compilation of some more sources.
  cd %ENTRYDIR%
  exit /B 1
:okJar

REM restore current dir: %ENTRYDIR%
cd %ENTRYDIR%
echo === SUCCESS making %OUTPUTFILE_JAVAC%.
