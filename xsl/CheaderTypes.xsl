<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                 xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" encoding="iso-8859-1"/>

<xsl:variable name="indent"><xsl:text>
</xsl:text>
</xsl:variable>


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
    <!-- -->
    <xsl:for-each select="/root/Cheader">
      <usage type="{@filename}{'_h'}" tag="{local-name()}" source="filename" />
    </xsl:for-each>
    <!-- -->
    <xsl:for-each select="//*[boolean(type)]">
      <xsl:if test="not(type/@forward)">
        <usage test="2" type="{type/@name}" tag="{local-name()}" name="{type/@name}" source="type" />
      </xsl:if>
    </xsl:for-each>
    <!-- -->
    <xsl:for-each select="//classDef">
      <xsl:variable name="classIdent"><xsl:call-template name="classIdent" /><!-- xsl:value-of select="@name" / --></xsl:variable>
      <usage test="2" type="{$classIdent}" tag="{local-name()}" name="{@name}" source="classDef" />
    </xsl:for-each>
    <!-- -->
    <xsl:for-each select="//structDefinition">
      <xsl:variable name="classIdent"><xsl:call-template name="classIdent" /></xsl:variable>
      <usage test="2" type="{$classIdent}" tag="{local-name()}" name="{@name}" source="structDefintion" />
      <structTagName tagname="{@tagname}" type="{$classIdent}" name="{@name}" />
    </xsl:for-each>
    <!-- -->
    <xsl:for-each select="//CLASS_C">
      <xsl:variable name="classIdent"><xsl:call-template name="classIdent" /></xsl:variable>
      <usage test="2" type="{$classIdent}" tag="{local-name()}" name="{@name}" source="CLASS_C" />
    </xsl:for-each>
    <!-- -->
    <xsl:for-each select="//attribute[@implicitStruct]">
      <xsl:variable name="classIdent"><xsl:call-template name="classIdent" /><!-- xsl:value-of select="@name" / --></xsl:variable>
      <usage test="2" type="{$classIdent}" tag="{local-name()}" name="{@tagname}" source="attribute" />
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
    <xsl:variable name="simpleTypeName" select="@name" />
    <usedType name="{$type}" xmi.id="{generate-id()}" tag="{@tag}" source="{@source}" >
      <xsl:if test="not(  boolean($input//class[@name=$simpleTypeName]) 
                       or boolean($input//classDef[@name=$simpleTypeName or @tagname=$simpleTypeName]) 
                       or boolean($input//structDefinition[@name=$simpleTypeName or @tagname=$simpleTypeName])
                       or boolean($input//attribute[@tagname=$simpleTypeName])
                       or boolean(@source='filename')
                       )">
        <!-- TODO here is a problem: if the same name exists in a other scope, this condition is true but the type are not defined. -->               
        <xsl:attribute name="external">true</xsl:attribute>
      </xsl:if>
    </usedType><xsl:value-of select="$indent" />
  </xsl:for-each>
  <xsl:for-each select="$allTypes/structTagName">
    <xsl:value-of select="$indent" />
    <xsl:copy-of select="." />
  </xsl:for-each>
  <xsl:value-of select="$indent" />
</xsl:template>


<xsl:template name="classIdent">
  <xsl:call-template name="classIdent-recursive" />
  <xsl:choose><xsl:when test="@implicitStruct"><xsl:value-of select="@tagname" />
  </xsl:when><xsl:when test="@name"><xsl:value-of select="@name" />
  </xsl:when><xsl:when test="@type"><xsl:value-of select="@type" />
  </xsl:when><xsl:otherwise><xsl:value-of select="@tagname" />
  </xsl:otherwise></xsl:choose>
</xsl:template>
  
<xsl:template name="classIdent-recursive">
  <xsl:for-each select="..">
    <xsl:if test="local-name(.) != 'CHeader' and local-name(.)!='outside'">
      <xsl:call-template name="classIdent-recursive" />
    </xsl:if>
    <xsl:choose>
    <xsl:when test="local-name(.) = 'classDef'"><xsl:value-of select="@name" /><xsl:text>::</xsl:text></xsl:when>
    <xsl:when test="local-name(.) = 'structDefinition'"><xsl:value-of select="@name" /><xsl:text>::</xsl:text></xsl:when>
    <xsl:when test="local-name(.) = 'attribute' and boolean(@implicitStruct)"><xsl:value-of select="@tagname" /><xsl:text>::</xsl:text></xsl:when>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>    


</xsl:stylesheet>
