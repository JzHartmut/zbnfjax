<?xml version="1.0" encoding="iso-8859-1"?>
<!--
 2007-12-27 TODO detecting of superclass, important to build reflection with base Object_Jc.
 2007-12-25 JcHartmut processing of inner struct, inner class and implicit struct.
 -->
<!-- This file should be translated using makeXsl_fromXslp before using for a XSLT translation, see http://www.vishia.org/Xml/html/Xsltpre.html -->
<!-- made by Hartmut Schorrig www.vishia.org
  2012-03-25 Hartmut inlideMethod (usage of Inline_Fwc in Header)
  2011-06-26 Hartmut consider typedef struct inside a @CLASS_C block with naming Name_ClassCName as inner classes in XMI, adjust some details for description 
  2007..2011 Hartmut some changes
  2007       Hartmut created -->                       
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:saxon="http://saxon.sf.net/"
  xmlns:UML="omg.org/UML13"
  extension-element-prefixes="saxon"
>
<xsl:output method="xml" encoding="iso-8859-1"/>

<xsl:variable name="Indent"><xsl:text>
                                                                           </xsl:text>
</xsl:variable>
<xsl:variable name="IndentPos" select="'2'" />                                                                           


<xsl:key name="typeSearch" use="@name" 
  match="/root/Types/usedType" 
/>

<xsl:key name="tag2type" use="@tagname" 
  match="/root/Types/structTagName" 
/>


<xsl:variable name="Stereotype_CONST_Initializer">
  <UML:Stereotype  xmi.id="{generate-id()}" name="CONST_initializer" visibility="public">
  </UML:Stereotype>
</xsl:variable>



<xsl:template match="/" >
  <xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
  <XMI xmi.version="1.2"><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
    <XMI.header><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
      <XMI.documentation/><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
      <XMI.metamodel xmi.name="UML" xmi.version="1.3"/><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
    </XMI.header><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
    <XMI.content><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
      <UML:Model name="GeneratedFromCheader"><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
        <UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          <xsl:call-template name="gen_HeaderDependencies" />
          <xsl:copy-of select="$Stereotype_CONST_Initializer" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          <UML:Package name="_Types"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
            <UML:Namespace.ownedElement>
              <xsl:call-template name="_Types"><xsl:with-param name="IndentPos" select="number($IndentPos)+10" /></xsl:call-template>
              <xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
            </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          </UML:Package><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
          <xsl:for-each select="/root/Cheader">
            <xsl:variable name="pkgName"><xsl:value-of select="@filename" />_h</xsl:variable>
            <xsl:variable name="pkgTypeId" select="key('typeSearch',$pkgName)/@xmi.id" />
              <UML:Package name="{$pkgName}" xmi.id="{$pkgTypeId}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
              <UML:Namespace.ownedElement>
                <xsl:call-template name="allClassesOfHeader" />
              </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            </UML:Package><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
          </xsl:for-each>
          <!-- xsl:for-each select="//Cheader">
            <xsl:call-template name="genPkgHeader" ><xsl:with-param name="IndentPos" select="'10'" /></xsl:call-template>
          </xsl:for-each -->
  
          <UML:Component name="Header">
            <UML:Component.residentElement>
              <xsl:call-template name="allScopedClasses" />
            </UML:Component.residentElement>
          </UML:Component>
  
  
  
        </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
      </UML:Model><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
    </XMI.content><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
  </XMI>
</xsl:template>

<!-- Generates all include dependencies as package dependencies. 
     called one time for all packages.
  -->
<xsl:template name="gen_HeaderDependencies" >
<xsl:param name="IndentPos" select="4"/>
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
  <xsl:comment>gen_HeaderDependencies file=<xsl:value-of select="@headerfile" /></xsl:comment>
  <xsl:for-each select="/root/Cheader"> 
    <xsl:variable name="ownfile"><xsl:value-of select="@filename" />_h</xsl:variable>
    <xsl:variable name="ownTypeId" select="key('typeSearch',$ownfile)/@xmi.id" />
    <xsl:comment><xsl:text> Header dependency from </xsl:text><xsl:value-of select="$ownfile" /><xsl:text>:</xsl:text><xsl:value-of select="$ownTypeId" /><xsl:text></xsl:text></xsl:comment>
    <xsl:for-each select="includeDef" > 
      <xsl:variable name="includefile"><xsl:value-of select="@file" />_h</xsl:variable>
      <xsl:variable name="InclTypeId" select="key('typeSearch',$includefile)/@xmi.id" />
      <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
      <UML:Dependency name="{$ownfile}_{$includefile}" client="{$ownTypeId}" _clientFile="{$ownfile}" supplier="{$InclTypeId}" _supplierName="{$includefile}"  /> 
    </xsl:for-each>
  </xsl:for-each>  
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
</xsl:template>  


<xsl:template name="genPkgHeader">
<xsl:param name="IndentPos" />  
  <!--
  <xsl:variable name="fileClassName" select="/root/Cheader[1]/outside/classDef[1]/@name | /root/Cheader[1]/CLASS_C/classDef[1]/@name" />
  <xsl:variable name="pkg" select="substring-before(/root/Cheader[1]/HeaderEntry/text(),$fileClassName)" />
  -->
  <xsl:variable name="fileClassName" select="outside/classDef[1]/@name | CLASS_C/classDef[1]/@name" />
  <xsl:variable name="pkg" select="substring-before(HeaderEntry/text(),$fileClassName)" />
  <xsl:choose>
  <xsl:when test="string-length($pkg)>0" >
     <xsl:call-template name="genPkgHeader1" >
       <xsl:with-param name="IndentPos" select="number($IndentPos) + 2" />
       <xsl:with-param name="pkg"><xsl:value-of select="$pkg" /><xsl:text>pkg</xsl:text></xsl:with-param>
     </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
    <UML:Package><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
      <UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
        <xsl:call-template name="allClasses" />
      </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
    </UML:Package><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template name="genPkgHeader1">
<xsl:param name="IndentPos" />  
<xsl:param name="pkg" />
  <xsl:variable name="pkg1" select="substring-before($pkg,'_pkg')" />
  <xsl:variable name="pkg2" select="substring-after($pkg,'_pkg')" />
  <!-- TEST val="{$pkg1}" pkg2="{$pkg2}" / -->
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
  <UML:Package name="{$pkg1}"><UML:Namespace.ownedElement>
    <xsl:choose>
      <xsl:when test="string-length($pkg2)>0">
          <xsl:call-template name="genPkgHeader1" >
            <xsl:with-param name="IndentPos" select="number($IndentPos) + 2" />
            <xsl:with-param name="pkg"><xsl:text>pkg</xsl:text><xsl:value-of select="$pkg2" /></xsl:with-param>
          </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="allClasses" />
      </xsl:otherwise>
    </xsl:choose>
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
  </UML:Namespace.ownedElement></UML:Package>
  
</xsl:template>

  
    
<xsl:template name="_Types">
<xsl:param name="IndentPos" />  
  <xsl:for-each select="/root/Types/usedType[@external='true']">
    <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
    <UML:DataType name="{@name}" xmi.id="{@xmi.id}" visibility="public">
      <xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
      <UML:TaggedValue xmi.id="{generate-id()}" tag="documentation" value="autoGenerated from HeaderXml2Xmi, used type defined outside."/>
      <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
    </UML:DataType>
  </xsl:for-each>
</xsl:template>










<xsl:template name="allScopedClasses">
  <xsl:for-each select="//Cheader/CLASS_C | //Cheader/outside/classDef | //Cheader/outside/structDefinition">
     <UML:ElementResidence resident="{key('typeSearch',@name)/@xmi.id}" xName="{@name}" />

    <!-- xsl:variable name="className" select="@name" />
      <xsl:for-each select="/">
        <xsl:variable name="classId" select="key('typeSearch',$className)/@xmi.id" />
        <UML:ElementResidence resident="d2e3" xresident="{$classId}" xName="{@name}" yName="{$className}" zName="{key('typeSearch',$className)/@xmi.id}"/>
      </xsl:for-each>
    <xsl:variable name="classId2" select="key('typeSearch','TraceData22_TRCA')/@name" />
    <xsl:variable name="classIdElement" select="key('typeSearch',$className)" />
    <xsl:variable name="classId3" select="@name" />
    <UML:ElementResidence test2="{$classIdElement}" test3="{$classId2}" resident="d2e3" xresident="{$classId2}" xName="{@name}" yName="{$className}" zName="{key('typeSearch',$className)/@xmi.id}"/>
    -->
  </xsl:for-each>
  
    
  <!-- xsl:variable name="ClassNamesSorted">
    <xsl:for-each select="//Cheader/class | //Cheader/outside/classDef">
    <xsl:sort select="@name" />  
      <class name="{@name}" />
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="Input" select="/" />
  <xsl:for-each select="$ClassNamesSorted/class[position()=last() or @name!=following-sibling::class[1]/@name]">
    <xsl:variable name="className" select="@name" />
      <xsl:for-each select="/">
        <xsl:variable name="classId" select="key('typeSearch',$className)/@xmi.id" />
        <UML:ElementResidencex resident="d2e3" xresident="{$classId}" xName="{@name}" yName="{$className}" zName="{key('typeSearch',$className)/@xmi.id}"/>
      </xsl:for-each>
    <xsl:variable name="classId2" select="key('typeSearch','TraceData22_TRCA')/@name" />
    <xsl:variable name="classIdElement" select="key('typeSearch',$className)" />
    <xsl:variable name="classId3" select="@name" />
    <UML:ElementResidencex test2="{$classIdElement}" test3="{$classId2}" resident="d2e3" xresident="{$classId2}" xName="{@name}" yName="{$className}" zName="{key('typeSearch',$className)/@xmi.id}"/>
  </xsl:for-each -->
</xsl:template>




<!-- This template searches all classes in XML input, from current CHeader element, it is input from one header.
     Because the informations to one class may be dispersed in several header files,
     first only the names of the classes are gathered. This is in variable ClassNamesSorted.
     Second, the xml tree of ClassNamesSorted is proceeded, GenerateNamedClass is called, but only one per className.
     The work in the matter of fact is done from the called template GenerateNamedClass,
     this template searches the named class in the input xml tree and processes it.     
 -->
<xsl:template name= "allClassesOfHeader">
  <!-- caputure all names of classes found in all input files: -->
  <xsl:variable name="ClassNamesSorted">
    <!-- xsl:for-each select="CLASS_C[structDefinition/@name=@name] | CLASS_CPP//classDef | .//classDef | outside//classDef | outside/structDefinition" -->
    <xsl:for-each select="CLASS_C | CLASS_CPP//classDef | .//classDef | outside//classDef | outside/structDefinition">
    <xsl:sort select="@name" />  
      <xsl:variable name="structName_s"><xsl:value-of select="@name" />_s</xsl:variable>
      <class name="{@name}">
        <xsl:choose><xsl:when test="structDefinition[@name=$structName_s]">
          <xsl:attribute name="structName"><xsl:value-of select="$structName_s" /></xsl:attribute>
        </xsl:when><xsl:otherwise>
          <xsl:attribute name="structName"><xsl:value-of select="@name" /></xsl:attribute>
        </xsl:otherwise></xsl:choose>
      </class>
    </xsl:for-each>
  </xsl:variable>
  <!-- variable ClassNamesSorted may contain more as one entry with same name, but sorted! It is because parts of class definition may be dispursed in some headers.-->
  <xsl:variable name="ClassNames">
    <xsl:for-each select="$ClassNamesSorted/class[position()=last() or @name!=following-sibling::class[1]/@name]">
	<!-- TODO: unresolved problem: if the last element is the same as last preceding-sibling, it is taken double. -->
	<!-- TODO: the problem on StringJc is: It is member in several files, and so member in several packages. 
	           Note package indentifcation in the file and sort to packages while calling this template! -->
      <xsl:message><xsl:text>test Class: </xsl:text><xsl:value-of select="@name" />, <xsl:value-of select="following-sibling::class[1]/@name" /></xsl:message>
      <xsl:if test="position()=last() or @name!=following-sibling::class[1]/@name" >
	    <xsl:copy-of select="." />
          <!-- class name="{@name}" / -->
      </xsl:if>		  
    </xsl:for-each>    
  </xsl:variable>
  <xsl:variable name="Input" select="/" /><!-- reference to input tree -->
  <!-- select only classes with differen name-->
  <xsl:for-each select="$ClassNames/class">
    <xsl:variable name="className" select="@name" />
    <xsl:variable name="structName_s"><xsl:value-of select="@name" />_s</xsl:variable>
    <!-- NOTE: use $Input as reference to the input tree to select because otherwise / means the root in context $Classname -->
    <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
    <xsl:comment><xsl:text> search Associations of </xsl:text><xsl:value-of select="$className" /><xsl:text>/</xsl:text><xsl:value-of select="@structName" /><xsl:text> or </xsl:text><xsl:value-of select="$structName_s" /><xsl:text></xsl:text></xsl:comment>
    <xsl:for-each select="$Input//(classDef | structDefinition)[@name=$className or @name=$structName_s]">
      <xsl:call-template name="generateAssociations">
        <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:for-each>
  <!-- xsl:for-each select="$ClassNamesSorted/class[position()=last() or @name!=following-sibling::class[1]/@name]" -->
  <xsl:for-each select="$ClassNames/class">
    <xsl:message><xsl:text>use Class: </xsl:text><xsl:value-of select="@name" /></xsl:message>
    <xsl:variable name="className" select="@name" />
    <xsl:variable name="structName" select="@structName" />
    <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
    <xsl:comment><xsl:text> generate named class </xsl:text><xsl:value-of select="$className" /><xsl:text> / struct </xsl:text><xsl:value-of select="$structName" /><xsl:text> </xsl:text></xsl:comment>
    <!-- NOTE: use $Input as reference to the input tree to select because otherwise / means the root in context $Classname -->
    <xsl:for-each select="$Input">
      <xsl:call-template name="GenerateNamedClass">
        <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
        <xsl:with-param name="className" select="$className" />
        <xsl:with-param name="classNameFull" select="$structName" /><!-- to get xmi.id -->
        <xsl:with-param name="structName" select="$structName" />
        <xsl:with-param name="classNameXmi" select="$structName" />
      </xsl:call-template>
    </xsl:for-each>  
  </xsl:for-each>
</xsl:template>





<xsl:template name= "allClasses">
  <xsl:message>old</xsl:message>
</xsl:template>  


<!-- Searches the named class (param className) in the whole xml input tree and generates its content. -->
<xsl:template name="GenerateNamedClass">
<xsl:param name="IndentPos" />
<xsl:param name="fromCurrent" select="'no'" />
<xsl:param name="className" />
<xsl:param name="structName" />
<xsl:param name="classNameXmi" /><!-- The name used for the XMI element to generate, not used in search paths. --> 
<xsl:param name="classNameFull" select="$className"/><!-- full class name from root focus -->
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
  
  <xsl:variable name="classId" select="key('typeSearch',$classNameFull)/@xmi.id" />
  <xsl:variable name="nodeClassStruct" 
    select="/root/Cheader//CLASS_C[@name=$classNameFull]/structDefinition[@name=$structName] 
          | /root/Cheader/outside//classDef[@name=$className]
          | /root/Cheader/outside/structDefinition[@name=$classNameFull]
           " />
  <UML:Class name="{$classNameXmi}" xmi.id="{$classId}" headerStruct="true" nameRootFocus_info="{$classNameFull}">
    <xsl:if test="$nodeClassStruct/description/GUID">
      <xsl:attribute name="xmi.uuid"><xsl:value-of select="$nodeClassStruct/description/GUID/@value" /></xsl:attribute>
    </xsl:if>
    <xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
    <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
      <xsl:for-each select=".[$fromCurrent='yes'] | /root/Cheader/CLASS_C[@name=$classNameFull] | /root/Cheader/*/classDef[@name=$classNameFull] | /root/Cheader/outside/structDefinition[@name=$classNameFull]">
        <xsl:variable name="nameHeaderfile"><xsl:call-template name="fileCheader" /></xsl:variable>
        <UML:TaggedValue tag="filename" value="{$nameHeaderfile}" />
        <xsl:if test="local-name()='structDefinition'">
          <UML:TaggedValue tag="headerStruct" value="true" />
        </xsl:if>
        <xsl:for-each select=".[$fromCurrent='yes'] 
				                    | /root/Cheader//CLASS_C[@name=$classNameFull]/structDefinition[@name=$className] 
                            | /root/Cheader/outside//classDef[@name=$className]
                            | /root/Cheader/outside/structDefinition[@name=$classNameFull]
                             ">
          <xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
					<UML:TaggedValue tag="documentation" value="{description/text}" />
        </xsl:for-each>
        <xsl:for-each select="defineDefinition/description/text[starts-with(text(), 'CLASS_C_Description:')]">
          <xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
          <UML:TaggedValue tag="documentation" value="{text()}" />
        </xsl:for-each>
      </xsl:for-each>  
    </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
    
    <UML:Classifier.feature>
      <!-- generate atrributes of the structDefinition or classDef.
           If it is a toplevel CLASS_C than the node for structDefinition will be found with the name is given classNameFull,
           but if it is a inner structDefinition or classDef the current xml element contains the attribute[] 
        -->
      <xsl:for-each select=".[$fromCurrent='yes'] | /root/Cheader//structDefinition[@name=$structName] ">
        <xsl:comment><xsl:text>Attributes: Find structDefinition </xsl:text><xsl:value-of select="$structName" /><xsl:text></xsl:text>
        </xsl:comment>
        <xsl:for-each select="(classVisibilityBlock|.)/(structContentInsideCondition|.)/attribute[1]">                    
          <xsl:call-template name="attributeRecursive">
            <xsl:with-param name="bytePosBefore" select="'0'" />
          </xsl:call-template>
        </xsl:for-each>  
      </xsl:for-each>
      <xsl:for-each select="/root/Cheader/CLASS_C[@name=$classNameFull] | /root/Cheader//classDef[@name=$classNameFull]">
        <xsl:comment><xsl:text>Attributes: Find structDefinition </xsl:text><xsl:value-of select="$structName" /><xsl:text></xsl:text>
        </xsl:comment>
        <xsl:for-each select="(classVisibilityBlock|.)/(structContentInsideCondition|.)/xxxattribute[1]"> <!-- TODO static attributes -->                   
          <xsl:call-template name="attributeRecursive">
            <xsl:with-param name="bytePosBefore" select="static" />
          </xsl:call-template>
        </xsl:for-each>  
      </xsl:for-each>

      <xsl:for-each select=".[$fromCurrent='yes'] | /root/Cheader/CLASS_C[@name=$className] | /root//classDef[@name=$className]">
        <xsl:for-each select="(classVisibilityBlock | .)/(conditionBlock | .)/
				  ( virtualMethod|method
				  | methodDef
					| inlineMethod/methodDef
					| defineDefinition[parameter]
					)">
					<!-- NOTE: define-Macros with parameter are accepted as methods too. --> 
          <xsl:variable name="xmi-id" select="generate-id()"/>
          <xsl:variable name="type"><xsl:value-of select="type/@name" /></xsl:variable>
          <xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
          <!-- NOTE: UML:Method isn't accepted by XMI-Import of Rhapsody. -->
          <UML:Operation name="{name}{@name}" xmi.id="{$xmi-id}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)" />
            <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
              <UML:TaggedValue tag="documentation" value="{description/text | ../description/text}" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
							<xsl:for-each select="description/auxDescription">
							  <UML:TaggedValue tag="{@name}" value="{text}" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
							</xsl:for-each>
						</UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
            <UML:BehavioralFeature.parameter><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
              
							<UML:Parameter kind="return" typeName_info="{type/@name}" type="{key('typeSearch',type/@name)/@xmi.id}" visibility="public"><!-- typePackage="{$nameHeaderfile}" -->
							  <xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
							  <xsl:for-each select="description/returnDescription">
								  <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+10)"/>
                		<UML:TaggedValue tag="documentation" value="{text}" />
								  </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
                </xsl:for-each>
              </UML:Parameter>
              
							<xsl:for-each select="typedParameter|parameter">
                <xsl:variable name="paramName" select="@name" />
                <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                <UML:Parameter name="{$paramName}" typeName_info="{type/@name}" type="{key('typeSearch',type/@name)/@xmi.id}" kind="inout"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
                  <xsl:for-each select="../description/paramDescription[@name=$paramName]">
                    <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+10)"/>
                      <UML:TaggedValue tag="documentation" value="{text}" />
										</UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                  </xsl:for-each>
                  <xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
                </UML:Parameter>
              </xsl:for-each>
              
						</UML:BehavioralFeature.parameter><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
          </UML:Operation>
        </xsl:for-each>  
      </xsl:for-each>

      <xsl:for-each select="/root/Cheader/CLASS_C[@name=$className]/enumDefinition | /root/Cheader/CLASS_C[@name=$className]/structDefinition[@name=$className]/enumDefinition">
        <UML:Enumeration name="{@name}"><xsl:value-of select="substring($Indent,1,number($IndentPos))" /><xsl:text>    </xsl:text>
          <xsl:for-each select="enumElement">
            <UML:EnumerationLiteral name="{@name}"><xsl:value-of select="substring($Indent,1,number($IndentPos))" /><xsl:text>    </xsl:text>
              <xsl:if test="count(hexnumber)>0">
                <tag name="hexvalue"><xsl:value-of select="hexnumber" /></tag>
              </xsl:if>
              <xsl:if test="count(intnumber)>0">
                <tag name="intvalue"><xsl:value-of select="intnumber" /></tag>
              </xsl:if>
              <xsl:if test="count(symbol)>0">
                <tag name="symbolvalue"><xsl:value-of select="symbol" /></tag>
              </xsl:if>
              <xsl:if test="count(expressionValue)>0">
                <tag name="expressionValue"><xsl:value-of select="expressionValue" /></tag>
              </xsl:if>
              <xsl:if test="count(description)>0">
                <tag name="documentation"><xsl:value-of select="description/text" /></tag>
              </xsl:if>
            </UML:EnumerationLiteral><xsl:value-of select="substring($Indent,1,number($IndentPos))" /><xsl:text>  </xsl:text>
          </xsl:for-each>
        </UML:Enumeration><xsl:value-of select="substring($Indent,1,number($IndentPos))" /><xsl:text>  </xsl:text>
      </xsl:for-each>

    </UML:Classifier.feature><xsl:value-of select="substring($Indent,1,number($IndentPos))" />

    <UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos))" />

      <!-- Inner classes as definitions with same suffix name inside a CLASS_C are inner classes in C: -->
      <xsl:for-each select="/root/Cheader//CLASS_C[@name=$className]/structDefinition[@name ne $className and ends-with(@name, $className)]">
        <xsl:message>inner CLASS_C: <xsl:value-of select="@name" /></xsl:message>
        <xsl:comment><xsl:text> inner C-class </xsl:text><xsl:value-of select="@name" /><xsl:text> </xsl:text></xsl:comment>
        <xsl:variable name="classNameInner" select="@name" />
        <xsl:call-template name="GenerateNamedClass">
          <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
          <xsl:with-param name="fromCurrent" select="'yes'" />
          <xsl:with-param name="className" select="$classNameInner" />
          <xsl:with-param name="structName" select="$classNameInner" />
          <xsl:with-param name="classNameXmi" select="substring-before($classNameInner, $className)" />
          <xsl:with-param name="classNameFull"  select="$classNameInner" />
        </xsl:call-template>
      </xsl:for-each>

      <!-- inner classes (C++): -->
      <xsl:for-each select="/root/Cheader//classDef[@name=$className] | /root/Cheader//structDefinition[@name=$className]"><!-- select the named class or struct --> 
        <!-- current node: inside the struct or class definition -->
        <xsl:comment><xsl:text> check for inner classes </xsl:text><xsl:value-of select="@name" /><xsl:text> </xsl:text></xsl:comment>
        <xsl:for-each select="structDefintion | classDef | classVisibilityBlock/classDef"><!--struct or class inside another one. -->                   
          <xsl:message>inner class: <xsl:value-of select="@name" /></xsl:message>
          <xsl:variable name="classNameInner" select="@name" />
          <xsl:call-template name="GenerateNamedClass">
            <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
            <xsl:with-param name="fromCurrent" select="'yes'" />
            <xsl:with-param name="className" select="$classNameInner" />
            <xsl:with-param name="structName" select="$classNameInner" />
            <xsl:with-param name="classNameXmi" select="$classNameInner" />
            <xsl:with-param name="classNameFull" ><xsl:value-of select="$classNameFull" /><xsl:text>::</xsl:text><xsl:value-of select="$classNameInner" /></xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>  
        <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
        <xsl:comment><xsl:text> gen attributes </xsl:text><xsl:value-of select="$className" /><xsl:text>/</xsl:text><xsl:value-of select="$structName" /><xsl:text> </xsl:text></xsl:comment>
        <xsl:for-each select="attribute[@tagname]">                   
          <xsl:message>inner implicit class: <xsl:value-of select="@tagname" /></xsl:message>
          <xsl:variable name="classNameInner" select="@tagname" />
          <xsl:call-template name="GenerateNamedClass">
            <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
            <xsl:with-param name="fromCurrent" select="'yes'" />
            <xsl:with-param name="className" select="$classNameInner" />
            <xsl:with-param name="structName" select="$classNameInner" />
            <xsl:with-param name="classNameXmi" select="$classNameInner" />
            <xsl:with-param name="classNameFull" ><xsl:value-of select="$classNameFull" /><xsl:text>::</xsl:text><xsl:value-of select="$classNameInner" /></xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>  
        <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
      </xsl:for-each>  
   </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos))" /> 

    <UML:Classifier.instance>
      <xsl:for-each select="/root/Cheader/CLASS_C[@name=$className]/const_initializer">
        <xsl:variable name="name"><xsl:text>CONST</xsl:text><xsl:value-of select="@name" /></xsl:variable>
        <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
        <UML:Instance name="{$name}" stereotype="{$Stereotype_CONST_Initializer/UML:Stereotype/@xmi.id}" implementation="{value}" ><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
          <UML:ModelElement.taggedValue>
            <UML:TaggedValue tag="documentation" value="{description/text}" ></UML:TaggedValue>
          </UML:ModelElement.taggedValue>
          <UML:Instance.classifier>
            <UML:Classifier>
              <UML:Classifier.parameter><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
      <xsl:for-each select="parameter">
                  <xsl:variable name="paramName" select="@name" />
                  <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                  <UML:Parameter name="{$paramName}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
                    <UML:ModelElement.taggedValue>
                      <xsl:for-each select="../description/paramDescription[@name=$paramName]">
                        <xsl:value-of select="substring($Indent,1,number($IndentPos)+10)"/>
                        <UML:TaggedValue tag="documentation" value="{text}" />
                      </xsl:for-each>
                    <xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
                    </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                  </UML:Parameter>
                </xsl:for-each>
                <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
              </UML:Classifier.parameter><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
            </UML:Classifier>  
          </UML:Instance.classifier>  
        </UML:Instance>
      </xsl:for-each><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
    </UML:Classifier.instance> 
  </UML:Class><xsl:value-of select="substring($Indent,1,number($IndentPos))" />
</xsl:template>



<xsl:template name="attributeRecursive" >
<xsl:param name="IndentPos" />
<xsl:param name="bytePosBefore"/>  
      <xsl:variable name="typeName">
        <xsl:call-template name="getTypeRootfocus">
        <xsl:with-param name="typeName">      
          <xsl:choose><xsl:when test="type/@forward='struct' and ends-with(type/@name,'_t')">
            <xsl:variable name="typename" select="type/@name" />
            <xsl:value-of select="substring($typename,1,string-length($typename)-2)" /><!-- without _t -->  
          </xsl:when><xsl:when test="not(type/@name) and @tagname"><xsl:value-of select="@tagname" /><!-- especially on implicit embedded struct -->
          </xsl:when><xsl:otherwise>
            <xsl:value-of select="type/@name" />
          </xsl:otherwise></xsl:choose>
        </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
      <xsl:variable name="TypeNode" select="key('typeSearch',$typeName)" />
      <xsl:variable name="attribId" select="generate-id()" />
      <xsl:variable name="sizeType"><xsl:call-template name="getSizeType" /></xsl:variable>
      <xsl:variable name="sizeType">
				<xsl:choose><xsl:when test="description[last()]/sizeof">
					<xsl:value-of select="description[last()]/sizeof/@sizeof" />
				</xsl:when><xsl:otherwise>
					<xsl:call-template name="getSizeType" />
				</xsl:otherwise></xsl:choose>
			</xsl:variable>
      <xsl:variable name="bytePos">
				<xsl:choose><xsl:when test="description[last()]/bytepos">
					<xsl:value-of select="description[last()]/bytepos/@value" />
				</xsl:when><xsl:otherwise>
					<xsl:value-of select="$bytePosBefore" />
				</xsl:otherwise></xsl:choose>
			</xsl:variable>
      <xsl:if test="not(boolean(type/@xxxconstPointer) or boolean(type/@xxxpointer))">  
        <xsl:text>
        </xsl:text>
        <UML:Attribute name="{@name}" xmi.id="{$attribId}" typeName_info="{$typeName}" type="{$TypeNode/@xmi.id}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)" />
          <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <xsl:variable name="multiplicity">
              <xsl:choose><xsl:when test="count(arraysize)>0"><xsl:value-of select="arraysize/@value" />
              </xsl:when><xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>    
            <UML:TaggedValue tag="byteOffset" value="{$bytePos}"/><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <UML:TaggedValue tag="sizeof" value="{$sizeType}"/><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <xsl:if test="description/bytepos">
            </xsl:if>
            <UML:TaggedValue tag="multiplicity" value="{$multiplicity}"/><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <xsl:if test="boolean(type/@pointer) or boolean(type/@constPointer) or boolean(type/@volatilePointer)" >
              <UML:TaggedValue xmi.id="{generate-id()}{'@r'}" tag="isReference" value="True" modelElement="{$attribId}"/>
            </xsl:if>
            <xsl:if test="boolean(type/@constPointer)" >
              <UML:TaggedValue xmi.id="{generate-id()}{'@c'}" tag="isConstant" value="True" modelElement="{$attribId}"/>
            </xsl:if>
            <xsl:if test="boolean(type/@pointer) or boolean(type/@volatilePointer) " >
              <UML:TaggedValue xmi.id="{generate-id()}{'@a'}" tag="isAssociationEnd" value="True" modelElement="{$attribId}"/>
            </xsl:if>
            <UML:TaggedValue tag="documentation" value="{description[last()]/text}" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <xsl:for-each select="description/sizeof">
            </xsl:for-each>
          </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
        </UML:Attribute>
      </xsl:if>  
  <xsl:for-each select="following-sibling::attribute[1]|structContentInsideCondition/attribute[1]">
    <xsl:call-template name="attributeRecursive">
      <xsl:with-param name="bytePosBefore" select="number($bytePos) + number($sizeType)" />
      <xsl:with-param name="IndentPos" select="$IndentPos" />
    </xsl:call-template>
  </xsl:for-each>          
</xsl:template>





<!-- gets the name of a current <class> considering the possibility that the type is a inner type of the own class.
     Example:
     <structDefinition name="outer">
         <structDefinition name="inner" xmi.id="1234">
     returns outer_inner ##a    
 --> 
<xsl:template name="getGlobalClassIdent">
<xsl:param name="separator" select="'_'" />
  <xsl:call-template name="getGlobalClassIdent-recursively"><xsl:with-param name="separator" select="$separator" /></xsl:call-template>      
  <xsl:value-of select="@name" /> 
</xsl:template>     

<xsl:template name="getGlobalClassIdent-recursively">
<xsl:param name="separator" />
  <xsl:for-each select="..[local-name()!='Cheader']">
    <!-- process backward to the last <UML:Class>-level -->
    <xsl:call-template name="getGlobalClassIdent-recursively"><xsl:with-param name="separator" select="$separator" /></xsl:call-template>      
    <!-- than capture forward the name structure -->
    <xsl:variable name="tag" select="local-name()" />
    <xsl:if test="($tag='structDefinition' or $tag='classDef')">
      <!-- a definition with the $typeName is found as an inner element: add the outer name. -->
      <xsl:value-of select="@name" /><xsl:value-of select="$separator" />
    </xsl:if>
  </xsl:for-each>
</xsl:template>     






<!-- gets the name of a type considering the possibility that the type is a inner type of the own class (visible in local scope).
     The problem is: A C compiler visits the type in local scope without long-form (canonical form) of the type identifier.
     But by XMI conversion the type-id are found only with the long canonical name.
     Example:
     struct MyStruct
     { typedef struct InnerStruct{ int a; int b; } InnerStruct;
       InnerStruct* pointer;  //The canonical type is MyStruct::InnerStruct.
     }  
 --> 
<xsl:template name="getTypeRootfocus">
<xsl:param name="typeName" />
  <xsl:call-template name="getTypeRootfocus-recursively"><xsl:with-param name="typeName" select="$typeName" /></xsl:call-template>      
  <xsl:value-of select="$typeName" /> 
</xsl:template>     

<xsl:template name="getTypeRootfocus-recursively">
<xsl:param name="typeName" />
  <xsl:for-each select="..[local-name()!='CHeader']">
    <xsl:call-template name="getTypeRootfocus-recursively"><xsl:with-param name="typeName" select="$typeName" /></xsl:call-template>      
  </xsl:for-each>
  <xsl:variable name="tag" select="local-name()" />
  <xsl:if test="(       $tag='structDefinition' or $tag='classDef' 
                )and(   boolean(.//attribute[@tagname=$typeName]) or boolean(.//classDef[@name=$typeName]) or boolean(.//structDefinition[@name=$typeName])
                )
               ">
    <!-- a definition with the $typeName is found as an inner element: add the outer name. -->
    <xsl:value-of select="@name" /><xsl:text>::</xsl:text>
  </xsl:if>
</xsl:template>     
  





<xsl:template name="getSizeType">
  <xsl:choose>
    <xsl:when test="type/@name='int8'">1</xsl:when>
    <xsl:when test="type/@name='int16'">2</xsl:when>
    <xsl:when test="type/@name='int32'">4</xsl:when>
    <xsl:when test="type/@name='uint8'">1</xsl:when>
    <xsl:when test="type/@name='uint16'">2</xsl:when>
    <xsl:when test="type/@name='uint32'">4</xsl:when>
    <xsl:when test="type/@name='char'">1</xsl:when>
    <xsl:when test="type/@name='short'">2</xsl:when>
    <xsl:when test="type/@name='int'">4</xsl:when>
    <xsl:when test="type/@name='long'">4</xsl:when>
    <xsl:when test="boolean(type/@pointer)">4</xsl:when>
    <xsl:when test="boolean(variante)"><xsl:call-template name="getSizeUnion" /></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="getSizeStruct">
        <xsl:with-param name="structName" select="type/@name" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- supplies the size of the current attribut with elements variante, its a union. -->
<!-- It works in a recursion calling getSizeUnion_i. The last call supplies the sizeMaxNew as return value -->
<xsl:template name="getSizeUnion">
<xsl:param name="sizeMax" select="'0'" />
  <xsl:text>/*union: */ </xsl:text>
  <xsl:for-each select="variante[1]">
    <xsl:call-template name="getSizeUnion_i" />
  </xsl:for-each>
</xsl:template>


  
<!-- inner routine called only recursively in getSizeUnion. -->
<xsl:template name="getSizeUnion_i">
<xsl:param name="sizeMax" select="'0'" />
  <xsl:variable name="nrofBytes"><xsl:call-template name="getSizeType" /></xsl:variable>
  <xsl:variable name="sizeMaxNew">
    <xsl:choose>
      <!-- if nrofBytes or sizeMax contains .kIdxAfterLast, it comes from a structure. Any comparision is not able here. -->
      <!-- in this cases it is assumed that the all struct in the union have the same size. -->
      <xsl:when test="contains($nrofBytes,'.kIdxAfterLast')" ><xsl:value-of select="$nrofBytes" /></xsl:when>
      <xsl:when test="contains($sizeMax,'.kIdxAfterLast')" ><xsl:value-of select="$sizeMax" /></xsl:when>
      <!-- xsl:when test="$nrofBytes instance of String"><xsl:value-of select="$nrofBytes" /></xsl:when -->
      <!-- xsl:when test="$sizeMax instance of String"><xsl:value-of select="$sizeMax" /></xsl:when -->
      <xsl:when test="$nrofBytes gt $sizeMax"><xsl:value-of select="$nrofBytes" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$sizeMax" /></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:text>/*</xsl:text><xsl:value-of select="@name" /><xsl:text>=</xsl:text><xsl:value-of select="$sizeMaxNew" /><xsl:text> */ </xsl:text>
  <xsl:choose>
    <xsl:when test="boolean(following-sibling::variante[1])">
      <xsl:for-each select="following-sibling::variante[1]">
        <xsl:call-template name="getSizeUnion_i"><xsl:with-param name="sizeMax" select="$sizeMaxNew" /></xsl:call-template>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$sizeMaxNew" /></xsl:otherwise>
  </xsl:choose>
</xsl:template>




<xsl:template name="getSizeStruct">
<xsl:param name="structName" />
  <xsl:for-each select="  /root/Cheader//structDefinition[@name=$structName]/(structContentInsideCondition|.)/attribute[1]
                       | /root/Cheader//classDef[@name=$structName]//attribute[1]">
    <xsl:call-template name="getSizeStruct-i" ><xsl:with-param name="sizeBefore" select="0" /></xsl:call-template>
  </xsl:for-each>  
</xsl:template>



<xsl:template name="getSizeStruct-i">
<xsl:param name="sizeBefore" />
  <xsl:variable name="typeSize"><xsl:call-template name="getSizeType" /></xsl:variable>
  <xsl:variable name="size" select="number($sizeBefore) + number($typeSize)" />
  <xsl:for-each select="following-sibling::attribute[1]">
    <xsl:call-template name="getSizeStruct-i"><xsl:with-param name="sizeBefore" select="$size" /></xsl:call-template>
  </xsl:for-each>          
  <xsl:if test="not(following-sibling::attribute[1])" >
    <xsl:value-of select="$size" />
  </xsl:if>    
</xsl:template>




<xsl:template name="getType" >
  <xsl:variable name="name" select="type/@name" />
  <xsl:variable name="translatedName" select="key('tag2type',$name)" />
  <xsl:choose><xsl:when test="$translatedName" >
    <xsl:value-of select="$translatedName/@type" />
  </xsl:when><xsl:otherwise>
    <xsl:value-of select="$name"/>
  </xsl:otherwise></xsl:choose>          
</xsl:template>



<xsl:template name="generateAssociations" >
<!-- current xml element is a structDefinition or classDef -->
<xsl:param name="IndentPos" />
  <xsl:variable name="className">
    <xsl:call-template name="getGlobalClassIdent"><xsl:with-param name="separator" select="'::'" /></xsl:call-template>      
  </xsl:variable>
  <xsl:variable name="ClassNode" select="key('typeSearch',$className)" /><!-- name of the structDefinition -->
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
  <xsl:for-each select="(structDefinition | . | classVisibilityBlock) / (structContentInsideCondition|.)/attribute">
    <!-- xsl:variable name="typeName" select="type/@name" / -->
    <xsl:variable name="typeName"><xsl:call-template name="getType" /></xsl:variable>
    <xsl:variable name="type"><!-- xxa -->
      <xsl:call-template name="getTypeRootfocus">
        <xsl:with-param name="typeName" select="$typeName" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="TypeNode" select="key('typeSearch',$typeName)" />
    <!-- xsl:variable name="typeNode" select="/root/Types/usedType[@name=$typeName]" / -->
    <xsl:variable name="isClassType"><xsl:if test="not($TypeNode/@external='true')">true</xsl:if></xsl:variable><!-- NOTE-xsl: use not(...='true') instead ...!='true' because it is false if the attribute @external isnot found. -->
    <!-- TEST name="{@name}" type="{$typeName}"><xsl:copy-of select="$TypeNode" /></TEST -->
    <!-- xsl:if test="boolean(type/@constPointer) 
               or boolean(type/@pointer)
               or $isClassType='true'            " -->
    <xsl:if test="$isClassType='true'">
      <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
      <xsl:variable name="AssociationName">
        <xsl:value-of select="$className" /><xsl:text>_</xsl:text><xsl:value-of select="@name" />
      </xsl:variable>
      <xsl:choose><xsl:when test="boolean(description/superClass) or (position()=1 and not(type/@pointer) and not(type/@constPointer) and not(type/@volatilePointer))">
        <!-- NOTE UML: parent is the superclass,from which the generalization starts. -->
        <UML:Generalization name="{$AssociationName}" parent="{$TypeNode/@xmi.id}" child="{$ClassNode/@xmi.id}" />
      </xsl:when><xsl:otherwise>  
        <UML:Association name="{$AssociationName}" gen_info="generateAssociations"><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
          <UML:Association.connection><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
            <!-- NOTE: an association has always to ends, but all references in Headerfiles are single ended associations.
                 The first end has the name of the reference and the type of the destination (referenced) object.
                 The second end has no name and the type of the source (own) object.
             -->
            <UML:AssociationEnd 
              name="{@name}" 
              type="{$TypeNode/@xmi.id}"  typeName_info="{$type}"
              isNavigable="true" aggregation="none" 
            >
              <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)" />
              <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                <xsl:variable name="multiplicity">
                  <xsl:choose><xsl:when test="count(arraysize)>0"><xsl:value-of select="arraysize/@value" />
                  </xsl:when><xsl:otherwise>1</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>    
                <UML:TaggedValue tag="multiplicity" value="{$multiplicity}"/><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                <UML:TaggedValue tag="documentation" value="{description/text}" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                <xsl:for-each select="description/sizeof">
                  <UML:TaggedValue tag="sizeof" value="{@sizeof}" ><xsl:value-of select="text" /></UML:TaggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                </xsl:for-each>
              </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
            </UML:AssociationEnd><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
    
            <UML:AssociationEnd type="{$ClassNode/@xmi.id}" _srcClass="{$ClassNode/@name}" >
              
              <xsl:choose><xsl:when test="type/@constPointer">
                <xsl:attribute name="aggregation">shared</xsl:attribute>
              </xsl:when><xsl:when test="type/@pointer">
                <xsl:attribute name="aggregation">none</xsl:attribute>
              </xsl:when><xsl:otherwise>
                <!-- it isnot a pointer, therefore composite. -->  
                <xsl:attribute name="aggregation">composite</xsl:attribute>
              </xsl:otherwise></xsl:choose>  
            </UML:AssociationEnd><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
            
          </UML:Association.connection><xsl:value-of select="substring($Indent,1,number($IndentPos))" />
        </UML:Association>
      </xsl:otherwise></xsl:choose>    
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<!-- returns the appropriate Cheader element to fillin in a variable. 
     It is possible that more as one Cheader Object exists if more as one input files are converted.
 -->    
<xsl:template name="elementCheader" >
  <xsl:choose><xsl:when test="local-name()='Cheader'"><xsl:copy-of select="." />
  </xsl:when><xsl:otherwise><xsl:for-each select=".."><xsl:call-template name="elementCheader" /></xsl:for-each>
  </xsl:otherwise></xsl:choose>
</xsl:template>


<!-- returns the filename containing in Cheader/@filename. 
     It is possible that more as one Cheader Object exists if more as one input files are converted.
 -->    
<xsl:template name="fileCheader" >
  <xsl:choose><xsl:when test="local-name()='Cheader'"><xsl:value-of select="@filename" />
  </xsl:when><xsl:otherwise><xsl:for-each select=".."><xsl:call-template name="fileCheader" /></xsl:for-each>
  </xsl:otherwise></xsl:choose>
</xsl:template>


</xsl:stylesheet>

