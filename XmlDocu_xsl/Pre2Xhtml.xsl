<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs ="http://www.w3.org/2001/XMLSchema"
  xmlns:pre="http://www.vishia.de/2006/XhtmlPre"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
  <xsl:output method="html" encoding="iso-8859-1"/>

  <xs:annotation><xs:documentation>
    Datum      Wer      Beschreibung der Änderung
    2006-07-18 hartmutS anchor not only at start of chapter, also inside.
    2005-12-14 hartmutS Initial-Revision

  </xs:documentation></xs:annotation>

  <xsl:variable name="testOutput">0</xsl:variable>
  
  <xsl:param name="cssHtml">htmlstd.css</xsl:param>

  <!-- xsl:preserve-space elements="p" / -->

  <xsl:template match="/">
    <html test_rootname="{local-name(*)}"><!-- test1 to test the name of the root element. -->
      <xsl:apply-templates select="root|pre:Chapters" />
      <xsl:if test="not(root/pre:Chapters | pre:Chapters)">
        <head></head>
        <body><p><xsl:text>Error no input Xml-Docs found using Pre2Xhtml.xsl.</xsl:text></p></body>
      </xsl:if>
    </html>
  </xsl:template>

  <xsl:template match="root">
    <!-- test_root /-->
    <xsl:for-each select="*">
      <test_inputXmlRoot name="local-name(.)" /> 
    </xsl:for-each>
    <xsl:apply-templates select="pre:Chapters" />
  </xsl:template>

  <xsl:template match= "pre:Chapters">
    <head>
      <!-- title><xsl:value-of select="pre:Chapters/@title" /></title -->
      <title><xsl:value-of select="@title" /></title>
      <link rel="stylesheet" type="text/css" href="{$cssHtml}" />
      <!-- xsl:copy-of select="/root/style" / --><!-- copy the css-style-definitions -->
    </head>
    <body>
      <h1><xsl:value-of select="@title"/></h1><!-- The title of the whole html document. -->
      <xsl:call-template name="directory" />
      <hr />
      <xsl:apply-templates select="xhtml:body" /><!-- any paragraphs before the first chapter. -->
      <xsl:for-each select="pre:chapter">
        <xsl:apply-templates select="."><!-- the pre:chapter -->
          <xsl:with-param name="chapterNr">
            <xsl:value-of select="position()"/>
          </xsl:with-param>
          <xsl:with-param name="chapterLevel" select="2" />
          <!-- nested chapters are called recursively. -->
        </xsl:apply-templates>
      </xsl:for-each>
    </body>
  </xsl:template>


  <xsl:template name="directory">
    <p class="standard"><font size="+1"><u>Inhalt</u></font></p>
    <xsl:call-template name="directory-intern">
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="directory-intern">
  <xsl:param name="chapterNr"/>
    <xsl:if test="count(pre:chapter)>0">
      <ul>
        <xsl:for-each select="pre:chapter">
          <xsl:variable name="chapterNr1">
            <xsl:value-of select="$chapterNr"/><!-- empty on h1-level, end with dot on deeper level -->
            <xsl:value-of select="position()"/>
          </xsl:variable>
          <xsl:variable name="label">#chapter_<xsl:value-of select="$chapterNr1"/></xsl:variable>
          <li><a href="{$label}"><xsl:value-of select="$chapterNr1"/><xsl:text> </xsl:text><xsl:value-of select="pre:title"/></a></li>

          <!-- recursive call of nested chapters if present-->
          <xsl:call-template name="directory-intern">
            <xsl:with-param name="chapterNr"><xsl:value-of select="$chapterNr1"/><xsl:text>.</xsl:text></xsl:with-param>
          </xsl:call-template>

        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>





  <!-- write one chapter with its title and content and nested chapters. -->
  <xsl:template match="pre:chapter">
  <xsl:param name="chapterLevel">-</xsl:param>
  <xsl:param name="chapterNr"></xsl:param>

    <xsl:if test="@breakPage='before'">
      <hr/><hr/><hr/><!-- breakpage shown as 3 horizontal lines -->
    </xsl:if>

    <!-- set an anchor for navigation from generated directory, style: <a name="chapter_3.2.1"/> -->
    <xsl:variable name="label">chapter_<xsl:value-of select="$chapterNr"/></xsl:variable>
    <a id="{generate-id()}" name="{$label}"/>
    
    <xsl:variable name="labela"><xsl:value-of select="xhtml:body/@id"/></xsl:variable>
    <a id="{$labela}" name="{$labela}" test="labela" />
    
    <xsl:if test="count(@id)>0"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <xsl:variable name="chapterId" select="@id" /><!-- may be emtpy -->
    <!-- xsl:apply-templates select="anchor"/ -->

    <!-- write the chapter title line, with the header style dependeded on the chapterLevel -->
    <xsl:variable name="hx">h<xsl:value-of select="$chapterLevel"/></xsl:variable><!-- h1, h2 etc. -->
    <xsl:element name="{$hx}">   <!-- produce h1, h2 etc. -->
      <xsl:value-of select="$chapterNr"/><xsl:text> </xsl:text><!-- numbering of the chapter on title -->
      <!-- TODO: xsl:attribute doesn't work in this context, therefore a name="@id" above! -->
      <!-- xsl:if test="count(@id)>0"><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute></xsl:if -->
      <!-- NOTE also the test using chapterId fails. -->
      <!-- xsl:if test="string-length($chapterId)>0"><xsl:attribute name="id"><xsl:value-of select="$chapterId" /></xsl:attribute></xsl:if -->
      <xsl:apply-templates select="pre:title"/>
    </xsl:element>

    <!-- write the textual content of this chapter level (no yet nested chapters) -->
    <xsl:apply-templates select="xhtml:body|pre:img|img">
    </xsl:apply-templates>

    <!-- write nested chapters -->
    <xsl:for-each select="pre:chapter">
      <xsl:apply-templates select=".">
        <xsl:with-param name="chapterNr">
          <xsl:value-of select="$chapterNr"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="position()"/>
        </xsl:with-param>
        <xsl:with-param name="chapterLevel" select="number($chapterLevel+1)" />
      </xsl:apply-templates>
    </xsl:for-each>

  </xsl:template>



  <xsl:template match="xhtml:body">
    <!-- xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if -->
    <div class="{@class}">
      <!-- xsl:if test="boolean(@id)"><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute></xsl:if -->
      <xsl:apply-templates />
    </div>
    <br clear="all" /><!-- to force break if any img is above. -->
  </xsl:template>





  <xsl:template match="xhtml:div"><!-- some textual content with a section style, possible overloadable by user. -->
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <div class="{@class}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>




  <xsl:template match="xhtml:dl"><!-- some textual content with a section style, possible overloadable by user. -->
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
      <dl class="{@class}">
        <xsl:apply-templates/>
      </dl>
  </xsl:template>



  <xsl:template match="xhtml:dt"><!-- some textual content with a section style, possible overloadable by user. -->
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
      <dt class="{@class}"><!-- the style must be defined in HTML with #name -->
        <xsl:apply-templates/>
      </dt>
  </xsl:template>



  <xsl:template match="xhtml:dd"><!-- some textual content with a section style, possible overloadable by user. -->
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
      <dd  class="{@class}"><!-- the style must be defined in HTML with #name -->
        <xsl:apply-templates/>
      </dd>
  </xsl:template>




  <xsl:template match="xhtml:p">
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <p class="{@class}">
      <xsl:apply-templates select="text()|xhtml:b|xhtml:i|xhtml:stroke|xhtml:em|xhtml:u|xhtml:code|xhtml:span|xhtml:br|xhtml:a|xhtml:img"/><!-- select see PreHtml.xsd -->
    </p>
  </xsl:template>


  <xsl:template match="xhtml:span">
    <xsl:if test="text()|b|i|u|br|fileref|internref" ><!-- only if any content is found, otherwise the emtpy <span/> is destructive i html. -->
      <span class="{@class}">
        <xsl:call-template name="copyId" />
        <xsl:apply-templates select="text()|b|i|u|br|fileref|internref"/><!-- select see PreHtml.xsd -->
      </span>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:ul">
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <xsl:choose><xsl:when test="count(@class)>0">
      <ul class="{@class}">
        <xsl:apply-templates/>
      </ul>
    </xsl:when><xsl:otherwise>
      <ul><xsl:apply-templates/></ul>
    </xsl:otherwise></xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:li">
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <xsl:choose><xsl:when test="count(@class)>0">
      <li class="{@class}">
        <xsl:apply-templates/>
      </li>
    </xsl:when><xsl:otherwise>
      <li><xsl:apply-templates/></li>
    </xsl:otherwise></xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:table">
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <table class="{@class}">
      <xsl:if test="@border"><xsl:attribute name="border"><xsl:value-of select="@border" /></xsl:attribute></xsl:if>
      <xsl:apply-templates><xsl:with-param name="classTable" select="@class" /></xsl:apply-templates>
    </table>
  </xsl:template>

  <xsl:template match="xhtml:tr">
  <xsl:param name="classTable" />  
    <tr class="{$classTable}"><xsl:apply-templates><xsl:with-param name="classTable" select="$classTable" /></xsl:apply-templates></tr>
  </xsl:template>

  <xsl:template match="xhtml:th">
  <xsl:param name="classTable" />  
    <th class="{$classTable}">
      <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan" /></xsl:attribute></xsl:if>
      <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class" /></xsl:attribute></xsl:if>
      <xsl:apply-templates></xsl:apply-templates>
    </th>
  </xsl:template>

  <xsl:template match="xhtml:td">
  <xsl:param name="classTable" />  
    <td class="{$classTable}">
      <xsl:if test="@colspan"><xsl:attribute name="colspan"><xsl:value-of select="@colspan" /></xsl:attribute></xsl:if>
      <xsl:if test="@class"><xsl:attribute name="class"><xsl:value-of select="@class" /></xsl:attribute></xsl:if>
      <xsl:apply-templates></xsl:apply-templates>
    </td>
  </xsl:template>

  <xsl:template match="xhtml:pre">
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <xsl:choose><xsl:when test="count(@class)>0">
      <pre class="{@class}">
        <xsl:apply-templates/>
      </pre>
    </xsl:when><xsl:otherwise>
      <pre><xsl:apply-templates/></pre>
    </xsl:otherwise></xsl:choose>
  </xsl:template>


  <xsl:template match="xhtml:p/xhtml:xxximg">
    <!-- the tag ist the same like html, copy also all attributes! -->
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="xhtml:img|img">
    <!-- the tag ist the same like html, copy also all attributes! -->
    <xsl:if test="boolean(@id)"><a id="{generate-id()}" name="{@id}" /></xsl:if>
    <!-- xsl:copy-of select="."/ -->
    <br clear="all" /><!-- to force break if any other img is above. -->
    <a href="{@src}">
      <img src="{@src}">
        <xsl:if test="count(@height)>0"><xsl:attribute name="height"><xsl:value-of select="@height"/></xsl:attribute></xsl:if>
        <xsl:if test="count(@width)>0"><xsl:attribute name="width"><xsl:value-of select="@width"/></xsl:attribute></xsl:if>
        <xsl:if test="count(@align)>0"><xsl:attribute name="align"><xsl:value-of select="@align"/></xsl:attribute></xsl:if>
        <xsl:if test="count(@usemap)>0"><xsl:attribute name="usemap"><xsl:value-of select="@usemap"/></xsl:attribute></xsl:if>
        <xsl:if test="count(@border)>0"><xsl:attribute name="border"><xsl:value-of select="@border"/></xsl:attribute></xsl:if>
        <xsl:copy-of select="map"/><!-- if an image map exists -->
      </img>
      <xsl:if test="count(@title)>0 and @title!='.'">
        <span class="ImageTitle"><xsl:text>Bild: </xsl:text><xsl:value-of select="@title"/></span>
      </xsl:if>
    </a>
  </xsl:template>

  <xsl:template match="xhtml:anchor">
    <!-- a id="{generate-id()}" name="{@label}" / -->  <!-- do nothing, the anchor label is written already -->
  </xsl:template>

  <xsl:template match="xhtml:a">
    <xsl:if test="boolean(@href)">
      <a href="{@href}"><xsl:apply-templates/></a>
    </xsl:if>
    <xsl:if test="boolean(@name)">
      <a id="{generate-id()}" name="{@name}"><xsl:apply-templates/></a>
    </xsl:if>
  </xsl:template>

  <xsl:template match="internref">
    <xsl:variable name="label1">#<xsl:value-of select="@label"/></xsl:variable>
    <a href="{$label1}"><xsl:apply-templates/></a>
  </xsl:template>

  <xsl:template match="fileref">
  <!-- a fileref is a hyperlink to the external file. -->
    <xsl:variable name="NAME"><xsl:value-of select="translate(@name,'\','/')"/></xsl:variable>
    <a href="{$NAME}"><xsl:apply-templates/></a>
  </xsl:template>

  <xsl:template match="xhtml:i">
    <i><xsl:apply-templates/></i>
  </xsl:template>

  <xsl:template match="xhtml:em">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="xhtml:stroke">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <xsl:template match="xhtml:u">
    <u><xsl:apply-templates/></u>
  </xsl:template>

  <xsl:template match="xhtml:b">
    <b><xsl:apply-templates/></b>
  </xsl:template>

  <xsl:template match="xhtml:br">
    <br/>
  </xsl:template>

  <xsl:template match="xhtml:font">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="xhtml:code">
    <xsl:if test="count(text()|*)>0">
      <code><xsl:apply-templates/></code>
    </xsl:if>
  </xsl:template>


  <!-- xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template -->

  <xsl:template match="pre:testOutput">
    <xsl:if test="$testOutput>=@level">
      <p><xsl:apply-templates select="text()"/></p>
      <xsl:apply-templates select="*"/>
    </xsl:if>
  </xsl:template>


<xsl:template name="copyId">
  <xsl:if test="@id"><xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute></xsl:if>
</xsl:template>



</xsl:stylesheet>
