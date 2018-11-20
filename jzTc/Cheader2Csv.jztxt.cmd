REM the following batch file should be adapted to the position of zbnfjax on hard disk. Template see zbnfjax/batch_template/jztxtcmd.bat
JZtxtcmd.bat %0 %1 %2
REM alternatively:
::set ZBNFJAX_HOME=D:/vishia/ZBNF/zbnfjax
::java -cp %ZBNFJAX_HOME%/zbnf.jar org.vishia.jztxtcmd.JZtxtcmd  %0 %1 %2

exit /B

==JZtxtcmd==

##jzTc script to generate a csv file for excel with information from header.
##invoke this batch with 2 arguments: path/to/headerfile.h path/to/dst.csv 
##made by Hartmut Schorrig, 2018-02

##TODO parse result should be a JZtxtcmd variable, join both concepts.
Obj descrParser = java new org.vishia.zbnf.ZbnfParser(console);
descrParser.setSyntax(<:>
root::=[!\>]<*\e?text>.
<.>);


sub genCsv(Obj target: org.vishia.cmd.ZmakeTarget, String html = null)
{
  call genDstFiles(target = target, html=html, genRoutine="genCsvHeader", fileExt=".csv");
}




################################################################################################################
##
##The routine to generate reflection files, one file per header file.
##It parses all header files one after another, then generates reflection
##
sub genCsvHeader(Obj headerfile, String fileDst)
{
  Openfile outCsv = fileDst;
    <+outCsv>
    <:>
====Type; Name
    <.><.+>
  for(classC: headerfile.listClassC) {
    for(entry: classC.entries) {
      if(  entry.whatisit == "structDefinition" 
        && not entry.description.noReflection
        && not(entry.name >= "Mtbl")
        && not(entry.name >= "Vtbl")
        ) {
        ##
        ##check whether a Bus should be generated.
        ##
        <+outCsv>
        <:>
========<&entry.name>;;;;
========Bit;Name;Description;32;<.><.+>
        <+outCsv><:call:genCsvStruct:struct=entry><.+>
        
      }
      if(entry.whatisit == "unionDefinition") {
        <+>  union <.n+>
        for(variant: entry.attribs) {
          if(variant.struct) {
            <+>  :struct <&variant.struct.tagname>  <.+n>
            
          }
        }
      }
    }
  
  }
  outCsv.close();
}




sub genCsvStruct(Obj struct) 
{ Num nrElements = 0;
  for(entry:struct.entries){if(entry.name) {
    nrElements = nrElements +1;
  } }
  <+out>nrElements=<&nrElements><.+n>
  Num nrBit = 0;
  for(entry:struct.attribs){ 
    String sTypeRefl;
    String bytesType;
    String modifier;
    Obj typeRefl;
    if(entry.description.reflType) {
      typeRefl = entry.description.reflType;
    } elsif(entry.type) {
      typeRefl = entry.type;
    }
    if(typeRefl.pointer){ modifier = "*"; }  ##reference type, from primitive or class type. 
    if(entry.macro && entry.macro == "OS_HandlePtr") {  ##special macro for bus - handle
      sTypeRefl = <:>&reflection_<&typeRefl.name><.>;
      modifier = "*";
    } elsif(typeRefl) {  
      bytesType = bytesSimpleTypes.get(typeRefl.name);
      if(bytesType){ modifier = <:>(<&bytesType><<kBitPrimitiv_Modifier_reflectJc)<.>; } else { modifier = "0"; }
      sTypeRefl = reflSimpleTypes.get(typeRefl.name);
      if(!sTypeRefl) { 
        sTypeRefl = <:>&reflection_<&typeRefl.name><.>; 
      }
    } else {
      //another macro is ignored.
    }
    String arraysize;
    if(entry.arraysize.value) {
      arraysize = <:><&entry.arraysize.value> //nrofArrayElements<.>;
      modifier = <:><&modifier> | kStaticArray_Modifier_reflectJc<.>;
    } else {
      arraysize = "0";
    }
    if((entry.arraysize || not bytesType) && not typeRefl.pointer && not typeRefl.pointer2) {
      modifier = <:><&modifier>[]<.>;
    }
    if(typeRefl.pointer) { modifier = <:><&modifier>*<.>; }
    if(!sTypeRefl) { ##else: a #define
      sTypeRefl = "";
    }
    String description="";
    if(entry.description) {
      description = entry.description.text;
    }
    if(entry.name) {
      if(entry.bitField) {
        <:>
==========<&nrBit>;<&entry.name>;<&description>;<&entry.bitField>;<.>
      } else {
        <:>
==========X;<&entry.name>;<&description>;;<.>
      }
    } else {
      <:>
========<&nrBit>;;<&description>;<&entry.bitField>;<.>
    }
    if(not entry.bitField || entry.bitField ==0) { nrBit = 0; } else { nrBit = nrBit + entry.bitField; }
  } //for
  
}




