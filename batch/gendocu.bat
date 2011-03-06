echo off
cls
call setZBNFJAX_HOME.bat
echo ZBNFJAX_HOME=%ZBNFJAX_HOME%;
set INPUT=%1


echo on
::%ZMAKE_EXE%
::pause
%ZMAKE_EXE% -i:%INPUT% -tmp:%TMP_ZBNFJAX% -tmpantxml:ant_%INPUT%.xml -zbnf4ant:XmlDocu_xsl/DocuGenCtrl.zbnf -xslt4ant:XmlDocu_xsl/DocuGenCtrl2Ant.xslp -ZBNFJAX_HOME=%ZBNFJAX_HOME% --rlevel:335 --report:../tmp/Zmake.rpt
if errorlevel 1 goto :error
call %ANT_HOME%\bin\ant -f %TMP_ZBNFJAX%/ant_%INPUT%.xml -logfile %TMP_ZBNFJAX%/ant_%INPUT%.xml.log -DcurDir="%CD%"
if errorlevel 1 goto :error
copy %ZBNFJAX_HOME%\XmlDocu_xsl\htmlstd.css ..\html\*
pause
goto :ende

:error
pause
:ende

