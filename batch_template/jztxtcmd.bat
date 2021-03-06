@echo off
REM This is the start batch for JZcmd execution for MS-Windows.
REM It should be copied in a directory which is referenced by the Operation system's PATH
REM and adapt with the paths to Java and the other tools.
REM All what is need to run JZcmd is referenced here. 
 
REM The TMP variable may used by any scrips. Set it to a defined location if necessary:
set TMP=d:\tmp

REM adapt the path to the zbnfjax folder of vishia-ZBNF tools.
REM It contains the jar archive for execution of JZcmd and some JZcmd scripts which may be included.
set ZBNFJAX_HOME=D:/vishia/ZBNF/zbnfjax

REM If necessary adapt the PATH for a special java version. Comment it if the standard Java installation should be used.
REM Note Java does not need an installation. It runs well if it is only present in the file system.
set JAVA_HOME=D:\Programs\JAVA\JRE
set PATH=%JAVA_HOME%\bin;%PATH%

REM adapt the path to the Xml-Tools. See zbnfjax-readme. 
REM The XML tools are necessary for some XML operations. This environment variable may be used in some JZtxtcmd scripts. 
REM Comment it if not used.
set XML_TOOLS=D:\Programs\XML_Tools

REM This is the invocation of JZcmd, with up to 9 arguments.
java -cp %ZBNFJAX_HOME%/zbnf.jar org.vishia.jztxtcmd.JZtxtcmd   %1 %2 %3 %4 %5 %6 %7 %8 %9
if errorlevel 1 pause

