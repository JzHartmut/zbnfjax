::echo off
REM shell for invoking commands for ZBNF or ZBNFJAX_HOME

call setZBNFJAX_HOME.bat silent
::echo on

if not "%1" == "call" goto :nCall
  %2 %3 %4 %5 %6 %7 %8 %9
  goto :ende
:nCall 
if not "%1" == "genDocu" goto :nGenDocu
  %ZBNFJAX_HOME%\batch\cmdDocuGctr.bat %2
  goto :ende
:nGenDocu  
if not "%1" == "javacjar" goto :nJavac
  %ZBNFJAX_HOME%\batch\javacjar.bat %2
  goto :ende
:nJavac
if not "%1" == "java" goto :nJava
  %JAX_EXE% %2 %3
  goto :ende
:nJava
if not "%1" == "zmakeAnt" goto :nZmakeAnt
  %ZBNFJAX_HOME%\batch\zmakeAnt.bat %2
  goto :ende
:nZmakeAnt  
if not "%1" == "zmake" goto :nZmake
  echo Hint: use zmakeAnt instead zmake as cmd argument of zbnfjax for future compatibility!
  %ZBNFJAX_HOME%\batch\zmakeAnt.bat %2
  goto :ende
:nZmake
if not "%1" == "zmakeGen" goto :nZmakeGen
  echo zbnfjax zmakeGen: %2 %3 %4 %5 %6 %7 %8 %9 >>%TMP_ZBNFJAX%\zbnfjax.log"
  %JAVA_EXE% -cp "%JAVACP_XSLT%" org.vishia.zmake.Zmake %2 %3 %4 %5 %6 %7 %8 %9
  goto :ende
:nZmakeGen
if not "%1" == "zbnf2xml" goto :nZbnf2Xml
  %JAVA_EXE% -cp %JAVACP_ZBNF% org.vishia.zbnf.Zbnf2Xml %2 %3 %4 %5 %6 %7 %8 %9
  goto :ende
:nZbnf2Xml
if not "%1" == "zbnf2xml" goto :nCHeader2JB
  %ZBNFJAX_HOME%\batch\CHeader2JavaByteCoding.bat %2
  goto :ende
:nCHeader2JB
if not "%1" == "Header2Reflection" goto :nHeader2Refl
  echo on
	%Header2Reflection_EXE% %INPUT% %2 %3 %4 %5 %6 %7 %8 %9
  @echo off
	goto :ende
:nHeader2Refl
if not "%1" == "winCCvarFromSCL" goto :nwinCCvarFromSCL
  %ZBNFJAX_HOME%\batch\winCCvarFromSCL.bat %2 %3
  goto :ende
:nwinCCvarFromSCL
if not "%1" == "vxslt" goto :nvxslt
  echo on
  %JAVA_EXE% -cp %JAVACP_XSLT% org.vishia.xml.Xslt %2 %3 %4 %5 %6 %7 %8 %9
  goto :ende
:nvxslt
  echo fault command %1, expected: call, genDocu, java, javacjar, zmakeAnt, zmake, zbnf2xml
  pause
  goto :ende
:ende  