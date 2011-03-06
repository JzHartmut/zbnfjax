<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs ="http://www.w3.org/2001/XMLSchema"
  xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:w10="urn:schemas-microsoft-com:office:word"
  xmlns:aml="http://schemas.microsoft.com/aml/2001/core"
  xmlns:wx="http://schemas.microsoft.com/office/word/2003/auxHint"
  xmlns:pre="http://www.vishia.de/2006/XhtmlPre"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>
<!--
created by Hartmut Schorrig
2009-06-13 Hartmut corr xsl:template match="xhtml:p": text()[1] necessary because text() isn't a string but a tree of nodes, if it consists of some parts. 
2009-06-09 Hartmut new empty w:p with pStyle endChapter at end of each chapter to cause a vertical space to the next chapter title, but not if a new page may be used.
                   new a xhtml:p which contains only a . where suppressed.
                   new: xhtml:body id="xxx" is used as bookmark for a title of chapter! That are topic labels!
                   new: xhtml:image with pStyle Grafik
-->



  <xsl:output method="xml" encoding="UTF-8"/>

  <xs:annotation><xs:documentation>
    Data       Who      Description of changing
    2009-06-25 hartmut chg: xhtml:li doesn't use list styles in word, but a special style, and a manual bullet.
    2009-02-16 hartmut new: xhtml:em regarded
    2006-02-24 hartmut changing in using of style
    2006-02-23 hartmut consider pict widht
    2006-01-20 hartmut consider table widht
    2005-12-14 hartmut Initial-Revision

  </xs:documentation></xs:annotation>




  <!-- Festlegung der Bezeichnungen der Formatvorlagen -->
  <xsl:variable name="pStyleParagraph">Standard</xsl:variable>   <!-- normaler Absatz -->
  <xsl:variable name="pStyleTabCell">Tabelle</xsl:variable>      <!-- Zelle in einer Tabelle -->


<xsl:variable name="ListBullet0"><xsl:text>&#8226;</xsl:text></xsl:variable>
<xsl:variable name="ListBullet1"><xsl:text>&#x2022;</xsl:text></xsl:variable>
<xsl:variable name="ListBullet2"><xsl:text>&#x25e6;</xsl:text></xsl:variable>
<xsl:variable name="ListBullet3"><xsl:text>&#x25a0;</xsl:text></xsl:variable>
<xsl:variable name="ListBullet4"><xsl:text>&#x25a1;</xsl:text></xsl:variable>
<xsl:variable name="ListBullet9"><xsl:text>●</xsl:text></xsl:variable>

  <xsl:variable name="widthTable" select="5000" /><!-- what for a unit? 5000 is a good value for page width of 16 cm -->

	<xsl:template match= "/root">
    <xsl:apply-templates select="pre:Chapters" />
  </xsl:template>

  <!-- select the whole document with all <chapter> -->
	<xsl:template match="pre:Chapters">
    <w:wordDocument w:macrosPresent="no" w:embeddedObjPresent="no" w:ocxPresent="no" xml:space="preserve">
      <xsl:copy-of select="/root/WordFormat/WordHeadInfos/*" />
      <w:body>
        <wx:sect>
          <xsl:apply-templates select="pre:chapter">
            <xsl:with-param name="chapterLevel" select="1" />
          </xsl:apply-templates>
        </wx:sect>
      </w:body>

    </w:wordDocument>

	</xsl:template>





  <!-- write one chapter with its title and content and nested chapters. -->

	<xsl:template match="pre:chapter">
	<xsl:param name="chapterLevel"/><!-- level of the chapter deepness -->
	<xsl:param name="breakPage"/><!-- if value is 'before' than insert a page bread befort the title line. -->

    <wx:sub-section>
      <!-- write the chapter title line, with the header style dependeded on the chapterLevel -->
      <xsl:variable name="titleStyle">berschrift<xsl:value-of select="$chapterLevel"/></xsl:variable>
      <w:p>
        <w:pPr><!-- properties -->
          <w:pStyle w:val="{$titleStyle}"/>
          <xsl:if test="$breakPage='before'">
            <w:pageBreakBefore/>
          </xsl:if>
        </w:pPr>
        <xsl:call-template name="setBookmarkFromId" />
        <w:r>
          <w:rPr><w:lang w:val="DE"/></w:rPr>
          <w:t><xsl:value-of select="pre:title"/></w:t><!-- the header text -->
        </w:r>
      </w:p>

      <!-- write the textual content of this chapter level (no yet nested chapters) -->
      <xsl:apply-templates select="xhtml:body|pre:img|img">
      </xsl:apply-templates>

      <w:p>
        <w:pPr><!-- properties -->
          <w:pStyle w:val="endChapter"/>
        </w:pPr>
        <w:r>
          <w:rPr><w:lang w:val="DE"/></w:rPr>
          <w:t><xsl:text> </xsl:text></w:t><!-- empty text -->
        </w:r>
      </w:p>

      <!-- write nested chapters -->
      <xsl:apply-templates select="pre:chapter">
        <xsl:with-param name="chapterLevel" select="number($chapterLevel+1)" />
      </xsl:apply-templates>

    </wx:sub-section>
	</xsl:template>



<xsl:template match="xhtml:body">
  <!-- the body is only a wrapper for xhtml elements, ignore it for word output -->
  <xsl:apply-templates>
  </xsl:apply-templates>
</xsl:template>



<xsl:template match="xhtml:div">
<xsl:param name="listLevel">0</xsl:param>
<xsl:param name="listStyle" />
<xsl:param name="bullet" />
  <xsl:for-each select="xhtml:div|xhtml:p|xhtml:pre|xhtml:ul|xhtml:ol|xhtml:dl|xhtml:table|xhtml:img">
    <!-- HINT: use for-each ... apply-templates select="." instead apply-templates select"xhtml..."
               because a position() is necessary (bullet)
     -->
    <xsl:apply-templates select=".">
      <xsl:with-param name="listLevel" select="$listLevel" />
      <xsl:with-param name="listStyle" select="'xxx'" />
      <xsl:with-param name="bullet"><!-- transfer to xhtml:p -->
        <xsl:if test="position()=1"><xsl:value-of select="$bullet" /></xsl:if>
        <!-- else: let it empty. -->
      </xsl:with-param>
      <!-- xsl:with-param name="listStyle" select="$listStyle"/ -->
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>






	<xsl:template match="xhtml:p"><!-- paragraph -->
	<!-- the p-tag may be called inside a list -->
	<xsl:param name="xxxpStyle">Standard</xsl:param>
  <xsl:param name="bullet" select="'yy'" />
  <xsl:param name="pInside"/>
	<xsl:param name="listLevel">-1</xsl:param>
	<xsl:param name="listStyle"></xsl:param>
    <xsl:if test="count(@testOutput)=0 and not(@class='debug')">
      <xsl:apply-templates select="xhtml:ul"/>
      <xsl:apply-templates select="xhtml:img" /> <!-- image inside paragraph -->
      <xsl:variable name="text" select="text()[1]" />
      <xsl:if test="not(starts-with($text,'.')) or string-length($text)>1" >
        <w:p>
          <xsl:variable name="style">
            <!-- If attribute class is given, it is the style. Otherwise 'Standard' or 'std_li'
              If a listLevel is present, its number is appended. 
             -->
            <xsl:choose>
              <xsl:when test="count(@class)>0"><xsl:value-of select="@class"/></xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="number($listLevel)>0"><xsl:value-of select="'std'"/></xsl:when>
                  <xsl:otherwise>Standard</xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="number($listLevel)>0">_li<xsl:value-of select="$listLevel"/></xsl:if>
          </xsl:variable>
          <w:pPr><!-- properties -->
            <w:pStyle w:val="{$style}"/>
          </w:pPr>
          <xsl:if test="@breakPage='xxxbefore'">
            <wr>
              <w:br w:type="page"/>
            </wr>
          </xsl:if>
          <xsl:call-template name="setBookmarkFromId" />
          <xsl:if test="number($listLevel)>0">
            <w:r>
              <w:t><xsl:value-of select="$bullet" /><xsl:text>&#9;</xsl:text></w:t>
            </w:r>
          </xsl:if>
          <xsl:apply-templates select="xhtml:a|xhtml:u|xhtml:b|xhtml:stroke|xhtml:em|xhtml:i|xhtml:br|xhtml:code|xhtml:span|xhtml:a|text()"> <!-- text inside paragraph -->
            <xsl:with-param name="pInside" select="onlyChar"/>
          </xsl:apply-templates>
        </w:p>
      </xsl:if>
    </xsl:if>
	</xsl:template>




	<xsl:template match="xhtml:pre"><!-- preformatted text -->
	<!-- the p-tag may be called inside a list -->
    <!-- w:p>
      <xsl:variable name="style">
        <xsl:choose>
          <xsl:when test="count(@class)>0"><xsl:value-of select="@class"/></xsl:when>
          <xsl:otherwise>Pre</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <w:pPr>
        
        <w:pStyle w:val="Pre"/>
      </w:pPr -->
      <xsl:call-template name="setBookmarkFromId" />
      <xsl:call-template name="preLine">
        <xsl:with-param name="TEXT"  select="text()" />
        <xsl:with-param name="style">
          <xsl:choose>
            <xsl:when test="count(@class)>0"><xsl:value-of select="@class"/></xsl:when>
            <xsl:otherwise>Pre</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
	</xsl:template>

  <xsl:template name="preLine">
  <xsl:param name="TEXT" />
  <xsl:param name="style" />
    <xsl:variable name="line" select="substring-before($TEXT,'&#xa;')"  />
    <xsl:choose><xsl:when test="string-length($line)>0">
      <w:p><w:pPr><w:pStyle w:val="{$style}"/></w:pPr><w:r><w:t><xsl:value-of select="$line"/></w:t></w:r></w:p>
      <xsl:variable name="rest" select="substring-after($TEXT,'&#xa;')" />
      <xsl:if test="string-length($rest)>0">
        <xsl:call-template name="preLine">
          <xsl:with-param name="TEXT" select="$rest" />
          <xsl:with-param name="style" select="$style" />
        </xsl:call-template>
      </xsl:if>
    </xsl:when><xsl:otherwise>
      <w:p><w:pPr><w:pStyle w:val="{$style}"/></w:pPr><w:r><w:t><xsl:value-of select="$TEXT"/></w:t></w:r></w:p>
    </xsl:otherwise></xsl:choose>
  </xsl:template>






  <xsl:template match="xhtml:ol"><!-- liste -->
  <xsl:param name="listLevel" select="'0'"/><!-- default 0 if not called inside a xhtml:li, will be incremented -->
  <xsl:param name="pInside"/>
    <xsl:if test="$pInside!='onlyChar'"> <!-- elements ul also evaluated outside! -->
      <xsl:apply-templates select="xhtml:li" >
        <xsl:with-param name="listLevel" select="number($listLevel)+1"/><!-- first level is 1 -->
        <xsl:with-param name="listStyle" select="@style"/>
        <xsl:with-param name="listType" select="ul"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>



  <xsl:template match="xhtml:ul"><!-- liste -->
  <xsl:param name="listLevel" select="'0'"/><!-- default 0 if not called inside a xhtml:li, will be incremented -->
  <xsl:param name="pInside"/>
    <xsl:if test="$pInside!='onlyChar'"> <!-- elements ul also evaluated outside! -->
      <xsl:apply-templates select="xhtml:li" >
        <xsl:with-param name="listLevel" select="number($listLevel)+1"/><!-- first level is 1 -->
        <xsl:with-param name="listStyle" select="@style"/>
        <xsl:with-param name="listType" select="ul"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>




	<xsl:template match="xhtml:li"><!-- listitem -->
  <xsl:param name="listLevel" select="'4'"/><!-- should be initialized always, 4 to detect errors. -->
  <xsl:param name="listStyle" select="xxx"/>
  <xsl:param name="listType"/>
    <xsl:for-each select="xhtml:div|xhtml:p|xhtml:pre|xhtml:ul|xhtml:ol|xhtml:dl|xhtml:table|xhtml:img">
      <xsl:apply-templates select="." >
        <xsl:with-param name="listLevel" select="$listLevel" ></xsl:with-param>
        <!-- xsl:with-param name="listStyle" select="$listStyle"/ -->
        <xsl:with-param name="bullet">
          <xsl:if test="position()=1">
            <xsl:choose><xsl:when test="number($listLevel)=1"><xsl:value-of select="$ListBullet1" />
            </xsl:when><xsl:when test="number($listLevel)=2"><xsl:value-of select="$ListBullet2" />
            </xsl:when><xsl:when test="number($listLevel)=3"><xsl:value-of select="$ListBullet3" />
            </xsl:when><xsl:otherwise><xsl:value-of select="$ListBullet4" />
            </xsl:otherwise></xsl:choose>
          </xsl:if>
          <!-- else, it is empty, because it is a second paragraph in the same xhtml:li 
               A tab &#9; will be written anyhow in xhtml:p
           -->
        </xsl:with-param>
      </xsl:apply-templates>
    </xsl:for-each>  
	</xsl:template>








	<xsl:template match="xhtml:dl"><!-- liste -->
  <xsl:param name="listLevel" select="'-1'"/>
	<xsl:param name="pInside"/>
    <xsl:if test="$pInside!='onlyChar'"> <!-- elements ul also evaluated outside! -->
      <xsl:apply-templates select="xhtml:dt|xhtml:dd|xhtml:anchor" >
        <xsl:with-param name="listLevel" select="'0'"/>
        <xsl:with-param name="listStyle" select="@style"/>
        <xsl:with-param name="listType" select="dl"/>
      </xsl:apply-templates>
    </xsl:if>
	</xsl:template>




	<xsl:template match="xhtml:dt"><!-- listitem -->
  <xsl:param name="listLevel" select="'0'"/>
  <xsl:param name="listStyle" select="testFormat"/>
  <xsl:param name="listType"/>
    <w:p>
      <xsl:variable name="style">
        <xsl:choose>
          <xsl:when test="string-length($listStyle)>0"><xsl:value-of select="$listStyle"/></xsl:when>
          <xsl:when test="count(@class)>0"><xsl:value-of select="@class"/></xsl:when>
          <xsl:otherwise>Standard</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <w:pPr><!-- properties -->
        <w:pStyle w:val="{$style}"/>
      </w:pPr>
      <xsl:call-template name="setBookmarkFromId" />
      <xsl:apply-templates select="xhtml:a|xhtml:u|xhtml:b|xhtml:stroke|xhtml:em|xhtml:i|xhtml:br|xhtml:code|xhtml:span|xhtml:img|xhtml:a|text()"> <!-- text inside paragraph -->
        <xsl:with-param name="pInside" select="onlyChar"/>
      </xsl:apply-templates>
    </w:p>
	</xsl:template>




	<xsl:template match="xhtml:dd">
    <!-- xsl:message><xsl:text>...dd: </xsl:text><xsl:value-of select="xhtml:p"/></xsl:message -->
    <xsl:apply-templates select="xhtml:div|xhtml:p|xhtml:pre|xhtml:ul|xhtml:ol|xhtml:dl|xhtml:table|xhtml:img">
    </xsl:apply-templates>
	</xsl:template>






	<xsl:template match="xhtml:table"><!-- table -->
    <w:tbl>
      <w:tblPr>
        <w:tblStyle w:val="TabelleTab"/>
        <!-- w:tblW w:w="0" w:type="auto"/ -->
        <w:tblW w:w="{$widthTable}" w:type="pct"/>
        <w:tblLook w:val="00BF"/>
      </w:tblPr>
      <!-- w:tblGrid>
        <w:gridCol w:w="3600"/>
        <w:gridCol w:w="2096"/>
        <w:gridCol w:w="2500"/>
      </w:tblGrid -->
      <xsl:apply-templates select="xhtml:tr">
        <xsl:with-param name="breakPage" select="@breakPage"/>
      </xsl:apply-templates>
    </w:tbl>
	</xsl:template>




	<xsl:template match="xhtml:tr"><!-- table row -->
	<xsl:param name="breakPage"/>
    <xsl:if test="count(xhtml:th|xhtml:td)gt 0"><!-- don't create an empty w:tr, it's bad for winword. -->
      <w:tr><xsl:apply-templates select="xhtml:th|xhtml:td"><xsl:with-param name="breakPage" select="$breakPage"/></xsl:apply-templates></w:tr>
    </xsl:if>
	</xsl:template>



	<xsl:template match="xhtml:th"><!-- table head cell -->
	<xsl:param name="breakPage"/>
    <w:tc>
      <xsl:if test="boolean(@width)">
        <xsl:variable name="widthPercent" select="substring-before(@width,'%')"/>
        <xsl:if test="number($widthPercent)&lt;50">
          <!-- only table rows with widht less than 50% are marked with a widht, because the page widht is not so deterministed. -->
          <xsl:variable name="widthInch" select="number($widthPercent) * number($widthTable) *0.01"/>
          <w:tcPr><w:tcW w:w="{$widthInch}" w:type="pct"/><!-- is pct a unit for width??? -->
          </w:tcPr>
        </xsl:if>
      </xsl:if>
      <xsl:if test="count(div|p|ul|table|img|xhtml:div|xhtml:p|xhtml:ul|xhtml:table)=0">
        <!-- simple tablecell content: no complex tags, generate last as one w:p -->
        <w:p>
          <w:pPr><!-- properties -->
            <w:pStyle w:val="Tabellenkopf"/><!-- Absatzformat in einer Tabellenzelle ist Tabelle -->
            <w:keepNext/><!-- kein SeitenUmbruch nach diesem Abschnitt -->
          </w:pPr>
          <xsl:call-template name="setBookmarkFromId" />
          <xsl:apply-templates select="xhtml:a|xhtml:u|xhtml:b|xhtml:stroke|xhtml:em|xhtml:i|xhtml:code|xhtml:span|xhtml:img|xhtml:a|text()"/>
        </w:p>
      </xsl:if>
      <xsl:apply-templates select="xhtml:div|xhtml:p|xhtml:ul">
        <xsl:with-param name="pStyle">Tabellenkopf</xsl:with-param>
      </xsl:apply-templates>
      <xsl:if test="count(xxxtable)>0">
        <!-- :TODO: nesting of tables doesn't work, it is a problem of word, how to realize? -->
        <w:p>
          <xsl:apply-templates select="xhtml:p|xhtml:ul">
            <xsl:with-param name="pStyle">Tabellenkopf</xsl:with-param>
          </xsl:apply-templates>
        </w:p>
      </xsl:if>
    </w:tc>
	</xsl:template>


	<xsl:template match="xhtml:td"><!-- table cell -->
	<xsl:param name="breakPage"/>
    <w:tc>
      <w:tcPr>
        <!-- w:tcW w:w="2665" w:type="dxa"/ -->
      </w:tcPr>
      <xsl:if test="count(div|p|ul|table|img|xhtml:div|xhtml:p|xhtml:ul|xhtml:table)=0">
        <!-- simple tablecell content: no complex tags, generate last as one w:p -->
        <w:p>
          <w:pPr><!-- properties -->
            <w:pStyle w:val="Tabelle"/><!-- Absatzformat in einer Tabellenzelle ist Tabelle -->
            <xsl:if test="$breakPage='noBreak' or $breakPage='noBreakAfter'">
              <w:keepNext/><!-- kein SeitenUmbruch nach diesem Abschnitt -->
            </xsl:if>
          </w:pPr>
          <xsl:if test="$breakPage='xxxbefore'">
            <wr>
              <w:br w:type="page"/>
            </wr>
          </xsl:if>
          <xsl:call-template name="setBookmarkFromId" />
          <xsl:apply-templates select="xhtml:a|xhtml:u|xhtml:b|xhtml:stroke|xhtml:em|xhtml:i|xhtml:code|xhtml:span|xhtml:img|xhtml:a|text()"/>
        </w:p>
      </xsl:if>
      <xsl:apply-templates select="xhtml:div|xhtml:p|xhtml:pre|xhtml:ul|xhtml:ol|xhtml:dl|xhtml:table|xhtml:img">
        <xsl:with-param name="pStyle">Tabelle</xsl:with-param>
      </xsl:apply-templates>
      <xsl:if test="local-name(*[last()])='table'">
        <w:p>END-TABLE</w:p>
      </xsl:if>
      <xsl:if test="count(xxxtable)>0">
        <!-- :TODO: nesting of tables doesn't work, it is a problem of word, how to realize? -->
        <w:p>
          <xsl:apply-templates select="xhtml:p|xhtml:ul">
            <xsl:with-param name="pStyle">Tabelle</xsl:with-param>
          </xsl:apply-templates>
        </w:p>
      </xsl:if>
    </w:tc>
	</xsl:template>









  <xsl:template match="xhtml:u">
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="rPrNew"><xsl:copy-of select="$rPr"/><w:u w:val="single"/></xsl:variable>
    <!-- xsl:copy-of select="/root/WordFormat/WordFormatProperties/underline/*"/ -->
    <xsl:apply-templates>
      <xsl:with-param name="rPr"><xsl:copy-of select="$rPrNew" /></xsl:with-param>
    </xsl:apply-templates>

  </xsl:template>


  <xsl:template match="xhtml:i">
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="rPrNew"><xsl:copy-of select="$rPr"/><w:i/></xsl:variable>
    <!-- xsl:copy-of select="/root/WordFormat/WordFormatProperties/underline/*"/ -->
    <xsl:apply-templates>
      <xsl:with-param name="rPr"><xsl:copy-of select="$rPrNew" /></xsl:with-param>
    </xsl:apply-templates>

  </xsl:template>


  <xsl:template match="xhtml:em">
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="rPrNew"><xsl:copy-of select="$rPr"/><w:i/></xsl:variable>
    <!-- xsl:copy-of select="/root/WordFormat/WordFormatProperties/underline/*"/ -->
    <xsl:apply-templates>
      <xsl:with-param name="rPr"><xsl:copy-of select="$rPrNew" /></xsl:with-param>
    </xsl:apply-templates>

  </xsl:template>


  <xsl:template match="xhtml:b">
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="rPrNew"><xsl:copy-of select="$rPr"/><w:b/></xsl:variable>
    <!-- xsl:copy-of select="/root/WordFormat/WordFormatProperties/underline/*"/ -->
    <xsl:apply-templates>
      <xsl:with-param name="rPr"><xsl:copy-of select="$rPrNew" /></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template match="xhtml:stroke">
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="rPrNew"><xsl:copy-of select="$rPr"/><w:b/></xsl:variable>
    <!-- xsl:copy-of select="/root/WordFormat/WordFormatProperties/underline/*"/ -->
    <xsl:apply-templates>
      <xsl:with-param name="rPr"><xsl:copy-of select="$rPrNew" /></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>


  <xsl:template match="xhtml:code">
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="rPrNew"><xsl:copy-of select="$rPr"/><w:rStyle w:val="code"/></xsl:variable>
    <!-- xsl:copy-of select="/root/WordFormat/WordFormatProperties/underline/*"/ -->
    <xsl:apply-templates>
      <xsl:with-param name="rPr"><xsl:copy-of select="$rPrNew" /></xsl:with-param>
    </xsl:apply-templates>

  </xsl:template>



  <xsl:template match="xhtml:span">
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="rPrNew">
      <xsl:copy-of select="$rPr"/>
      <xsl:if test="boolean(@class)">
        <w:rStyle w:val="{@class}"/>
      </xsl:if>
    </xsl:variable>
    <xsl:apply-templates>
      <xsl:with-param name="rPr"><xsl:copy-of select="$rPrNew" /></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>



  <xsl:template match="xhtml:p/text()|xhtml:td/text()|xhtml:th/text()|xhtml:li/text()|xhtml:dt/text()|xhtml:u/text()|xhtml:i/text()|xhtml:b/text()|xhtml:code/text()|xhtml:a/text()|xhtml:pre/text()">
  <!-- its posible unnecessary, see template match="text()" -->
  <xsl:param name="rPr"></xsl:param>
    <w:r>
      <w:rPr><w:lang w:val="DE"/><xsl:copy-of select="$rPr"/></w:rPr>
      <!-- w:t><xsl:value-of select="normalize-space(.)"/ --><!-- xsl:text> </xsl:text --><!-- /w:t -->
      <xsl:variable name="TEXT"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
      <xsl:if test="string-length($TEXT)>0">
        <w:t><xsl:value-of select="."/></w:t>
      </xsl:if>
    </w:r>
  </xsl:template>



  <xsl:template match="text()">
  <!-- Text could not be handled directly without template, because the element w:r is necessary. 
       The problem can be resolved by using this template for textual parts in XML.
       But because whitespaces between some elements are also of type text(),
       there should be disabled. An emtpy element w:t at improper position in word-xml cause an error.
       So a test of only-whitespace will be done here.
   -->
  <xsl:param name="rPr"></xsl:param>
    <xsl:variable name="TEXT"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
    <xsl:if test="string-length($TEXT)>0">
      <w:r>
        <w:rPr><w:lang w:val="DE"/><xsl:copy-of select="$rPr"/></w:rPr>
        <!-- w:t><xsl:value-of select="normalize-space(.)"/ --><!-- xsl:text> </xsl:text --><!-- /w:t -->
          <w:t><xsl:value-of select="."/></w:t>
      </w:r>
    </xsl:if>
  </xsl:template>



  <xsl:template match="xcode/text()">
    <w:r>
      <w:rPr>
        <w:lang w:val="DE"/>
        <w:rStyle w:val="code"/>
      </w:rPr>
      <w:t><!-- xsl:text> </xsl:text --><xsl:value-of select="normalize-space(.)"/><!-- xsl:text> </xsl:text --></w:t>
    </w:r>
  </xsl:template>




  <xsl:template match="xhtml:aXXX">
    <xsl:if test="count(@href)>0">
      <xsl:variable name="href1">
        <xsl:choose>
        <xsl:when test="starts-with(@href,'#')">
          <xsl:text>LaBeL_</xsl:text><xsl:value-of select="substring(@href,2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@href"/>
        </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <w:hlink w:bookmark="{$href1}">
        <w:r>
          <w:rPr><w:lang w:val="DE"/><w:rStyle w:val="Hyperlink"/></w:rPr>
          <w:t><xsl:value-of select="normalize-space(.)"/></w:t>
        </w:r>
      </w:hlink>
    </xsl:if>
    <xsl:if test="count(@name)>0">
      <xsl:variable name="label">LaBeL_<xsl:value-of select="@name"/></xsl:variable>
      <aml:annotation aml:id="30001" w:type="Word.Bookmark.Start" w:name="{$label}"/>
      <aml:annotation aml:id="30001" w:type="Word.Bookmark.End"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:a">
    <xsl:if test="count(@href)>0"><!-- It is a hyperlink-->
      <xsl:choose><xsl:when test="starts-with(@href,'#')"><!-- It is a internal link -->
        <xsl:variable name="href1"><xsl:value-of select="substring(@href,2,40)"/></xsl:variable>
        <w:hlink w:bookmark="{$href1}">
          <w:r>
            <w:rPr><w:lang w:val="DE"/><w:rStyle w:val="Hyperlink"/></w:rPr>
            <w:t><xsl:value-of select="normalize-space(.)"/></w:t>
          </w:r>
        </w:hlink>
      </xsl:when><xsl:otherwise><!-- It is a external link-->
        <xsl:variable name="href1">
          <xsl:choose><xsl:when test="starts-with(@href,'../')">
            <!-- dispose the linked folders parallel to word, adequat like parallel to html folder: -->
            <xsl:value-of select="substring(@href,4)"/>
          </xsl:when><xsl:otherwise>
            <xsl:value-of select="@href"/>
          </xsl:otherwise></xsl:choose>
        </xsl:variable>
        <w:hlink w:dest="{$href1}">
          <w:r>
            <w:rPr><w:lang w:val="DE"/><w:rStyle w:val="Hyperlink"/></w:rPr>
            <w:t><xsl:value-of select="normalize-space(.)"/></w:t>
          </w:r>
        </w:hlink>
      </xsl:otherwise></xsl:choose>
    </xsl:if>
    <xsl:if test="count(@name)>0"><!--It is an anchor -->
      <xsl:variable name="label"><xsl:value-of select="substring(@name,1,40)"/></xsl:variable>
      <aml:annotation aml:id="30001" w:type="Word.Bookmark.Start" w:name="{$label}"/>
      <aml:annotation aml:id="30001" w:type="Word.Bookmark.End"/>
    </xsl:if>
  </xsl:template>


  <xsl:template match="xhtml:xxxanchor">
  <xsl:variable name="label"><xsl:value-of select="@label"/></xsl:variable>
  <aml:annotation aml:id="30001" w:type="Word.Bookmark.Start" w:name="{$label}"/>
  <aml:annotation aml:id="30001" w:type="Word.Bookmark.End"/>
</xsl:template>


<!-- This template is called at start of w:p (inside w:p) because bookmarks should be placed in paragraphs. -->
<xsl:template name="setBookmarkFromId">
  <xsl:if test="xhtml:body/@id"><!-- The w.p is a title of a chapter -->
    <xsl:variable name="label"><xsl:value-of select="substring(xhtml:body[1]/@id,1,40)"/></xsl:variable>
    <xsl:variable name="annotation-id" ><xsl:value-of select="generate-id()" /></xsl:variable>
    <aml:annotation aml:id="{$annotation-id}" w:type="Word.Bookmark.Start" w:name="{$label}"/>
    <aml:annotation aml:id="{$annotation-id}" w:type="Word.Bookmark.End"/>
  </xsl:if>
  <xsl:if test="boolean(@id)">
    <xsl:variable name="label"><xsl:value-of select="substring(@id,1,40)"/></xsl:variable>
    <aml:annotation aml:id="30001" w:type="Word.Bookmark.Start" w:name="{$label}"/>
    <aml:annotation aml:id="30001" w:type="Word.Bookmark.End"/>
  </xsl:if>
  <xsl:if test="../xhtml:anchor"><!-- anchor as sibling found -->
    <xsl:variable name="label"><xsl:value-of select="substring(../xhtml:anchor[1]/@label,1,40)"/></xsl:variable>
    <aml:annotation aml:id="30001" w:type="Word.Bookmark.Start" w:name="{$label}"/>
    <aml:annotation aml:id="30001" w:type="Word.Bookmark.End"/>
  </xsl:if>
</xsl:template>




  <xsl:template match="internref">
      <w:hlink w:bookmark="{@label}">
        <w:r>
          <w:rPr><w:lang w:val="DE"/><w:rStyle w:val="Hyperlink"/></w:rPr>
          <w:t><xsl:value-of select="."/></w:t>
        </w:r>
      </w:hlink>
  </xsl:template>

  <xsl:template match="fileref">
        <w:r>
          <w:rPr><w:lang w:val="DE"/><w:rStyle w:val="Standard"/></w:rPr>
          <w:t><xsl:value-of select="."/></w:t>
        </w:r>
  </xsl:template>


  <xsl:template match="anchor">
      <xsl:variable name="label"><xsl:value-of select="@label"/></xsl:variable>
      <aml:annotation aml:id="30001" w:type="Word.Bookmark.Start" w:name="{@label}"/>
      <aml:annotation aml:id="30001" w:type="Word.Bookmark.End"/>
  </xsl:template>




  <xsl:template match="xhtml:img|img|pre:img">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="Grafik"/><!-- Format for picture -->
        <w:rPr><w:lang w:val="DE"/></w:rPr>
      </w:pPr>
      <w:r>
        <w:rPr><w:lang w:val="DE"/></w:rPr>
        <w:pict>
          <!-- attribute height, width in source are pixel (for html-viewing), calculate points -->
          <!-- 640 pixel = half widht of a standard 1280-display are approximately a page width, 6,2 inch. =  -->
          <!-- The factor is 6.2 inch * 72 pt/inch / 640 = 0.6975 -->
          <xsl:variable name="pictWidth">
            <xsl:choose><xsl:when test="count(@width)>0 and number(@width) le 640"><xsl:value-of  select="number(@width) * 0.6975"/></xsl:when>
            <!-- xsl:otherwise>600pt</xsl:otherwise></xsl:choose -->
            <xsl:otherwise>640 * 0.6975</xsl:otherwise></xsl:choose>
          </xsl:variable>
          <xsl:variable name="pictHeight">
            <xsl:choose>
            <xsl:when test="count(@height)>0 and count(@width)>0 and number(@width) ge 640"><xsl:value-of select="number(@height)* 640 div number(@width) * 0.6975"/></xsl:when>
            <xsl:when test="count(@height)>0"><xsl:value-of select="number(@height) * 0.6975"/></xsl:when>
            <xsl:otherwise>450pt</xsl:otherwise></xsl:choose>
          </xsl:variable>
          <!-- xsl:variable name="style">width:<xsl:value-of select="$pictWidth"/>pt<xsl:if test="count(@height)>0">;height:<xsl:value-of select="$pictHeight"/>pt</xsl:if></xsl:variable -->
          <xsl:variable name="style">width:<xsl:value-of select="$pictWidth"/>pt;height:<xsl:value-of select="$pictHeight"/>
            <xsl:text>pt;mso-position-horizontal:left</xsl:text><!-- Befehle fï¿½ksstehendes Bild eingefï¿½unktinierte aber nicht im word. -->
          </xsl:variable>
          <!-- v:shape id="_x0000_i1025" type="#_x0000_t75" style="width:453.75pt;height:294pt" -->
          <v:shape id="_x0000_i1025" type="#_x0000_t75" style="{$style}" o:allowoverlap="f">
            <!-- w:binData w:name="{@src}" /--> <!-- It doesn't work!!! -->
            <v:imagedata src="{@src}" />
            <w10:wrap type="square"/><!-- Befehle fï¿½ksstehendes Bild eingefï¿½unktinierte aber nicht im word. -->
          </v:shape>
        </w:pict>
      </w:r>
    </w:p>
    <xsl:if test="count(@title)>0">
      <w:p>
        <w:pPr>
          <w:pStyle w:val="BeschriftGrafik"/><!-- Format with figure numbering -->
          <w:rPr><w:lang w:val="DE"/></w:rPr>
        </w:pPr>
        <!-- w:r><w:rPr><w:lang w:val="DE"/></w:rPr>
          <w:t>BILd </w:t>
        </w:r>
        <w:r>
          <w:fldChar w:fldCharType="begin"/>
        </w:r>
        <w:r>
          <w:rPr><w:lang w:val="DE"/></w:rPr>
          <w:instrText> SEQ Figure \* ARABIC </w:instrText>
        </w:r>
        <w:r>
          <w:fldChar w:fldCharType="separate"/>
        </w:r>
        <w:r><w:rPr><w:noProof/><w:lang w:val="DE"/></w:rPr>
          <w:t>1</w:t>
        </w:r>
        <w:r>
          <w:fldChar w:fldCharType="end"/>
        </w:r --><!-- This block is not necessary if the figure title format creates a number. --> 
        <w:r><w:rPr><w:lang w:val="DE"/></w:rPr>
          <w:t><xsl:text> </xsl:text><xsl:value-of select="@title"/></w:t>
        </w:r>
      </w:p>
    </xsl:if>
  </xsl:template>




  <xsl:template match="figure">
    <w:p>
      <w:pPr>
        <w:pStyle w:val="BeschriftGrafik"/>
        <w:rPr><w:lang w:val="DE"/></w:rPr>
      </w:pPr>
      <w:r><w:rPr><w:lang w:val="DE"/></w:rPr>
        <w:t>Bild </w:t>
      </w:r>
      <w:r>
        <w:fldChar w:fldCharType="begin"/>
      </w:r>
      <w:r>
        <w:rPr><w:lang w:val="DE"/></w:rPr>
        <w:instrText> SEQ Figure \* ARABIC </w:instrText>
      </w:r>
      <w:r>
        <w:fldChar w:fldCharType="separate"/>
      </w:r>
      <w:r><w:rPr><w:noProof/><w:lang w:val="DE"/></w:rPr>
        <w:t>1</w:t>
      </w:r>
      <w:r>
        <w:fldChar w:fldCharType="end"/>
      </w:r>
      <w:r><w:rPr><w:lang w:val="DE"/></w:rPr>
        <w:t> <xsl:value-of select="."/></w:t>
      </w:r>
    </w:p>
  </xsl:template>



  <xsl:template match="xhtml:br">
    <w:r>
      <w:rPr><w:lang w:val="DE"/></w:rPr>
      <w:br/>
      <!-- w:t></w:t -->
    </w:r>
  </xsl:template>





	<xsl:template match="xxhr"><!-- paragraph -->
    <w:p>
      <w:pPr><!-- properties -->
        <w:rPr><w:lang w:val="DE"/></w:rPr>
      </w:pPr>
      <wr>
        <w:br w:type="page"/>
      </wr>
    </w:p>
	</xsl:template>






</xsl:stylesheet>
