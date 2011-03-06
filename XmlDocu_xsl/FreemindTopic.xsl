<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs ="http://www.w3.org/2001/XMLSchema"
  xmlns:pre="http://www.vishia.de/2006/XhtmlPre"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
  <xsl:output method="xml" encoding="iso-8859-1"/>

  <xs:annotation><xs:documentation>

  </xs:documentation></xs:annotation>

  <xsl:variable name="testOutput">0</xsl:variable>

  <!-- ................................................................................................. -->
  <!-- template to transform from topics or other xhtml-like xml-files into a PreHtml-Format ........... -->
  <!-- This script may be included in a user xsl-script. -->
  <!-- The input format may be matched to the TextTopic.xsd-schema,
       but may have some other things appropriately to the wrapping user script. -->
  <!-- The outputted format is matched to the PreHtml.xsd-schema -->

  <!-- xsl:template match="topics:topic" -->
  <xsl:template name="freemindtopic">
  <xsl:param name="withTitle" select="'-'" />
  <xsl:param name="recursive" select="'-'" />
  <xsl:param name="topicIdent">-</xsl:param>
  
  <xsl:param name="TopicLabel" select="'-'" />
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'standard'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="topicLabel">-</xsl:param>
  <xsl:param name="paraStyle">standard</xsl:param>
  <xsl:param name="style_dt">standard_dtT</xsl:param>
  <xsl:param name="paraStyle_li">standard_li</xsl:param>
  <xsl:param name="paraStyle_tdli">standard_tdli</xsl:param>
  <xsl:param name="paraStyle_td">standard_td</xsl:param>
  <xsl:param name="paraStyle_th">standard_th</xsl:param>
  <xsl:param name="listStyle">listStandard</xsl:param>
  <xsl:param name="cellHeadStyle">tableHeadStanard</xsl:param>
  <xsl:param name="cellStyle">tableCellStandard</xsl:param>

    <xsl:variable name="topicLabelNew"><xsl:value-of select='$topicLabel'/>.<xsl:value-of select="@ident"/></xsl:variable>
    <xsl:variable name="topicIdentnew"><xsl:value-of select="$topicIdent"/>.<xsl:value-of select="@ident"/></xsl:variable>

    <xsl:choose>
    <!-- xsl:when test="count(@title)>0 and string-length(@title)&gt;0" -->
    <xsl:when test="$withTitle='true' and node[starts-with(@TEXT,'=')]">
      <!-- produce only a nested chapter if an attribute title is present -->
      <pre:chapter>
        <!-- anchor for hyperlink navigation: -->
        <xsl:if test="count(@label)>0">
          <xsl:variable name="topicLabelLocal"><xsl:value-of select='@label'/></xsl:variable>
          <anchor label="{$topicLabelLocal}"/>
        </xsl:if>
        <xsl:if test="count(./@label)=0">
          <anchor label="{$topicLabelNew}"/>
        </xsl:if>

        <pre:title><xsl:value-of select="node[starts-with(@TEXT,'=')]/substring-after(@TEXT,'=')"/></pre:title>
        <xsl:call-template name="freemindtopicIntern" ><!-- does a recursion in sup topics -->
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
          <xsl:with-param name="recursive"  select="$recursive" />
        
          <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabelNew'/></xsl:with-param>
          <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdent'/></xsl:with-param>
          <xsl:with-param name="paraStyle"><xsl:value-of select='$paraStyle'/></xsl:with-param>
          <xsl:with-param name="style_dt" select="$style_dt"/>
          <xsl:with-param name="paraStyle_li" select="$paraStyle_li"/>
          <xsl:with-param name="paraStyle_th" select="$paraStyle_th"/>
          <xsl:with-param name="paraStyle_td" select="$paraStyle_td"/>
          <xsl:with-param name="paraStyle_tdli" select="$paraStyle_tdli"/>
          <xsl:with-param name="listStyle"><xsl:value-of select='$listStyle'/></xsl:with-param>
          <xsl:with-param name="cellHeadStyle"><xsl:value-of select='$cellHeadStyle'/></xsl:with-param>
          <xsl:with-param name="cellStyle"><xsl:value-of select='$cellStyle'/></xsl:with-param>
        </xsl:call-template>
      </pre:chapter>

    </xsl:when>
    <xsl:otherwise>
      <!-- no @title, no own pre:chapter -->

      <!-- anchor for hyperlink navigation: -->
      <xsl:if test="count(@label)>0">
        <xsl:variable name="topicLabelLocal">Topic=<xsl:value-of select='@label'/></xsl:variable>
        <anchor label="{$topicLabelLocal}"/>
      </xsl:if>
      <xsl:if test="count(./@label)=0">
        <anchor label="{$topicLabelNew}"/>
      </xsl:if>

      <xsl:call-template name="freemindtopicIntern" ><!-- does a recursion in sup topics -->
        <xsl:with-param name="divStyle"   select="$divStyle" />
        <xsl:with-param name="pStyle"     select="$pStyle" />
        <xsl:with-param name="ulStyle"    select="$ulStyle" />
        <xsl:with-param name="olStyle"    select="$olStyle" />
        <xsl:with-param name="dlStyle"    select="$dlStyle" />
        <xsl:with-param name="tableStyle" select="$tableStyle" />
        <xsl:with-param name="recursive"  select="$recursive" />
      
        <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabelNew'/></xsl:with-param>
        <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdent'/></xsl:with-param>
        <xsl:with-param name="paraStyle"><xsl:value-of select='$paraStyle'/></xsl:with-param>
        <xsl:with-param name="style_dt" select="$style_dt"/>
        <xsl:with-param name="paraStyle_li" select="$paraStyle_li"/>
        <xsl:with-param name="paraStyle_th" select="$paraStyle_th"/>
        <xsl:with-param name="paraStyle_td" select="$paraStyle_td"/>
        <xsl:with-param name="paraStyle_tdli" select="$paraStyle_tdli"/>
        <xsl:with-param name="listStyle"><xsl:value-of select='$listStyle'/></xsl:with-param>
        <xsl:with-param name="cellHeadStyle"><xsl:value-of select='$cellHeadStyle'/></xsl:with-param>
        <xsl:with-param name="cellStyle"><xsl:value-of select='$cellStyle'/></xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="freemindtopicIntern">
  <!-- actual element is either xhtml:body or topics:topic -->
  <xsl:param name="recursive" select="'-'" />
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'-'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="topicLabel">NO_REFLABEL_ONCALL</xsl:param>
  <xsl:param name="topicIdent">-</xsl:param>
  <xsl:param name="paraStyle">standard</xsl:param>
  <xsl:param name="style_dt">standard_dtTi</xsl:param>
  <xsl:param name="paraStyle_li">standard_li</xsl:param>
  <xsl:param name="paraStyle_tdli">standard_tdli</xsl:param>
  <xsl:param name="paraStyle_td">standard_td</xsl:param>
  <xsl:param name="paraStyle_th">standard_th</xsl:param>
  <xsl:param name="listStyle">listStandard</xsl:param>
  <xsl:param name="cellHeadStyle">tableCellHeadStandard</xsl:param>
  <xsl:param name="cellStyle">tableCellStandard</xsl:param>


    <xsl:if test='$testOutput&gt;2'>
      <testOutput level="3">[
        <xsl:if test="count(./@label)>0">Label:<xsl:value-of select='@label'/> Path:</xsl:if>
        <xsl:value-of select='$topicLabel' />]
      </testOutput>
    </xsl:if>

    <xsl:if test='$testOutput&gt;1'>
      <testOutput level="2">Topic:<xsl:value-of select="$topicIdent" /></testOutput>
    </xsl:if>
    
    <xhtml:body id="{'Topic:'}{$topicIdent}">
      <xhtml:p class="debug">Topic:<xsl:value-of select="$topicIdent" /></xhtml:p>
      <xhtml:div expandWikistyle="true"><xsl:value-of select="node[@TEXT='&amp;']/node/@TEXT | node[not(starts-with(@TEXT,'&amp;') or starts-with(@TEXT,'='))]/@TEXT" /></xhtml:div></xhtml:body>
    

    <xsl:if test="$recursive='true'" >
    <!-- sub pre:chapter or additinal content after the content at the own level -->
      <xsl:for-each select="node[starts-with(@TEXT,'&amp;') and string-length(@TEXT) gt 2]" >
        <xsl:variable name="ident" select="substring(@TEXT,2)" />
        <xsl:variable name="topicIdentRec"><xsl:value-of select="$topicIdent" />.<xsl:value-of select="$ident" /></xsl:variable>
        <xsl:call-template name="freemindtopic">
            <xsl:with-param name="recursive"  select="$recursive" />
            <xsl:with-param name="withTitle"  select="'true'" />
            <xsl:with-param name="divStyle"   select="$divStyle" />
            <xsl:with-param name="pStyle"     select="$pStyle" />
            <xsl:with-param name="ulStyle"    select="$ulStyle" />
            <xsl:with-param name="olStyle"    select="$olStyle" />
            <xsl:with-param name="dlStyle"    select="$dlStyle" />
            <xsl:with-param name="tableStyle" select="$tableStyle" />
          
          <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabel'/></xsl:with-param>
          <xsl:with-param name="topicIdent"><xsl:value-of select="$topicIdentRec"/></xsl:with-param>
          <xsl:with-param name="paraStyle"><xsl:value-of select='$paraStyle'/></xsl:with-param>
          <xsl:with-param name="style_dt" select="$style_dt"/>
          <xsl:with-param name="paraStyle_li" select="$paraStyle_li"/>
          <xsl:with-param name="paraStyle_th" select="$paraStyle_th"/>
          <xsl:with-param name="paraStyle_td" select="$paraStyle_td"/>
          <xsl:with-param name="paraStyle_tdli" select="$paraStyle_tdli"/>
          <xsl:with-param name="listStyle"><xsl:value-of select='$listStyle'/></xsl:with-param>
          <xsl:with-param name="cellHeadStyle"><xsl:value-of select='$cellHeadStyle'/></xsl:with-param>
          <xsl:with-param name="cellStyle"><xsl:value-of select='$cellStyle'/></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

                              
  <xsl:template name="assemblefreemindtopicAnchor">
  <!-- assembles the ident of all topics to root level in Form ".parent.child.child"
       therefore first a recursive call to parent will be done, after them the own ident will be added.
    -->    
    <xsl:if test="local-name(..)='topic'">
      <xsl:for-each select=".."><xsl:call-template name="assembleTopicAnchor" /></xsl:for-each>
    </xsl:if>      
    <xsl:text>.</xsl:text><xsl:value-of select="@ident" />  
  </xsl:template>
                              
                              
                              

  <xsl:template name="freemindtable">
  <xsl:param name="withTitle" select="'-'" />
  <xsl:param name="recursive" select="'-'" />
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'standard'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="topicLabel">LABEL</xsl:param>
  <xsl:param name="topicIdent">/.../</xsl:param>
  <xsl:param name="paraStyle">standard</xsl:param>
  <xsl:param name="style_dt">standard_dtT</xsl:param>
  <xsl:param name="paraStyle_li">standard_li</xsl:param>
  <xsl:param name="paraStyle_tdli">standard_tdli</xsl:param>
  <xsl:param name="paraStyle_td">standard_td</xsl:param>
  <xsl:param name="paraStyle_th">standard_th</xsl:param>
  <xsl:param name="listStyle">listStandard</xsl:param>
  <xsl:param name="cellHeadStyle">tableHeadStanard</xsl:param>
  <xsl:param name="cellStyle">tableCellStandard</xsl:param>
  <xhtml:body>
    <!-- The $columns contains element <column name=""> for each column -->
    <xsl:variable name="columns">
      <xsl:for-each select="node[@TEXT='&amp;TableHead']">
        <xsl:for-each select="node">
          <column name="{@TEXT}" />
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>
    <!-- TEST --><!-- xhtml:p><xsl:for-each select="$columns/column"><xsl:value-of select="@name" />, </xsl:for-each></xhtml:p -->
    <xhtml:table border="2">
      <!-- The head row: -->
      <xhtml:tr>
        <xsl:for-each select="node[@TEXT='&amp;TableHead']">
          <xsl:for-each select="node">
            <xhtml:th expandWikistyle="true"><xsl:value-of select="node/@TEXT" /></xhtml:th>
          </xsl:for-each>
        </xsl:for-each>
      </xhtml:tr>
      <xsl:for-each select="node[starts-with(@TEXT,'-')]"><!-- any row-->
        <xsl:variable name="rowdata" select="." /><!-- reference to row data -->
        
        <!-- show whole text of the row if exists: -->
        <xsl:for-each select="node[@TEXT='&amp;']">
          <xhtml:tr><xhtml:td colspan="3" expandWikistyle="true"><xsl:value-of select="node/@TEXT" /></xhtml:td></xhtml:tr>
        </xsl:for-each>
        
        <!-- show cells of the row. The cells are selected by identifier defined in the TableHead node.-->
        <xhtml:tr>
          <xsl:for-each select="$columns/column"><!-- use the names stored in $columns -->
            <xsl:variable name="column" select="@name"/><!-- identifier of the column, defined in &amp;TableHead -->
            <!-- the cell: -->
            <xhtml:td expandWikistyle="true">
              <xsl:value-of select="$rowdata/node[@TEXT=$column]/node/@TEXT"/><!-- select text of the node with cell ident-->
              <!-- show error with cell identifier, if no cell with the requested name is found. Its a debug helpness -->
              <xsl:if test="not($rowdata/node[@TEXT=$column])"><xsl:text>??</xsl:text><xsl:value-of select="$column"/><xsl:text>??</xsl:text></xsl:if>
            </xhtml:td> 
          </xsl:for-each>
        </xhtml:tr>
      </xsl:for-each>
    </xhtml:table>
  </xhtml:body>
  </xsl:template>




</xsl:stylesheet>
