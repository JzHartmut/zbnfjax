REM the following batch file should be adapted to the position of zbnfjax on hard disk. Template see zbnfjax/batch_template/jztxtcmd.bat
JZtxtcmd.bat %0 %1 %2
REM alternatively:
::set ZBNFJAX_HOME=D:/vishia/ZBNF/zbnfjax
::java -cp %ZBNFJAX_HOME%/zbnf.jar org.vishia.jztxtcmd.JZtxtcmd  %0 %1 %2

exit /B

==JZtxtcmd==

##jzTc script to generate a Reflection.crefl file from some struct of Header.
##invoke this batch with 2 arguments: path/to/headerfile.h path/to/dst.crefl 
##made by Hartmut Schorrig,  

Class reflStructDefinition = org.vishia.header2Reflection.CheaderParser$StructDefinition;

Obj headerTranslator = java new org.vishia.header2Reflection.CheaderParser(console);


Map reflSimpleTypes = {
  String int = "REFLECTION_int32";
  String char = "REFLECTION_uint8";
  String uint32_t = "REFLECTION_uint32";
  String uint32 =   "REFLECTION_uint32";
  String int32_t =  "REFLECTION_int32";
  String int32 =    "REFLECTION_int32";
  String uint16_t = "REFLECTION_uint16";
  String Uint16 =   "REFLECTION_uint16";
  String int16_t =  "REFLECTION_int16";
  String int16 =    "REFLECTION_int16";
  String uint8_t =  "REFLECTION_uint8";
  String Uint8 =    "REFLECTION_uint8";
  String int8_t =   "REFLECTION_int8";
  String int8 =     "REFLECTION_int8";
  String float =    "REFLECTION_float";
  String double =   "REFLECTION_double";
};  

Map bytesSimpleTypes = {
  String int =      "4";
  String char =     "1";
  String uint32_t = "4";
  String uint32 =   "4";
  String int32_t =  "4";
  String int32 =    "4";
  String uint16_t = "2";
  String Uint16 =   "2";                                        
  String int16_t =  "2";
  String int16 =    "2";
  String uint8_t =  "1";
  String Uint8 =    "1";
  String int8_t =   "1";
  String int8 =     "1";
  String float =    "4";
  String double =   "8";
};  

    
                   
sub genReflStruct(Obj struct) 
{ Num nrElements = 0;
  for(entry:struct.entries){if(entry.name) {
    nrElements = nrElements +1;
  } }
  <:>
==
==extern_C const ClassJc reflection_<&struct.name>;  //the just defined reflection_ used in the own fields.
  <.>
  for(entry:struct.entries) { if(entry.name && entry.type) { ##Note a type is not present for a #define inside a struct.
    String typeRefl;
    if(not reflSimpleTypes.get(entry.type.name)) { 
      <:>
======extern_C const ClassJc reflection_<&entry.type.name>;  //used for field <&entry.name><.>      
    }
  }}
  if(struct.entries.size()>0) {
   Obj base = struct.entries.get(0);
   String reflSuperName;
   if(base ?instanceof reflStructDefinition && (base.name == "base" || base.name == "obj" || base.name == "object" || base.name == "super")) {
    if(base.isUnion) { ##base class and interface or ObjectJc are joined in a union. The first element should be the super class. 
      reflSuperName = <:>reflection_<&base.entries.get(0).type.name><.>;
    } else {
      reflSuperName = <:>reflection_<&base.type.name><.>;
    }
    <:>  
====
====const struct SuperClasses_<&struct.name>_ClassOffset_idxMtblJcARRAY_t  //Type for the super class
===={ ObjectArrayJc head;
====  ClassOffset_idxMtblJc data[1];
====}  superClasses_<&struct.name> =   //reflection instance for the super class
===={ INITIALIZER_ObjectArrayJc(ClassOffset_idxMtblJc, 1, OBJTYPE_ClassOffset_idxMtblJc, null, &superClasses_<&struct.name>)
====  , { &<&reflSuperName>, 0} //TODO Index of mtbl of superclass
====};
====<.>
  } }
  <:>
==const struct Reflection_Fields_<&struct.name>_t
=={ ObjectArrayJc head;
==  FieldJc data[<&struct.entries.size>];
==} reflection_Fields_<&struct.name> =
=={ CONST_ObjectArrayJc(FieldJc, <&nrElements>, OBJTYPE_FieldJc, null, &reflection_Fields_<&struct.name>)
==, { <.>
  for(entry:struct.entries){ if(entry.name) {
    String typeRefl;
    String bytesType;
    String modifier;
    if(entry.type.pointer){ modifier = "kReference_Modifier_reflectJc"; }  ##reference type, from primitive or class type. 
    if(entry.macro && entry.macro == "OS_HandlePtr") {  ##special macro for bus - handle
      typeRefl = <:>&reflection_<&entry.type.name><.>;
      modifier = "kHandlePtr_Modifier_reflectJc | kReference_Modifier_reflectJc";
    } elsif(entry.type) {  
      bytesType = bytesSimpleTypes.get(entry.type.name);
      if(bytesType){ modifier = <:>(<&bytesType><<kBitPrimitiv_Modifier_reflectJc)<.>; } else { modifier = "0"; }
      typeRefl = reflSimpleTypes.get(entry.type.name);
      if(!typeRefl) { typeRefl = <:>&reflection_<&entry.type.name><.>; }
    } else {
      //another macro is ignored.
    }
    String arraysize;
    if(entry.arraysize.value) {
      arraysize = <:><&entry.arraysize.value> //nrofArrayElements<.>;
      modifier = <:><&modifier> | kStaticArray_Modifier_reflectJc<.>;
    } else {
      arraysize = "0   //no Array, no Bitfield";
    }
    if((entry.arraysize || not bytesType) && not entry.type.pointer && not entry.type.pointer2) {
      modifier = <:><&modifier>|kEmbeddedContainer_Modifier_reflectJc<.>;
    }
    if(entry.type.pointer) { modifier = <:><&modifier>|mReference_Modifier_reflectJc<.>; }
    if(typeRefl) { ##else: a #define
    <:><:indent:2=><: >
      { "<&entry.name>"
====    , <&arraysize>
====    , <&typeRefl>                                                                                            
====    , <&modifier> //bitModifiers
====    , (int16)((int32)(&((<&struct.name>*)(0x1000))-><&entry.name>) -(int32)(<&struct.name>*)0x1000)
====    , 0  //offsetToObjectifcBase
====    , &reflection_<&struct.name>
====    }
====  <:hasNext>, <.hasNext><: >
    <.>
    }
  } } //if for
  ##The class:
  String classModif;
  
  <:>  
==} };
==
==const ClassJc reflection_<&struct.name> =
=={ CONST_ObjectJc(OBJTYPE_ClassJc + sizeof(ClassJc), &reflection_<&struct.name>, &reflection_ClassJc)
==, "<&struct.name>"
==, 0
==, sizeof(<&struct.name>)
==, (FieldJcArray const*)&reflection_Fields_<&struct.name>  //attributes and associations
==, null  //method      
==, <:if:reflSuperName>(ClassOffset_idxMtblJcARRAY*)&superClasses_<&struct.name><:else>null<.if>  //superclass  
==, null  //interfaces  ##TODO check first union
==, 0 ##TODO |mObjectJc_Modifier_reflectJc if union{ ObjectJc obj, ...} or 1. element ObjectJc
==, <:if:struct.description.vtbl>&<&struct.description.vtbl>.tbl.head<:else>null<.if>  //virtual table
==};
==
==<.>
}








################################################################################################################
##
##The routine to generate reflection files, one file per header file.
##It parses all header files one after another, then generates reflection
##
sub genReflection(Obj target: org.vishia.cmd.ZmakeTarget, String html = null)
{

  <+out>currdir=<&currdir><.+n>
  List inputs = target.allInputFiles();
  for(input:inputs)
  { <+out>files: <&input.absfile()><.+n>
  }
  List inputsExpanded = target.allInputFilesExpanded();
  for(headerfile:inputsExpanded)
  { <+out><&headerfile.absfile()><.+n>
    call genReflectionFile(filepath = headerfile, fileRefl = <:><&target.output.absdir()>/<&headerfile.localname()>.crefl<.>, html = html);
  }
}







sub genReflectionFile(Obj filepath :org.vishia.cmd.JZtxtcmdFilepath, String fileRefl, String html = null)
{
  ##java org.vishia.util.DataAccess.debugMethod("setSrc");
  Obj args = java new org.vishia.header2Reflection.CheaderParser$Args();
  args.addSrc(filepath.absfile(), filepath.localname());

  ##args.setDst(target.output.absfile());
  
  args.setZbnfHeader(<:><&scriptdir>/../zbnf/Cheader.zbnf<.>);
  
  
  Obj headers = headerTranslator.execute(args);


  for(headerfile: headers.files){
    <+out>generate <&headerfile.fileName> <.+n>
    ##Only to help change the script, output all parsed data:
    if(html !=null && html.length()>0) {
      <+out>html: <&html>/<&headerfile.fileName><.+n>
      mkdir <:><&html>/<&headerfile.fileName>'<.>;
      test.dataHtml(headers, File:<:><&html>/<&headerfile.fileName>.html<.>);
    }
    call genReflectionHeader(headerfile = headerfile, fileRefl = fileRefl);
  }
} 









################################################################################################################
##
##The routine to generate reflection files, one file per header file.
##It parses all header files one after another, then generates reflection
##
sub genReflectionHeader(Obj headerfile, String fileRefl)
{
  Openfile outRefl = fileRefl;
    <+outRefl>
    <:>
========//This file is generated by ZBNF/zbnfjax/jzTc/Cheader2Refl.jzTc
========#include "<&headerfile.fileName>.h"  ##it comes from args.addSrc(...,input.localname())
========#include <Jc/ReflectionJc.h>
========#include <stddef.h>
    <.><.+>
  for(classC: headerfile.listClassC) {
    for(entry: classC.entries) {
      if(entry.whatisit == "structDefinition" && not entry.description.noReflection) {
        ##
        ##check whether a Bus should be generated.
        ##
        <+outRefl><:call:genReflStruct:struct=entry><.+>
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
  outRefl.close();
}



##############################################################################################################
##
## main only if it is invoked with absolute path to one headerfile.
##
sub xxxmain()
{ ##NOTE: to test parsed data from header add an argument html="path/to/outdirForhtml"
  call genReflectionFile(filepath = Filepath: &$1, fileRefl = $2);
}

