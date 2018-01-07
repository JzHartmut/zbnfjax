<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:topics="http://www.vishia.de/2006/Topics"
  xmlns:pre="http://www.vishia.de/2006/XhtmlPre"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
  <xsl:output method="html" encoding="iso-8859-1"/>

  <xs:annotation><xs:documentation type="versions">
    This file is included in all xsl files which proceeded a xml file based on xschema texttopic.xsd.
    Date       Who      Description of changing
    2005-12-14 hartmutS Initial-Revision
    2005-12-16 hartmutS chapterlevel as paramter for topic etc removed, not necessary because the realisation of the
                        chapter-nesting is done by PreHtml.xsl respective PreWord.xsl.
    2006-02-23 hartmutS changing of using of style.
    2006-02-25 hartmutS consequently selecting from child elements, no &lt;apply-templates />, always &lt;apply-templates select="..."/>
  </xs:documentation></xs:annotation>


  <!-- ................................................................................................. -->
  <!-- template to transform from topics or other xhtml-like xml-files into a PreHtml-Format ........... -->
  <!-- This script may be included in a user xsl-script. -->
  <!-- The input format may be matched to the TextTopic.xsd-schema,
       but may have some other things appropriately to the wrapping user script. -->
  <!-- The outputted format is matched to the PreHtml.xsd-schema -->

  <!-- xsl:template match="topics:topic" -->
  <xsl:template name="TextTopic">
  <xsl:param name="withTitle" select="'-'" />
  <xsl:param name="recursive" select="'-'" />
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'stdTable'" />

  <xsl:param name="topicLabel">LABEL</xsl:param>
  <xsl:param name="topicIdent">/.../</xsl:param>

    <xsl:variable name="topicLabelNew"><xsl:value-of select='$topicLabel'/>.<xsl:value-of select="@ident"/></xsl:variable>
    <xsl:variable name="topicIdentnew"><xsl:value-of select="$topicIdent"/>/<xsl:value-of select="@ident"/></xsl:variable>

    <xsl:choose>
    <!-- xsl:when test="count(@title)>0 and string-length(@title)&gt;0" -->
    <xsl:when test="$withTitle='true'">
      <!-- produce only a nested chapter if an attribute title is present -->
      <pre:chapter>
        <!-- anchor for hyperlink navigation: -->
        <xsl:if test="count(@label)>0">
          <xsl:variable name="topicLabelLocal">Topic:<xsl:value-of select='@label'/></xsl:variable>
          <anchor label="{$topicLabelLocal}"/>
        </xsl:if>
        <xsl:if test="count(./@label)=0">
          <anchor label="{$topicLabelNew}"/>
        </xsl:if>

        <pre:title><xsl:value-of select="@title"/></pre:title>
        <xsl:if test="count(@defineUnit)>0"><!-- topic with an attribute define is a define unit with references. -->
          <content>
            <!-- topic is a design element -->
            <table breakPage="noBreakAfter" border="1" width="100%">
              <tr><td><xsl:value-of select="@defineUnit"/></td></tr>
              <xsl:for-each select="tag[@name='ReqRef']">
                <xsl:variable name="reqAnchor">#<xsl:value-of select="@value"/></xsl:variable>
                <xsl:variable name="REQ"><xsl:value-of select="@value"/></xsl:variable>
                <xsl:variable name="reqElement" select="/root/Requirements/Requirement[@Ident=$REQ] | /root/SwComponententSpec/NewRequirements/Requirement[@Ident=$REQ]"/>
                <tr><td>
                  <a href="{$reqAnchor}"><xsl:value-of select="$REQ"/> :
                  <xsl:value-of select="$reqElement/Titel"/></a>
                  <xsl:if test="count($reqElement/phase)>0"><i> (<xsl:value-of select="$reqElement/phase"/>)</i></xsl:if>
                </td></tr>
              </xsl:for-each>
            </table>
          </content>
        </xsl:if>
        <xsl:call-template name="topicIntern" ><!-- does a recursion in sup topics -->
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
          <xsl:with-param name="recursive"  select="$recursive" />
        
          <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabelNew'/></xsl:with-param>
          <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdentnew'/></xsl:with-param>
        </xsl:call-template>
      </pre:chapter>

    </xsl:when>
    <xsl:otherwise>
      <!-- no @title, no own pre:chapter -->

      <!-- anchor for hyperlink navigation: -->
      <xsl:if test="count(@label)>0">
        <xsl:variable name="topicLabelLocal">Topic:<xsl:value-of select='@label'/></xsl:variable>
        <anchor label="{$topicLabelLocal}"/>
      </xsl:if>
      <xsl:if test="count(./@label)=0">
        <anchor label="{$topicLabelNew}"/>
      </xsl:if>

      <xsl:call-template name="topicIntern" ><!-- does a recursion in sup topics -->
        <xsl:with-param name="divStyle"   select="$divStyle" />
        <xsl:with-param name="pStyle"     select="$pStyle" />
        <xsl:with-param name="ulStyle"    select="$ulStyle" />
        <xsl:with-param name="olStyle"    select="$olStyle" />
        <xsl:with-param name="dlStyle"    select="$dlStyle" />
        <xsl:with-param name="tableStyle" select="$tableStyle" />
        <xsl:with-param name="recursive"  select="$recursive" />
      
        <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabelNew'/></xsl:with-param>
        <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdentnew'/></xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:template>



  <xsl:template name="topicIntern">
  <!-- actual element is either xhtml:body or topics:topic -->
  <xsl:param name="recursive" select="'-'" />
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="topicLabel">NO_REFLABEL_ONCALL</xsl:param>
  <xsl:param name="topicIdent">/i/</xsl:param>


    <xsl:if test='$testOutput&gt;2'>
      <testOutput level="3">[
        <xsl:if test="count(./@label)>0">Label:<xsl:value-of select='@label'/> Path:</xsl:if>
        <xsl:value-of select='$topicLabel' />]
      </testOutput>
    </xsl:if>

    <xsl:if test='$testOutput&gt;1'>
      <testOutput level="2">Topic:[<xsl:value-of select="$topicIdent" />]
        <xsl:if test="count(./@date)>0"> Last changed:<xsl:value-of select="./@date" /> </xsl:if>
      </testOutput>
    </xsl:if>

    <xsl:for-each select="xhtml:body"><!-- topics:topic contains xhtml:body or topics:topic. --> 
      <xsl:call-template name="topicContent"><!-- may be specified by user -->
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
        <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabel'/></xsl:with-param>
        <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdent'/></xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:if test="$recursive='true'" >
    <!-- sub pre:chapter or additinal content after the content at the own level -->
      <xsl:for-each select="topics:topic" >
        <xsl:call-template name="TextTopic">
            <xsl:with-param name="recursive"  select="$recursive" />
            <xsl:with-param name="withTitle"  select="'true'" />
            <xsl:with-param name="divStyle"   select="$divStyle" />
            <xsl:with-param name="pStyle"     select="$pStyle" />
            <xsl:with-param name="ulStyle"    select="$ulStyle" />
            <xsl:with-param name="olStyle"    select="$olStyle" />
            <xsl:with-param name="dlStyle"    select="$dlStyle" />
            <xsl:with-param name="tableStyle" select="$tableStyle" />
          
          <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabel'/></xsl:with-param>
          <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdent'/></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

                              
  <xsl:template name="assembleTopicAnchor">
  <!-- assembles the ident of all topics to root level in Form ".parent.child.child"
       therefore first a recursive call to parent will be done, after them the own ident will be added.
    -->    
    <xsl:if test="local-name(..)='topic'">
      <xsl:for-each select=".."><xsl:call-template name="assembleTopicAnchor" /></xsl:for-each>
    </xsl:if>      
    <xsl:text>.</xsl:text><xsl:value-of select="@ident" />  
  </xsl:template>
                              
                              
                              


  <xsl:template name="topicContent">
  <!-- this template method may be overloaded by a user specification if the user will shown its tag content
       in a special form. At example it is possible to show at first special tags via select="tag[@name='NAME']"
       and to show other tags inside text, via select="text|tag[@name='OTHERNAME']"
       In the standard specification all text and tag parts are converted in its common order.
  -->
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="topicLabel">NO_REFLABEL_ONCALL</xsl:param>
  <xsl:param name="topicIdent">/c/</xsl:param>
    <!-- xsl:if test="boolean(xhtml:body)>0" -->
    
    <xsl:if test="local-name()='body'">
      <xsl:variable name="topicId"><xsl:text>Topic</xsl:text><xsl:call-template name="assembleTopicAnchor" /></xsl:variable>
        <!-- xsl:apply-templates select="xhtml:body" -->
        <xsl:apply-templates select="." >
          <xsl:with-param name="id"         select="$topicId" />
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
          <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabel'/></xsl:with-param>
          <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdent'/></xsl:with-param>
        </xsl:apply-templates>

    </xsl:if>

  </xsl:template>



  <xsl:template match="tag">
  <!-- show a tag in topics in a universal form -->

    <!-- p><u>Tag:<xsl:value-of select="@name"/></u>=<xsl:value-of select="@value"/></p -->
  </xsl:template>








  <xsl:template match="xhtml:body">
  <xsl:param name="id" select="'-'" />
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="topicLabel">NO_REFLABEL_ONCALL</xsl:param>
  <xsl:param name="topicIdent">/b/</xsl:param>
    <xhtml:body>
      <xsl:if test="$id!='-'"><xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute></xsl:if>
      <xsl:if test="$divStyle!='-'"><xsl:attribute name="class"><xsl:value-of select="$divStyle" /></xsl:attribute></xsl:if>
      <xsl:if test="name(..)='topics:topic'">
        <xhtml:p class="debug"><xsl:text>Topic:</xsl:text><xsl:call-template name="assembleTopicAnchor" /></xhtml:p>
      </xsl:if>
      <xsl:if test="count(../@date)>0">
        <xhtml:p>Last changed: <xsl:value-of select="../@date" /></xhtml:p>
      </xsl:if>

      <xsl:if test="count(../@obsolete)>0">
        <xhtml:p>Obsolte: <xsl:value-of select="../@obsolete" /></xhtml:p>
      </xsl:if>


      <!-- xhtml:p class="debug">
     
        <xsl:if test="$divStyle!='-'"><xsl:text> divStyle=</xsl:text><xsl:value-of select="$divStyle"/></xsl:if>
        <xsl:if test="$pStyle!='-'"><xsl:text> pStyle=</xsl:text><xsl:value-of select="$pStyle"/></xsl:if>
        <xsl:if test="$ulStyle!='-'"><xsl:text> ulStyle=</xsl:text><xsl:value-of select="$ulStyle"/></xsl:if>
        <xsl:if test="$olStyle!='-'"><xsl:text> olStyle=</xsl:text><xsl:value-of select="$olStyle"/></xsl:if>
        <xsl:if test="$dlStyle!='-'"><xsl:text> dlStyle=</xsl:text><xsl:value-of select="$dlStyle"/></xsl:if>
        <xsl:if test="$tableStyle!='-'"><xsl:text> tableStyle=</xsl:text><xsl:value-of select="$tableStyle"/></xsl:if>
      </xhtml:p -->
      <xsl:apply-templates >
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
        <xsl:with-param name="topicLabel"><xsl:value-of select='$topicLabel'/></xsl:with-param>
        <xsl:with-param name="topicIdent"><xsl:value-of select='$topicIdent'/></xsl:with-param>
      </xsl:apply-templates>
    </xhtml:body>

  </xsl:template>











  <!-- common templates for current text *********************************************** -->

  <xsl:template match="docuLink"><xsl:copy-of select="." /></xsl:template>

  <xsl:template match="picture">
    <img src="{@file}">
      <xsl:if test="count(@height)>0"><xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute></xsl:if>
      <xsl:if test="count(@width)>0"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
      <xsl:if test="count(@align)>0"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
      <xsl:if test="count(@title)>0"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if>
      <xsl:if test="following-sibling::*[1]/@name='picture'"><xsl:attribute name="title"><xsl:value-of select="following-sibling::*[1]/@value"/></xsl:attribute></xsl:if>
    </img>
  </xsl:template>

  <xsl:template match="xhtml:img">
    <xhtml:img src="{@src}">
      <xsl:if test="count(@height)>0"><xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute></xsl:if>
      <xsl:if test="count(@width)>0"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
      <xsl:if test="count(@align)>0"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
      <xsl:if test="count(@title)>0"><xsl:attribute name="title"><xsl:value-of select="@title"/></xsl:attribute></xsl:if>
      <xsl:if test="following-sibling::*[1]/@name='picture'"><xsl:attribute name="title"><xsl:value-of select="following-sibling::*[1]/@value"/></xsl:attribute></xsl:if>
    </xhtml:img>
  </xsl:template>

  <xsl:template match="textfile">
    <table border="0"><tr><td bgcolor="#e0e0e0">
      <xsl:copy-of select="." />
    </td></tr></table>
  </xsl:template>

  <!-- Converts an input xhtml:p to xhtml:p for output. The content is copied, but the class for style is procesed: 
       * If a style is given in input (@class), it is used.
       * Else If a pStyle is given from calling level, it is used.
       * default: std is set.
    -->
  <xsl:template match="xhtml:p">
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="paraStyle">std</xsl:param>
    <xsl:variable name="style">
      <xsl:choose><xsl:when test="count(@class)>0 and @class!='-'"><xsl:value-of select="@class"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$pStyle"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose><xsl:when test="@class='inset'">
      <xsl:variable name="label" select="@title" />
      <xhtml:p>(p-INSET:<xsl:value-of select="$label" />)</xhtml:p>
      <!-- The value of the chapter with the title like the inset label is used as content of the inset. -->
      <xsl:if test="not(/root/pre:Chapters[@title='inset']/pre:chapter[pre:title=$label])">
        <xhtml:p class="error-inset">Error inset not found: <xsl:value-of select="$label" />.</xhtml:p>
      </xsl:if>
      <xsl:copy-of select="/root/pre:Chapters[@title='inset']/pre:chapter[pre:title=$label]/xhtml:body/*" />
    </xsl:when><xsl:otherwise>
      <xhtml:p class="{$style}"><xsl:apply-templates select="text()|xhtml:b|xhtml:i|xhtml:stroke|xhtml:em|xhtml:u|xhtml:br|xhtml:code|xhtml:span|xhtml:font|xhtml:a|xhtml:img" /></xhtml:p>
    </xsl:otherwise></xsl:choose>
  </xsl:template>


  <!-- ********************************************************************************************* -->
  <!-- ********************************************************************************************* -->
  <!-- *********** Standard-conversion of a definition list ********************** -->

  <xsl:template match="xhtml:dl">
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="style_dl">standard_dl</xsl:param>
    <xhtml:dl class="{$dlStyle}">
      <xsl:apply-templates select="xhtml:dt|xhtml:dd" >
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
      </xsl:apply-templates>
    </xhtml:dl>
  </xsl:template>




  <xsl:template match="xhtml:dt">
  <xsl:param name="dlStyle">std_dl</xsl:param>
    <xsl:variable name="style">
      <xsl:choose><xsl:when test="count(@class)>0"><xsl:value-of select="@class"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$dlStyle"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xhtml:dt class="{$style}">
      <xsl:apply-templates select="text()|xhtml:b|xhtml:i|xhtml:stroke|xhtml:em|xhtml:u|xhtml:br|xhtml:code|xhtml:span|xhtml:font|xhtml:a" />
    </xhtml:dt>
  </xsl:template>


  <xsl:template match="xhtml:dd">
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

    <xhtml:dd class="{$dlStyle}{'_dd'}">
      <xsl:apply-templates>
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
      </xsl:apply-templates>
    </xhtml:dd>
  </xsl:template>






  <xsl:template match="xhtml:br">
    <br/>
  </xsl:template>



  <xsl:template match="xhtml:i"><xhtml:i><xsl:apply-templates /></xhtml:i></xsl:template>
  <xsl:template match="xhtml:u"><xhtml:u><xsl:apply-templates /></xhtml:u></xsl:template>
  <xsl:template match="xhtml:b"><xhtml:b><xsl:apply-templates /></xhtml:b></xsl:template>
  <xsl:template match="xhtml:stroke"><xhtml:stroke><xsl:apply-templates /></xhtml:stroke></xsl:template>
  <xsl:template match="xhtml:em"><xhtml:em><xsl:apply-templates /></xhtml:em></xsl:template>
  <xsl:template match="xhtml:code"><xhtml:code><xsl:apply-templates /></xhtml:code></xsl:template>

  <xsl:template match="xhtml:xxpre">
    <xhtml:table border="0"><xhtml:tr><xhtml:td bgcolor="#FFFFa0">
      <xsl:copy-of select="." />
    </xhtml:td></xhtml:tr></xhtml:table>
  </xsl:template>

  <xsl:template match="xhtml:pre">
    <xsl:copy-of select="." />
  </xsl:template>


  <xsl:template match="xhtml:span">
    <xsl:choose><xsl:when test="@class='xxxinset'">
      <xsl:variable name="insetTopic" select="/root/GenCtrl/document/inset/topic/@select" />
      <xhtml:u>(INSET:<xsl:value-of select="$insetTopic" />
          <xsl:for-each select="/root/Topics">
              <xsl:call-template name="selectInset">
                <xsl:with-param name="select" select="$insetTopic" />
          </xsl:call-template>
          </xsl:for-each>
      </xhtml:u>
    </xsl:when><xsl:when test="@class='inset'">
      <xsl:variable name="xxxinsetTopic" select="/root/GenCtrl/document/inset/topic/@select" />
      <xsl:variable name="label" select="@title" />
      <xhtml:u>(INSET:<xsl:value-of select="$label" />)</xhtml:u>
      <!-- The value of the chapter with the title like the inset label is used as content of the inset. -->
      <xsl:copy-of select="/root/pre:Chapters[@title='inset']/*" />
      <xhtml:u>xxxxx</xhtml:u>
      <xsl:copy-of select="/root/pre:Chapters[@title='inset']/pre:chapter/*" />
      <xhtml:u>xxxxx1</xhtml:u>
      <xsl:copy-of select="/root/pre:Chapters[@title='inset']/pre:chapter[pre:title=$label]/*" />
      <xhtml:u>xxxxx2</xhtml:u>
      <xsl:copy-of select="/root/pre:Chapters[@title='inset']/pre:chapter[pre:title=$label]/xhtml:body/*" />
      <xhtml:u>xxxxx3</xhtml:u>
      <xsl:value-of select="/root/pre:Chapters[@title='inset']/pre:chapter[pre:title=$label]/xhtml:body/xhtml:p" />
    </xsl:when><xsl:otherwise>
      <xhtml:span class="{@class}">
        <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute></xsl:if>
		    <xsl:apply-templates />
		  </xhtml:span>
	  </xsl:otherwise></xsl:choose>
  </xsl:template>



  <xsl:template name="selectInset">
	<xsl:param name="select" />
	  <xsl:variable name="select1" select="substring-before($select,'/')" />
	  <xsl:value-of select="$select1" /><xsl:text>:</xsl:text>
		<xsl:choose><xsl:when test="string-length($select1)>0">
      <xsl:for-each select="topics:topic[@ident=$select1]">
			  <xsl:call-template name="selectInset">
				  <xsl:with-param name="select" select="substring-after($select,'/')" />
			  </xsl:call-template>
			</xsl:for-each>  
	  </xsl:when><xsl:otherwise>
      <xsl:for-each select="topics:topic[@ident=$select]/xhtml:body/xhtml:p">
  	    <xsl:apply-templates select="text()|*" />
      </xsl:for-each>
		</xsl:otherwise></xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:ul">
  <xsl:param name="divStyle" select="'std'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'std'" />
  <xsl:param name="olStyle" select="'std'" />
  <xsl:param name="dlStyle" select="'std'" />
  <xsl:param name="tableStyle" select="'stdTable'" />

    <xsl:variable name="style">
      <xsl:choose><xsl:when test="$ulStyle!='-'"><xsl:value-of select="$ulStyle"/></xsl:when>
      <xsl:when test="count(@class)>0 and @class!='-'"><xsl:value-of select="@class"/></xsl:when>
      <xsl:otherwise>std</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xhtml:ul class="{$style}">
      <!-- xsl:apply-templates select="li" ><xsl:with-param name="listStyle">listIntern</xsl:with-param></xsl:apply-templates -->
      <xsl:apply-templates select="xhtml:li" >
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
      </xsl:apply-templates>
    </xhtml:ul>
  </xsl:template>



  <xsl:template match="xhtml:li">
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

    <xhtml:li>
      <xsl:if test="string-length(normalize-space(text()))>0">
        <!-- if the li contents direct formated or non formated text, a p-tag will set arround. -->
        <p class="{$pStyle}"><!-- paragraph in list with paraStyle_li! -->
          <xsl:apply-templates  select="text()|xhtml:b|xhtml:i|xhtml:stroke|xhtml:em|xhtml:u|xhtml:br|xhtml:code|xhtml:font|xhtml:a">
          </xsl:apply-templates>
        </p>
      </xsl:if>
      <xsl:apply-templates select="xhtml:p|xhtml:ul|xhtml:ol|xhtml:dl|xhtml:table|xhtml:img|xhtml:pre">
          <xsl:with-param name="pStyle"    select="$pStyle" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
      </xsl:apply-templates>
    </xhtml:li>
  </xsl:template>






  <!-- ********************************************************************************************* -->
  <!-- ********************************************************************************************* -->
  <!-- *********** Standard-Konvertierung einer table mit tabhead und tabline ********************** -->

  <xsl:template match="xhtml:table">
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="pStyle_th" select="'std_th'" />
  <xsl:param name="pStyle_td" select="'std_td'" />
  <xsl:param name="pStyle_tdli" select="'std_tdli'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="paraStyle_tdli">std_litd</xsl:param>
  <xsl:param name="paraStyle_td">std_td</xsl:param>
  <xsl:param name="paraStyle_th">std_th</xsl:param>
  <xsl:param name="listStyle">listStandard</xsl:param>
  <xsl:param name="cellHeadStyle">tableHeadStanard</xsl:param>
  <xsl:param name="cellStyle">tableCellStandard</xsl:param>
    <xsl:if test="count(@title)>0">
      <!-- p xml:space="preserve" --><p><b>Tabelle:</b> <xsl:value-of select="@title"/></p>
    </xsl:if>
    <xsl:variable name="style">
      <xsl:choose><xsl:when test="$tableStyle!='-'"><xsl:value-of select="$tableStyle"/></xsl:when>
      <xsl:when test="count(@class)>0 and @class!='-'"><xsl:value-of select="@class"/></xsl:when>
      <xsl:otherwise>tabStandard</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xhtml:table class="{$style}">
      <xsl:apply-templates select="xhtml:tr" >
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="pStyle_td"     select="$pStyle_td" />
          <xsl:with-param name="pStyle_th"     select="$pStyle_th" />
          <xsl:with-param name="pStyle_tdli"   select="$pStyle_tdli" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
        <xsl:with-param name="paraStyle" select="$paraStyle_td"/><!-- paragraph in table with paraStyle_td! -->
        <xsl:with-param name="listStyle" select="$listStyle"/>
        <xsl:with-param name="cellHeadStyle" select="$cellHeadStyle"/>
        <xsl:with-param name="cellStyle" select="$cellStyle"/>
      </xsl:apply-templates>
    </xhtml:table>
  </xsl:template>






  <xsl:template match="xhtml:tr">
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="pStyle_th" select="'std_th'" />
  <xsl:param name="pStyle_td" select="'std_td'" />
  <xsl:param name="pStyle_tdli" select="'std_tdli'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="paraStyle_tdli">std_litd</xsl:param>
  <xsl:param name="paraStyle_td">std_td</xsl:param>
  <xsl:param name="paraStyle_th">std_th</xsl:param>
  <xsl:param name="listStyle">listStandard</xsl:param>
  <xsl:param name="cellHeadStyle">tableHeadStanard</xsl:param>
  <xsl:param name="cellStyle">tableCellStandard</xsl:param>
    <xhtml:tr>
      <xsl:apply-templates select="xhtml:th|xhtml:td" >
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle" />
          <xsl:with-param name="pStyle_td"     select="$pStyle_td" />
          <xsl:with-param name="pStyle_th"     select="$pStyle_th" />
          <xsl:with-param name="pStyle_tdli"   select="$pStyle_tdli" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
        <xsl:with-param name="paraStyle_th" select="$paraStyle_th"/>
        <xsl:with-param name="paraStyle_td" select="$paraStyle_td"/>
        <xsl:with-param name="paraStyle_tdli" select="$paraStyle_tdli"/>
        <xsl:with-param name="listStyle" select="$listStyle"/>
        <xsl:with-param name="cellHeadStyle" select="$cellHeadStyle"/>
        <xsl:with-param name="cellStyle" select="$cellStyle"/>
      </xsl:apply-templates>
    </xhtml:tr>
  </xsl:template>







  <xsl:template match="xhtml:th">
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="pStyle_th" select="'std_th'" />
  <xsl:param name="pStyle_td" select="'std_td'" />
  <xsl:param name="pStyle_tdli" select="'std_td'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="paraStyle_tdli">std_td</xsl:param>
  <xsl:param name="paraStyle_td">std_td</xsl:param>
  <xsl:param name="paraStyle_th">std_th</xsl:param>
  <xsl:param name="listStyle">listStandard</xsl:param>
  <xsl:param name="cellHeadStyle">tableHeadStanard</xsl:param>
  <xsl:param name="cellStyle">tableCellStandard</xsl:param>
    <xhtml:td class="{$tableStyle}{'_td'}">
      <xsl:apply-templates>
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle_td" /><!-- the normal para style is now pStyle_td, first table level. -->
          <xsl:with-param name="pStyle_td"     select="$pStyle_td" />
          <xsl:with-param name="pStyle_th"     select="$pStyle_th" />
          <xsl:with-param name="pStyle_tdli"   select="$pStyle_tdli" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
        <xsl:with-param name="paraStyle" select="$paraStyle_th"/><!-- paragraph in table head with paraStyle_th! -->
        <xsl:with-param name="paraStyle_th" select="$paraStyle_th"/>
        <xsl:with-param name="paraStyle_td" select="$paraStyle_td"/>
        <xsl:with-param name="paraStyle_tdli" select="$paraStyle_tdli"/>
        <xsl:with-param name="listStyle" select="$listStyle"/>
        <xsl:with-param name="cellHeadStyle" select="$cellHeadStyle"/>
        <xsl:with-param name="cellStyle" select="$cellStyle"/>
      </xsl:apply-templates>
    </xhtml:td>
  </xsl:template>



  <xsl:template match="xhtml:td">
  <xsl:param name="divStyle" select="'-'" />
  <xsl:param name="pStyle" select="'std'" />
  <xsl:param name="pStyle_td" select="'std_td'" />
  <xsl:param name="pStyle_th" select="'std_th'" />
  <xsl:param name="pStyle_tdli" select="'std_th'" />
  <xsl:param name="ulStyle" select="'-'" />
  <xsl:param name="olStyle" select="'-'" />
  <xsl:param name="dlStyle" select="'-'" />
  <xsl:param name="tableStyle" select="'-'" />

  <xsl:param name="paraStyle_tdli">std_td</xsl:param>
  <xsl:param name="paraStyle_td">std_td</xsl:param>
  <xsl:param name="paraStyle_th">std_th</xsl:param>
  <xsl:param name="listStyle">listStandard</xsl:param>
  <xsl:param name="cellHeadStyle">tableHeadStanard</xsl:param>
  <xsl:param name="cellStyle">tableCellStandard</xsl:param>
    <xhtml:td class="{$tableStyle}{'_td'}">
      <xsl:apply-templates>
          <xsl:with-param name="divStyle"   select="$divStyle" />
          <xsl:with-param name="pStyle"     select="$pStyle_td" /><!-- the normal para style is now pStyle_td, first table level. -->
          <xsl:with-param name="pStyle_td"     select="$pStyle_td" />
          <xsl:with-param name="pStyle_th"     select="$pStyle_th" />
          <xsl:with-param name="pStyle_tdli"   select="$pStyle_tdli" />
          <xsl:with-param name="ulStyle"    select="$ulStyle" />
          <xsl:with-param name="olStyle"    select="$olStyle" />
          <xsl:with-param name="dlStyle"    select="$dlStyle" />
          <xsl:with-param name="tableStyle" select="$tableStyle" />
        
        <xsl:with-param name="paraStyle" select="$paraStyle_td"/><!-- paragraph in table cell with paraStyle_td! -->
        <xsl:with-param name="paraStyle_th" select="$paraStyle_th"/>
        <xsl:with-param name="paraStyle_td" select="$paraStyle_td"/>
        <xsl:with-param name="paraStyle_tdli" select="$paraStyle_tdli"/>
        <xsl:with-param name="listStyle" select="$listStyle"/>
        <xsl:with-param name="cellHeadStyle" select="$cellHeadStyle"/>
        <xsl:with-param name="cellStyle" select="$cellStyle"/>
      </xsl:apply-templates>
    </xhtml:td>
  </xsl:template>





  <!-- ********************************************************************************************* -->
  <!-- ********************************************************************************************* -->
  <!-- Alles für Querverweise und Literaturangaben :diesen Kommentar stehenlassen für Dokugenerierung! -->

  <xsl:template match="a"><!-- html-like anchor -->
    <xsl:message>invalid element &lt;a> </xsl:message>
    <xsl:if test="count(@href)>0 and starts-with(@href,'#')">
      <xsl:variable name="label"><xsl:value-of select="substring(@href,2)"/></xsl:variable><!-- label without the # ! -->
      <internref label="{$label}"><xsl:apply-templates/></internref>
    </xsl:if>
    <xsl:if test="count(@href)>0 and not(starts-with(@href,'#'))">
      <fileref name="{@href}"><xsl:apply-templates/></fileref>
    </xsl:if>
    <xsl:if test="count(@name)>0">
      <anchor label="{@name}"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:xxxa">
    <xsl:if test="count(@href)>0 and starts-with(@href,'#')">
      <xsl:variable name="label"><xsl:value-of select="substring(@href,2)"/></xsl:variable><!-- label without the # ! -->
      <internref label="{$label}"><xsl:apply-templates/></internref>
    </xsl:if>
    <xsl:if test="count(@href)>0 and not(starts-with(@href,'#'))">
      <fileref name="{@href}"><xsl:apply-templates/></fileref>
    </xsl:if>
    <xsl:if test="count(@name)>0">
      <anchor label="{@name}"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="xhtml:a">
    <xhtml:a href="{@href}"><xsl:apply-templates/></xhtml:a>
  </xsl:template>

  <xsl:template match="fileref">
  <!-- a fileref is a hyperlink to a external file. -->
    <fileref name="{@name}"><xsl:apply-templates/></fileref>
  </xsl:template>

  <xsl:template match="internref">
  <!-- a internref is a hyperlink to a label. -->
    <internref label="{@label}"><xsl:apply-templates/></internref>
  </xsl:template>





</xsl:stylesheet>
