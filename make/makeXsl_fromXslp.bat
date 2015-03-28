echo off
cls
call setZBNFJAX_HOME.bat
if not exist ..\tmp mkdir ..\tmp
if not exist ..\XmlDocu_xsl\gen mkdir exist ..\XmlDocu_xsl\gen
if not exist ..\xsl\gen mkdir exist ..\xsl\gen
if exist ..\XmlDocu_xsl\gen\*.* del /F /Q ..\XmlDocu_xsl\gen\*.* 
if exist ..\xsl\gen\*.* del /F /Q ..\xsl\gen\*.* 

:: echo %JAVA_HOME%
echo off
%ZMAKE_EXE% -i:makeXsl_fromXslp.bat -tmp:../tmp -tmpantxml:ant_makeXsl_fromXslp.xml -zbnf4ant:xsl/ZmakeStd.zbnf -xslt4ant:xsl/ZmakeStd.xslp --rlevel:334 --report:../tmp/makeXsl_fromXslp.rpt
if errorlevel 1 goto :error
call %ANT_HOME%\bin\ant -f ../tmp/ant_makeXsl_fromXslp.xml  -DcurDir="%CD%"
if errorlevel 1 goto :error
pause
goto :ende

:error
echo error
pause
:ende
exit /B


ZMAKE_RULES:

../XmlDocu_xsl/gen/*.xsl := Xsltpre
( srcpath="../XmlDocu_xsl"
//, Data3Struct2ihcpp.xslp
, DocuGenCtrl2Ant.xslp
, DocuGenCtrl2Xsl.xslp
, RequCrossRef.xslp
, XmiDocu.xslp
, HeaderDocu.xslp

);

../xsl/gen/*.xsl := Xsltpre
( srcpath="../xsl"
//, CHeader2ByteDataAccess_Java.xslp
, Cheader2Xmi.xslp
, Java2xmi.xslp
, ZmakeStd.xslp
);

