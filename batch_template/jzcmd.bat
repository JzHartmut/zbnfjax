REM adapt the path to the zbnfjax folder of vishia-ZBNF tools:
set ZBNFJAX_HOME=D:/vishia/ZBNF/sf/ZBNF/zbnfjax

REM If necessary adapt the PATH for a special java version. Comment it if the standard Java installation should be used.
REM Note Java does not need an installation. It runs well if it is only present in the file system.
set JAVA_HOME=D:\Programme\JAVA\jre7

set PATH=%JAVA_HOME%\bin;%PATH%

REM This is the invocation of JZcmd, with up to 9 arguments.
java -cp %ZBNFJAX_HOME%/zbnf.jar org.vishia.zcmd.JZcmd %1 %2 %3 %4 %5 %6 %7 %8 %9
