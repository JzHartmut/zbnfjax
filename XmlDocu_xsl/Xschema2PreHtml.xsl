<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <!--  ****** allgemeine Transformation einer XML-Schema-Beschreibung ******************************************* -->

  <xsl:template match="/root">
    <Chapters><title>XSchema</title>
      <xsl:apply-templates select="xs:schema/xs:element"/>
      <xsl:apply-templates select="xs:schema/xs:group"/>
      <xsl:apply-templates select="xs:schema/xs:complexType"/>
    </Chapters>
  </xsl:template>

  <xsl:template match="/xs:schema">
  <!-- This template is only activated from super xsl script if included this xsl. It produce some chapter -->
    <xsl:apply-templates select="xs:element"/>
    <xsl:apply-templates select="xs:group"/>
    <xsl:apply-templates select="xs:complexType"/>
  </xsl:template>


  <!-- ....... call fuer gesamtes xschema ............................................................ -->
  <xsl:template name="xmlSchemaTables">
    <xsl:param name="xschema_id" />
    <xsl:param name="chapterlevel" />
    <h level="{$chapterlevel}"><a name="xschema_{$xschema_id}" />Xschema-Beschreibung <xsl:copy-of select="$xschema_id"/></h>
    <p>Die folgenden Tabellen wurden automatisch aus dem XSchema-File mit
       <code>&lt;xs:schema id=&quot;<xsl:value-of select='$xschema_id' />&quot; &gt;</code>
       konvertiert.</p>
    <p><xsl:apply-templates select="xs:schema[@id=$xschema_id]/xs:annotation/xs:documentation/text()" /></p>
    <xsl:for-each select="xs:schema[@id=$xschema_id]/xs:element">
      <xsl:variable name="xschema_element" ><xsl:value-of select="./@name" /></xsl:variable>
      <h level="{$chapterlevel+1}"><a name="xschema_{$xschema_id}_{$xschema_element}" />Elementbeschreibung &lt;<xsl:value-of select="@name"/>&gt;</h>
      <p><xsl:apply-templates select="xs:annotation/xs:documentation/text()" /></p>
      <xsl:apply-templates select="xs:complexType" />
    </xsl:for-each>
  </xsl:template>



  <xsl:template match="xs:schema/xs:complexType">
    <chapter><title>Complextype auf oberster Ebene :TODO:</title>
      <content>
        <xsl:apply-templates select="*"/>
      </content>
    </chapter>
  </xsl:template>



  <!-- ....... call fuer 1 Element ..................................................................... -->
  <xsl:template name="xmlSchemaElementTable">
    <xsl:param name="xschema_id" />
    <xsl:param name="xschema_element" />
    <xsl:param name="chapterlevel" />
    <h level="{$chapterlevel}"><a name="xschema_{$xschema_id}_{$xschema_element}" />Elementbeschreibung &lt;<xsl:value-of select='$xschema_element'/>&gt;</h>
    <p>Die folgenden Tabellen wurden automatisch aus dem XSchema-File mit
       <code>&lt;xs:schema id=&quot;<xsl:value-of select='$xschema_id' />&quot; &gt;</code>
       konvertiert.</p>
    <p><xsl:apply-templates select="xs:schema[@id=$xschema_id]/xs:element[@name=$xschema_element]/xs:annotation/xs:documentation/text()" /></p>
    <xsl:apply-templates select="xs:schema[@id=$xschema_id]/xs:element[@name=$xschema_element]/xs:complexType" />
  </xsl:template>

  <!-- ....... Element auf dem toplevel einer Schema-Datei: ............................................ -->
  <!-- xsl:template match="xs:schema/xs:element">
    <xsl:variable name="elementname"><xsl:value-of select="@name" /></xsl:variable>
    <xsl:variable name="xschema_id">XSCHEMA</xsl:variable>
    <h level="{$chapterlevel}"><a name="xschema_{$xschema_id}_{$elementname}" />Elementbeschreibung &lt;<xsl:value-of select="@name" />&gt;</h>
    <p><xsl:apply-templates select="./xs:annotation/xs:documentation/text()" /></p>
    <xsl:apply-templates select="./xs:complexType" />
  </xsl:template -->


  <!-- ....... Beschreibung eines Elementes als Tabelle  .................................... -->
  <xsl:template match="xs:element/xs:complexType">
    <xsl:if test="count(./xs:attribute)>0">
      <p>Attribute:</p>
      <table><tr><th width="30%">name</th><th>Bedeutung</th></tr>
        <xsl:apply-templates select="./xs:attribute" />
      </table>
    </xsl:if>
    <xsl:apply-templates select="xs:sequence"/>
    <xsl:apply-templates select="xs:choice"/>
    <!--
    <xsl:if test="count(./xs:sequence/xs:element)>0">
      <p>Elemente:</p>
      <table><tr><th width="40%">&lt;name&gt;<br />Bedeutung</th><th width="60%">Inhalt</th></tr>
        <xsl:for-each select="./xs:sequence/xs:element">
          <xsl:call-template name="elementInTable" />
        </xsl:for-each>
      </table>
    </xsl:if>
    <xsl:if test="count(./xs:choice/xs:element)>0">
      <p>Sub-Elemente als Auswahl </p>
      <table><tr><th width="40%">&lt;name&gt;<br />Bedeutung</th><th width="60%">Inhalt</th></tr>
        <xsl:for-each select="./xs:choice/xs:element or xs:choice/xs:group">
          <xsl:call-template name="elementInTable" />
        </xsl:for-each>
      </table>
    </xsl:if>
    -->
  </xsl:template>


  <!-- ....... attribute eines Elementes allgemein .................................... -->
  <xsl:template match="xs:element/xs:complexType/xs:attribute">
    <tr><td><xsl:value-of select="@name" /></td>
        <td><xsl:value-of select="./xs:annotation/xs:documentation/text()" /></td>
    </tr>
  </xsl:template>


  <!-- ...... Auswahl eines Element innerhalb eines Elementes ...................................... -->
  <xsl:template name="elementInTable">
    <xsl:if test="count(@name)>0">
      <tr><td><code>&lt;<xsl:value-of select="@name" />&gt;</code><br />
            <xsl:value-of select="./xs:annotation/xs:documentation/text()" /></td>
          <td>
            <xsl:if test="count(@type)>0">(<xsl:value-of select="./@type" />)</xsl:if>
            <xsl:if test="count(xs:complexType)>0"><xsl:apply-templates select="./xs:complexType" /></xsl:if>
            <xsl:if test="count(xs:simpleType)>0"><xsl:apply-templates select="./xs:simpleType" /></xsl:if>
          </td>
          <!-- td><xsl:value-of select="./xs:annotation/xs:documentation/text()" /></td -->
      </tr>
    </xsl:if>
    <xsl:if test="count(@ref)>0">
      <xsl:variable name="LABEL">Element_<xsl:value-of select="@ref" /></xsl:variable>
      <tr><td><internref label="{$LABEL}"><code>&lt;<xsl:value-of select="@ref" />&gt;</code></internref><br />
            <xsl:value-of select="./xs:annotation/xs:documentation/text()" /></td>
          <td>siehe dessen Definition</td>
          <!-- td><xsl:value-of select="./xs:annotation/xs:documentation/text()" /></td -->
      </tr>
    </xsl:if>
  </xsl:template>

  <!-- ...... Auswahl eines Element aus der obersten Ebene ...................................... -->
  <xsl:template match="xs:schema/xs:element">
    <chapter><title>Element: &lt;<xsl:value-of select="@name" />&gt;</title>
      <xsl:variable name="LABEL">Element_<xsl:value-of select="@name" /></xsl:variable>
      <anchor label="{$LABEL}"/>
      <content>
        <p><xsl:value-of select="./xs:annotation/xs:documentation/text()" /></p>
        <xsl:if test="count(@type)>0">(<xsl:value-of select="./@type" />)</xsl:if>
        <xsl:if test="count(xs:complexType)>0"><xsl:apply-templates select="./xs:complexType" /></xsl:if>
        <xsl:if test="count(xs:simpleType)>0"><xsl:apply-templates select="./xs:simpleType" /></xsl:if>
      </content>
    </chapter>
  </xsl:template>

  <!-- ...... Group aus der obersten Ebene ...................................... -->
  <xsl:template match="xs:schema/xs:group">
    <chapter><title>Gruppierung von Elementen: <xsl:value-of select="@name" /></title>
      <xsl:variable name="labelGrp">Group_<xsl:value-of select="@name" /></xsl:variable>
      <anchor label="{$labelGrp}"/>
      <content>
        <p><xsl:value-of select="./xs:annotation/xs:documentation/text()" /></p>
        <table><tr><th width="40%">&lt;name&gt;<br />Bedeutung</th><th width="60%">Inhalt</th><!-- th>Bedeutung</th --></tr>
          <xsl:for-each select="./xs:choice/xs:element">
            <xsl:call-template name="elementInTable" />
          </xsl:for-each>
        </table>
      </content>
    </chapter>
  </xsl:template>




  <xsl:template match="xs:choice">
    <xsl:choose>
    <xsl:when test="@maxOccurs='unbounded'">
      <p><u>Auswahl von Elementen in beliebiger Folge aus:</u></p>
    </xsl:when><xsl:when test="@maxOccurs='1'">
      <p><u>Auswahl genau eines Elementes aus:</u></p>
    </xsl:when><xsl:otherwise>
      <p><u>Auswahl von <xsl:value-of select="@minOccurs"/> bis <xsl:value-of select="@maxOccurs"/> Elemente aus:</u></p>
    </xsl:otherwise></xsl:choose>
    <p><xsl:apply-templates select="xs:annotation/xs:documentation/text()" /></p>
    <ul>
      <xsl:for-each select="xs:element|xs:group">
        <xsl:choose><xsl:when test="local-name()='group'">
          <xsl:call-template name="groupListItem" />
        </xsl:when><xsl:otherwise>
          <xsl:call-template name="elementListItem" />
        </xsl:otherwise></xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <xsl:template match="xs:sequence">
    <xsl:choose>
    <xsl:when test="@maxOccurs='unbounded'">
      <p><u>Abfolge (sequence) von jeweils beliebig vielen Elementen aus:</u></p>
    </xsl:when><xsl:when test="@maxOccurs='1'">
      <p><u>Abfolge (sequence) jeweils genau eines Elementes aus:</u></p>
    </xsl:when><xsl:otherwise>
      <p><u>Abfolge (sequence) von jeweils <xsl:value-of select="@minOccurs"/> bis <xsl:value-of select="@maxOccurs"/> Elemente aus:</u></p>
    </xsl:otherwise></xsl:choose>
    <p><xsl:apply-templates select="xs:annotation/xs:documentation/text()" /></p>
    <ul>
      <xsl:for-each select="xs:element|xs:group|xs:sequence|xs:choice">
        <xsl:choose><xsl:when test="local-name()='group'">
          <xsl:call-template name="groupListItem" />
        </xsl:when><xsl:when test="local-name()='element'">
          <xsl:call-template name="elementListItem" />
        </xsl:when><xsl:otherwise>
          <li>
            <xsl:apply-templates select="." /><!-- it is choice or sequence -->
          </li>
        </xsl:otherwise></xsl:choose>
      </xsl:for-each>
    </ul>
  </xsl:template>


  <!-- ...... Element als ListItem ...................................... -->
  <xsl:template name="elementListItem">
    <xsl:if test="count(@name)>0">
      <li>
        <p>
          <code>&lt;<xsl:value-of select="@name" />&gt;</code>
          <xsl:if test="count(@type)>0"><xsl:text> </xsl:text>(<xsl:value-of select="./@type" />)</xsl:if>
          <br />
          <xsl:value-of select="./xs:annotation/xs:documentation/text()" />
        </p>
        <xsl:if test="count(xs:complexType)>0"><xsl:apply-templates select="./xs:complexType" /></xsl:if>
        <xsl:if test="count(xs:simpleType)>0"><xsl:apply-templates select="./xs:simpleType" /></xsl:if>
      </li>
    </xsl:if>
    <xsl:if test="count(@ref)>0">
      <xsl:variable name="LABEL">Element_<xsl:value-of select="@ref" /></xsl:variable>
      <li>
        <p>
          <internref label="{$LABEL}"><code>&lt;<xsl:value-of select="@ref" />&gt;</code></internref>
          <xsl:if test="count(@type)>0">(<xsl:value-of select="./@type" />)</xsl:if>
          <br />
          <xsl:value-of select="./xs:annotation/xs:documentation/text()" />
        </p>
      </li>
    </xsl:if>
  </xsl:template>


  <!-- ...... Gruppe als ListItem ...................................... -->
  <xsl:template name="groupListItem">
    <xsl:if test="count(@name)>0">
      <li>
        <p>
          Gruppe: <code><xsl:value-of select="@name" /></code>
          <xsl:if test="count(@type)>0"><xsl:text> </xsl:text>(<xsl:value-of select="./@type" />)</xsl:if>
          <br />
          <xsl:value-of select="./xs:annotation/xs:documentation/text()" />
          <xsl:if test="count(xs:complexType)>0"><xsl:apply-templates select="./xs:complexType" /></xsl:if>
          <xsl:if test="count(xs:simpleType)>0"><xsl:apply-templates select="./xs:simpleType" /></xsl:if>
        </p>
      </li>
    </xsl:if>
    <xsl:if test="count(@ref)>0">
      <xsl:variable name="LABEL">Group_<xsl:value-of select="@ref" /></xsl:variable>
      <li>
        <p>
          Gruppe: <internref label="{$LABEL}"><code><xsl:value-of select="@ref" /></code></internref>
          <xsl:if test="count(@type)>0">(<xsl:value-of select="./@type" />)</xsl:if>
          <br />
          <xsl:value-of select="./xs:annotation/xs:documentation/text()" />
        </p>
      </li>
    </xsl:if>
  </xsl:template>



  <xsl:template match="xs:element/xs:simpleType">
    <p>TEXT</p>
  </xsl:template>





</xsl:stylesheet>