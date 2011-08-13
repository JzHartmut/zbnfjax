echo off


REM Notation rules: Remarks are signed with a REM-Line,
::  But alternate settings should be remarks with 2 colons as comment chars.
REM This exemplar is a template. It should be adapted to the users environment.
REM More Samples of user locations are provided as commented lines.


REM =====================================================================================================
REM Location of the zbnfjax tools. The default for setup is given. 

set ZBNFJAX_HOME=D:\vishia\ZBNF\sf\ZBNF\zbnfjax
::set ZBNFJAX_HOME=D:\Progs\zbnfjax


REM =====================================================================================================
REM The TMP_ZBNFJAX - environment variable is used inside some scripts to save temporary files.
REM Mostly it should be a relative local path beside the working directory.
REM The rule is: If the user has set it outside first, it is not changed here.

if "%TMP_ZBNFJAX%"=="" set TMP_ZBNFJAX=..\tmp
if not exist %TMP_ZBNFJAX% mkdir %TMP_ZBNFJAX%

REM =====================================================================================================
REM Some XML-Tools are necessary to work. There can be used as open-source.
REM The downloaded XML Tools are found at another directory of the hard disk.
REM At this location the following files and directories should be present:
REM * jdom.jar                http://www.jdom.org
REM * org.apache.ant_1.6.5    http://ant.apache.org
REM * saxon9-jdom.jar         http://www.saxonica.com
REM * saxon9.jar              http://www.saxonica.com
REM * saxon9he.jar    - it isn't sufficient.

set XML_TOOLS=V:\Progs\XML_Tools


REM =====================================================================================================
REM Location of the Java JDK installation, it should be at least version 6. 

set JAVA_JDK=D:\Progs\JAVA\jdk1.6.0_21


REM =====================================================================================================
REM Calling command to invoke java for command line and for GUI
REM The JAVA_EXE may located in the jre folder of the used JAVA_JDK
REM or it can be another (maybe newer) version as the java-compiler, located in another folder.
REM Hint: Don't write the content of set in "", also the path may contain spaces!

REM variant: use java-call direct.
::set JAVA_HOME=%JAVA_JDK%
::set JAVA_EXE=java
::set JAVAW_EXE=javaw

REM variant: use existing JAVA_HOME-variable:
::set JAVA_EXE=%JAVA_HOME%/bin/java
::set JAVAW_EXE=%JAVA_HOME%/bin/javaw

REM other variant: use JRE inside installed JDK:
set JAVA_HOME=%JAVA_JDK%\jre
set JAVA_EXE=%JAVA_JDK%\jre\bin\java"
set JAVAW_EXE=%JAVA_JDK%\jre\bin\javaw"

REM other variant: Only jre is installed:
::set JAVA_HOME=D:\Programs\JAVA\jre1.6.0_21
::set JAVA_EXE=%JAVA_HOME%\bin\java
::set JAVAW_EXE=%JAVA_HOME%\bin\javaw


  
REM =====================================================================================================
REM Location of the ANT-Library

set ANT_HOME=%XML_TOOLS%\org.apache.ant_1.6.5
::set ANT_HOME=D:\Progs\eclipse3_3\plugins\org.apache.ant_1.6.5
::set ANT_HOME=D:\Progs\eclipse3_3\plugins\org.apache.ant_1.7.0.v200706080842


REM =====================================================================================================
REM Location of the class files of a local Eclipse workspace
REM This should be only setted if tests with actual Eclipse compiled sources should be done.
::set ECLIPSE_CP=D:\Eclipse.wrk\Eclipse3_3\vishia\bin
set ECLIPSE_CP=


REM =====================================================================================================
REM Location of the Java2C_Toolbase scripts. It is not a part of zbnfjax.
set JAVA2C_TOOLBASE=D:\Progs\Java2C


REM === End of adaption =================================================================================



REM =====================================================================================================
REM Some deviated environment variables are set. They are used in the scripts. 
REM Do not change if you are not tested special cases as expert! 

REM Compatibility with oder scripts:
set XML_TOOLBASE=%ZBNFJAX_HOME%

REM Some JAVA_CP_xxx are used also in ANT-scripts.

REM Java-Classpath for Execution only Zbnf, Zbnf2Xml
set JAVACP_ZBNF=%ZBNFJAX_HOME%/zbnf.jar;%ZBNFJAX_HOME%/zmakeAnt.jar


REM Java-Classpath for the additional download parts saxon and jdom:
REM see http://www.jdom.org, http://www.saxonica.com/
set JAVACP_SAXON=%XML_TOOLS%/jdom.jar;%XML_TOOLS%/saxon9.jar;%XML_TOOLS%/saxon9-jdom.jar


REM Java-Classpath for Execution of Xslt. This should be include the jars for JDOM and SAXON, see http://www.jdom.org, http://www.saxonica.com/
set JAVACP_XSLT=%JAVACP_ZBNF%;%ZBNFJAX_HOME%/zmake.jar;%ZBNFJAX_HOME%/xslt.jar;%JAVACP_SAXON%

REM Java-Classpath for Execution of Header2Reflection.
set JAVACP_Header2Reflection=%ZBNFJAX_HOME%/header2Reflection.jar;%ZBNFJAX_HOME%/zbnf.jar

REM delete the environment variable XML_TOOLS, it is only temporary, its content is used in the other environments.
set XML_TOOLS=


REM expands the common PATH with the used java VM and XML-Tools:
set PATH=%ZBNFJAX_HOME%\batch;%ANT_HOME%;%JAVA_HOME%\bin;%PATH%

REM sets the CLASSPATH common variable using from ANT and java call without classpath:
set CLASSPATH=%JAVACP_XSLT%

REM callable java for xml, use %JAX_EXE% class arguments
set JAX_EXE=%JAVA_EXE% -cp %JAVACP_XSLT%

REM calling special progs via java:
set ZBNF2XML_EXE=%JAVA_EXE% -cp "%JAVACP_ZBNF%" org.vishia.zbnf.Zbnf2Xml
set XSLT_EXE=%JAVA_EXE% -cp %JAVACP_XSLT% org.vishia.xml.Xslt
set ZMAKE_EXE=%JAVA_EXE% -cp "%JAVACP_XSLT%" org.vishia.zbnf.Zmake
set Header2Reflection_EXE=%JAVA_EXE% -cp %JAVACP_Header2Reflection% org.vishia.header2Reflection.CmdHeader2Reflection


REM =====================================================================================================
REM The next statements test the correctness of the settings, don't change it!
REM If any error occurs, the batch process is stopped! Please correct the settings in the first block
REM or install the tools!

if "%1"=="silent" goto :silent
echo ========================================ZBNFJAX_HOME environment ===========
::echo PATH=%PATH%
echo TMP_ZBNFJAX=%TMP_ZBNFJAX%
echo ZBNFJAX_HOME=%ZBNFJAX_HOME%
echo JAVA_HOME = %JAVA_HOME%
echo JAVA_EXE = %JAVA_EXE%
echo ANT_HOME = %ANT_HOME%
echo ECLIPSE_CP=%ECLIPSE_CP%
echo ==== composed environment ==================================================
echo CLASSPATH = %CLASSPATH%               
echo JAX_EXE = %JAX_EXE%                 
echo ZBNF2XML_EXE = %ZBNF2XML_EXE%            
echo XSLT_EXE = %XSLT_EXE%               
echo ZMAKE_EXE = %ZMAKE_EXE%               
echo JAVACP_ZBNF=%JAVACP_ZBNF%
echo JAVACP_XSLT=%JAVACP_XSLT%
echo JAVACP_Header2Reflection=%JAVACP_Header2Reflection%
echo ============================================================================
"%JAVA_EXE%" -version
if errorlevel 1 set ERRORMSG=JAVA_EXE
echo ============================================================================
:silent

set ERRORMSG=
if not exist "%TMP_ZBNFJAX%" set ERRORMSG=%ERRORMSG% TMP_ZBNFJAX
if not exist "%ANT_HOME%\lib\ant.jar" set ERRORMSG=%ERRORMSG% ANT_HOME
if not exist "%ZBNFJAX_HOME%\XmlDocu_xsl" set ERRORMSG=%ERRORMSG% ZBNFJAX_HOME
::if not exist "%JAVA_HOME%\bin\java.exe" set ERRORMSG=%ERRORMSG% JAVA_HOME

if "%ERRORMSG%"=="" goto :ok
  echo setZBNFJAX_HOME.bat: Environemnt variable(s) %ERRORMSG% is/are not correct. abort.!
  pause
	::if "%NOPAUSE%" = "" pause
  exit 255
:ok
::pause
