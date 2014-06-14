@echo off
REM may set the PATH for java in an user specific way, not need if java is present.
call setZBNFJAX_HOME.bat silent

java -cp ../zbnf.jar org.vishia.zcmd.JZcmd >JZcmd.help