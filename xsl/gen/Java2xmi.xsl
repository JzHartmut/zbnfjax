<?xml version="1.0" encoding="iso-8859-1"?>
<!--
 2007-12-27 TODO detecting of superclass, important to build reflection with base Object_Jc.
 2007-12-25 JcHartmut processing of inner struct, inner class and implicit struct.
 -->
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


<xsl:variable name="Stereotype_CONST_Initializer">
  <UML:Stereotype  xmi.id="{generate-id()}" name="CONST_initializer" visibility="public">
  </UML:Stereotype>
</xsl:variable>



<xsl:template match="/" >
  <xsl:message>==Java2XMI==</xsl:message>
  <xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
  <XMI xmi.version="1.2"><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
    <XMI.header><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
      <XMI.documentation/><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
      <XMI.metamodel xmi.name="UML" xmi.version="1.3"/><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
    </XMI.header><xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
    <XMI.content><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
      <UML:Model name="GeneratedFromJava"><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
        <UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          <xsl:copy-of select="$Stereotype_CONST_Initializer" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          <UML:Package name="pkgExtTypes"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
            <UML:Namespace.ownedElement>
              <xsl:call-template name="_Types"><xsl:with-param name="IndentPos" select="number($IndentPos)+10" /></xsl:call-template>
              <xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
            </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          </UML:Package><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
          
          <xsl:variable name="pkgList">
            <xsl:call-template name="getTreeOfPackages" />
          </xsl:variable>
          
          <xsl:for-each select="$pkgList/Package">
            <xsl:message>Package: <xsl:value-of select="@name" />:<xsl:value-of select="@count" /></xsl:message>
          </xsl:for-each>
          
          <xsl:variable name="Input" select="/" /><!-- reference to input tree -->
          <xsl:for-each select="$pkgList/Package">
            <xsl:variable name="pkgNameFromList" select="@name"/>
            <UML:Package name="{$pkgNameFromList}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
              <UML:Namespace.ownedElement>
                
                <xsl:for-each select="$Input/root/JavaSrc">
                  <xsl:variable name="pkgName"><xsl:call-template name="getPkgName" /></xsl:variable>  
                  <xsl:if test="$pkgName = $pkgNameFromList">
                 
                    <xsl:call-template name="allClassesOfJava" />
                 
                  </xsl:if>
                </xsl:for-each>
                
              </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            </UML:Package><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
          </xsl:for-each>
          
          
          
            
          <!-- all the same package! TODO: first detect packages. -->
          <xsl:variable name="nameOfPkg"><xsl:for-each select="/root/JavaSrc[1]/PackageDefinition">
            <xsl:for-each select="packageClassName"><xsl:text></xsl:text><xsl:choose><xsl:when test="last() = position()"><xsl:text></xsl:text><xsl:value-of select="text()" /><xsl:text></xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text></xsl:for-each>
            <!-- xsl:for-each select="packageClassName"><xsl:text></xsl:text><xsl:value-of select="text()" /><xsl:text></xsl:text><xsl:choose><xsl:when test="last() > position()"><xsl:text>_</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text></xsl:for-each -->
          </xsl:for-each></xsl:variable>  
          <!-- UML:Package name="{$nameOfPkg}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
            <UML:Namespace.ownedElement>
              <xsl:for-each select="/root/JavaSrc">
                <xsl:call-template name="allClassesOfJava" />
          
              </xsl:for-each>
            </UML:Namespace.ownedElement><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          </UML:Package><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/ -->
  
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
    <!-- UML:DataType... -->
    <UML:Class name="{@name}" xmi.id="{@xmi.id}" visibility="public">
      <xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
        <UML:ModelElement.taggedValue>
          <UML:TaggedValue xmi.id="{generate-id()}" tag="documentation" value="autoGenerated from Java2Cxmi, used type defined outside."/>
        </UML:ModelElement.taggedValue>
      <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
    </UML:Class>
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





<xsl:template name="getTreeOfPackages">
  <xsl:variable name="pkgUnsorted"><!-- tree of all packages -->
    <xsl:for-each select="/root/JavaSrc">
      <xsl:variable name="countPkgName"><xsl:value-of select="count(packageClassName)"/></xsl:variable>
      <xsl:variable name="pkgName"><xsl:call-template name="getPkgName" /></xsl:variable>  
      <Package name="{$pkgName}" count="{$countPkgName}" />
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="pkgSorted">
    <xsl:for-each select="$pkgUnsorted/Package">
    <xsl:sort select="@name"/>
      <xsl:copy-of select="."/>  
    </xsl:for-each>
  </xsl:variable>

  <!-- Produce all different packages in the result tree, it should be written in a variable: -->
  <xsl:for-each select="$pkgSorted/Package[@name != following-sibling::Package[1]/@name  or position()=last()]">
      <xsl:copy-of select="."/>  
  </xsl:for-each>
  
</xsl:template>


<!-- gets the package name. Current node is root/JavaSrc -->
<xsl:template name="getPkgName" >
  <xsl:for-each select="PackageDefinition/packageClassName">
    <xsl:if test="position() = last()"><!-- Use only the last part as pkg name. It should be different. -->
      <xsl:value-of select="text()" /><xsl:text></xsl:text>
    </xsl:if>
  </xsl:for-each>  
</xsl:template>





<!-- This template searches all classes in XML input, from current JavaSrc element, it is input from one src.java.
     It's from Cheader, not in Java, simplify it later TODO: Because the informations to one class may be dispersed in several header files,
     first only the names of the classes are gathered. This is in variable ClassNamesSorted.
     Second, the xml tree of ClassNamesSorted is proceeded, GenerateNamedClass is called, but only one per className.
     The work in the matter of fact is done from the called template GenerateNamedClass,
     this template searches the named class in the input xml tree and processes it.     
 -->
<xsl:template name= "allClassesOfJava">
  <!-- caputure all names of classes found in all input files: -->
  <xsl:variable name="ClassNamesSorted">
    <xsl:for-each select="classDefinition | interfaceDefinition">
    <xsl:sort select="classident" />  
      <class name="{classident}" />
    </xsl:for-each>
  </xsl:variable>
  <!-- variable ClassNamesSorted may contain more as one entry with same name, but sorted! It is because parts of class definition may be dispursed in some headers.-->
  <xsl:variable name="ClassNames">
    <xsl:for-each select="$ClassNamesSorted/class[position()=last() or @name!=following-sibling::class[1]/@name]">
      <class name="{@name}" />
    </xsl:for-each>    
  </xsl:variable>
  <xsl:variable name="Input" select="/" /><!-- reference to input tree -->
  <!-- select only classes with differen name-->
    <xsl:for-each select=".//classDefinition | .//interfaceDefinition">
      <xsl:call-template name="generateAssociations">
        <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
      </xsl:call-template>
    </xsl:for-each>
  <!-- xsl:for-each select="$ClassNamesSorted/class[position()=last() or @name!=following-sibling::class[1]/@name]" -->
  <xsl:for-each select="classDefinition | interfaceDefinition">
    <xsl:message><xsl:text>Class </xsl:text><xsl:value-of select="classident" /></xsl:message>
    <xsl:variable name="ClassName" select="classident" />
    <!-- NOTE: use $Input as reference to the input tree to select because otherwise / means the root in context $Classname -->
    <!--xsl:for-each select="$Input" -->
      <xsl:call-template name="GenerateClass">
        <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
        <xsl:with-param name="className" select="$ClassName" />
      </xsl:call-template>
    <!-- /xsl:for-each -->  
  </xsl:for-each>
</xsl:template>





<xsl:template name= "allClasses">
  <xsl:message>old</xsl:message>
</xsl:template>  


<!-- generates its content. -->
<xsl:template name="GenerateClass">
<xsl:param name="IndentPos" />
<xsl:param name="fromCurrent" select="'yes'" />
<xsl:param name="className" />
<xsl:param name="classNameFull" select="$className"/><!-- full class name from root focus -->
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
  
  <xsl:variable name="classId" select="key('typeSearch',$classNameFull)/@xmi.id" />
  <xsl:variable name="nodeClassStruct" 
    select="." />
  <UML:Class name="{$className}" xmi.id="{$classId}" headerStruct="true" nameRootFocus_info="{$classNameFull}">
    <xsl:if test="$nodeClassStruct/description/GUID">
      <xsl:attribute name="xmi.uuid"><xsl:value-of select="$nodeClassStruct/description/GUID/@value" /></xsl:attribute>
    </xsl:if>
    <xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
    <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
      <xsl:for-each select=".[$fromCurrent='yes'] | /root/JavaSrc/classDefinition[classident=$classNameFull]">
        <xsl:variable name="nameHeaderfile"><xsl:call-template name="fileCheader" /></xsl:variable>
        <UML:TaggedValue tag="filename" value="{$nameHeaderfile}" />
        <xsl:for-each select="/root/Cheader//CLASS_C[@name=$classNameFull]/structDefinition[@name=$className] 
                            | /root/Cheader/outside//classDef[@name=$className]
                            | /root/Cheader/outside/structDefinition[@name=$classNameFull]
                             ">
          <xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
          <UML:TaggedValue tag="documentation" value="{description/text}" />
        </xsl:for-each>
      </xsl:for-each>  
    </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
    
    <UML:Classifier.feature>
      <!-- generate atrributes of the structDefinition or classDef.
           If it is a toplevel CLASS_C than the node for structDefinition will be found with the name is given classNameFull,
           but if it is a inner structDefinition or classDef the current xml element contains the attribute[] 
        -->
        <xsl:for-each select="variableDefinition">                    
          <xsl:call-template name="gen_attribute">
            <xsl:with-param name="IndentPos" select="number($IndentPos)" />
          </xsl:call-template>
        </xsl:for-each>  
      
      <xsl:for-each select="methodDefinition">
        <xsl:variable name="type"><xsl:value-of select="type/@name" /></xsl:variable>
        <xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
        <!-- NOTE: UML:Method isn't accepted by XMI-Import of Rhapsody. -->
        <UML:Operation name="{name}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)" />
          <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
            <UML:TaggedValue tag="documentation" value="{description/text}" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
          <UML:BehavioralFeature.parameter><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <UML:Parameter kind="return" typeName_info="{type/@name}" type="{key('typeSearch',type/@name)/@xmi.id}" visibility="public"/><!-- typePackage="{$nameHeaderfile}" -->
            <xsl:for-each select="argument">
              <xsl:variable name="paramName" select="variableName" />
              <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
              <UML:Parameter name="{$paramName}" typeName_info="{type/@name}" type="{key('typeSearch',type/@name)/@xmi.id}" kind="inout"><xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
                <UML:ModelElement.taggedValue>
                  <xsl:for-each select="../description/param[variableName=$paramName]">
                    <xsl:value-of select="substring($Indent,1,number($IndentPos)+10)"/>
                    <UML:TaggedValue tag="documentation" value="{text}" />
                  </xsl:for-each>
                <xsl:value-of select="substring($Indent,1,number($IndentPos)+8)"/>
                </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
              </UML:Parameter>
            </xsl:for-each>
            <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
          </UML:BehavioralFeature.parameter><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)"/>
        </UML:Operation>
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
        <xsl:for-each select="classDefinition | interfaceDefinition">                   
          <xsl:message>inner class: <xsl:value-of select="@name" /></xsl:message>
          <xsl:variable name="classNameInner" select="classident" />
          <xsl:call-template name="GenerateClass">
            <xsl:with-param name="IndentPos" select="number($IndentPos)+8" />
            <xsl:with-param name="className" select="$classNameInner" />
            <xsl:with-param name="classNameFull" ><xsl:value-of select="$classNameFull" /><xsl:text>.</xsl:text><xsl:value-of select="$classNameInner" /></xsl:with-param>
          </xsl:call-template>
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



<xsl:template name="gen_attribute" >
<xsl:param name="IndentPos" select="$IndentPos" />  
      <xsl:variable name="typeName">
        <xsl:call-template name="getTypeRootfocus">
        <xsl:with-param name="typeName">      
          <xsl:call-template name="getTypeName" />
    
            <!-- xsl:value-of select="type/name" / -->
        </xsl:with-param>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
      <xsl:variable name="typeNode" select="key('typeSearch',$typeName)" />
      <xsl:variable name="isAttrType"><xsl:if test="$typeNode/@basicType">true</xsl:if></xsl:variable><!-- NOTE-xsl: use not(...='true') instead ...!='true' because it is false if the attribute @external isnot found. -->
      <xsl:if test="$isAttrType='true'">  
        <xsl:variable name="attribId" select="generate-id()" />
        <UML:Attribute name="{name|variableName}" xmi.id="{$attribId}" typeName_info="{$typeName}" type="{$typeNode/@xmi.id}"><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)" />
          <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <xsl:variable name="multiplicity">
              <xsl:choose><xsl:when test="count(arraysize)>0"><xsl:value-of select="arraysize/@value" />
              </xsl:when><xsl:otherwise>1</xsl:otherwise>
              </xsl:choose>
            </xsl:variable>    
            <UML:TaggedValue tag="multiplicity" value="{$multiplicity}"/><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <xsl:if test="boolean(type/@pointer) or boolean(type/@constPointer) or boolean(type/@volatilePointer)" >
              <UML:TaggedValue xmi.id="{generate-id()}" tag="isReference" value="True" modelElement="{$attribId}"/>
            </xsl:if>
            <UML:TaggedValue tag="documentation" value="{description/text}" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            <xsl:for-each select="description/sizeof">
              <UML:TaggedValue tag="sizeof" value="{@sizeof}" ><xsl:value-of select="text" /></UML:TaggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
            </xsl:for-each>
          </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
        </UML:Attribute>
      </xsl:if>  
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
  <xsl:value-of select="classident" /> 
</xsl:template>     

<xsl:template name="getGlobalClassIdent-recursively">
<xsl:param name="separator" />
  <xsl:for-each select="..[local-name()!='JavaSrc']">
    <!-- process backward to the last <UML:Class>-level -->
    <xsl:call-template name="getGlobalClassIdent-recursively"><xsl:with-param name="separator" select="$separator" /></xsl:call-template>      
    <!-- than capture forward the name structure -->
    <xsl:variable name="tag" select="local-name()" />
    <xsl:if test="($tag='classDefinition') or ($tag='interfaceDefinition')">
      <!-- a definition with the $typeName is found as an inner element: add the outer name. -->
      <xsl:value-of select="classident" /><xsl:value-of select="$separator" />
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
  <!-- xsl:message>getTypeRootFocus, typeName=<xsl:value-of select="$typeName"/></xsl:message -->
  <xsl:variable name="typeName1">
    <!-- test 2015-03-15 there is a problem with contains, not clarified -->
    <!--xsl:choose><xsl:when test="contains($typeName, '.')" ><xsl:value-of select="substring-before($typeName, '.')" />
    </xsl:when><xsl:otherwise --><xsl:value-of select="$typeName" />  
    <!-- /xsl:otherwise></xsl:choose -->
  </xsl:variable>
  <xsl:call-template name="getTypeRootfocus-recursively"><xsl:with-param name="typeName" select="$typeName1" /></xsl:call-template>      
  <xsl:value-of select="$typeName" /> 
  <!-- xsl:message>getTypeRootFocus, success</xsl:message -->
</xsl:template>     

<xsl:template name="getTypeRootfocus-recursively">
<xsl:param name="typeName" />
  <xsl:variable name="tag" select="local-name()" />
  <xsl:variable name="envName" >
    <xsl:if test="($tag='classDefinition') or ($tag='interfaceDefinition')"><xsl:value-of select="classident" /></xsl:if> 
  </xsl:variable>
  <xsl:for-each select="..[local-name()!='JavaSrc']">
    <xsl:call-template name="getTypeRootfocus-recursively"><xsl:with-param name="typeName" select="$typeName" /></xsl:call-template>      
  </xsl:for-each>
  <xsl:if test="($tag='classDefinition' 
                and boolean(.//(classDefinition|interfaceDefinition)[classident=$typeName])
                )
               ">
    <!-- a definition with the $typeName is found as an inner element: add the outer name. -->
    <xsl:value-of select="classident" /><xsl:text>.</xsl:text>
  </xsl:if>
</xsl:template>     
  





<xsl:template name="getSizeType">
  <xsl:choose>
    <xsl:when test="type/name='int8'">1</xsl:when>
    <xsl:when test="type/name='int16'">2</xsl:when>
    <xsl:when test="type/name='int32'">4</xsl:when>
    <xsl:when test="type/name='uint8'">1</xsl:when>
    <xsl:when test="type/name='uint16'">2</xsl:when>
    <xsl:when test="type/name='uint32'">4</xsl:when>
    <xsl:when test="type/name='char'">1</xsl:when>
    <xsl:when test="type/name='short'">2</xsl:when>
    <xsl:when test="type/name='int'">4</xsl:when>
    <xsl:when test="type/name='long'">4</xsl:when>
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
  <xsl:for-each select="  /root/Cheader//structDefinition[@name=$structName]/attribute[1]
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



<!-- current xml is type/ContainerElementType or type -->
<xsl:template name="getNameEnv">
  <xsl:for-each select="envIdent">
    <xsl:text></xsl:text><xsl:value-of select="@name" /><xsl:text>.</xsl:text>
    <xsl:for-each select="subIdent">
      <xsl:text></xsl:text><xsl:value-of select="@name" /><xsl:text>.</xsl:text>
    </xsl:for-each>
  
  </xsl:for-each>
  <xsl:value-of select="@name" />
</xsl:template>



<xsl:template name="getTypeName">
  <xsl:choose><xsl:when test="type/ContainerElementType"><!-- old form, obsolete -->
    <xsl:for-each select="type/ContainerElementType" ><xsl:call-template name="getNameEnv" /></xsl:for-each>
  </xsl:when><xsl:when test="type/GenericType">
    <xsl:choose><xsl:when test="type/GenericType[2]"><xsl:for-each select="type/GenericType[2]" ><xsl:call-template name="getNameEnv" /></xsl:for-each>
    </xsl:when><xsl:otherwise><xsl:for-each select="type/GenericType" ><xsl:call-template name="getNameEnv" /></xsl:for-each>
    </xsl:otherwise></xsl:choose>
  </xsl:when><xsl:otherwise>
    <xsl:for-each select="type" ><xsl:call-template name="getNameEnv" /></xsl:for-each>
  </xsl:otherwise></xsl:choose>
      <!--xsl:text></xsl:text><xsl:choose><xsl:when test="type/ContainerElementType"><xsl:text></xsl:text><xsl:value-of select="type/ContainerElementType/@name" /><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text></xsl:text><xsl:value-of select="type/@name" /><xsl:text></xsl:text></xsl:otherwise></xsl:choose><xsl:text></xsl:text -->
</xsl:template>

<xsl:template name="generateAssociations" >
<!-- current xml element is a classDefinition -->
<xsl:param name="IndentPos" />
  <xsl:variable name="className">
    <xsl:call-template name="getGlobalClassIdent"><xsl:with-param name="separator" select="'.'" /></xsl:call-template>      
  </xsl:variable>
  <xsl:variable name="ClassNode" select="key('typeSearch',$className)" /><!-- name of the structDefinition -->
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
  <xsl:call-template name="gen_Generalization" >
    <xsl:with-param name="childClassNode" select="$ClassNode" />
    <xsl:with-param name="IndentPos" select="number($IndentPos)" />
  </xsl:call-template>
  <xsl:call-template name="gen_Dependencies" >
    <xsl:with-param name="childClassNode" select="$ClassNode" />
    <xsl:with-param name="IndentPos" select="number($IndentPos)" />
  </xsl:call-template>
  <xsl:for-each select="variableDefinition">
    <xsl:variable name="typeName1">
      <xsl:call-template name="getTypeName" />
     </xsl:variable>
    <xsl:variable name="typeName"><!-- xxa -->
      <xsl:call-template name="getTypeRootfocus">
        <xsl:with-param name="typeName" select="$typeName1" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="typeNode" select="/root/Types/usedType[@name=$typeName]" />
    <xsl:variable name="isClassType"><xsl:if test="not($typeNode/@basicType='true')">true</xsl:if></xsl:variable><!-- NOTE-xsl: use not(...='true') instead ...!='true' because it is false if the attribute @external isnot found. -->
    <!-- xsl:variable name="isClassType"><xsl:if test="$typeNode/@basicType!='true'">true</xsl:if></xsl:variable --><!-- NOTE-xsl: use not(...='true') instead ...!='true' because it is false if the attribute @external isnot found. -->
    <!-- TEST text="{$typeName}"><xsl:copy-of select="$typeNode" /></TEST -->
    <xsl:if test="$isClassType='true'">
      <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
      <xsl:variable name="typeNode" select="key('typeSearch',$typeName)" />
      <xsl:variable name="AssociationName">
        <xsl:value-of select="$className" /><xsl:text>_</xsl:text><xsl:value-of select="name|variableName" />
      </xsl:variable>
      <xsl:variable name="association_id" select="generate-id()" />
        <UML:Association name="{name|variableName}" xmi.id="{$association_id}" gen_info="generateAssociations"><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
          <UML:Association.connection><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
            <!-- NOTE: an association has always to ends, but all references in Headerfiles are single ended associations.
                 The first end has the name of the reference and the type of the destination (referenced) object.
                 The second end has no name and the type of the source (own) object.
             -->
            <UML:AssociationEnd
              name="{name|variableName}" 
              type="{$typeNode/@xmi.id}"  typeName1_info="{$typeName1}" typeName_info="{$typeName}"
              isNavigable="true" aggregation="none"
              association="{$association_id}" 
            >
              <xsl:value-of select="substring($Indent,1,number($IndentPos)+6)" />
              <xsl:if test="type/GenericType">    <!-- ContainerElementType"> -->
                <UML:AssociationEnd.multiplicity>
                  <UML:Multiplicity >
                    <UML:Multiplicity.range>
                      <UML:MultiplicityRange lower="*" upper="*"/>
                    </UML:Multiplicity.range>
                  </UML:Multiplicity>
                </UML:AssociationEnd.multiplicity>
              </xsl:if>  
              <xsl:if test="type/typeArray">
                <UML:AssociationEnd.multiplicity>
                  <UML:Multiplicity >
                    <UML:Multiplicity.range>
                      <UML:MultiplicityRange lower="*" upper="*"/>
                    </UML:Multiplicity.range>
                  </UML:Multiplicity>
                </UML:AssociationEnd.multiplicity>
              </xsl:if><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)" />
              <UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
                <UML:TaggedValue tag="documentation" value="{description/text}" /><xsl:value-of select="substring($Indent,1,number($IndentPos)+6)"/>
              </UML:ModelElement.taggedValue><xsl:value-of select="substring($Indent,1,number($IndentPos)+4)" />
           
            </UML:AssociationEnd><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
    
            <UML:AssociationEnd 
              type="{$ClassNode/@xmi.id}" 
              _srcClass="{$ClassNode/@name}"   
              association="{$association_id}" 
            >
              
              <xsl:choose><xsl:when test="boolean(final) and boolean(newObject)">
                <xsl:attribute name="aggregation">composite</xsl:attribute>
              </xsl:when><xsl:when test="final">
                <xsl:attribute name="aggregation">aggregate</xsl:attribute>
              </xsl:when><xsl:otherwise>
                <xsl:attribute name="aggregation">none</xsl:attribute>
              </xsl:otherwise></xsl:choose>  
            </UML:AssociationEnd><xsl:value-of select="substring($Indent,1,number($IndentPos)+2)" />
            
          </UML:Association.connection><xsl:value-of select="substring($Indent,1,number($IndentPos))" />
        </UML:Association>
    </xsl:if>
  </xsl:for-each>
</xsl:template>





<xsl:template name="gen_Generalization" >
<!-- current xml element is a classDefinition -->
<xsl:param name="IndentPos" />
<xsl:param name="childClassNode" />
  <xsl:comment>gen_Generalization class=<xsl:value-of select="$childClassNode/@name" /></xsl:comment>
  <xsl:for-each select="Superclass | SuperInterface">
    <xsl:variable name="typeNameUsed" select="text()" />
    <xsl:variable name="typeNameFull">
      <xsl:call-template name="getTypeRootfocus"><xsl:with-param name="typeName" select="$typeNameUsed" /></xsl:call-template>
    </xsl:variable>
    <xsl:variable name="typeId" select="key('typeSearch',$typeNameFull)/@xmi.id" />
    <UML:Generalization name="{$typeNameUsed}" child="{$childClassNode/@xmi.id}" _childClass="{$childClassNode/@name}" parent="{$typeId}" _parentFull="{$typeNameFull}" /> 
  </xsl:for-each>
  <xsl:for-each select="ImplementedInterface">
    <xsl:variable name="typeNameUsed" select="text()" />
    <xsl:variable name="typeNameFull">
      <xsl:call-template name="getTypeRootfocus"><xsl:with-param name="typeName" select="$typeNameUsed" /></xsl:call-template>
    </xsl:variable>
    <xsl:variable name="typeId" select="key('typeSearch',$typeNameFull)/@xmi.id" />
    <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
    <UML:Generalization name="{$typeNameUsed}" child="{$childClassNode/@xmi.id}" _childClass="{$childClassNode/@name}" parent="{$typeId}" _parentFull="{$typeNameFull}" interface="true" /> 
  </xsl:for-each>
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
</xsl:template>  
  





<xsl:template name="gen_Dependencies" >
<!-- current xml element is a classDefinition -->
<xsl:param name="IndentPos" />
<xsl:param name="childClassNode" />
  <xsl:comment>gen_Generalization class=<xsl:value-of select="$childClassNode/@name" /></xsl:comment>
  <xsl:variable name="allTypeUsed">
    <xsl:for-each select=".//variableDefinition | .//argument | .//attribute">
      <xsl:variable name="typeName" ><xsl:call-template name="getTypeName" /></xsl:variable>
      <usage type="{$typeName}" />
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="sortedTypes">
    <xsl:for-each select="$allTypeUsed/usage" >
    <xsl:sort select="@type" />  
      <xsl:copy-of select="." />
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="classNode" select="." />
  <xsl:for-each select="$sortedTypes/usage[position()=last() or @type != following-sibling::usage[1]/@type]">
    <xsl:variable name="typeNameUsed" select="@type" />
    <xsl:for-each select="$classNode" > 
      <xsl:variable name="typeNameFull">
        <xsl:call-template name="getTypeRootfocus"><xsl:with-param name="typeName" select="$typeNameUsed" /></xsl:call-template>
      </xsl:variable>
      <xsl:variable name="typeId" select="key('typeSearch',$typeNameFull)/@xmi.id" />
      <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
      <UML:Dependency name="{$typeNameUsed}" client="{$childClassNode/@xmi.id}" _clientClass="{$childClassNode/@name}" supplier="{$typeId}" _supplierName="{$typeNameUsed}" _supplierFull="{$typeNameFull}" /> 
    </xsl:for-each>
  </xsl:for-each>  
  <xsl:value-of select="substring($Indent,1,number($IndentPos))" />
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

