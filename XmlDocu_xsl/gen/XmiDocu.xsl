<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xs ="http://www.w3.org/2001/XMLSchema"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:UML="omg.org/UML13"
  xmlns:pre="http://www.vishia.de/2006/XhtmlPre"
>
<!-- This file should be translated using makeXsl_fromXslp before using for a XSLT translation, see http://www.vishia.org/Xml/html/Xsltpre.html -->
<!-- made by Hartmut Schorrig www.vishia.org
  2011-06-26 Hartmut new: Inner classes will be placed after attributes. It is proper for data struct in C. TODO control it where it is placed. It's different for C-struct and UML-classes.
  2009-07-02 HScho chg: Labels for classes, methods:
                   * inner classes are designated Outer.Inner
                   * methods and attributes without 'method_' at prefix, because Winword may only have up to 40 chars for a label.
                   * but label of methods, attributes, association starts with classLabel including Outer.inner.
                   * see template name="getClassLabel" 
  2009-07-02 HScho new: attribute expandOwnLabel with the classLabel because using [[~ownElement]] in descriptions of UML fields.
                        The changed WikistyleTextToSimpleXml.java is necessary to used this feature.                   
  2009-07-02 HScho new: template name="umlClassAttributesDetail": label for attributes.
  2009-02-15 HScho new: <xsl:template name="umlClassContent-i">, <xsl:template name="umlClassAssociationsDetail">: separation of composition, aggregation and association for documentation of associations.
  2009-02-10 HScho corr: <xsl:template name="umlStateD">: showing not in nested lists <ul>, <li> but in <dl><dt>... , some changes in outfit,
  2009-02-08 HScho corr: template name="umlClassContent": class NAME im Package NAME-getted with call getPackageClassContext(), therefore correct
                   corr: template name="umlClassAttributesDetail": Do not show attributes with @deprecated
                   corr: template name="umlClassAssociationsDetail": Do not show attributes with @deprecated
                   corr: template name="umlClassMethodsDetail": Do not show attributes with @deprecated
                   corr: template name="umlMethodDetail": if comment starts with @implements or Implementiert, than don't show parameter description.
                   rem: The parameter description should be the same like definition in an interface always,
                        but the description itself starts with implements [[method_INTERFACE_METHOD(...)]] and may contain additional implementation hints.
                   corr: xsl:template name="umlStateD": title-paragraph with style (class) caption_p instead standard.
                   new: xsl:template name="umlComment" has an label anchor (id) named ''Topic.tagname'' like text-topics
                   corr: xsl:template name="debugPath": shows 3 levels, it is sufficient.
 -->                       

<xsl:key name="id" use="@xmi.id" 
  match="UML:DataType|UML:Package|UML:Stereotype|UML:Association|UML:AssociationEnd|UML:Dependency|UML:Class|UML:Interface|UML:Enumeration|UML:CompositeState|UML:SimpleState|UML:Pseudostate" 
/>

<xsl:variable name="Indent"><xsl:text>
</xsl:text>
</xsl:variable>

<xsl:variable name="IndentPos" select="'2'" />                                                                           



<xsl:variable name="IdStereotype_CONST_Initializer" select="//UML:Stereotype[@name='CONST_Initializer']/@xmi.id" />


  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- presentation of the content of a class. The calling may be ransomed from generated DocuCtrl.xsl via GenDocuCtrl2Xsl.xsd -->

  <xsl:template name="umlClassContent">
  <xsl:param name="title" />
  <xsl:param name="methods">all</xsl:param>
  <xsl:param name="methodstyle">-</xsl:param>
  <xsl:param name="attributes">all</xsl:param>
    <xsl:variable name="classLabel"><xsl:call-template name="getClassLabel" /></xsl:variable>

    <xsl:choose><xsl:when test="string-length($title)>0">

      <pre:chapter><pre:title><xsl:value-of select="$title" /></pre:title>
        <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
          <xhtml:p class="umlElement" id="{'class_'}{$classLabel}"><xsl:text>Class </xsl:text><xhtml:b><xsl:value-of select="$classLabel" /></xhtml:b><xsl:text> definiert in </xsl:text><xsl:call-template name="getPackageClassContext"></xsl:call-template><xsl:text></xsl:text></xhtml:p>
          <xsl:call-template name="umlClassContent-i">
            <xsl:with-param name="classLabel" select="$classLabel" />
            <xsl:with-param name="attributes" select="$attributes" />
            <xsl:with-param name="methods" select="$methods" />
            <xsl:with-param name="methodstyle" select="$methodstyle" />
          </xsl:call-template>
        </xhtml:body>
      </pre:chapter>

    </xsl:when><xsl:otherwise>

      <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
        <xhtml:p class="umlTitle" id="{'class_'}{$classLabel}"><xsl:text>Class </xsl:text><xsl:value-of select="$classLabel" /><xsl:text> im Package </xsl:text><xsl:call-template name="getPackageClassContext"></xsl:call-template><xsl:text></xsl:text></xhtml:p>
        <xsl:call-template name="umlClassContent-i">
          <xsl:with-param name="classLabel" select="$classLabel" />
          <xsl:with-param name="attributes" select="$attributes" />
          <xsl:with-param name="methods" select="$methods" />
          <xsl:with-param name="methodstyle" select="$methodstyle" />
        </xsl:call-template>
      </xhtml:body>

    </xsl:otherwise></xsl:choose>

  </xsl:template>




<!-- inner call of the content of a class. -->
<xsl:template name="umlClassContent-i">
<xsl:param name="classLabel" />
<xsl:param name="methods">all</xsl:param>
<xsl:param name="methodstyle">-</xsl:param>
<xsl:param name="attributes">all</xsl:param>
  <xsl:variable name="ClassId" select="@xmi.id" />
  <xsl:call-template name="debugModelElement" />
  <xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']">
    <xhtml:div expandWikistyle="true" class="umlDescription" expandLabelOwn="{$classLabel}{'.'}"><xsl:value-of select="@value"/></xhtml:div>
  </xsl:for-each>    
  <xhtml:div Backref="{@name}" />

  <xsl:if test="count(UML:Classifier.feature/UML:Attribute)>0">
    <xsl:choose><xsl:when test="$attributes='bytes'">
      <xhtml:p class="caption_P">Attributes:</xhtml:p>
      <xsl:call-template name="umlClassBytes" />
      <xsl:call-template name="umlClassAttributesWithBytepos" />
    </xsl:when><xsl:when test="$attributes='all'">
        <xhtml:p class="caption_p">Attribute:</xhtml:p>
      <xsl:call-template name="umlClassAttributesDetail" ><xsl:with-param name="classLabel" select="$classLabel" /><xsl:with-param name="className" select="@name" /></xsl:call-template>
    </xsl:when><xsl:otherwise>
      <xhtml:p class="title">Attribute:</xhtml:p>
      <xsl:call-template name="umlClassAttributesDetail" ><xsl:with-param name="classLabel" select="$classLabel" /><xsl:with-param name="className" select="@name" /></xsl:call-template>
    </xsl:otherwise></xsl:choose>
  </xsl:if>

  <xsl:if test="boolean(//UML:AssociationEnd[@type=$ClassId and @aggregation='composite']/../UML:AssociationEnd[@type!=$ClassId and boolean(@name)])">
    <!-- a nameless association is the second end of a directed association. -->
    <xhtml:p class="caption_p">Kompositionen:</xhtml:p>
    <xsl:call-template name="umlClassAssociationsDetail"><xsl:with-param name="classLabel" select="$classLabel" /><xsl:with-param name="className" select="@name" /><xsl:with-param name="aggregation" select="'composite'" /></xsl:call-template>
  </xsl:if>

  <xsl:if test="boolean(//UML:AssociationEnd[@type=$ClassId and @aggregation='aggregate']/../UML:AssociationEnd[@type!=$ClassId and boolean(@name)])">
    <!-- a nameless association is the second end of a directed association. -->
    <xhtml:p class="caption_p">Aggregationen:</xhtml:p>
    <xsl:call-template name="umlClassAssociationsDetail"><xsl:with-param name="classLabel" select="$classLabel" /><xsl:with-param name="className" select="@name" /><xsl:with-param name="aggregation" select="'aggregate'" /></xsl:call-template>
  </xsl:if>

  <xsl:if test="boolean(//UML:AssociationEnd[@type=$ClassId and @aggregation='none']/../UML:AssociationEnd[@type!=$ClassId and boolean(@name)])">
    <!-- a nameless association is the second end of a directed association. -->
    <xhtml:p class="caption_p">Associationen:</xhtml:p>
    <xsl:call-template name="umlClassAssociationsDetail"><xsl:with-param name="classLabel" select="$classLabel" /><xsl:with-param name="className" select="@name" /><xsl:with-param name="aggregation" select="'none'" /></xsl:call-template>
  </xsl:if>

  <!-- For C: inner data struct here -->
  <xsl:for-each select="UML:Namespace.ownedElement/UML:Class">
		<xsl:variable name="classLabel"><xsl:call-template name="getClassLabel" /></xsl:variable>
    <xhtml:p class="umlElement" id="{'class_'}{$classLabel}"><xsl:text>Inner class </xsl:text><xhtml:b><xsl:value-of select="$classLabel" /></xhtml:b><xsl:text> definiert in </xsl:text><xsl:call-template name="getPackageClassContext"></xsl:call-template><xsl:text></xsl:text></xhtml:p>
    <xsl:call-template name="umlClassContent-i">
			<xsl:with-param name="classLabel"  select="$classLabel" />
			<xsl:with-param name="methods" select="$methods" />
			<xsl:with-param name="methodstyle" select="$methodstyle" />
			<xsl:with-param name="attributes" select="$attributes" />
    </xsl:call-template>
  </xsl:for-each>

  <xsl:choose>
    <!-- Anomaly on Rhapsody: In version 7.0 by classes both, UML:Method and UML:Operation are outputted with same content in XMI,
         but on Interfaces only UML:Operation are outputtet.
         In older versions only UML:Operations are outputted.   
     -->
    <xsl:when test="count(UML:Classifier.feature/UML:Method)>0 or count(UML:Classifier.feature/UML:Operation)>0">
      <xsl:if test="$methods!='no'">
        <xhtml:p class="caption_p">Methods:</xhtml:p>
        <xsl:call-template name="umlClassMethodsDetail">
          <xsl:with-param name="classLabel" select="$classLabel" />
          <xsl:with-param name="methodstyle" select="$methodstyle" />
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
  </xsl:choose>
  <xsl:for-each select="UML:Enumeration">
    <xsl:if test="true()">
      <xhtml:p class="caption_p"><xsl:text>Enumeration </xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text></xhtml:p>
      <xsl:if test="true()">
        <xsl:call-template name="umlClassEnumerationDetail"/>
      </xsl:if>
    </xsl:if>
  </xsl:for-each>

  <!-- xsl:if test="boolean(UML:Classifier.instance/UML:Instance[@stereotype=$IdStereotype_CONST_Initializer])" -->
  <xsl:if test="boolean(UML:Classifier.instance/UML:Instance)">
    <!-- a nameless association is the second end of a directed association. -->
    <xhtml:p class="caption_p">CONST-Initializer:</xhtml:p>
    <xhtml:p>CONST-Initializer sind Makros f�r C-Konstanten, sie sind in Headerfiles definiert. 
      C-Konstante sind Konstrukte in { ... } mit ausschlie�lich konstanten Werten. 
      Die Makros der CONST-Initializer �bernehmen Argumente, die zur Compilezeit die Konstanten bestimmen. 
      Die Initializer sind deshalb als Makros definiert, weil die Struktur der Konstanten exakt der struct-Definition folgen muss,
      die struct ist im Headerfile definiert, daher auch dazu passend diese Makros. 
      Mit denCONST-Intializer ist es auf einfache Weise m�glich, C-struct-Daten (Plain Old Data) zu initialisieren.
      F�r Klassen (C++) ist dieses Konzept nicht geeignet.</xhtml:p>
    <xsl:call-template name="umlConstInitializer"/>
  </xsl:if>
  
</xsl:template>



<!-- presentation of the attributes of a class in a definition list. Called from umlClassContent -->
<xsl:template name="umlClassAttributesDetail">
<xsl:param name="classLabel" />
<xsl:param name="className" />
  <xhtml:dl>
    <xsl:for-each select="UML:Classifier.feature/UML:Attribute [not(contains(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'@deprecated'))]"> <!-- [count(tag[@name='documentation'])>0]" >           -->
    <xsl:sort select="@name" />
      <xsl:variable name="TypeName">
        <xsl:call-template name="typeName"><xsl:with-param name="type-id" select="@type" /></xsl:call-template>
      </xsl:variable>
      <xsl:variable name="typeLabel"><xsl:text>#class_</xsl:text><xsl:call-template name="getTypeIdent" ><xsl:with-param name="typeName" select="$TypeName" /></xsl:call-template></xsl:variable>
      <!-- Label built from Class.method(paramtype,paramtype) -->
      <xsl:variable name="LABEL"><xsl:text></xsl:text><xsl:value-of select="$classLabel" /><xsl:text>.</xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text></xsl:variable>
      <xhtml:dt class="umlElement" id="{$LABEL}">
        <xhtml:b><xsl:value-of select="@name" /></xhtml:b><xsl:text> : </xsl:text>
        <xhtml:a href="{$typeLabel}"><xsl:value-of select="$TypeName"/></xhtml:a>
        <xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='multiplicity']">
          <xsl:if test="number(@value) gt 1"><xsl:text> [</xsl:text><xsl:value-of select="@value" /><xsl:text>]</xsl:text></xsl:if>
        </xsl:for-each>  
      </xhtml:dt>
      <xhtml:dd expandWikistyle="true" class="umlDescription" expandLabelOwn="{$classLabel}{'.'}">
        <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
      </xhtml:dd>
    </xsl:for-each>
  </xhtml:dl>
</xsl:template>




<xsl:template name="umlClassAttributesWithBytepos">
<!-- TODO bytepos to generate, use recurcively call and call-template name="sizeof" -->  
  <xhtml:dl>
    <xsl:for-each select="UML:Classifier.feature/UML:Attribute"> <!-- [count(tag[@name='documentation'])>0]" >           -->
      <xsl:variable name="TypeName" select="key('id',@type)/@name" />
      <xsl:variable name="typeLabel"><xsl:text>#class_</xsl:text><xsl:call-template name="getTypeIdent" ><xsl:with-param name="typeName" select="$TypeName" /></xsl:call-template></xsl:variable>
      <xsl:variable name="bytepos" select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='byteOffset']/@value" />
      <xsl:variable name="multiplicity">
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='multiplicity'])>0"><xsl:text></xsl:text><xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='multiplicity']/@value" /><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text>1</xsl:text></xsl:otherwise></xsl:choose><xsl:text></xsl:text>
      </xsl:variable>
      <xsl:variable name="nrofBytes"><xsl:value-of select="number(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='sizeof']/@value) * number($multiplicity)" /></xsl:variable>
      <xsl:variable name="byteposEnd" select="number($bytepos) + number($nrofBytes) -1" />
      <!-- Label built from Class.method(paramtype,paramtype) -->
      <xhtml:dt class="umlElement">
        <xsl:text>Pos. 0x</xsl:text><xsl:call-template name="decimal2hex"><xsl:with-param name="x"  select="$bytepos" /></xsl:call-template><xsl:text>..0x</xsl:text><xsl:call-template name="decimal2hex"><xsl:with-param name="x"  select="$byteposEnd" /></xsl:call-template><xsl:text> = </xsl:text><xsl:value-of select="$bytepos" /><xsl:text>..</xsl:text><xsl:value-of select="$byteposEnd" /><xsl:text> ( </xsl:text><xsl:value-of select="$nrofBytes" /><xsl:text> bytes): </xsl:text>
        <xhtml:b><xsl:value-of select="@name" /></xhtml:b><xsl:text> : </xsl:text><xhtml:a href="{$typeLabel}"><xsl:value-of select="$TypeName"/></xhtml:a>
        <xsl:if test="number($multiplicity) gt 1"><xsl:text> [</xsl:text><xsl:value-of select="$multiplicity" /><xsl:text>]</xsl:text></xsl:if>
      </xhtml:dt>
      <xhtml:dd expandWikistyle="true" class="umlDescription">
        <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
      </xhtml:dd>
    </xsl:for-each>
  </xhtml:dl>
</xsl:template>




<xsl:template name="getTypeIdent">
<xsl:param name="typeName" select="xx_typeName_xx" />  
  <xsl:variable name="typeWithoutPointer">
    <xsl:choose><xsl:when test="contains(@typeName,' const*')">
      <xsl:value-of select="substring-before(@typeName,' const*')" />
    </xsl:when><xsl:when test="contains(@typeName,'*')">
      <xsl:value-of select="substring-before(@typeName,'*')" />
    </xsl:when><xsl:otherwise>
      <xsl:value-of select="$typeName" />
    </xsl:otherwise></xsl:choose>
  </xsl:variable>
  <xsl:variable name="typeWithoutModifier">
    <xsl:choose><xsl:when test="starts-with($typeWithoutPointer,'const ')">
      <xsl:value-of select="substring-after($typeWithoutPointer,'const ')" />
    </xsl:when><xsl:otherwise>
      <xsl:value-of select="$typeWithoutPointer" />
    </xsl:otherwise></xsl:choose>
  </xsl:variable>
    <xsl:choose><xsl:when test="substring($typeWithoutModifier,string-length($typeWithoutModifier)-1)='_t'">
      <xsl:value-of select="substring($typeWithoutModifier,1, string-length($typeWithoutModifier)-2)" />
    </xsl:when><xsl:otherwise>
      <xsl:value-of select="$typeWithoutModifier" />
    </xsl:otherwise></xsl:choose>
</xsl:template>






<!-- presentation of the associations of a class in a definition list. Called from umlClassContent -->
<xsl:template name="umlClassAssociationsDetail">
<xsl:param name="classLabel" />
<xsl:param name="IndentPos" select="'10'" />
<xsl:param name="className" />
<xsl:param name="aggregation" /><!-- composite, aggregate -->  
  <xsl:variable name="ClassId" select="@xmi.id" />
  <xsl:value-of select="substring($Indent,1,number($IndentPos))"/>
  <xhtml:dl>
    <xsl:for-each select="//UML:AssociationEnd[@type=$ClassId and @aggregation=$aggregation]/../UML:AssociationEnd[@type!=$ClassId and boolean(@name)]">
      <!--xsl:sort select="@name" / -->
      <!-- Label built from Class.method(paramtype,paramtype) -->
      <xsl:if test="not(contains(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'@deprecated'))">
        <xsl:variable name="TypeName" select="key('id',@type)/@name" />
        <xsl:variable name="TypeLabel"><xsl:text>#class_</xsl:text><xsl:value-of select="$TypeName" /><xsl:text></xsl:text></xsl:variable>
        <xsl:variable name="LABEL"><xsl:text></xsl:text><xsl:value-of select="$classLabel" /><xsl:text>.</xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text></xsl:variable>
        <xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
        <xhtml:dt class="umlElement" id="{$LABEL}">
          <xsl:text></xsl:text><xsl:value-of select="$classLabel" /><xsl:text>.</xsl:text><xsl:value-of select="@name" /><xsl:text> : </xsl:text><xhtml:a href="{$TypeLabel}"><xsl:text></xsl:text><xsl:value-of select="$TypeName" /><xsl:text></xsl:text></xhtml:a>
          <xsl:for-each select="UML:AssociationEnd.multiplicity/UML:Multiplicity/UML:Multiplicity.range/UML:MultiplicityRange">
            <xsl:choose><xsl:when test="@lower = @upper">
              <xsl:if test="@upper != 1"><xsl:text> [</xsl:text><xsl:value-of select="@upper" /><xsl:text>]</xsl:text></xsl:if>
            </xsl:when><xsl:otherwise><xsl:text> [</xsl:text><xsl:value-of select="@lower" /><xsl:text> .. </xsl:text><xsl:value-of select="@upper" /><xsl:text>]</xsl:text>
            </xsl:otherwise></xsl:choose>
          </xsl:for-each>
        </xhtml:dt>
        <xsl:value-of select="substring($Indent,1,number($IndentPos)+2)"/>
        <xhtml:dd expandWikistyle="true" class="umlDescription" expandLabelOwn="{$className}{'.'}">
          <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
        </xhtml:dd>
      </xsl:if>  
    </xsl:for-each>
  </xhtml:dl>
</xsl:template>




<!-- presentation of the methods of a class in a definition list. Called from umlClassContent -->
<xsl:template name="umlClassMethodsDetail">
<xsl:param name="classLabel" />
<xsl:param name="methodstyle" />
  <xhtml:dl>
    <xsl:for-each select="
			 UML:Classifier.feature/UML:Method[not(contains(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'@deprecated')) and not(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='deprecated'])] 
			|UML:Classifier.feature/UML:Operation[not(contains(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'@deprecated')) and not(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='deprecated'])]
			 " >          <!-- select="Operation[@visibility='public']" -->
      <!-- xsl:sort select="@name" / -->
      <xsl:call-template name="umlMethodDetail" >
        <xsl:with-param name="classLabel" select="$classLabel" />
        <xsl:with-param name="methodstyle" select="$methodstyle" />
      </xsl:call-template>
      </xsl:for-each>
  </xhtml:dl>
</xsl:template>    



<!-- presentation of the methods of a class in a definition list. Called from umlClassContent -->
<xsl:template name="xxxumlClassMethodsDetail">
<xsl:param name="methodstyle" />
  <xhtml:dl>
    <xsl:choose>
      <xsl:when test="boolean(UML:Classifier.feature/UML:Method)">
        <xsl:for-each select="UML:Classifier.feature/UML:Method[not(contains(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'@deprecated'))]" >          <!-- select="Operation[@visibility='public']" -->
          <xsl:sort select="@name" />
          <xsl:call-template name="umlMethodDetail" >
            <xsl:with-param name="methodstyle" select="$methodstyle" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <!-- Consideres Rhapsody-Behaviour: Methods will be saved in XMI two times with identical content, as Method and as Operation. 
             Only use one.
         -->
        <xsl:for-each select="UML:Classifier.feature/UML:Operation[not(contains(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'@deprecated'))]" >          
          <!-- select="Operation[@visibility='public']" -->
          <xsl:sort select="@name" />
          <xsl:call-template name="umlMethodDetail" >
            <xsl:with-param name="methodstyle" select="$methodstyle" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xhtml:dl>
</xsl:template>    



<xsl:template name="umlClassOperationsDetail"><!--not called yet? TODO-->
<xsl:param name="classLabel" />
  <xhtml:dl>
    <xsl:for-each select="UML:Classifier.feature/UML:Operation" >          <!-- select="Operation[@visibility='public']" -->
      <!-- xsl:sort select="@name" / -->
      <xsl:call-template name="umlMethodDetail" ><xsl:with-param name="classLabel" select="$classLabel" /></xsl:call-template>
      
    </xsl:for-each>
  </xhtml:dl>
</xsl:template>    



<xsl:template name="umlMethodContent">
<xsl:param name="methodstyle" />
<xsl:param name="methodblock" select="'-'" />
<xsl:param name="methodblockEnd" />
<xsl:param name="title" />
  
  <xsl:variable name="classLabel" >  <!-- The class is 2 levels left in XMI -->
    <xsl:for-each select="../.."><xsl:call-template name="getClassLabel" /></xsl:for-each>
  </xsl:variable>

  <xsl:choose><xsl:when test="string-length($title)>0">

    <pre:chapter><pre:title><xsl:value-of select="$title" /></pre:title>
      <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
        <xhtml:dl>
          <xsl:call-template name="umlMethodDetail" >
            <xsl:with-param name="classLabel" select="$classLabel" />
            <xsl:with-param name="methodstyle"><xsl:value-of select="$methodstyle" /><xsl:text>+className+</xsl:text></xsl:with-param>      
            <xsl:with-param name="methodblock" select="$methodblock" />      
            <xsl:with-param name="methodblockEnd" select="$methodblockEnd" />      
          </xsl:call-template>
        </xhtml:dl>  
      </xhtml:body>
    </pre:chapter>

  </xsl:when><xsl:otherwise>

    <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
      <xhtml:dl>
        <xsl:call-template name="umlMethodDetail" >
          <xsl:with-param name="classLabel" select="$classLabel" />
          <xsl:with-param name="methodstyle"><xsl:value-of select="$methodstyle" /><xsl:text>+className+</xsl:text></xsl:with-param>      
          <xsl:with-param name="methodblock" select="$methodblock" />      
          <xsl:with-param name="methodblockEnd" select="$methodblockEnd" />      
        </xsl:call-template>
      </xhtml:dl>
    </xhtml:body>

  </xsl:otherwise></xsl:choose>

</xsl:template>    



<xsl:template name="umlEnumeration">
<xsl:param name="content" />
<xsl:param name="title" />

  <xsl:choose><xsl:when test="string-length($title)>0">

    <pre:chapter><pre:title><xsl:value-of select="$title" /></pre:title>
      <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
        <xhtml:p class="caption_p"><xsl:text>Enumeration </xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text></xhtml:p>
        <xsl:call-template name="umlClassEnumerationDetail" >
          <xsl:with-param name="content" select="$content" />      
        </xsl:call-template>
      </xhtml:body>
    </pre:chapter>

  </xsl:when><xsl:otherwise>

    <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
        <xsl:call-template name="umlClassEnumerationDetail" >
          <xsl:with-param name="content" select="$content" />      
        </xsl:call-template>
    </xhtml:body>

  </xsl:otherwise></xsl:choose>

</xsl:template>    



<xsl:template name="umlDatatype">
<xsl:param name="content" />
<xsl:param name="title" />

  <xsl:choose><xsl:when test="string-length($title)>0">

    <pre:chapter><pre:title><xsl:value-of select="$title" /></pre:title>
      <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
        <xhtml:p class="caption_p"><xsl:text>Enumeration </xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text></xhtml:p>
        <xsl:call-template name="umlClassDatatypeDetail" >
          <xsl:with-param name="content" select="$content" />      
        </xsl:call-template>
      </xhtml:body>
    </pre:chapter>

  </xsl:when><xsl:otherwise>

    <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
        <xsl:call-template name="umlClassDatatypeDetail" >
          <xsl:with-param name="content" select="$content" />      
        </xsl:call-template>
    </xhtml:body>

  </xsl:otherwise></xsl:choose>

</xsl:template>    





<!-- presentation of the methods of a class in a definition list. Called from umlClassMethodsDetail -->
<xsl:template name="umlMethodDetail">
<xsl:param name="classLabel" />
<xsl:param name="methodstyle" />
<xsl:param name="methodblock" />
<xsl:param name="methodblockEnd" />

  <xsl:variable name="labelClassPart"><!-- it is left empty if the name of the method ends with the class name. -->
		<xsl:if test="not(ends-with(@name,$classLabel))"><xsl:value-of select="$classLabel"/>.</xsl:if>
	</xsl:variable>
	<xsl:variable name="LABELtyped"></xsl:variable>
	<!-- Label built from Class.method(paramtype,paramtype) -->
	<xsl:variable name="LABEL"><xsl:value-of select="$labelClassPart"/><xsl:value-of select="@name"/>(<xsl:text/>
		<xsl:for-each select="UML:BehavioralFeature.parameter/UML:Parameter
		                      [@kind!='return' and @name!='ythis' and @name!='thiz' and @name!='YTHIS' and @name!='THIZ' and @name!='OTHIZ' and @name!='_thCxt' and @name!='_THC']
												 " >
			<xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
			<xsl:value-of select="@name"/>
		</xsl:for-each>)<xsl:text/>
	</xsl:variable>
	<xsl:variable name="LABELshort"><xsl:value-of select="$labelClassPart"/><xsl:value-of select="@name"/>(...)<xsl:text/></xsl:variable>
	<xsl:variable name="LABEL_description"><xsl:value-of select="$LABEL" /><xsl:text>_+</xsl:text></xsl:variable>
    <xhtml:anchor label="{$LABELshort}"/><!-- The short label is useable in hyperlinks like class.method(...) -->
    <!-- The explicitely label with argument types are set as dt-id: -->
    <xhtml:dt class="umlElement" id="{$LABEL}">
      <xhtml:b>
        <xsl:if test="contains($methodstyle,'+className+')"><xsl:text></xsl:text><xsl:value-of select="$classLabel" /><xsl:text>::</xsl:text></xsl:if>
        <xsl:value-of select="@name"/>
      </xhtml:b><xsl:text> (</xsl:text>
        <xsl:for-each select="UML:BehavioralFeature.parameter/UML:Parameter[@kind!='return']">
          <xsl:value-of select="@name"/>
          <xsl:if test="last() > position()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
      <xsl:text>) : </xsl:text>
        <xsl:for-each select="UML:BehavioralFeature.parameter/UML:Parameter[@kind='return']" >
          <xsl:variable name="TypeName">
            <xsl:call-template name="typeName"><xsl:with-param name="type-id" select="@type" /></xsl:call-template>
          </xsl:variable>
          <!-- xsl:variable name="TypeName" select="key('id',@type)/@name" / -->
          <xsl:variable name="TypeLabel"><xsl:text>#class_</xsl:text><xsl:value-of select="$TypeName" /><xsl:text></xsl:text></xsl:variable>
          <xhtml:a href="{$TypeLabel}"><xsl:value-of select="$TypeName" /></xhtml:a>
        </xsl:for-each>
    </xhtml:dt>
    <xhtml:dd class="umlDescription" id="{$LABEL_description}">
      <xsl:if test="not(contains($methodstyle,'onlybody'))">  
        <xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']">
          <xhtml:div expandWikistyle="true" class="umlDescription" expandLabelOwn="{$classLabel}{'.'}">
            
            <xsl:value-of select="replace(@value,'@implements','Implementiert')" />
          </xhtml:div>
        </xsl:for-each>
        <!-- xsl:if test="count(Parameter[@kind!='return'])>0" -->
        <xsl:if test="count(UML:BehavioralFeature.parameter/UML:Parameter)>0
                     and not(contains(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'@implements'))
                     and not(starts-with(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value,'Implementiert'))">
          <!-- NOTE: don't show parameter if @implements is in docu, because an interface have the description.-->
          <xhtml:ul>
          
  					<xsl:for-each select="UML:BehavioralFeature.parameter/UML:Parameter
						                      [@kind!='return' and @name!='ythis' and @name!='thiz' and @name!='othis' and @name!='ithis' 
																	 and @name!='_thCxt' and @name!='_THC' and @name!='YTHIS' and @name!='THIZ' and @name!='OTHIZ']" >
							<!-- ythis is used in C-like methods -->
              <xsl:variable name="xxxTypeName" select="key('id',@type)/@name" />
              <xsl:variable name="TypeName">
                <xsl:call-template name="typeName"><xsl:with-param name="type-id" select="@type" /></xsl:call-template>
              </xsl:variable>
              <xsl:variable name="TypeLabel"><xsl:text>class_</xsl:text><xsl:value-of select="$TypeName" /><xsl:text></xsl:text></xsl:variable>
              <xhtml:li>
                <xhtml:div expandWikistyle="true" class="umlDescription" expandLabelOwn="{$classLabel}{'.'}"><xsl:text>'''</xsl:text><xsl:value-of select="@name" /><xsl:text>''': [[</xsl:text><xsl:value-of select="$TypeLabel" /><xsl:text>|</xsl:text><xsl:value-of select="$TypeName" /><xsl:text>]] - </xsl:text>
                  <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
                </xhtml:div>
              </xhtml:li>
            </xsl:for-each>
						
            <xsl:for-each select="UML:BehavioralFeature.parameter/UML:Parameter[@kind='return']" >
              <xsl:variable name="TypeName">
                <xsl:call-template name="typeName"><xsl:with-param name="type-id" select="@type" /></xsl:call-template>
              </xsl:variable>
              <xsl:variable name="TypeLabel"><xsl:text>class_</xsl:text><xsl:value-of select="$TypeName" /><xsl:text></xsl:text></xsl:variable>
              <xhtml:li>
                <xhtml:div expandWikistyle="true" class="umlDescription" expandLabelOwn="{$classLabel}{'.'}">
								  <xsl:text>'''returns''': [[</xsl:text><xsl:value-of select="$TypeLabel" /><xsl:text>|</xsl:text><xsl:value-of select="$TypeName" /><xsl:text>]] - </xsl:text>
                  <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
                </xhtml:div>
              </xhtml:li>
            </xsl:for-each>
          
						<xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag!='documentation']">
							<xhtml:li>
                <xhtml:div expandWikistyle="true" class="umlDescription" expandLabelOwn="{$classLabel}{'.'}">
								  <xsl:text>'''</xsl:text><xsl:value-of select="@tag" /><xsl:text>''' - </xsl:text><xsl:value-of select="@value" /><xsl:text></xsl:text>
                </xhtml:div>
						  </xhtml:li>
            </xsl:for-each>
        	</xhtml:ul>
        </xsl:if>
      </xsl:if>  
      <xsl:if test="contains($methodstyle, 'body')">
        <xhtml:p>Code (body):</xhtml:p>
        <xhtml:pre>
          <xsl:choose><xsl:when test="$methodblock != '-'">
            <xsl:value-of select="substring-before(substring-after(UML:Method.body/UML:ProcedureExpression/@body, $methodblock), $methodblockEnd)" />
          </xsl:when><xsl:otherwise>
            <xsl:value-of select="UML:Method.body/UML:ProcedureExpression/@body" />
          </xsl:otherwise></xsl:choose>
        </xhtml:pre>
      </xsl:if>
    </xhtml:dd>
</xsl:template>


<xsl:template name="umlConstInitializer">
  <xhtml:dl>
    <xsl:for-each select="UML:Classifier.instance/UML:Instance">
    <xsl:sort select="@name" />
      <xhtml:dt class="umlElement">
        <xhtml:b><xsl:value-of select="@name" /></xhtml:b><xsl:text>(</xsl:text>
        <xsl:for-each select="UML:Instance.classifier/UML:Classifier/UML:Classifier.parameter/UML:Parameter">
          <xsl:value-of select="@name"/><xsl:if test="last() > position()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
      </xhtml:dt>
      <xhtml:dd class="umlDescription">
        <xhtml:div expandWikistyle="true" class="umlDescription">
          <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
        </xhtml:div>  
        <xsl:if test="count(UML:Instance.classifier/UML:Classifier/UML:Classifier.parameter/UML:Parameter)>0" ><!-- ythis is used in C-like methods -->
          <xhtml:ul>
            <xsl:for-each select="UML:Instance.classifier/UML:Classifier/UML:Classifier.parameter/UML:Parameter" ><!-- ythis is used in C-like methods -->
              <xhtml:li>
                <xhtml:div expandWikistyle="true" class='umlDescription'><xsl:text>'''</xsl:text><xsl:value-of select="@name" /><xsl:text>''' - </xsl:text>
                  <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
                </xhtml:div>
              </xhtml:li>
            </xsl:for-each>
          </xhtml:ul>
        </xsl:if>
      </xhtml:dd>
    </xsl:for-each>
  </xhtml:dl>
</xsl:template>






<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->
<!-- presentation of the attributes of a class in a byte image. Called from umlClassContent -->

<xsl:variable name="charsPerByte" select="8" />
<xsl:variable name="bytesPerLine" select="8" />
<xsl:variable name="bytesImageTopline"><xsl:text>+-------'-------'-------'-------'-------'-------'-------'-------'-------'-------</xsl:text></xsl:variable>
<xsl:variable name="spaces"><xsl:text>���������������������������������������������������</xsl:text></xsl:variable>


<xsl:template name="umlClassBytes">
  <xsl:for-each select="UML:Classifier.feature/UML:Attribute[1]">
    <!-- call for the first attribute, the rest is called recursively with using the axes following-sibling -->
    <!-- xsl:call-template name="attributes-bytes"/ -->
    <xsl:call-template name="bytesImageLine">
      <xsl:with-param name="prevTopline" select="''" />
      <xsl:with-param name="prevNameline" select="''" />
    </xsl:call-template> 
  </xsl:for-each>
</xsl:template>


<xsl:template name="sizeof">
<!-- returns the sizeof depends of the type -->
  <xsl:variable name="TypeName" select="key('id',@type)/@name" />
  <xsl:variable name="SizeElement">
    <xsl:choose>
    <xsl:when test="contains($TypeName,'*')>0">4</xsl:when>
    <xsl:when test="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='isReference']/@value='True'">4</xsl:when>
    <xsl:when test="$TypeName='char'">1</xsl:when>
    <xsl:when test="$TypeName='uint8'">1</xsl:when>
    <xsl:when test="$TypeName='int8'">1</xsl:when>
    <xsl:when test="$TypeName='int16'">2</xsl:when>
    <xsl:when test="$TypeName='uint16'">2</xsl:when>
    <xsl:when test="$TypeName='int32'">4</xsl:when>
    <xsl:when test="$TypeName='uint32'">4</xsl:when>
    <xsl:when test="$TypeName='float'">4</xsl:when>
    <xsl:when test="tag[@name='sizeof']"><xsl:value-of select="tag[@name='sizeof']/@value" /></xsl:when>
    <xsl:otherwise>8</xsl:otherwise><!-- may be a embedded structure -->
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="multiplicity" select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='multiplicity']/@value" />
  <xsl:variable name="n_multiplicity" select="number($multiplicity)" />
  <xsl:choose>
    <!-- xsl:when test="count(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='xxxmultiplicity'])>0" -->
    <xsl:when test="string-length($multiplicity)>0">
      <xsl:value-of select="number($SizeElement) * number($multiplicity)" />
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$SizeElement" /></xsl:otherwise>
  </xsl:choose>
  <!-- xsl:text>4</xsl:text -->
</xsl:template>

<xsl:template name="xsizeof">
  <!-- returns the sizeof depends of the type -->
  <xsl:variable name="TypeName" select="key('id',@type)/@name" />
  <xsl:variable name="SizeElement">
    <xsl:choose>
    <xsl:when test="contains($TypeName,'*')>0">4</xsl:when>
    <xsl:when test="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='isReference']/@value='True'">4</xsl:when>
    <xsl:when test="$TypeName='char'">1</xsl:when>
    <xsl:when test="$TypeName='uint8'">1</xsl:when>
    <xsl:when test="$TypeName='int8'">1</xsl:when>
    <xsl:when test="$TypeName='int16'">2</xsl:when>
    <xsl:when test="$TypeName='uint16'">2</xsl:when>
    <xsl:when test="$TypeName='int32'">4</xsl:when>
    <xsl:when test="$TypeName='uint32'">4</xsl:when>
    <xsl:when test="$TypeName='float'">4</xsl:when>
    <xsl:when test="tag[@name='sizeof']"><xsl:value-of select="tag[@name='sizeof']/@value" /></xsl:when>
    <xsl:otherwise>8</xsl:otherwise><!-- may be a embedded structure -->
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="count(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='multiplicity'])>0">
      <xsl:value-of select="number($SizeElement) * number(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='multiplicity']/@value)" />
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$SizeElement" /></xsl:otherwise>
  </xsl:choose>
</xsl:template>




<xsl:template name="bytesImageLine">
<xsl:param name="prevTopline" >xxxxx</xsl:param>  
<xsl:param name="prevNameline" />  
  <xsl:variable name="sizeof"><xsl:call-template name="sizeof" /></xsl:variable>
  <xsl:variable name="prevSumBytes" select="string-length($prevTopline) idiv $charsPerByte " />
  <!-- xsl:variable name="prevSumBytes" select="10" / -->
  <xsl:variable name="sumBytes" select="$prevSumBytes + $sizeof" />
  <xsl:variable name="nrofChars">
    <xsl:choose>
      <xsl:when test="$sumBytes gt $bytesPerLine"><xsl:value-of select="$charsPerByte * ($bytesPerLine - $prevSumBytes)" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="$charsPerByte * $sizeof" /></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="topline">
    <xsl:value-of select="$prevTopline" />
    <xsl:choose>
      <xsl:when test="$sumBytes gt $bytesPerLine">
        <xsl:value-of select="substring($bytesImageTopline, 1, $nrofChars -5) " />
        <xsl:text>...</xsl:text><xsl:value-of select="$sizeof" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring($bytesImageTopline, 1, $nrofChars)" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  
  <xsl:variable name="nameline">
    <xsl:value-of select="$prevNameline" />
    <xsl:variable name="value" select="@name" />
    <xsl:variable name="spacesLeft" select="($nrofChars - string-length($value) - 2) idiv 2" />
    <xsl:variable name="spacesRight" select="$nrofChars - $spacesLeft - string-length($value) -1" />
    <xsl:text>|</xsl:text>
    <xsl:value-of select="substring($spaces, 1, $spacesLeft)" />
    <xsl:value-of select="$value" />
    <xsl:value-of select="substring($spaces, 1, $spacesRight)" />
  </xsl:variable>
  <xsl:choose>

    <xsl:when test="$sumBytes lt $bytesPerLine and boolean(following-sibling::UML:Attribute[1])">
      <!-- the line isn't full and some more bytes exist, append next byte to the variables -->
      <xsl:for-each select="following-sibling::UML:Attribute[1]" >
        <xsl:call-template name="bytesImageLine">
          <xsl:with-param name="prevTopline" select="$topline" />
          <xsl:with-param name="prevNameline" select="$nameline" />
        </xsl:call-template> 
      </xsl:for-each>  
    </xsl:when>

    <xsl:otherwise>
      <!-- either the line is full, or no more bytes exists, write it out -->
      <xhtml:pre class="bytes"><xsl:value-of select="$topline" /><xsl:text>+</xsl:text></xhtml:pre>
      <xhtml:pre class="bytes"><xsl:value-of select="$nameline" /><xsl:text>|</xsl:text></xhtml:pre>

      <xsl:for-each select="following-sibling::UML:Attribute[1]" >
        <!-- some more bytes, produce next lines: -->
        <xsl:call-template name="bytesImageLine">
          <xsl:with-param name="prevTopline" select="''" />
          <xsl:with-param name="prevNameline" select="''" />
        </xsl:call-template> 
      </xsl:for-each>  
      <xsl:if test="not(following-sibling::UML:Attribute[1])">
        <!-- after last calling: -->
        <xhtml:pre class="bytes"><xsl:value-of select="substring($bytesImageTopline, 1, string-length($topline))" /></xhtml:pre>
      </xsl:if>  
    </xsl:otherwise>

  </xsl:choose>  
</xsl:template>





<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->



<!-- presentation of the attributes of a class in a definition list. Called from umlClassContent -->
<xsl:template name="umlClassEnumerationDetail">
<xsl:param name="content" />  
  <xsl:call-template name="debugModelElement" />
  <xsl:if test="not($content='onlydocu')">
    <xhtml:dl>
      <xsl:for-each select="UML:Enumeration.literal/UML:EnumerationLiteral"> <!-- [count(tag[@name='documentation'])>0]" >           -->
        <xhtml:dt class="umlElement">
          <xhtml:b><xsl:value-of select="@name" /></xhtml:b><xsl:text> : </xsl:text><xsl:value-of select="tag[@name='hexvalue']" /><xsl:text></xsl:text><xsl:value-of select="tag[@name='intvalue']" /><xsl:text></xsl:text><xsl:value-of select="tag[@name='symbolvalue']" /><xsl:text></xsl:text><xsl:value-of select="tag[@name='expressionvalue']" /><xsl:text></xsl:text>
        </xhtml:dt>
        <xhtml:dd expandWikistyle="true" class="umlDescription">
          <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
        </xhtml:dd>
      </xsl:for-each>
    </xhtml:dl>
  </xsl:if>
  <xsl:if test="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']">
    <xhtml:div expandWikistyle="true" class='umlDescription'>
      <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value"/>
    </xhtml:div>  
  </xsl:if>
</xsl:template>





<xsl:template name="umlClassDatatypeDetail">
<xsl:param name="content" />  
  <xsl:call-template name="debugModelElement" />
  <xsl:if test="not($content='onlydocu')">
    <xhtml:pre>
      <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='declaration']/@value" />
    </xhtml:pre>
  </xsl:if>
  <xsl:if test="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']">
    <xhtml:div expandWikistyle="true" class='umlDescription'>
      <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value"/>
    </xhtml:div>  
  </xsl:if>
</xsl:template>






<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->






  <!-- Darstellung des Inhaltes eines Package -->
  <xsl:template name="pkgContent">
    <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
      <xsl:variable name="LABEL">#PKG.<xsl:value-of select="@name"/></xsl:variable>
      <xhtml:anchor label="{$LABEL}"/>
      <xhtml:p class="std"><xhtml:u>Package: <xsl:value-of select="@name"/></xhtml:u></xhtml:p>
      <xhtml:body expandWikistyle="true">
        <xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value"/>
      </xhtml:body>
    </xhtml:body>

  </xsl:template>




  <!-- Darstellung des Inhaltes einer Klasse -->
  <xsl:template name="classContentShort"><!-- version bis 2006-10-23, neu ist umlClass -->
      <xhtml:body class="UmlClassContent" ><xsl:call-template name="debugModelElement" />
        <xsl:variable name="LABEL">class_<xsl:value-of select="@name"/></xsl:variable>
        <xhtml:anchor label="{$LABEL}"/>
        <xhtml:p>.</xhtml:p>
        <xhtml:p class="std"><xhtml:u>Class: <xsl:value-of select="@name"/></xhtml:u> im Package:<xsl:value-of select="@package"/><xsl:value-of select="@class"/></xhtml:p>
        <xhtml:div expandWikistyle="true" class='standard'><xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value"/></xhtml:div>
        <xsl:if test="count(Operation/tag[@name='documentation'])>0">
          <xhtml:table border="1" width="100%"><xhtml:tr><xhtml:th width="30%">Methode</xhtml:th><xhtml:th>Beschreibung</xhtml:th></xhtml:tr>
            <xsl:for-each select="Operation[count(tag[@name='documentation'])>0 and not(starts-with(tag[@name='documentation'],'#'))]" >          <!-- select="Operation[@visibility='public']" -->
              <xsl:sort select="@name" />
              <!-- Label built from Class.method(paramtype,paramtype) -->
              <xsl:variable name="LABEL">#<xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/>(<xsl:text/>
                <xsl:for-each select="Parameter[@kind!='return']" >
                  <xsl:value-of select="@typeName"/><xsl:text>,</xsl:text>
                </xsl:for-each>)<xsl:text/>
              </xsl:variable>

              <xhtml:tr>
                <xhtml:td><xhtml:a href="{$LABEL}"><xsl:value-of select="@name"/></xhtml:a></xhtml:td>
                <xhtml:td>
                  <xhtml:div expandWikistyle="true" class='standard'><xsl:value-of select="tag[@name='documentation']" /></xhtml:div>
                  <!-- xsl:if test="count(Parameter[@kind!='return'])>0" -->
                  <xhtml:ul>
                    <xsl:for-each select="Parameter[@kind!='return']" >
                      <xhtml:li>
                        <xhtml:div expandWikistyle="true" class='standard'><xsl:text>''</xsl:text><xsl:value-of select="@name"/><xsl:text>'': </xsl:text>
                          <xsl:value-of select="tag[@name='documentation']" />
                        </xhtml:div>
                      </xhtml:li>
                    </xsl:for-each>
                  </xhtml:ul>
                </xhtml:td>
              </xhtml:tr>
            </xsl:for-each>
          </xhtml:table>
        </xsl:if>
        <xsl:if test="count(UML:Attribute/tag[@name='documentation'])>0">
          <xhtml:p class="caption_P">Attribute:</xhtml:p>
          <xhtml:table border="1" width="100%"><xhtml:tr><xhtml:th width="30%">Attribute</xhtml:th><xhtml:th>Beschreibung</xhtml:th></xhtml:tr>
            <xsl:for-each select="UML:Classifier.feature/UML:Attribute" >          <!-- select="Operation[@visibility='public']" -->
              <xsl:sort select="@name" />
              <!-- Label built from Class.method(paramtype,paramtype) -->
              <xhtml:tr>
                <xhtml:td><xsl:value-of select="@name"/></xhtml:td>
                <xhtml:td>
                  <xhtml:div expandWikistyle="true" class='standard'><xsl:value-of select="tag[@name='documentation']" /></xhtml:div>
                </xhtml:td>
              </xhtml:tr>
            </xsl:for-each>
          </xhtml:table>
        </xsl:if>
        <!-- xsl:if test="count(Association/tag[@name='documentation'])>0" -->
        <xsl:if test="count(xxxAssociation)>0">
          <xhtml:p>Assoziationen:</xhtml:p>
          <xhtml:table border="1" width="100%"><xhtml:tr><xhtml:th width="30%">Assoziation</xhtml:th><xhtml:th>Zielklasse</xhtml:th><xhtml:th>Beschreibung</xhtml:th></xhtml:tr>
            <!-- xsl:for-each select="Association[count(tag[@name='documentation'])>0]" -->
            <xsl:for-each select="Association" >
              <xsl:sort select="@name" />
              <xsl:variable name="LABEL">#class_<xsl:value-of select="@classType"/></xsl:variable>
              <xhtml:tr>
                <xhtml:td><xsl:value-of select="@name"/></xhtml:td>
                <xhtml:td><xhtml:a href="{$LABEL}"><xsl:value-of select="@classType"/></xhtml:a></xhtml:td>
                <xhtml:td>
                  <xhtml:div expandWikistyle="true" class='standard'><xsl:value-of select="tag[@name='documentation']" /></xhtml:div>
                </xhtml:td>
              </xhtml:tr>
            </xsl:for-each>
          </xhtml:table>
        </xsl:if>
      </xhtml:body>

  </xsl:template>




  <xsl:template name="typeWithReference">
  <!-- writes the typename with or without a internref -->
    <xsl:if test="count(@typeName)>0 and @typePackage!='-?-'">
      <xsl:variable name="HREF">#CLASS.<xsl:value-of select="@typeName"/></xsl:variable>
      <xhtml:a href="{$HREF}"><xsl:value-of select="@typeName"/></xhtml:a>
    </xsl:if>
    <xsl:if test="count(@typeName)>0 and @typePackage='-?-'">
      <xsl:value-of select="@typeName"/>
    </xsl:if>
  </xsl:template>


<xsl:template name="getPackageClassContext">
<!-- supplies the package/package/class.class -->  
  <xsl:if test="local-name(../../../../../../..) = 'Package'"><xsl:value-of select="../../../../../../../@name" /><xsl:text>/</xsl:text></xsl:if>
  <xsl:if test="local-name(../../../../../../..) = 'Class'"><xsl:value-of select="../../../../../../../@name" /><xsl:text>.</xsl:text></xsl:if>
  <xsl:if test="local-name(../../../../../..) = 'Package'"><xsl:value-of select="../../../../../../@name" /><xsl:text>/</xsl:text></xsl:if>
  <xsl:if test="local-name(../../../../../..) = 'Class'"><xsl:value-of select="../../../../../../@name" /><xsl:text>.</xsl:text></xsl:if>
  <xsl:if test="local-name(../../../..) = 'Package'"><xsl:value-of select="../../../../@name" /><xsl:text>/</xsl:text></xsl:if>
  <xsl:if test="local-name(../../../..) = 'Class'"><xsl:value-of select="../../../../@name" /><xsl:text>.</xsl:text></xsl:if>
  <xsl:if test="local-name(../..) = 'Package'"><xsl:value-of select="../../@name" /><xsl:text></xsl:text></xsl:if>
  <xsl:if test="local-name(../..) = 'Class'"><xsl:value-of select="../../@name" /><xsl:text></xsl:text></xsl:if>
</xsl:template>


  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->


  <xsl:template name="umlStateD">
    <xhtml:body><xsl:call-template name="debugModelElement" />
      <xhtml:p class='caption_p'>State diagram of <xsl:value-of select="@name"/></xhtml:p>
      <xsl:variable name="LabelPrefix"><xsl:value-of select="'?package'"/><xsl:value-of select="@class"/><xsl:value-of select="@name"/></xsl:variable>
      <!-- xsl:for-each select="UML:Namespace.ownedElement/UML:StateMachine" -->
        <xsl:variable name="AllTransitions" select="UML:StateMachine.transitions" /><!-- used as transition tree -->
        <xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']">
          <xhtml:div expandWikistyle="true" class="umlDescription"><xsl:value-of select="@value"/></xhtml:div>
        </xsl:for-each>    
        <xsl:for-each select="UML:StateMachine.top/UML:CompositeState/UML:CompositeState.subvertex">
          <xhtml:dl>
            <xsl:for-each select="UML:CompositeState | UML:SimpleState">
              <xsl:call-template name="umlStateDescriptionAndTransitions">
                <xsl:with-param name="LabelPrefix" select="$LabelPrefix"/>
                <xsl:with-param name="AllTransitions" select="$AllTransitions" />
              </xsl:call-template>
            </xsl:for-each>
          </xhtml:dl>
        </xsl:for-each>  

        <xsl:for-each select="UML:StateMachine.top/UML:CompositeState/UML:CompositeState.subvertex//UML:CompositeState/UML:CompositeState.subvertex">
          <xhtml:p class="caption_P"><xsl:text>Substates von </xsl:text><xsl:value-of select="../@name" /><xsl:text></xsl:text></xhtml:p>
          <xhtml:dl>
            <xsl:for-each select="UML:CompositeState | UML:SimpleState">
              <xsl:call-template name="umlStateDescriptionAndTransitions">
                <xsl:with-param name="LabelPrefix" select="$LabelPrefix"/>
                <xsl:with-param name="AllTransitions" select="$AllTransitions" />
              </xsl:call-template>
            </xsl:for-each>
          </xhtml:dl>
        </xsl:for-each>  


        <xsl:for-each select=".//State">
          <xsl:if test="count(State)>0">
            <xsl:variable name="LabelSubstates"><xsl:value-of select="$LabelPrefix"/><xsl:text>_SUB_</xsl:text><xsl:value-of select="@name"/></xsl:variable>
            <xhtml:anchor label="{$LabelSubstates}"/>
            <xhtml:p class="std"><xhtml:u>
              <xsl:choose><xsl:when test="@isConcurrent='true'"><xsl:text>Parallele Zweige</xsl:text></xsl:when>
              <xsl:otherwise><xsl:text>Substates</xsl:text></xsl:otherwise></xsl:choose>
              <xsl:text> von </xsl:text><xsl:value-of select="@name"/></xhtml:u></xhtml:p>
            <xhtml:dl>
              <xsl:for-each select="State">
                <xsl:call-template name="umlStateDescriptionAndTransitions"><xsl:with-param name="LabelPrefix" select="$LabelPrefix"/></xsl:call-template>
              </xsl:for-each>
            </xhtml:dl>
          </xsl:if>
        </xsl:for-each>
      <!-- /xsl:for-each -->
    </xhtml:body>
  </xsl:template>



  <xsl:template name="umlStateDescriptionAndTransitions">
  <xsl:param name="LabelPrefix"/>
  <xsl:param name="AllTransitions" />
    <xsl:variable name="Name">
      <xsl:choose><xsl:when test="string-length(@name)>0"><xsl:value-of select="@name"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@xmi.id"/></xsl:otherwise></xsl:choose>
    </xsl:variable>
    <xsl:variable name="StateId" select="@xmi.id" />
    <xsl:variable name="LabelState"><xsl:value-of select="$LabelPrefix"/><xsl:text>_</xsl:text><xsl:value-of select="$Name"/></xsl:variable>
    <xhtml:anchor label="{$LabelState}"/>
    <xhtml:dt class='umlElement'>
      <xhtml:stroke>
        <xsl:choose><xsl:when test="@kind='branch'"><xsl:text>Branch </xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>State </xsl:text></xsl:otherwise></xsl:choose>
        <xsl:value-of select="$Name"/>
      </xhtml:stroke>
      <xsl:if test="count(UML:CompositeState | UML:SimpleState)>0">
        <!-- hyperlink to the documentation of the substates -->
        <xsl:variable name="LabelSubstates">#<xsl:value-of select="$LabelPrefix"/>_SUB_<xsl:value-of select="@name"/></xsl:variable>
        <xhtml:a href="{$LabelSubstates}">
          <xsl:choose><xsl:when test="@isConcurrent='true'"><xsl:text> (mit parallelen Zweigen)</xsl:text></xsl:when>
          <xsl:otherwise><xsl:text> (mit Substates)</xsl:text></xsl:otherwise></xsl:choose>
        </xhtml:a>
      </xsl:if>
    </xhtml:dt>
    <xhtml:dd>
      <xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']">
        <xhtml:div expandWikistyle="true" class="umlDescription"><xsl:value-of select="@value"/></xhtml:div>
      </xsl:for-each>    
      <xsl:if test="count($AllTransitions/UML:Transition[@source=$StateId])>0">
        <xsl:for-each select="$AllTransitions/UML:Transition[@source=$StateId]">
            <xsl:call-template name="StateDTransition" ><xsl:with-param name="AllTransitions" select="$AllTransitions" /></xsl:call-template>
          </xsl:for-each>
      </xsl:if>
    </xhtml:dd>  
  </xsl:template>




<xsl:template name="StateDTransition" >
<xsl:param name="AllTransitions" />  
<xsl:param name="LabelPrefix" />  
  <xsl:variable name="Target" select="key('id',@target)" />
    <xhtml:div expandWikistyle="true" class="umlDescription">
      <xsl:variable name="LabelState"><xsl:value-of select="$LabelPrefix"/><xsl:text>_</xsl:text><xsl:value-of select="$Target/@name"/></xsl:variable>
      <xsl:text>'''[[</xsl:text><xsl:value-of select="$LabelState" /><xsl:text>|=&gt;</xsl:text><xsl:value-of select="$Target/@name" /><xsl:text>]]'''</xsl:text> <!-- xsl:text>(</xsl:text><xsl:value-of select="@target" /><xsl:text>)</xsl:text -->
      <xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='displayName']" >
        <xsl:choose><xsl:when test="contains(@value,'/')">
          <xsl:text> on ,,</xsl:text><xsl:value-of select="substring-before(@value, '/')" /><xsl:text>,, </xsl:text><!-- suppress statements after / -->
        </xsl:when><xsl:otherwise>
          <xsl:text> on ,,</xsl:text><xsl:value-of select="@value" /><xsl:text>,, </xsl:text>
        </xsl:otherwise></xsl:choose>
      </xsl:for-each>
      <xsl:text>: </xsl:text><xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" /><xsl:text></xsl:text>
    </xhtml:div>
    <xsl:if test="local-name($Target/.)='Pseudostate'">
      <xsl:variable name="PseudostateId" select="$Target/@xmi.id" />
      <xhtml:ul>
        <xsl:for-each select="$AllTransitions/UML:Transition[@source=$PseudostateId]">
          <xsl:call-template name="StateDTransition" ><xsl:with-param name="AllTransitions" select="$AllTransitions" /></xsl:call-template>
        </xsl:for-each>  
      </xhtml:ul>
    </xsl:if>  
</xsl:template>




<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->
<!-- ******************************************************************************************* -->



  <xsl:template name="umlComment">
  <xsl:param name="param1"></xsl:param>
    <xsl:variable name="LABEL"><xsl:text>Topic.</xsl:text><xsl:value-of select="substring-before(@body,':')" /><xsl:text></xsl:text></xsl:variable>
    <xhtml:body><xsl:call-template name="debugModelElement" ><xsl:with-param name="gen" select="'umlComment'" /></xsl:call-template>
      <xhtml:div expandWikistyle="true"  class="std" id="{$LABEL}">
        <xsl:choose><xsl:when test="contains(@body,'###')">
          <xsl:value-of select="substring-after(@body,'###')"/>
        </xsl:when><xsl:otherwise>
          <xsl:value-of select="@body"/>
        </xsl:otherwise></xsl:choose>
      </xhtml:div>
    </xhtml:body>
  </xsl:template>




  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->

  <xsl:template name="umlSQDdescription">
  <xsl:param name="param1"></xsl:param>
    <xhtml:body class='standard'><xsl:call-template name="debugModelElement" />
      <xsl:for-each select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']">
        <xhtml:div expandWikistyle="true" class="umlDescription"><xsl:value-of select="@value"/></xhtml:div>
      </xsl:for-each>    
    </xhtml:body>
  </xsl:template>


  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->



<xsl:template name="getClassLabel">
<xsl:param name="first" select="''" />
  <!-- xsl:choose><xsl:when test="../..[local-name()='Class']" -->
    <xsl:for-each select="../..[local-name()='Class']">
      <xsl:call-template name="getClassLabel"><xsl:with-param name="first" select="'no'" /></xsl:call-template>      
    </xsl:for-each>
  <!-- /xsl:when><xsl:otherwise>
  </xsl:otherwise></xsl:choose -->
    <xsl:value-of select="@name" />
    <xsl:if test="$first='no'"><xsl:text>.</xsl:text></xsl:if>
</xsl:template>     



<!-- Searches the type name from given id -->
<xsl:template name="typeName">
<xsl:param name="type-id" />
  <xsl:if test="$type-id != ''">
		<xsl:variable name="typeNode" select="key('id',$type-id)" />
		<xsl:choose><xsl:when test="local-name($typeNode)='DataType'">
			<!-- not UML-(Rhapsody)-registered types: -->
			<xsl:value-of select="$typeNode/@name" /><!-- may be existing. -->
			<xsl:value-of select="$typeNode/UML:ModelElement.taggedValue/UML:TaggedValue[@tag='declaration']/@value" />
		</xsl:when><xsl:otherwise>
			<xsl:value-of select="$typeNode/@name" />
		</xsl:otherwise></xsl:choose>
  </xsl:if>
</xsl:template>



<xsl:template name="debugModelElement" >
<xsl:param name="gen" select="''" />
  <xhtml:p class="debug"><xsl:value-of select="$gen" /><xsl:text> UML=</xsl:text><xsl:call-template name="debugPath" /></xhtml:p>  
</xsl:template>  
  
  
<xsl:template name="debugPath">
  <xsl:if test="false() and local-name()!='XMI.content' and boolean(../..)">
    <for-each select=".."><xsl:call-template name="debugPath" /></for-each>    
  </xsl:if>
  
  <xsl:for-each select="../.."><xsl:text>/</xsl:text><xsl:value-of select="local-name()" /><xsl:text>[</xsl:text><xsl:value-of select="@name" /><xsl:text>]</xsl:text></xsl:for-each>
  <xsl:for-each select=".."><xsl:text>/</xsl:text><xsl:value-of select="local-name()" /><xsl:text>[</xsl:text><xsl:value-of select="@name" /><xsl:text>]</xsl:text></xsl:for-each>
  <xsl:choose><xsl:when test="local-name()='Comment'">
    <!-- Rhapsody bug: in name the same content is written like in body-->
    <xsl:text>/UML:Comment[</xsl:text><xsl:value-of select="substring(@name,1,20)" /><xsl:text>]</xsl:text>
  </xsl:when><xsl:otherwise><xsl:text>/</xsl:text><xsl:value-of select="local-name()" /><xsl:text>[</xsl:text><xsl:value-of select="@name" /><xsl:text>]</xsl:text>
  </xsl:otherwise></xsl:choose>
    
</xsl:template>  

  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->

  <xsl:template name="errorNotFound">
  <xsl:param name="param1"></xsl:param>
    <xhtml:body><xhtml:p class="errormsg">ERROR: not found ---&gt;<xsl:value-of select="$param1"/>&lt;---</xhtml:p></xhtml:body>
  </xsl:template>


<xsl:template name="decimal2hex">  
  <xsl:param name="x"/>  
  <xsl:variable name="symbols">0123456789ABCDEF</xsl:variable>   
  <xsl:variable name="temp">    
    <xsl:if test="$x &gt;= 16">
      <xsl:call-template name="decimal2hex">        
        <xsl:with-param name="x" select="floor($x div 16)"/>
      </xsl:call-template>    
    </xsl:if>  
  </xsl:variable>  
  <xsl:value-of select="concat($temp, substring($symbols, $x mod 16 + 1, 1))"/>
</xsl:template>






</xsl:stylesheet>

