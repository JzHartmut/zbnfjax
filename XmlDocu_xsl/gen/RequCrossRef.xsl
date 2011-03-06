<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:pre="http://www.vishia.de/2006/XhtmlPre"
>

<!--  This XSLT-script is able to use especially for org.vishia.xml.docuGen.CorrectHref.java
      to show cross references to requirements. The input xml Tree is build internally inside the converting routines
      as a tree of hyper-references.
 -->

  <xsl:output method="xml" encoding="iso-8859-1"/>
  <xsl:variable name="testOutput">1</xsl:variable><!-- wenn auf 0 gesetzt dann werden keine Zusatztexte für Test erzeugt. -->


<xsl:template match="/">
  <xsl:variable name="content" select="/root/@crossRefContent" />
  <xsl:choose><xsl:when test="starts-with($content,'Requirements')" >
    <pre:CrossRefContent>
      <xhtml:dl>
        <xsl:for-each select="/root/*//Requirement">
        <xsl:sort select="@Ident" />  
          <xsl:variable name="ident"><xsl:text>REQ</xsl:text><xsl:value-of select="substring-after(substring-before(@Ident,'#DEF#'),'#REQ')" /></xsl:variable>
          <xsl:variable name="label"><xsl:text></xsl:text><xsl:value-of select="$ident" /><xsl:text>_REF</xsl:text></xsl:variable>
          <xhtml:a name="{$label}" /><!-- das Label für href hierhin -->
          <xhtml:dt id="{$label}" class="umlElement"><xsl:text></xsl:text><xsl:value-of select="$ident" /><xsl:text>: </xsl:text><xsl:value-of select="Titel" /><xsl:text></xsl:text>
          </xhtml:dt>
          <xhtml:dd>
            <xsl:if test="contains($content, '+text+')">
              <xsl:for-each select="Description/text/p">
                <xhtml:p><xsl:value-of select="." /></xhtml:p>
              </xsl:for-each>
            </xsl:if>
            <xsl:if test="not(/root/pre:HrefRoot/pre:HrefEntry[starts-with(@name,$ident)])" >
              <xhtml:p>Nicht in dieser Spezifikation behandelt. </xhtml:p>
            </xsl:if>
            <xsl:for-each select="/root/pre:HrefRoot/pre:HrefEntry[starts-with(@name,$ident)]">
              <xhtml:p>Behandelt in:</xhtml:p>
              <xhtml:ul>
                <xsl:for-each select="Backref">
                  <xsl:variable name="href">#<xsl:value-of select="@href" /></xsl:variable>
                  <xhtml:li>
                    <xhtml:p>
                      <xhtml:a href="{$href}"><xsl:text></xsl:text><xsl:value-of select="@chapter-href" /><xsl:text> </xsl:text><xsl:value-of select="@chapter-title" /><xsl:text></xsl:text></xhtml:a>
                      <xsl:if test="contains($content, '+div+')">
                        <xsl:if test="@div-href">
                          <xsl:text>: </xsl:text><xsl:value-of select="@div-href" /><xsl:text></xsl:text>
                        </xsl:if>  
                      </xsl:if>
                    </xhtml:p>
                  </xhtml:li>
                </xsl:for-each>
              </xhtml:ul>
            </xsl:for-each>
          </xhtml:dd>
        </xsl:for-each>      
      </xhtml:dl>
    </pre:CrossRefContent>

  </xsl:when><xsl:when test="$content='Req-old'">
    <pre:CrossRefContent>
        <xhtml:dl>
        <xsl:for-each select="/root/pre:HrefRoot/pre:HrefEntry[starts-with(@name,'REQ')]">
          <xsl:variable name="label" select="substring-before(@name,'_REF')" />
          <!-- XML-Inputelement Requirement suchen und in variable speichern:-->
          <xsl:variable name="requirement" select="/root/Requirements//Requirement[contains(@Ident,$label)]" />
          <xhtml:a name="{@name}" /><!-- @name ist das Label für href hierhin -->
          <xhtml:dt id="{@name}" class="umlElement"><xsl:text></xsl:text><xsl:value-of select="@name" /><xsl:text>: </xsl:text>
            <!-- xsl:value-of select="$label" / -->
            <xsl:value-of select="$requirement/Titel" />
          </xhtml:dt>
          <xhtml:dd>
            <xhtml:p class="caption_p"><xsl:text>Aufgeführt in Kapitel:</xsl:text></xhtml:p>
            <xhtml:ul>
              <xsl:for-each select="Backref">
                <xhtml:li>
                  <xhtml:p>
                    <xsl:variable name="href">#<xsl:value-of select="@chapter-href" /></xsl:variable>
                      <xhtml:a href="{$href}"><xsl:value-of select="@chapter-title" /></xhtml:a>
                  </xhtml:p>
                </xhtml:li>
              </xsl:for-each>
            </xhtml:ul>
          </xhtml:dd>
        </xsl:for-each>
      </xhtml:dl>
    </pre:CrossRefContent>
  </xsl:when><xsl:when test="$content='TestCrossRef'">
    <pre:CrossRefContent>
        <xhtml:ul>
          <xsl:for-each select="/root/pre:HrefRoot/pre:HrefEntry">
            <xhtml:li><xsl:text></xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text>
              <xhtml:ul>
                <xsl:for-each select="Backref"><xhtml:li><xsl:text> - </xsl:text><xsl:value-of select="@chapter-href" /><xsl:text> : </xsl:text><xsl:value-of select="@chapter-title" /><xsl:text></xsl:text></xhtml:li></xsl:for-each>
              </xhtml:ul>
            </xhtml:li>    
          </xsl:for-each>
        </xhtml:ul>
      </pre:CrossRefContent>  
  </xsl:when><xsl:otherwise>
    <pre:noCrossRefContent />
  </xsl:otherwise></xsl:choose>
</xsl:template>









<xsl:template match="xx/xx">
  <xsl:apply-templates select="/root/CrossRefRoot" />
</xsl:template>

<xsl:template match="CrossRefRoot">
  <xsl:if test="count(CrossRef)>0">
    <xhtml:dl>
      <xsl:for-each select="CrossRef">
        <xhtml:dt><xsl:value-of select="@anchor" />
        </xhtml:dt>
        <xhtml:dd>
          <xhtml:ul>
            <xsl:for-each select="Backref">
              <xhtml:li>
                <xhtml:p>
                  <xsl:variable name="href">#<xsl:value-of select="@chapter-href" /></xsl:variable>
                  <xhtml:a href="{$href}"><xsl:value-of select="@chapter-title" /></xhtml:a>
                </xhtml:p>
              </xhtml:li>
            </xsl:for-each>
          </xhtml:ul>
        </xhtml:dd>
      </xsl:for-each>
    </xhtml:dl>
  </xsl:if>
</xsl:template>


	<xsl:template match="xxx">
  <ReqCrossRef>xxxTest<xsl:value-of select="/root/@forHref" />

    <!-- xsl:apply-templates select="/root//Requirements/Requirement | /root//NewRequirements/Requirement">
      <xsl:sort select="@Ident" />
    </xsl:apply-templates -->
  </ReqCrossRef>
	</xsl:template>




	<xsl:template name="Requirement">
	  <!-- Bereinigung des Ident weil vor- und nach-Leerzeichen auftreten: -->
    <xsl:variable name="label1"><xsl:text>REQ</xsl:text><xsl:value-of select="substring-after(@Ident,'#REQ')" /><xsl:text></xsl:text></xsl:variable>
    <xsl:variable name="label"><xsl:text></xsl:text><xsl:value-of select="substring-before($label1,'#DEF#')" /><xsl:text>#DEF#</xsl:text></xsl:variable>
    <xhtml:dl>
      <xhtml:a name="{$label}" />
      <xhtml:dt id="{$label}"><xsl:text></xsl:text><xsl:value-of select="$label" /><xsl:text>: </xsl:text><xsl:value-of select="Titel" /><xsl:text></xsl:text></xhtml:dt>
      <xhtml:dd><xsl:apply-templates select="Description/text/*" /></xhtml:dd>
      <!-- xsl:call-template name="searchReferences">
        <xsl:with-param name="reqIdent" select="@Ident"/>
      </xsl:call-template -->
    </xhtml:dl>
	</xsl:template>

	<xsl:template match="p">
	  <xhtml:p><xsl:apply-templates /></xhtml:p>
	</xsl:template>





  <xsl:template name="searchReferences">
  <xsl:param name="reqIdent"/>
    <info><xsl:value-of select="$reqIdent"/></info>
      <xsl:for-each select="/root/SwComponententSpec/Structure/topic">
        <xsl:call-template name="searchReferencesInTopic">
          <xsl:with-param name="reqIdent" select="$reqIdent"/>
          <xsl:with-param name="titlePath" select="'Structure'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="/root/SwComponententSpec/Algorithms/topic">
        <xsl:call-template name="searchReferencesInTopic">
          <xsl:with-param name="reqIdent" select="$reqIdent"/>
          <xsl:with-param name="titlePath" select="'Algorithms'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="/root/SwComponententSpec/Interfaces/*/topic">
        <xsl:call-template name="searchReferencesInTopic">
          <xsl:with-param name="reqIdent" select="$reqIdent"/>
          <xsl:with-param name="titlePath" select="'Interfaces'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="/root/SwComponententSpec/Moduls/topic">
        <xsl:call-template name="searchReferencesInTopic">
          <xsl:with-param name="reqIdent" select="$reqIdent"/>
          <xsl:with-param name="titlePath" select="'Moduls'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="/root/SwComponententSpec/SwEngeneering/topic">
        <xsl:call-template name="searchReferencesInTopic">
          <xsl:with-param name="reqIdent" select="$reqIdent"/>
          <xsl:with-param name="titlePath" select="'SwEngeneering'"/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:for-each select="/root/SwComponententSpec/Documentation/topic">
        <xsl:call-template name="searchReferencesInTopic">
          <xsl:with-param name="reqIdent" select="$reqIdent"/>
          <xsl:with-param name="titlePath" select="'Documentation'"/>
        </xsl:call-template>
      </xsl:for-each>
  </xsl:template>


  <xsl:template name="searchReferencesInTopic">
  <xsl:param name="reqIdent"/>
  <xsl:param name="titlePath"/><!-- path of the titles of the nested topics -->
    <!-- info2><xsl:value-of select="$reqIdent"/></info2 -->
    <!-- ident><xsl:value-of select="$titlePath"/></ident -->
    <!-- Reqxxx><xsl:value-of select="tag[@name='ReqRef']/@value"/></Reqxxx -->
    <xsl:variable name="titlePathOwn"><xsl:value-of select="$titlePath"/>/<xsl:value-of select="@ident"/></xsl:variable>
    <xsl:if test="tag[@name='ReqRef']/@value = $reqIdent">
      <ReferencedIn label="{@label}" titlepath="{$titlePathOwn}"><xsl:value-of select="@title"/></ReferencedIn>
    </xsl:if>
      <xsl:for-each select="topic">
        <xsl:call-template name="searchReferencesInTopic">
          <xsl:with-param name="reqIdent" select="$reqIdent"/>
          <xsl:with-param name="titlePath"><xsl:value-of select="$titlePathOwn"/></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
  </xsl:template>







</xsl:stylesheet>

