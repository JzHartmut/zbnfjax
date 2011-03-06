echo off
echo CHeader2JavaByteCoding.bat %INPUT% to %DST%
if "%ZBNFJAX_HOME%"=="" call setZBNFJAX_HOME.bat
set INPUT=%1
set DST=%2
set SRC=%3
set PACKAGE=%4


::parse input
echo off
%JAVA_EXE% -cp %JAVACP_ZBNF% org.vishia.zbnf.Zbnf2Xml -i%SRC%%INPUT%.h -s%ZBNFJAX_HOME%/zbnf/Cheader.zbnf -y%TMP_ZBNFJAX%/%INPUT%.xml --rlevel:323 --report:%TMP_ZBNFJAX%/%INPUT%.zbnf.rpt
if errorlevel 1 goto :error

%JAX_EXE% org.vishia.xmlSimple.Xsltpre -i%ZBNFJAX_HOME%/xsl/CHeader2ByteDataAccess_Java.xslp -o%ZBNFJAX_HOME%/xsl/gen/CHeader2ByteDataAccess_Java.xsl --rlevel:324 --report:%TMP_ZBNFJAX%/GenDocuCtrl2Ant.xsl.rpt
if errorlevel 1 goto :error

echo generate %DST%%INPUT%_h.java
if exist %DST%%INPUT%_h.java del /F/Q %DST%%INPUT%_h.java
%JAX_EXE% net.sf.saxon.Transform -o %DST%%INPUT%_h.java %TMP_ZBNFJAX%/%INPUT%.xml %ZBNFJAX_HOME%/xsl/gen/CHeader2ByteDataAccess_Java.xsl outPackage="%PACKAGE%" outFile="%INPUT%_h"
if errorlevel 1 goto :error

echo success.

goto :ende
:error
  echo error
  pause
  exit /B 1;

:ende

