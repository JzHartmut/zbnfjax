This directory contains some MS-Windows batch files.
 
That files should be copied to a folder which is member of the PATH environment variable.
Then that files should be adapted to the conditions of the operation file system, especially
* Invocation of java runtime
* Path to the ZBNF/zbnfjax directory, contained in the ZBNFJAX_HOME environement variable.

That are only a few files with less effort to adapt. The manual adaption may be better that a complex automatism.

* JZcmd.bat: start of any JZcmd script, need adapt java invocation and ZBNFJAX_HOME

* setZBNFJAX_HOME.bat: sets some environment variables, Path to ZBNFJAX_HOME and Path to XML_Tools etc. see description there.

* zbnfjax.bat: No adaption necessary, because it calls setZBNFJAX_HOME.bat internally which is adapted.




