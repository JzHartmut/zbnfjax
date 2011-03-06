<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                 xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" encoding="iso-8859-1"/>

<xsl:variable name="indent"><xsl:text>
</xsl:text>
</xsl:variable>

<!--
  @author Hartmut Schorrig www.vishia.org
  2009-03-31 Hartmut created copied from CheaderTypes.xsl and adapted to output from Java2C.zbnf
                     Java2C.zbnf is used for the Java2C-translator, the XMI conversion is an copycat for the present. 
  -->

<xsl:key name="importType" use="class" 
  match="/root/JavaSrc/importStatement" 
/>



<xsl:template match= "/">
<xsl:value-of select="$indent" />
<Types><xsl:value-of select="$indent" /><xsl:text>  </xsl:text>
  <comment>This is a file containing all founded types in all header files,
    as input for XMI.</comment><xsl:value-of select="$indent" /><xsl:text>  </xsl:text>

  <xsl:call-template name="_Types"><xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>    </xsl:text></xsl:with-param></xsl:call-template>
  <xsl:value-of select="$indent" /><xsl:text>  </xsl:text>

</Types><xsl:value-of select="$indent" />
</xsl:template>


  
<xsl:template name="_Types">
<xsl:param name="indent" />  
  <!-- saxon:assign name="lasttype__Types" select="''" xmlns:saxon="http://saxon.sf.net/" / -->
  <xsl:variable name="input" select="/" /><!-- reference to the root input node -->
  <xsl:variable name="allTypes">
      <xsl:for-each select="//classDefinition">
        <xsl:variable name="classIdent"><xsl:call-template name="classIdent" /><!-- xsl:value-of select="@name" / --></xsl:variable>
        <usage test="2" type="{$classIdent}" tag="{local-name()}" name="{classident}" source="classDefinition" />
      </xsl:for-each>
      <xsl:for-each select="//interfaceDefinition">
        <xsl:variable name="classIdent"><xsl:call-template name="classIdent" /><!-- xsl:value-of select="@name" / --></xsl:variable>
        <usage test="2" type="{$classIdent}" tag="{local-name()}" name="{classident}" source="classDefinition" />
      </xsl:for-each>
      <xsl:for-each select="//*[boolean(type)]">
        <xsl:variable name="typeName" select="type/@name" />
        <usage test="2" type="{$typeName}" tag="{local-name()}" name="{$typeName}" source="type" />
      </xsl:for-each>
  </xsl:variable>  
  <xsl:variable name="sortedTypes">
    <xsl:for-each select="$allTypes/usage" >
    <xsl:sort select="@type" />  
      <xsl:copy-of select="." />
    </xsl:for-each>
  </xsl:variable>
  <!-- test1 root1name="{local-name($input)}" rootname="{local-name($input/*[1])}" rootsortedTypes="{local-name($sortedTypes/*[1])}" /><xsl:value-of select="$indent" />
  <test2><xsl:copy-of select="$allTypes" /></test2>
  <test3><xsl:copy-of select="$sortedTypes" /></test3 -->
  <xsl:for-each select="$sortedTypes/usage[position()=last() or @type != following-sibling::usage[1]/@type]">
    <xsl:variable name="type" select="@type" />
    <xsl:variable name="simpleTypeName" select="@name" /><!-- name of a used type -->
      <!-- A type which is not definied in the model, is external! -->
    <usedType name="{$type}" simpleTypeName="{$simpleTypeName}" xmi.id="{generate-id()}" tag="{@tag}" source="{@source}" >
      <xsl:if test="not(  boolean($input//classDefinition[classident=$simpleTypeName])
                       or boolean($input//interfaceDefinition[classident=$simpleTypeName])
                       )">
        <!-- TODO here is a problem: if the same name exists in an other scope, this condition is true but the type are not defined. -->               
        <xsl:attribute name="external">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="boolean($input//classDefinition[classident=$simpleTypeName])
                 or boolean($input//interfaceDefinition[classident=$simpleTypeName])">
        <!-- TODO here is a problem: if the same name exists in an other scope, this condition is true but the type are not defined. -->               
        <xsl:attribute name="non-external">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="boolean($input//interfaceDefinition[classident=$simpleTypeName])">
        <!-- TODO here is a problem: if the same name exists in an other scope, this condition is true but the type are not defined. -->               
        <xsl:attribute name="ifc">true</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="TEST">true</xsl:attribute>
      <xsl:if test="@name='int' or @name='long' or @name='short' or @name='byte' or @name='float' or @name='double' 
                   or @name='String' or @name='int' or @name='int' or @name='int' or @name='int'">
        <xsl:attribute name="basicType">true</xsl:attribute>
      </xsl:if>
      <xsl:if test="@name='List' or @name='LinkedList' or @name='ArrayList' or @name='Map' or @name='TreeMap'">
        <xsl:attribute name="container">true</xsl:attribute>
      </xsl:if>
    </usedType><xsl:value-of select="$indent" />
  </xsl:for-each>
</xsl:template>


<xsl:template name="classIdent">
  <xsl:call-template name="classIdent-recursive" />
  <xsl:value-of select="classident" />
</xsl:template>
  
<xsl:template name="classIdent-recursive">
  <xsl:for-each select="..">
    <xsl:if test="local-name(.) != 'JavaSrc'">
      <!-- go backward until the top of tree-->
      <xsl:call-template name="classIdent-recursive" />
    </xsl:if>
    <!-- than, recursively returned, catch all structure names and assemble it to the type name. -->
    <xsl:choose>
    <xsl:when test="local-name(.) = 'classDefinition'"><xsl:value-of select="classident" /><xsl:text>.</xsl:text></xsl:when>
    <xsl:when test="local-name(.) = 'interfaceDefinition'"><xsl:value-of select="classident" /><xsl:text>.</xsl:text></xsl:when>
    <xsl:when test="local-name(.) = 'methodDefinition'"><xsl:value-of select="name" /><xsl:text>().</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>    


</xsl:stylesheet>
