<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:UML="omg.org/UML13"
  xmlns:saxon="http://icl.com/saxon"
  xmlns:exslt="exslt.org"
>
  <xsl:output method="xml" encoding="iso-8859-1"/>


<xsl:key name="id" use="@xmi.id" 
  match="UML:DataType|UML:Package|UML:Stereotype|UML:Association|UML:AssociationEnd|UML:Dependency|UML:Class|UML:Interface" 
/>

<!-- key to find the association appropriate to a class. 
     The class id is stored in type. It is an unnamed end
     if the association is directed. To find the other end see template umlAssociation.
  -->
<xsl:key name="associationEnd" use="@type" 
  match="UML:AssociationEnd" 
/>


<xsl:variable name="ident2">
  <xsl:text>
  </xsl:text>
</xsl:variable>


<xsl:template match= "/">
  <output>
    <xsl:for-each select="//UML:Component" >
      <xsl:value-of select="ident2" />
      <xsl:call-template name="umlComponent" >
        <xsl:with-param name="indent"><xsl:value-of select="$ident2" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>

    <xsl:for-each select="XMI/XMI.content/UML:Model/UML:Namespace.ownedElement/UML:Package/UML:Namespace.ownedElement/UML:Package" >
      <xsl:value-of select="ident2" />
      <xsl:call-template name="umlPkg">
        <xsl:with-param name="indent"><xsl:value-of select="$ident2" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </output>

</xsl:template>


<xsl:template name="umlPkg">
  <xsl:param name="indent" />
  <xsl:value-of select="$indent" />
  <pkg name="{@name}" xmi.id="{@xmi.id}">
    <xsl:for-each select="UML:Namespace.ownedElement/UML:Package">
      <xsl:call-template name="umlPkg">
        <xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="UML:Namespace.ownedElement/UML:Class">
      <xsl:call-template name="umlClass">
        <xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:value-of select="$indent" />
  </pkg>
  <xsl:value-of select="$indent" />
</xsl:template>




<xsl:template name="umlClass">
<xsl:param name="indent" />
  <xsl:variable name="classId" select="@xmi.id" />
  <xsl:value-of select="$indent" />
  <class name="{@name}" xmi.id="{@xmi.id}">
    
    <xsl:for-each select="UML:Classifier.feature/UML:Class">
      <!-- inner class: -->
      <xsl:call-template name="umlClass">
        <xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>  
    
    <xsl:for-each select="UML:Classifier.feature/UML:Attribute">
      <xsl:call-template name="umlAttribute">
        <xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    
    <xsl:for-each select="key('associationEnd', $classId)">
      <xsl:call-template name="umlAssociation">
        <xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    
    <xsl:for-each select="UML:Classifier.feature/UML:Method">
      <xsl:call-template name="umlMethod">
        <xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    
    <xsl:for-each select="UML:Classifier.feature/UML:Operation">
      <xsl:call-template name="umlOperation">
        <xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    
  <xsl:value-of select="$indent" />
  </class>
  <xsl:value-of select="$indent" />
</xsl:template>





<xsl:template name="umlAttribute">
<xsl:param name="indent" />
  <xsl:value-of select="$indent" />
  <xsl:variable name="typeId" select="@type" />
  <xsl:variable name="typeNode"><xsl:copy-of select="/.//UML:DataType[@xmi.id=$typeId]" /></xsl:variable>
  <attribute name="{@name}" xmi.id="{@xmi.id}" type="{key('id',@type)/@name}"  visibility="{@visibility}" />
    <!-- xsl:value-of select="$indent" />
    <type><xsl:value-of select="key('id',@type)/@name" /></type>
    <xsl:value-of select="$indent" />
    <type_x --><!-- xsl:value-of select="$typeNode/@name" / --><!-- xsl:value-of select="$typeId" /></type_x>
    <xsl:value-of select="$indent" />
  </attribute -->
</xsl:template>





<xsl:template name="umlAssociation">
<!-- the association end at the src class is selected,
     to get the other end, the target, select it as sibling.
 -->      
<xsl:param name="indent" />
  <xsl:variable name="srcId" select="@xmi.id"/>
  <xsl:for-each select="../UML:AssociationEnd[@xmi.id!=$srcId]"><!-- the other end -->
    <xsl:variable name="typeId" select="@type" />
    <xsl:value-of select="$indent" />
    <association name="{@name}" xmi.id="{@xmi.id}" type="{key('id',@type)/@name}" aggregation="{@aggregation}" visibility="{@visibility}" />
  </xsl:for-each>  
</xsl:template>





<xsl:template name="umlMethod">
<xsl:param name="indent" />
  <xsl:variable name="indent1"><xsl:value-of select="$indent"/><xsl:text>  </xsl:text></xsl:variable>
  <xsl:value-of select="$indent" />
  <xsl:variable name="typeId" select="@type" />
  <method name="{@name}" xmi.id="{@xmi.id}" type="{key('id',@type)/@name}" visibility="{@visibility}" >
    <xsl:call-template name="elementDocumentation"><xsl:with-param name="indent"><xsl:value-of select="$indent" /><xsl:text>  </xsl:text></xsl:with-param></xsl:call-template>
  </method>  
</xsl:template>





<xsl:template name="umlOperation">
<xsl:param name="indent" />
  <xsl:value-of select="$indent" />
  <xsl:variable name="typeId" select="@type" />
  <operation   name="{@name}" xmi.id="{@xmi.id}" type="{key('id',@type)/@name}" visibility="{@visibility}" />
</xsl:template>





<xsl:template name="umlComponent">
  <xsl:param name="indent" />
  <xsl:value-of select="$indent" />
  <component name="{@name}" xmi.id="{@xmi.id}">
    <xsl:for-each select="UML:Component.residentElement/UML:ElementResidence">
      <xsl:value-of select="$indent" /><xsl:text>  </xsl:text>
      <xsl:variable name="elementName" select="key('id',@resident)/@name" />
      <element resident="{@resident}" name="{$elementName}">
        <xsl:value-of select="key('id',@resident)/@name" />
      </element>
    </xsl:for-each>
  <xsl:value-of select="$indent" />
  </component>
</xsl:template>



<xsl:template name="elementDocumentation">
<xsl:param name="indent" />
  <xsl:if test="boolean(UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation'])">
    <xsl:value-of select="$indent" />
    <!-- documentation><xsl:value-of select="UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value" />
    <xsl:value-of select="$indent" />
    </documentation -->
    <documentation value="{UML:ModelElement.taggedValue/UML:TaggedValue[@tag='documentation']/@value}" />
    <xsl:value-of select="$indent" />
  </xsl:if>
</xsl:template>











</xsl:stylesheet>
