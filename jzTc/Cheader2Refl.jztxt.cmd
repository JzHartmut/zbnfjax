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
  String void = "REFLECTION_void";
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
  String void =     "4";
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
==extern_C const ClassJc reflection_<&struct.name>;  //the just defined reflection_ used in the own fields.<.>
  for(entry:struct.entries) { if(entry.name && entry.type) { ##Note a type is not present for a #define inside a struct.
    Obj typeRefl;
    if(entry.description.reflType) {
      typeRefl = entry.description.reflType;
    } elsif(entry.type) {
      typeRefl = entry.type;
    }
    if(not reflSimpleTypes.get(typeRefl.name)) { 
      if(typeRefl.forward && typeRefl.name.endsWith("_t")) {
        Num zname = typeRefl.name.length();
        String defname = typeRefl.name.substring(0, zname -2);
        <:>
========#define reflection_<&typeRefl.name> reflection_<&defname><.> 
      }
      <:>
======extern_C const ClassJc reflection_<&typeRefl.name>;  //used for field <&entry.name>
      <.>      
    }
  }}
  Num hasSuperclass = 0;
  if(struct.entries.size()>0) {
   Obj base = struct.entries.get(0);
   String reflSuperName;
   if(base ?instanceof reflStructDefinition && (base.name == "base" || base.name == "obj" || base.name == "object" || base.name == "super")) {
    hasSuperclass = 1;
    if(base.isUnion || (base ?instanceof reflStructDefinition && not base.type)) { ##base class and interface or ObjectJc are joined in a union. The first element should be the super class. 
      reflSuperName = <:>reflection_<&base.entries.get(0).type.name><.>;
    } else {
      reflSuperName = <:>reflection_<&base.type.name><.>; ####type.name><.>;
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
  String sFieldsInStruct = "null";
  if(struct.entries.size() > hasSuperclass) { ##hasSuperclass is 1 if the first entry is the superclass.
    String sFieldsInStruct = <:>(FieldJcArray const*)&reflection_Fields_<&struct.name><.>;
    Stringjar wrFields;
    Map retEntries;
    retEntries = call entries_struct(wr = wrFields, struct = struct, structNameRefl=struct.name);
    <:>
====const struct Reflection_Fields_<&struct.name>_t
===={ ObjectArrayJc head;
====  FieldJc data[<&retEntries.nrofEntries>];
====} reflection_Fields_<&struct.name> =
===={ CONST_ObjectArrayJc(FieldJc, <&retEntries.nrofEntries>, OBJTYPE_FieldJc, null, &reflection_Fields_<&struct.name>)
====, {  
    <&wrFields>
====} }; 
====                                                    
    <.>
  }
  ##The class:
  String classModif;
  
  <:>
==const ClassJc reflection_<&struct.name> =
=={ CONST_ObjectJc(OBJTYPE_ClassJc + sizeof(ClassJc), &reflection_<&struct.name>, &reflection_ClassJc)
==, "<&struct.name>"
==, 0
==, sizeof(<&struct.name>)
==, <&sFieldsInStruct>  //attributes and associations
==, null  //method      
==, <:if:reflSuperName>(ClassOffset_idxMtblJcARRAY*)&superClasses_<&struct.name><:else>null<.if>  //superclass  
==, null  //interfaces  ##TODO check first union
==, 0 ##TODO |mObjectJc_Modifier_reflectJc if union{ ObjectJc obj, ...} or 1. element ObjectJc
==, <:if:struct.description.vtbl>&<&struct.description.vtbl>.tbl.head<:else>null<.if>  //virtual table
==};
==
==<.>
}








##
##Subroutine writes the C-code for an entry of a struct.
##Regards bitfields
##
sub entries_struct(Obj wr, Obj struct, String structNameRefl)
{ Num return.nrofEntries = 0;
  String offset = "0";    ##initial value, keep it on bitfields
  String sizetype = "0";  ##initial, no element before 1. bitfield
  Bool bitfield = 0;
  Num bitPosition = 0;
  for(entry:struct.entries) { 
    if(entry ?instanceof reflStructDefinition && !entry.conditionDef){
      <:>/*INNER STRUCT */
      <.>
      Map ret;
      String structNameReflSub;
      if(entry.name){ structNameReflSub = entry.name; }
      else { structNameReflSub = structNameRefl; }  ##an unnamed struct, use the outside name.
      ##embedded sub struct, named or no named.
      ret = call entries_struct(wr = wr, struct = entry, structNameRefl = structNameRefl);
      return.nrofEntries = return.nrofEntries + ret.nrofEntries;
      ##
      <+wr><:>
      ========  <:hasNext>, <.hasNext><.><.+>
    }
    if(!entry.name) {
      ##unnamed entry, especially on inner struct, do nothing. The inner struct is handled already.
      ##unnamed entry on bitfields, do nothing don't show it.
    } else {
      String sTypeRefl;
      String bytesType;
      String modifier;
      Obj typeRefl;
      ##
      ## sTypeRefl
      ##
      if(entry.description.reflType) {  ##from annotation in comment, CHeader.zbnf: @refl: <type?reflType> 
        typeRefl = entry.description.reflType;
      } elsif(entry.type) {
        typeRefl = entry.type;  ##from parsed type
      }
      if(typeRefl.pointer){ modifier = "kReference_Modifier_reflectJc"; }  ##reference type, from primitive or class type. 
      if(entry.macro && entry.macro == "OS_HandlePtr") {  ##special macro for bus - handle
        sTypeRefl = <:>&reflection_<&typeRefl.name><.>;
        modifier = "kHandlePtr_Modifier_reflectJc | kReference_Modifier_reflectJc";
      } elsif(typeRefl) {  
        bytesType = bytesSimpleTypes.get(typeRefl.name);
        if(bytesType){ modifier = <:>(<&bytesType><<kBitPrimitiv_Modifier_reflectJc)<.>; } else { modifier = "0"; }
        sTypeRefl = reflSimpleTypes.get(typeRefl.name);
        if(!sTypeRefl) { 
          if(reflReplacement) {
            sTypeRefl = reflReplacement.get(typeRefl.name);
            if(!sTypeRefl) { 
              sTypeRefl = <:>&reflection_<&typeRefl.name><.>; 
            }
          } else {
            sTypeRefl = <:>&reflection_<&typeRefl.name><.>; 
          }
        }
      } else {
        //another macro is ignored.
      }
      ##
      String arraysize;
      ##
      if(entry.arraysize.value) {
        arraysize = <:><&entry.arraysize.value> //nrofArrayElements<.>;
        modifier = <:><&modifier> | kStaticArray_Modifier_reflectJc<.>;
      } else {
        arraysize = "0   //no Array, no Bitfield";
      }
      if(entry.bitField) {
        arraysize = <:>(uint16)(<&bitPosition> + (<&entry.bitField> << kBitNrofBitsInBitfield_FieldJc))<.>;
        bitPosition = bitPosition + entry.bitField;
        sTypeRefl = "REFLECTION_BITFIELD";
        modifier = "kBitfield_Modifier_reflectJc";
        if(!bitfield) {   ##the first bitfield:
          offset = <:><&offset> + <&sizetype>/* offset on bitfield: offset of element before + sizeof(element before) */<.>;
          bitfield = 1;
        } ##else: further bitfields: keep offset string 
      } elsif(sTypeRefl) { ##don't set offset = ... for an entry which is not used (espec. #define)
        if((entry.arraysize || not bytesType) && not typeRefl.pointer && not typeRefl.pointer2) {
          modifier = <:><&modifier>|kEmbeddedContainer_Modifier_reflectJc<.>;
        }
        offset = <:>(int16)( ((intptr_t)(&((<&structNameRefl>*)(0x1000))-><&entry.name>)) -0x1000 )<.>;
        if(entry.type) {
          sizetype = <:>sizeof(<&entry.type.name>)<.>;
        } else {
          sizetype = "4-4 /*unknown type*/";
        }
        bitfield = 0;  ##detect a next bitfield, for offset calculation.
      }
      if(typeRefl.pointer) { modifier = <:><&modifier>|mReference_Modifier_reflectJc<.>; }
      if(sTypeRefl) { ##else: a #define
        return.nrofEntries = return.nrofEntries +1;
        <+wr><:><:indent:2=>
========    { "<&entry.name>"
========    , <&arraysize>
========    , <&sTypeRefl>                                                                                            
========    , <&modifier> //bitModifiers
========    , <&offset>
========    , 0  //offsetToObjectifcBase
========    , &reflection_<&structNameRefl>
========    }
========  <:hasNext>, <.hasNext><: >
        <.><.+>
        }
    } } //if for
}









################################################################################################################
##
##The routine to generate reflection files, one file per header file.
##It parses all header files one after another, then generates reflection
##
sub genDstFiles(Obj target: org.vishia.cmd.ZmakeTarget, String genRoutine, String fileExt, String html = null)
{

  <+out>currdir=<&currdir><.+n>
  List inputs = target.allInputFiles();
  for(input:inputs)
  { <+out>files: <&input.absfile()><.+n>
  }
  List inputsExpanded = target.allInputFilesExpanded();
  for(headerfile:inputsExpanded)
  { <+out><&headerfile.absfile()><.+n>
    call genDstFile(filepath = headerfile, fileDst = <:><&target.output.absdir()>/<&headerfile.localname()><&fileExt><.>, genRoutine=genRoutine, html = html);
  }
}


sub genReflection(Obj target: org.vishia.cmd.ZmakeTarget, String html = null)
{
  call genDstFiles(target = target, html=html, genRoutine="genReflectionHeader", fileExt=".crefl");
}


sub XXXXXXXXgenReflectionFile(Obj filepath :org.vishia.cmd.JZtxtcmdFilepath, String fileRefl, String html = null)
{
  call genDstFile(filepath=filepath, fileDst=fileRefl, genRoutine="genReflectionHeader", html=html);
}




sub genDstFile(Obj filepath :org.vishia.cmd.JZtxtcmdFilepath, String fileDst, String genRoutine, String html = null)
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
    call &genRoutine(headerfile = headerfile, fileDst = fileDst);
  }
} 









################################################################################################################
##
##The routine to generate reflection files, one file per header file.
##It parses all header files one after another, then generates reflection
##
sub genReflectionHeader(Obj headerfile, String fileDst)
{
  FileSystem.mkDirPath(fileDst);  ##Note: makes only the directory, because fileDst does not end with /
  Openfile outRefl = fileDst;
    <+outRefl>
    <:>
========//This file is generated by ZBNF/zbnfjax/jzTc/Cheader2Refl.jzTc
========#include "<&headerfile.fileName>.h"  ##it comes from args.addSrc(...,input.localname())
========#include <Jc/ReflectionJc.h>
========#include <stddef.h>
    <.><.+>
  for(classC: headerfile.listClassC) {
    for(entry: classC.entries) {
      if(  (entry.whatisit == "structDefinition" || entry.whatisit == "unionDefinition")  
        && not entry.description.noReflection
        && not(entry.name >= "Mtbl")
        && not(entry.name >= "Vtbl")
        ) {
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
  call genReflectionFile(filepath = Filepath: &$1, fileDst = $2);
}
