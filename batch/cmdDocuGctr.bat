@echo on
echo cmdDocuGctr
set INPUT=%1
REM The environment variables may be set outside, elsewhere set it!
if "%TMP_ZBNFJAX%" == "" set TMP_ZBNFJAX=..\tmp
if not exist %TMP_ZBNFJAX% mkdir %TMP_ZBNFJAX%
if "%ZBNFJAX_HOME%" == "" call setZBNFJAX_HOME.bat

%JAX_EXE% org.vishia.zbnf.Zmake -i:%INPUT% -tmp:%TMP_ZBNFJAX% -tmpantxml:_antcmdDocuGctr.xml -zbnf4ant:XmlDocu_xsl/DocuGenCtrl.zbnf -xslt4ant:XmlDocu_xsl/DocuGenCtrl2Ant.xslp --rlevel:333 --report:%TMP_ZBNFJAX%/cmdDocuGctr.rpt
if errorlevel 1 goto :error
call %ANT_HOME%\bin\ant -f %TMP_ZBNFJAX%/_antcmdDocuGctr.xml  -DcurDir="%CD%"
if errorlevel 1 goto :error
REM don't copy the htmlstd.css here, because the destination directory is unknown really.
REM it should done in the calling script or done manually.
::copy %ZBNFJAX_HOME%\XmlDocu_xsl\htmlstd.css ..\html\*.*
::pause
goto :ende

:error
pause
:ende