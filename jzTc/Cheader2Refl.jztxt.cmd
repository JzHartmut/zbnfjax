REM the following batch file should be adapted to the position of zbnfjax on hard disk. Template see zbnfjax/batch_template/jztxtcmd.bat
JZtxtcmd.bat %0 %1 %2
REM alternatively:
::set ZBNFJAX_HOME=D:/vishia/ZBNF/zbnfjax
::java -cp %ZBNFJAX_HOME%/zbnf.jar org.vishia.jztxtcmd.JZtxtcmd  %0 %1 %2

exit /B                                      
                                                                   
==JZtxtcmd==

##jzTc script to generate a Reflection.crefl file from some struct of Header.
##invoke this batch with 2 arguments: path/to/headerfile.h path/to/dst.crefl 
##made by Hartmut Schorrig, www.vishia.org, 2018-08-11  
##
##History:
##2017-06: created, used instead Java-core-programmed reflection generation. Advantage: pattern-oriented, 
##2018-08-12: Fine adjustments to new Sources of emC.  
##2018-08-11: 
##  * Now supports unnamed or named embedded struct or union. Before: compiler error for such constructs
##  * Generates the super class not as attribute.
##  * writes now the field in ClassOffset_idxMtblJc:
##  ** It is valid for new sources of emC, especially emC/Object_emC.h for definition of ClassOffset_idxMtblJc
##  with element field, and for Jc/ReflectionJc.h: The definition of FieldJc is moved to emC/Object_emC.h.
##  ** For older sources it runs if superclasses are not used.


##Class reflStructDefinition = org.vishia.header2Reflection.CheaderParser$StructDefinition;
            
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
  String int32BigEndian =    "REFLECTION_int32";
  String int16BigEndian =    "REFLECTION_int16";
};  

Map bytesSimpleTypes = {
  ##String void =     "4";  ##void is a reference usual. Not a primitive type.
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
  String int32BigEndian =    "4";
  String int16BigEndian =    "2";
};  


Map idSimpleTypes = {
  Num void =     1;
  Num int =      4;
  Num char =     14;
  Num uint32_t = 5;
  Num uint32 =   5;
  Num int32_t =  4;
  Num int32 =    4;
  Num uint16_t = 7;
  Num Uint16 =   7;                                        
  Num int16_t =  6;
  Num int16 =    6;
  Num uint8_t =  9;
  Num Uint8 =    9;
  Num int8_t =   8;
  Num int8 =     8;
  Num float =    12;
  Num int64 =    2;
  Num int64_t =  2;
  Num uint64 =   3;
  Num uint64_t = 3;
  Num bool =     15;
  Num float_complex =   20;
  Num double_complex =  21;
  Num ObjectJc =     25;
  Num StringJc =     29;
  Num OS_PtrValue =  30;
  Num int32BigEndian =    4;
  Num int16BigEndian =    6;
};  



##
##Generates the reflection of one type (struct, class).
##It is invoked as subtext call.
##
sub genReflStruct(Obj struct, Obj fileBin, Obj fileOffs, Obj fileOffsTypetable) 
{ Num nrElements = 0;
  String structBasename = struct.baseName("_s");
  for(entry:struct.entries){if(entry.name) {
    nrElements = nrElements +1;
  } }
  <:>
==
==extern_C const ClassJc reflection_<&structBasename>;  //the just defined reflection_ used in the own fields.<.>
  for(entry:struct.entries) { if(entry.name && entry.type) { ##Note a type is not present for a #define inside a struct.
    Obj typeRefl;
    if(entry.description.reflType) {
      typeRefl = entry.description.reflType;
    } elsif(entry.type) {
      typeRefl = entry.type;
    }
    if(not reflSimpleTypes.get(typeRefl.name)) { 
      String sTypename = typeRefl.baseName("_s", "_t");
##      if(typeRefl.forward && typeRefl.name.endsWith("_t")) {
##        Num zname = typeRefl.name.length();
##        String defname = typeRefl.name.substring(0, zname -2);
##        <:>
##========#define reflection_<&typeRefl.name> reflection_<&defname><.> 
##      }
      <:>
======extern_C const ClassJc reflection_<&sTypename>;  //used for field <&entry.name>
      <.>      
    }
  }}
  Num hasSuperclass = 0;
    if(struct.superclass) {
      String reflSuperName = <:>reflection_<&struct.superclass.type.name><.>;
      <:>  
======
======const struct SuperClasses_<&struct.name>_ClassOffset_idxMtblJcARRAY_t  //Type for the super class
======{ ObjectArrayJc head;
======  ClassOffset_idxMtblJc data[1];
======}  superClasses_<&struct.name> =   //reflection instance for the super class
======{ INIZ_ObjectArrayJc(superClasses_<&struct.name>, 1, ClassOffset_idxMtblJc, null, INIZ_ID_ClassOffset_idxMtblJc)
======  , { &<&reflSuperName>                                   
======    , 0 //TODO Index of mtbl of superclass
======      //The field which presents the superclass data in inspector access.
======    , { "<&struct.superclass.name>"     
======      , 0 //arraysize
======      , &<&reflSuperName>  //type of super                                                                                         
======      , kEmbeddedContainer_Modifier_reflectJc //hint: embd helps to show the real type.
======      , 0 //offsetalways 0 (C++?)
======      , 0  //offsetToObjectifcBase
======      , &<&reflSuperName>  
======      }
======    }
======};
======<.>
  } 
  String sClassNameShow = struct.name;  ##TODO shorten
  if(fileBin) {
    Num nrClass = fileBin.addClass(sClassNameShow, struct.name);
    if(fileOffs) {
      <+fileOffsTypetable><:>
======, reflectionOffset_<&struct.name>    //access the array<.><.+>
      <+fileOffs>
      <:>
======extern int32 const reflectionOffset_<&struct.name>[];  //for usage as root instance
======int32 const reflectionOffset_<&struct.name>[] =
======{ <&nrClass>   //index of class in Offset data<.><.+>
    }
  }
  String sFieldsInStruct = "null";
  ##if(struct.entries.size() > hasSuperclass) { ##hasSuperclass is 1 if the first entry is the superclass.
  if(struct.attribs.size() > 0) { ##hasSuperclass is 1 if the first entry is the superclass.
    sFieldsInStruct = <:>(FieldJcArray const*)&reflection_Fields_<&struct.name><.>;
    Stringjar wrFields;  ##the container for the generated field data
    Map retEntries;
    ##
    ## generates all fields:
    ##
    retEntries = call attribs_struct(wr = wrFields, fileBin = fileBin, fileOffs = fileOffs, struct = struct);
    ##
    <:>
====const struct Reflection_Fields_<&struct.name>_t
===={ ObjectArrayJc head;
====  FieldJc data[<&retEntries.nrofEntries>];
====} reflection_Fields_<&struct.name> =
===={ INIZ_ObjectArrayJc(reflection_Fields_<&struct.name>, <&retEntries.nrofEntries>, FieldJc, null, INIZ_ID_FieldJc)
====, {  
    <&wrFields>
====} }; 
====                                                    
    <.>                                     
  }
  ##The class:
  String classModif;
  String sizeName;
  if(struct.implicitName !=null) { sizeName = <:>((<&struct.parent.name>*)0x1000)-><&struct.implicitName><.>; }
  else { sizeName = struct.name; }
  <:>                                                                   
==const ClassJc reflection_<&structBasename> =
=={ INIZ_objReflId_ObjectJc(reflection_<&structBasename>, &reflection_ClassJc, INIZ_ID_ClassJc)
==, "<&structBasename>"
==, 0
==, sizeof(<&sizeName>)
==, <&sFieldsInStruct>  //attributes and associations
==, null  //method      
==, <:if:reflSuperName>(ClassOffset_idxMtblJcARRAY*)&superClasses_<&struct.name><:else>null<.if>  //superclass  
==, null  //interfaces  ##TODO check first union
==, <:if:struct.isBasedOnObjectJc>mObjectJc_Modifier_reflectJc<:else>0<.if>   ## if union{ ObjectJc obj, ...} or 1. element ObjectJc
==, <:if:struct.description.vtbl>&<&struct.description.vtbl>.tbl.head<:else>null<.if>  //virtual table
==};
==
==<.>
  if(fileBin) {
    fileBin.closeAddClass();
    if(fileOffs) {
      <+fileOffs>
      <:>
======};
======
      <.><.+>
    }  
  }
}






                

##
##Subroutine writes the C-code for an entry of a struct.
##Regards bitfields
##
sub attribs_struct(Obj wr, Obj fileBin, Obj fileOffs, Obj struct)
{ Num return.nrofEntries = 0;
  String offset = "0";    ##initial value, keep it on bitfields
  String sizetype = "0";  ##initial, no element before 1. bitfield
  if(struct.superclass) {
    sizetype = <:>sizeof(<&struct.superclass.type.name>)<.>;
  }
  Bool bitfield = 0;
  Num bitPosition = 0;
  String structBasename = struct.baseName("_s");

  ##for(entry:struct.entries) { 
  for(entry:struct.attribs) { 
    if(!entry.name || entry.description.noRefl) {
      ##unnamed entry, especially on inner struct, do nothing. The inner struct is handled already.
      ##unnamed entry on bitfields, do nothing don't show it.
    } else {
      String sTypeRefl;
      String bytesType;
      String modifier;
      Num mModifier = 0;
      Obj typeRefl;
      ##
      ## sTypeRefl
      ##
      if(entry.description.reflType) {  ##from annotation in comment, CHeader.zbnf: @refl: <type?reflType> 
        typeRefl = entry.description.reflType;
      } elsif(entry.type) {
        typeRefl = entry.type;  ##from parsed type
      }
      
      if(typeRefl) {
        String typename = typeRefl.baseName("_s", "_t");  ##name ends on _s then without _s, forward ends on _t then without
        bytesType = bytesSimpleTypes.get(typename);
        if(bytesType){ 
          modifier = <:>(<&bytesType><<kBitPrimitiv_Modifier_reflectJc)<.>;
          Num nBytesType = bytesType;  //conversion to numeric
          mModifier = Num.shBits32To(nBytesType, %org.vishia.byteData.Class_Jc.kBitPrimitiv_Modifier, 3);
        } else { modifier = "0"; }
        if(reflReplacement) {                           
          sTypeRefl = reflReplacement.get(typename);
          if(!sTypeRefl) { 
            sTypeRefl = <:>&reflection_<&typename><.>; 
          }
        } else {
          sTypeRefl = reflSimpleTypes.get(typename); ##check whether the type is known as simple type
          if(!sTypeRefl) { ##not a simple type
            sTypeRefl = <:>&reflection_<&typename><.>; 
          }
        }
      } else {
        //another macro is ignored.
      }
      ##
      String arraysize;
      ##
      if(entry.bOS_HandlePointer) { 
        modifier = <:><&modifier> | kHandlePtr_Modifier_reflectJc<.>;
        mModifier = mModifier + %org.vishia.byteData.Class_Jc.kHandlePtr_Modifier;
      }
      Num zPointer = 0;
      if(typeRefl.pointer_) { zPointer = typeRefl.pointer_.size();}
      if(zPointer >0){ 
        modifier = "kReference_Modifier_reflectJc";   ##reference type, from primitive or class type. 
        mModifier = mModifier + %org.vishia.byteData.Class_Jc.kReference_Modifier;
      }
      if(entry.arraysize.value) {
        arraysize = <:><&entry.arraysize.value> //nrofArrayElements<.>;
        modifier = <:><&modifier> | kStaticArray_Modifier_reflectJc<.>;
        mModifier = mModifier + %org.vishia.byteData.Class_Jc.kStaticArray_Modifier;
      } else {
        arraysize = "0   //no Array, no Bitfield";
      }
      if(entry.bitField) {
        arraysize = <:>(uint16)(<&bitPosition> + (<&entry.bitField> << kBitNrofBitsInBitfield_FieldJc))<.>;
        bitPosition = bitPosition + entry.bitField;
        sTypeRefl = "REFLECTION_BITFIELD";
        modifier = "kBitfield_Modifier_reflectJc";
        mModifier = mModifier + %org.vishia.byteData.Class_Jc.kBitfield_Modifier;
        if(!bitfield) {   ##the first bitfield:
          offset = <:><&offset> + <&sizetype>/* offset on bitfield: offset of element before + sizeof(element before) */<.>;
          bitfield = 1;
        } ##else: further bitfields: keep offset string 
      } elsif(sTypeRefl) { ##don't set offset = ... for an entry which is not used (espec. #define)
        if((entry.arraysize || not bytesType) && not typeRefl.pointer_) {
          modifier = <:><&modifier>|kEmbeddedContainer_Modifier_reflectJc<.>;
          mModifier = mModifier + %org.vishia.byteData.Class_Jc.kEmbeddedContainer_Modifier;
        }
        if(struct.implicitName) { ##it is an implicitely struct
          if(struct.arraysize !=null) {
            String sImplArray = <:>[0]<.>; ##offset inside first element.
          } else {
            String sImplArray = "";
          }
          offset = <:>(int16)( ((intptr_t)(&((<&struct.parent.name>*)(0x1000))-><&struct.implicitName><&sImplArray>.<&entry.name>)) <: >
                              - ((intptr_t)(&((<&struct.parent.name>*)(0x1000))-><&struct.implicitName>)) )<.>;
        } else {
          offset = <:>(int16)( ((intptr_t)(&((<&struct.name>*)(0x1000))-><&entry.name>)) -0x1000 )<.>;
        }
        if(entry.type) {
          sizetype = <:>sizeof(<&entry.type.name>)<.>;
        } else {                                              
          sizetype = "4-4 /*unknown type*/";
        }
        bitfield = 0;  ##detect a next bitfield, for offset calculation.
      }
      if(sTypeRefl) { ##else: a #define
        return.nrofEntries = return.nrofEntries +1;
        String nameRefl = java org.vishia.header2Reflection.CheaderParser.prepareReflName(<:><&entry.name><.>);
        <+wr><:><:indent:2=>
========    { "<&nameRefl>"
========    , <&arraysize>                           
========    , <&sTypeRefl>                                                                                            
========    , <&modifier> //bitModifiers
========    , <&offset>
========    , 0  //offsetToObjectifcBase                                                            
========    , &reflection_<&structBasename>
========    }
========  <:hasNext>, <.hasNext><: >
        <.><.+>
        }
        if(fileBin) {
          Num idType = idSimpleTypes.get(typename);  ##stores 0 if not found.
          if(idType ==0) { idType = -1; }  ##to signal, unknown type
          if(return.nrofEntries == 1) { fileBin.addFieldHead(); }
          Num typeAddress = -1;
          Num nArraySize = entry.arraysize.value;
          fileBin.addField(nameRefl, idType, typename, mModifier,nArraySize); ##modifier, arraysize); 
          if(fileOffs) {
          <+fileOffs><:>
==========, (sizeof(<&typename>) | <&offset>) <.><.+>          
          }
        }
    } } //if for
}









################################################################################################################
##
##The routine to generate reflection files, one file per header file.
##It parses all header files one after another, then generates reflection
##
sub genDstFiles(Obj target: org.vishia.cmd.ZmakeTarget, String sfileBin, String sfileOffs, String genRoutine, String fileExt, String html = null)
{

  <+out>currdir=<&currdir><.+n>
  List inputs = target.allInputFiles();
  for(input:inputs)
  { <+out>files: <&input.absfile()><.+n>
  }
  List inputsExpanded = target.allInputFilesExpanded();
  Obj fileBin;
  if(sfileBin) {
    Bool endian = false;  ##Note: depends on the target processor, false for PC platform.
    fileBin = new org.vishia.header2Reflection.BinOutPrep(sfileBin, endian, false, 0);
  }
  if(sfileOffs) {
    Openfile fileOffs = &sfileOffs;
    <+fileOffs><:>
====//This file is generated by zbnfjax/jzTc/Cheader2Refl.jztxt.cmd. Do not modify.
====#include <applstdef_emC.h>
====#include <Inspc/Target2Proxy_Inspc.h>  //declares reflectionOffsetArrays
====
    <.><.+>
    Obj fileOffsTypetable = new java.lang.StringBuilder(1000);
  } else {
    Obj fileOffs;  //remain null but define
    Obj fileOffsTypetable;
  }
  for(headerfile:inputsExpanded)
  { <+out><&headerfile.absfile()><.+n>
    call genDstFile(filepath = headerfile, fileBin = fileBin, fileOffs = fileOffs, fileOffsTypetable = fileOffsTypetable
      , fileDst = <:><&target.output.absdir()>/<&headerfile.localname()><&fileExt><.>, genRoutine=genRoutine, html = html);
  }
  if(fileBin) {
    fileBin.postProcessBinOut();
    fileBin.close();
  }
  if(fileOffs) {
    <+fileOffs><:>
====    
====int32 const* const reflectionOffsetArrays[] =
===={ null  //index 0 left free
====<&fileOffsTypetable>
====};
    <.><.+>
    fileOffs.close();
  }
}


sub genReflection(Obj target: org.vishia.cmd.ZmakeTarget, String fileBin = null, String fileOffs = null, String html = null)
{
  call genDstFiles(target = target, html=html, sfileBin = fileBin, sfileOffs = fileOffs, genRoutine="genReflectionHeader", fileExt=".crefl");
}





sub genDstFile(Obj filepath :org.vishia.cmd.JZtxtcmdFilepath, Obj fileBin, Obj fileOffs, Obj fileOffsTypetable, String fileDst, String genRoutine, String html = null)
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
    call &genRoutine(headerfile = headerfile, fileBin = fileBin, fileOffs = fileOffs, fileOffsTypetable = fileOffsTypetable, fileDst = fileDst);
  }
} 









################################################################################################################
##
##The routine to generate reflection files, one file per header file.
##It parses all header files one after another, then generates reflection
##
sub genReflectionHeader(Obj headerfile, Obj fileBin, Obj fileOffs, Obj fileOffsTypetable, String fileDst)
{
  FileSystem.mkDirPath(fileDst);  ##Note: makes only the directory, because fileDst does not end with /
  Openfile outRefl = fileDst;
    <+outRefl>
    <:>
====//This file is generated by ZBNF/zbnfjax/jzTc/Cheader2Refl.jzTc
====#include "<&headerfile.fileName>.h"  ##it comes from args.addSrc(...,input.localname())
====#include <Jc/ReflectionJc.h>
====#include <stddef.h>
    <.><.+>
  if(fileOffs) {
    <+fileOffs>
    <:>
====#include <<&headerfile.fileName>.h>
====<.><.+>
  }

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
        <+outRefl><:call:genReflStruct:struct=entry, fileOffs=fileOffs, fileOffsTypetable = fileOffsTypetable, fileBin=fileBin><.+>
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



