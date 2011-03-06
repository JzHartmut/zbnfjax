<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="XSL"
>
<!-- This file transforms a docu.genctrl-file, which was parsed and converted to XML with DocuGenCtrl.zbnf,
     to a XSL-File, which controls the generation of a docu.pre.xml Documentation file.
     The input for the XSL-Translation, which will be done with this result.xsl-file, 
     may be come from different sources, at example XMI, parsed Headers, parsed text-topics or other XML-Files. 
  -->
<!-- made by Hartmut Schorrig
  2009-02-13 HScho corr <xsl:template name="recursivelyBuildUmlSelect">: A separator $ between class and inner-class is used.
  2009-02-10 HScho corr <xsl:template name="recursivelyBuildUmlSelect": Selection of inner classes was fault: <xsl:value-of select="$IdentClass"/><xsl:text>']/UML:Namespace.ownedElement/
  2009-02-08 HScho corr <xsl:template match="umlIfc"> was twice, commented

 --> 

<xsl:output method="text" encoding="iso-8859-1"/>
<xsl:param name="document" select="'?'" />



<xsl:template match= "/">
  <xsl:text>&lt;?xml version="1.0" encoding="iso-8859-1"?>
</xsl:text>
  <xsl:text>
&lt;xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:topics="http://www.vishia.de/2006/Topics"
  xmlns:pre="http://www.vishia.de/2006/XhtmlPre"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:UML="omg.org/UML13"
&gt;

&lt;!-- this file is generated using xmlDocu_xsl/GenDocuCtrl2Xsl.xslp --&gt;

</xsl:text>

  <!-- select of the requested document in DocuGenCtrl.xml, some variants, supporting multi documents in 1 genCtr-File, than call work -->
  <xsl:choose><xsl:when test="count(GenCtrl/document)>0 and $document!='?'"><xsl:for-each select="GenCtrl/document[@ident=$document]" ><xsl:call-template name="work"/></xsl:for-each></xsl:when>
  <xsl:when test="count(GenCtrl/document)>0"><xsl:for-each select="GenCtrl/document" ><xsl:call-template name="work"/></xsl:for-each></xsl:when>
  <xsl:when test="count(GenCtrl)>0"><xsl:for-each select="GenCtrl" ><xsl:call-template name="work"/></xsl:for-each></xsl:when>
  </xsl:choose>

  <xsl:text>
&lt;/xsl:stylesheet>
</xsl:text>

</xsl:template>







<xsl:template name= "work">

  <xsl:for-each select="import|../import">
    <xsl:text>
&lt;xsl:import href="</xsl:text><xsl:value-of select="@href"/><xsl:text>.xsl" /&gt;</xsl:text>
  </xsl:for-each>
  <xsl:text>
&lt;xsl:output method="xml" encoding="iso-8859-1"/>

&lt;xsl:variable name="document.ident" select="</xsl:text><xsl:value-of select="$document" /><xsl:text>" /&gt;

&lt;xsl:variable name="testOutput">2&lt;/xsl:variable>

&lt;xsl:template match="/|/root">
  &lt;pre:Chapters title="</xsl:text><xsl:value-of select="@title"/><xsl:text>" &gt;
</xsl:text>
    <xsl:apply-templates/>
<xsl:text>
  &lt;/pre:Chapters>
&lt;/xsl:template>
</xsl:text>
</xsl:template>



 <xsl:template match="chapter">
<xsl:text>&lt;pre:chapter </xsl:text><xsl:choose><xsl:when test="count(@id)>0"><xsl:text>id="</xsl:text><xsl:value-of select="@id" /><xsl:text>"</xsl:text></xsl:when></xsl:choose><xsl:text>&gt; &lt;pre:title></xsl:text><xsl:value-of select="title"/>&lt;/pre:title>
<xsl:text/>
    <xsl:apply-templates/>
<xsl:text/>
<xsl:text/>
<xsl:text/>&lt;/pre:chapter>
<xsl:text/>
</xsl:template>


<xsl:template match="title">
  <!-- no output, it is used by xsl:value-of in chapter -->
</xsl:template>


<xsl:template match="inset">
  <!-- no output, it is used inside evaluation. -->
  <xsl:text>
  &lt;xsl:variable name="Inset1"  &gt;
  </xsl:text><!-- xname="</xsl:text><xsl:value-of select="@label" /><xsl:text>" -->
  <xsl:apply-templates />
  <xsl:text>  
  &lt;/xsl:variable&gt;
  </xsl:text>
</xsl:template>


  <xsl:template match="topic|topictree">
    <xsl:variable name="IdentString" select="@select"/>
    <!-- build the select as text string in output xsl-script -->
    <!-- xsl:variable name="Select">/root/Topics<xsl:text/ -->
    <xsl:variable name="Select">/root/<xsl:text/>
      <xsl:call-template name="SelectTopic">
        <xsl:with-param name="IdentString" select="$IdentString"/>
      </xsl:call-template>
    </xsl:variable>
<xsl:text>
    &lt;xsl:for-each select="</xsl:text><xsl:value-of select="$Select" /><xsl:text>"&gt;
     
      &lt;xsl:call-template name="TextTopic"&gt;</xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@divStyle)>0"><xsl:text>  
          &lt;xsl:with-param name="divStyle"   select="'</xsl:text><xsl:value-of select="@divStyle" /><xsl:text>'"   /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@pStyle)>0"><xsl:text>    
          &lt;xsl:with-param name="pStyle"     select="'</xsl:text><xsl:value-of select="@pStyle" /><xsl:text>'"     /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@ulStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="ulStyle"    select="'</xsl:text><xsl:value-of select="@ulStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@olStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="olStyle"    select="'</xsl:text><xsl:value-of select="@olStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@dlStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="dlStyle"    select="'</xsl:text><xsl:value-of select="@dlStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@tableStyle)>0"><xsl:text>
          &lt;xsl:with-param name="tableStyle" select="'</xsl:text><xsl:value-of select="@tableStyle" /><xsl:text>'" /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:if test="local-name()='topictree'"><xsl:text>
          &lt;xsl:with-param name="recursive" select="'true'" /&gt;</xsl:text></xsl:if>
        <xsl:if test="not(ends-with($IdentString,'/*'))"><xsl:text>
          &lt;xsl:with-param name="withTitle" select="'true'" /&gt;</xsl:text></xsl:if><xsl:text>
      &lt;/xsl:call-template&gt;
    &lt;/xsl:for-each&gt;</xsl:text>  
    <xsl:call-template name="genErrorNotFound"><xsl:with-param name="select" select="$Select"/></xsl:call-template>
	</xsl:template>


  <xsl:template name="SelectTopic">
  <xsl:param name="IdentString"/>
    <xsl:variable name="Ident2" select="substring-after($IdentString,'/')"/>
    <xsl:variable name="Ident1" select="substring-before($IdentString,'/')"/>
    <xsl:choose>
      <xsl:when test="string-length($Ident2)>0">
        <!-- build the select as text string in output xsl-script -->
        <xsl:text>/topics:topic[@ident='</xsl:text>
          <xsl:value-of select="$Ident1"/>
        <xsl:text>']</xsl:text>

        <xsl:choose>
          <xsl:when test="$Ident2='*'">
            <!-- build the select as text string in output xsl-script -->
            <!-- xsl:text>/*</xsl:text xxx -->
          </xsl:when>
          <xsl:when test="string-length($Ident2)>0">
            <xsl:call-template name="SelectTopic">
              <xsl:with-param name="IdentString" select="$Ident2"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>/topics:topic[@ident='</xsl:text>
          <xsl:value-of select="$IdentString"/>
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
	</xsl:template>


  <xsl:template match="freemindtopic|freemindtopictree">
    <xsl:variable name="IdentString" select="@select"/>
    <!-- build the select as text string in output xsl-script -->
    <!-- xsl:variable name="Select">/root/Topics<xsl:text/ -->
    <xsl:variable name="Select">/root/map<xsl:text/>
      <xsl:call-template name="Selectfreemindtopic">
        <xsl:with-param name="IdentString" select="$IdentString"/>
      </xsl:call-template>
      <xsl:text></xsl:text>
    </xsl:variable>
    <xsl:variable name="topicIdent">
      <xsl:call-template name="Identfreemindtopic">
        <xsl:with-param name="IdentString" select="$IdentString"/>
      </xsl:call-template>
      <xsl:text></xsl:text>
    </xsl:variable>
  <xsl:text>
    &lt;xsl:for-each select="</xsl:text><xsl:value-of select="$Select" /><xsl:text>"&gt;
     
      &lt;xsl:call-template name="freemindtopic"&gt;</xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@divStyle)>0"><xsl:text>  
          &lt;xsl:with-param name="divStyle"   select="'</xsl:text><xsl:value-of select="@divStyle" /><xsl:text>'"   /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@pStyle)>0"><xsl:text>    
          &lt;xsl:with-param name="pStyle"     select="'</xsl:text><xsl:value-of select="@pStyle" /><xsl:text>'"     /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@ulStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="ulStyle"    select="'</xsl:text><xsl:value-of select="@ulStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@olStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="olStyle"    select="'</xsl:text><xsl:value-of select="@olStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@dlStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="dlStyle"    select="'</xsl:text><xsl:value-of select="@dlStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@tableStyle)>0"><xsl:text>
          &lt;xsl:with-param name="tableStyle" select="'</xsl:text><xsl:value-of select="@tableStyle" /><xsl:text>'" /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:if test="local-name()='freemindtopictree'"><xsl:text>
          &lt;xsl:with-param name="recursive" select="'true'" /&gt;</xsl:text></xsl:if>
        <xsl:if test="not(ends-with($IdentString,'/*'))"><xsl:text>
          &lt;xsl:with-param name="withTitle" select="'true'" /&gt;</xsl:text></xsl:if><xsl:text>
        &lt;xsl:with-param name="topicIdent" select="'</xsl:text><xsl:value-of select="$topicIdent" /><xsl:text>'" /&gt;
      &lt;/xsl:call-template&gt;
    &lt;/xsl:for-each&gt;</xsl:text>  
    <xsl:call-template name="genErrorNotFound"><xsl:with-param name="select" select="$Select"/></xsl:call-template>
  </xsl:template>


  <xsl:template match="freemindtable">
    <xsl:variable name="IdentString" select="@select"/>
    <!-- build the select as text string in output xsl-script -->
    <!-- xsl:variable name="Select">/root/Topics<xsl:text/ -->
    <xsl:variable name="Select">/root/map<xsl:text/>
      <xsl:call-template name="Selectfreemindtopic">
        <xsl:with-param name="IdentString" select="$IdentString"/>
      </xsl:call-template>
      <xsl:text></xsl:text>
    </xsl:variable>
<xsl:text>
    &lt;xsl:for-each select="</xsl:text><xsl:value-of select="$Select" /><xsl:text>"&gt;
     
      &lt;xsl:call-template name="freemindtable"&gt;</xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@divStyle)>0"><xsl:text>  
          &lt;xsl:with-param name="divStyle"   select="'</xsl:text><xsl:value-of select="@divStyle" /><xsl:text>'"   /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@pStyle)>0"><xsl:text>    
          &lt;xsl:with-param name="pStyle"     select="'</xsl:text><xsl:value-of select="@pStyle" /><xsl:text>'"     /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@ulStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="ulStyle"    select="'</xsl:text><xsl:value-of select="@ulStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@olStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="olStyle"    select="'</xsl:text><xsl:value-of select="@olStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@dlStyle)>0"><xsl:text>   
          &lt;xsl:with-param name="dlStyle"    select="'</xsl:text><xsl:value-of select="@dlStyle" /><xsl:text>'"    /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:text></xsl:text><xsl:choose><xsl:when test="count(@tableStyle)>0"><xsl:text>
          &lt;xsl:with-param name="tableStyle" select="'</xsl:text><xsl:value-of select="@tableStyle" /><xsl:text>'" /&gt;</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text>
        <xsl:if test="local-name()='freemindtopictree'"><xsl:text>
          &lt;xsl:with-param name="recursive" select="'true'" /&gt;</xsl:text></xsl:if>
        <xsl:if test="not(ends-with($IdentString,'/*'))"><xsl:text>
          &lt;xsl:with-param name="withTitle" select="'true'" /&gt;</xsl:text></xsl:if><xsl:text>
      &lt;/xsl:call-template&gt;
    &lt;/xsl:for-each&gt;</xsl:text>  
    <xsl:call-template name="genErrorNotFound"><xsl:with-param name="select" select="$Select"/></xsl:call-template>
  </xsl:template>


  <xsl:template name="Selectfreemindtopic">
  <xsl:param name="IdentString"/>
    <xsl:variable name="Ident2" select="substring-after($IdentString,'/')"/>
    <xsl:variable name="Ident1" select="substring-before($IdentString,'/')"/>
    <xsl:choose>
      <xsl:when test="string-length($Ident2)>0">
        <!-- build the select as text string in output xsl-script -->
        <xsl:text>/node[@TEXT='&amp;amp;</xsl:text>
          <xsl:value-of select="$Ident1"/>
        <xsl:text>']</xsl:text>

        <xsl:choose>
          <xsl:when test="$Ident2='*'">
            <!-- build the select as text string in output xsl-script -->
            <!-- xsl:text>/*</xsl:text xxx -->
          </xsl:when>
          <xsl:when test="string-length($Ident2)>0">
            <xsl:call-template name="Selectfreemindtopic">
              <xsl:with-param name="IdentString" select="$Ident2"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>/node[@TEXT='&amp;amp;</xsl:text>
          <xsl:value-of select="$IdentString"/>
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!--Build a label string for given Topic-->
  <xsl:template name="Identfreemindtopic">
  <xsl:param name="IdentString"/>
    <xsl:choose><xsl:when test="ends-with($IdentString, '/*')" >
      <xsl:variable name="sub" select="substring-before($IdentString, '/*')" />
      <xsl:value-of select="replace($sub,'/','.')" />
    </xsl:when><xsl:otherwise>
      <xsl:value-of select="replace($IdentString,'/','.')" />
    </xsl:otherwise></xsl:choose>
  </xsl:template>



  <!-- underlined output -->
  <xsl:template match="u">
<xsl:text/>&lt;p>&lt;u><xsl:value-of select="."/>&lt;/u>&lt;/p>
<xsl:text/>
  </xsl:template>


  <!-- normal output -->
  <xsl:template match="p">
<xsl:text>&lt;xhtml:body&gt;</xsl:text>
<xsl:text/>&lt;xhtml:div expandWikistyle="true"><xsl:value-of select="."/>&lt;/xhtml:div>
<xsl:text/>
<xsl:text>&lt;/xhtml:body&gt;</xsl:text>
  </xsl:template>


  <!-- include a picture -->
  <xsl:template match="picture">
    <xsl:choose><xsl:when test="count(@imgMap)>0">
      <xsl:text>
        &lt;xsl:for-each select="/root/imgMap/img[@name='</xsl:text><xsl:value-of select="@imgMap" /><xsl:text>']"&gt;
          &lt;xsl:copy-of select="." /&gt;
        &lt;/xsl:for-each&gt;
      </xsl:text>
    </xsl:when><xsl:otherwise>
      <xsl:text>&lt;img src="</xsl:text><xsl:value-of select="@file" /><xsl:text>" title="</xsl:text><xsl:value-of select="@title" /><xsl:text>" </xsl:text> 
      <xsl:if test="xPx"><xsl:text>height="</xsl:text><xsl:value-of select="number(yPx)*1" /><xsl:text>" width="</xsl:text><xsl:value-of select="number(xPx)*1" /><xsl:text>"</xsl:text></xsl:if>
      <xsl:text>/>
</xsl:text>
    </xsl:otherwise></xsl:choose>
  </xsl:template>


  <!-- umlClass -->
  <xsl:template match="umlClass_old">
<xsl:text/>&lt;xsl:call-template name="umlClass">&lt;xsl:with-param name="ident" select="'<xsl:value-of select="@select"/>'"/>&lt;/xsl:call-template>
<xsl:text/>
  </xsl:template>

  <!-- umlClassShort -->
  <xsl:template match="umlClassShort">
    <xsl:text>&lt;xsl:call-template name="umlClass"&gt;&lt;xsl:with-param name="ident" select="'</xsl:text>
    <xsl:value-of select="@select"/>
    <xsl:text>'" /&gt;&lt;xsl:with-param name="kind" select="'short'" /&gt;&lt;/xsl:call-template&gt;</xsl:text>
  </xsl:template>








  <xsl:template match="umlPkg">
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Package[@name='" />
      <xsl:with-param name="InternSelect2" select="''" />
      <xsl:with-param name="callName" select="'pkgContent'" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="umlClass">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@attributes)>0">
        <xsl:text>&lt;xsl:with-param name="attributes" select="'</xsl:text><xsl:value-of select="@attributes"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@methods)>0">
        <xsl:text>&lt;xsl:with-param name="methods" select="'</xsl:text><xsl:value-of select="@methods"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@methodstyle)>0">
        <xsl:text>&lt;xsl:with-param name="methodstyle" select="'</xsl:text><xsl:value-of select="@methodstyle"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="fromHeader">
      <xsl:if test="boolean(@header)">and boolean(@headerStruct)</xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'(UML:Class|UML:Interface)[@name='" />
      <xsl:with-param name="InternSelect2" select="$fromHeader" />
      <xsl:with-param name="callName" select="'umlClassContent'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="umlIfc">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@attributes)>0">
        <xsl:text>&lt;xsl:with-param name="attributes" select="'</xsl:text><xsl:value-of select="@attributes"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@methods)>0">
        <xsl:text>&lt;xsl:with-param name="methods" select="'</xsl:text><xsl:value-of select="@methods"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@methodstyle)>0">
        <xsl:text>&lt;xsl:with-param name="methodstyle" select="'</xsl:text><xsl:value-of select="@methodstyle"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="fromHeader">
      <xsl:if test="boolean(@header)">and boolean(@headerStruct)</xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Interface[@name='" />
      <xsl:with-param name="InternSelect2" select="$fromHeader" />
      <xsl:with-param name="callName" select="'umlClassContent'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="umlIfcMethod">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@methodstyle)>0">
        <xsl:text>&lt;xsl:with-param name="methodstyle" select="'</xsl:text><xsl:value-of select="@methodstyle"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Classifier.feature/UML:Operation[@name='" />
      <xsl:with-param name="callName" select="'umlMethodContent'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="umlMethod">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@methodstyle)>0">
        <xsl:text>&lt;xsl:with-param name="methodstyle" select="'</xsl:text><xsl:value-of select="@methodstyle"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Classifier.feature/UML:Method[@name='" />
      <xsl:with-param name="callName" select="'umlMethodContent'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
  </xsl:template>



  <xsl:template match="umlMethodBody">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@methodstyle)>0">
        <xsl:text>&lt;xsl:with-param name="methodstyle" select="'</xsl:text><xsl:value-of select="@methodstyle"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@methodblock)>0">
        <xsl:text>&lt;xsl:with-param name="methodblock" select="'</xsl:text><xsl:value-of select="@methodblock"/><xsl:text>'" /&gt;</xsl:text>
        <xsl:text>&lt;xsl:with-param name="methodblockEnd" select="'</xsl:text><xsl:value-of select="@methodblockEnd"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Classifier.feature/UML:Method[@name='" />
      <xsl:with-param name="callName" select="'umlMethodContent'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
  </xsl:template>




  <xsl:template match="xxxumlIfc">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@methods)>0">
        <xsl:text>&lt;xsl:with-param name="methods" select="'</xsl:text><xsl:value-of select="@methods"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@methodstyle)>0">
        <xsl:text>&lt;xsl:with-param name="methodstyle" select="'</xsl:text><xsl:value-of select="@methodstyle"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="fromHeader">
      <xsl:if test="boolean(@header)">and boolean(@headerStruct)</xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Interface[@name='" />
      <xsl:with-param name="InternSelect2" select="$fromHeader" />
      <xsl:with-param name="callName" select="'umlClassContent'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
	</xsl:template>


  <xsl:template match="umlStatechart">
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Class[@name='" />
      <xsl:with-param name="InternSelect2" select="''" />
      <xsl:with-param name="callName" select="'umlStatechart'" />
    </xsl:call-template>  <!-- in xsl-output variable select1 and select2 are defined. -->
	</xsl:template>



  <xsl:template match="umlComment">
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Comment[starts-with(@body,'" />
      <xsl:with-param name="InternSelect2" select="')'" />
      <xsl:with-param name="callName" select="'umlComment'" />
    </xsl:call-template>  <!-- in xsl-output variable select1 and select2 are defined. -->
	</xsl:template>


  <xsl:template match="umlSQD">
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Collaboration[@name='" />
      <xsl:with-param name="InternSelect2" select="''" />
      <xsl:with-param name="callName" select="'umlSQDdescription'" />
    </xsl:call-template>  <!-- in xsl-output variable select1 and select2 are defined. -->
	</xsl:template>


  <!-- in the older version of Rhapsody the statemachine was inside the class. -->
  <xsl:template match="OldumlStateD">
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Class[@name='" />
      <xsl:with-param name="InternSelect2" select="''" />
      <xsl:with-param name="callName" select="'umlStateD'" />
    </xsl:call-template>  <!-- in xsl-output variable select1 and select2 are defined. -->
  </xsl:template>



  <xsl:template match="umlStateD">
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:StateMachine[@name='" />
      <xsl:with-param name="InternSelect2" select="''" />
      <xsl:with-param name="callName" select="'umlStateD'" />
    </xsl:call-template>  <!-- in xsl-output variable select1 and select2 are defined. -->
  </xsl:template>



  <xsl:template match="umlStateReport">
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:StateMachine[@name='" />
      <xsl:with-param name="InternSelect2" select="''" />
      <xsl:with-param name="callName" select="'umlStateReport'" />
    </xsl:call-template>  <!-- in xsl-output variable select1 and select2 are defined. -->
  </xsl:template>



  <xsl:template match="umlEnumeration">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@content)>0">
        <xsl:text>&lt;xsl:with-param name="content" select="'</xsl:text><xsl:value-of select="@content"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Namespace.ownedElement/UML:Enumeration[@name='" />
      <xsl:with-param name="callName" select="'umlEnumeration'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="umlDatatype">
    <xsl:variable name="param">
      <!-- Assignment of the xsl-text of calling parameters in form "xsl:with-param..."
           This variable will be left empty if optional attributes are not present.
        -->
      <xsl:if test="count(@content)>0">
        <xsl:text>&lt;xsl:with-param name="content" select="'</xsl:text><xsl:value-of select="@content"/><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
      <xsl:if test="count(@title)>0">
        <xsl:text>&lt;xsl:with-param name="title" select="'</xsl:text><xsl:value-of select="@title" /><xsl:text>'" /&gt;</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:call-template name="callUmlSelect">
      <xsl:with-param name="IdentString" select="@select"/>
      <xsl:with-param name="InternSelect1" select="'UML:Namespace.ownedElement/UML:DataType[@name='" />
      <xsl:with-param name="callName" select="'umlDataType'" />
      <xsl:with-param name="callParam" select="$param"/>
    </xsl:call-template>
  </xsl:template>







  <xsl:template name="callUmlSelect">
  <!-- This template is called in any element requireness and prepares the statements in the output xsl
       to execute the selecting action.
       The Identstring is parsed and converted to the string format useable to select in docuSrc.uml.xml-file
       (xschema uml13.xsd).
       To process that, a recursively call of recursivelyBuildUmlSelect is done.
  -->
  <xsl:param name="IdentString"/>
  <xsl:param name="InternSelect1"/>
  <xsl:param name="InternSelect2"/>
  <xsl:param name="callName"/>
  <xsl:param name="callParam"/><!-- The whole string like &lt;xsl:with-param name="xyz"&gt; .... &lt;/xsl:with-param&gt; -->
    <xsl:variable name="modelSelect"><!-- supports more as one input XMI. -->
      <!-- The user can specify the model writing "MODELNAME:" at begin of the textual select string. -->
      <xsl:if test="contains(@select, ':')">
        <xsl:text>[@name='</xsl:text><xsl:value-of select="substring-before(@select,':')" /><xsl:text>']</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="select">
      <xsl:choose>
        <xsl:when test="contains(@select, ':')"><xsl:value-of select="substring-after(@select, ':')" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="@select" /></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:text>
            &lt;!-- created by callUmlSelect --&gt;
            &lt;!-- param=</xsl:text><xsl:value-of select="$callParam"/><xsl:text>  --&gt;
            &lt;xsl:for-each select="/root/XMI/XMI.content/UML:Model</xsl:text><xsl:value-of select="$modelSelect" /><xsl:text>/UML:Namespace.ownedElement/</xsl:text>
    <xsl:call-template name="recursivelyBuildUmlSelect">
      <xsl:with-param name="IdentString" select="$select"/>
      <xsl:with-param name="InternSelect1" select="$InternSelect1" />
      <xsl:with-param name="InternSelect2" select="$InternSelect2" />
      <xsl:with-param name="callName" select="$callName" />
      <xsl:with-param name="callParam" select="$callParam" />
    </xsl:call-template>

    <xsl:text>&lt;/xsl:for-each&gt;
            &lt;xsl:if test="count(/root/XMI/XMI.content/UML:Model</xsl:text><xsl:value-of select="$modelSelect" /><xsl:text>/UML:Namespace.ownedElement/</xsl:text>
    <xsl:variable name="PARAM">
      <xsl:text>&lt;xsl:with-param name="param1" select="'</xsl:text>
      <xsl:value-of select="$IdentString"/>
      <xsl:text>'"/&gt;</xsl:text>
    </xsl:variable>
    <xsl:call-template name="recursivelyBuildUmlSelect">
      <xsl:with-param name="IdentString" select="$select"/>
      <xsl:with-param name="InternSelect1" select="$InternSelect1" />
      <xsl:with-param name="InternSelect2" select="$InternSelect2" />
      <xsl:with-param name="InternSelect3" select="')=0'"/>
      <xsl:with-param name="callName" select="'errorNotFound'" />
      <xsl:with-param name="callParam" select="$PARAM" />
    </xsl:call-template>  <!-- in xsl-output variable select1 and select2 are defined. -->
    <xsl:text>&lt;/xsl:if&gt;
            </xsl:text>


	</xsl:template>


  <xsl:template name="recursivelyBuildUmlSelect">
  <!-- recursively called intern routine -->
  <xsl:param name="IdentString"/>
  <xsl:param name="InternSelect1"/>
  <xsl:param name="InternSelect2"/>
  <xsl:param name="InternSelect3"/>
  <xsl:param name="callName"/>
  <xsl:param name="callParam"/>
    <xsl:choose><xsl:when test="starts-with($IdentString,'**/')">
      <!-- the selected element should be searched at any location inside the uml tree: -->

        <xsl:text>/</xsl:text> <!-- NOTE: in XSL it is a recursive descent operator to select all childs of the actual node. -->
        <xsl:call-template name="recursivelyBuildUmlSelect">
          <xsl:with-param name="IdentString" select="substring-after($IdentString,'**/')" />
          <xsl:with-param name="InternSelect1" select="$InternSelect1"/>
          <xsl:with-param name="InternSelect2" select="$InternSelect2"/>
          <xsl:with-param name="InternSelect3" select="$InternSelect3"/>
          <xsl:with-param name="callName" select="$callName"/>
          <xsl:with-param name="callParam" select="$callParam"/>
        </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="IdentPkg" select="substring-before($IdentString,'/')"/>
      <xsl:choose><xsl:when test="string-length($IdentPkg)>0">

        <!-- selection of a package with the given name -->
        <xsl:text>UML:Package[@name='</xsl:text><xsl:value-of select="$IdentPkg"/><xsl:text>']/UML:Namespace.ownedElement/</xsl:text>
        <xsl:call-template name="recursivelyBuildUmlSelect">
          <xsl:with-param name="IdentString" select="substring-after($IdentString,'/')" />
          <xsl:with-param name="InternSelect1" select="$InternSelect1"/>
          <xsl:with-param name="InternSelect2" select="$InternSelect2"/>
          <xsl:with-param name="InternSelect3" select="$InternSelect3"/>
          <xsl:with-param name="callName" select="$callName"/>
          <xsl:with-param name="callParam" select="$callParam"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- no more '/' found, now look for '.' -->
        <xsl:variable name="IdentClass" select="substring-before($IdentString,'.')"/>
        <xsl:choose><xsl:when test="string-length($IdentClass)>0">

          <!-- selection of a class with the given name -->
          <xsl:text>(UML:Class|UML:Interface)[@name='</xsl:text><xsl:value-of select="$IdentClass"/><xsl:text>']/</xsl:text>
          <xsl:call-template name="recursivelyBuildUmlSelect">
            <xsl:with-param name="IdentString" select="substring-after($IdentString,'.')" />
            <xsl:with-param name="InternSelect1" select="$InternSelect1"/>
            <xsl:with-param name="InternSelect2" select="$InternSelect2"/>
            <xsl:with-param name="InternSelect3" select="$InternSelect3"/>
            <xsl:with-param name="callName" select="$callName"/>
            <xsl:with-param name="callParam" select="$callParam"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>

          <xsl:variable name="IdentInnerClass" select="substring-before($IdentString,'$')"/>
          <xsl:choose><xsl:when test="string-length($IdentInnerClass)>0">
  
            <!-- selection of a class with the given name -->
            <xsl:text>(UML:Class|UML:Interface)[@name='</xsl:text><xsl:value-of select="$IdentInnerClass"/><xsl:text>']/UML:Namespace.ownedElement/</xsl:text>
            <xsl:call-template name="recursivelyBuildUmlSelect">
              <xsl:with-param name="IdentString" select="substring-after($IdentString,'$')" />
              <xsl:with-param name="InternSelect1" select="$InternSelect1"/>
              <xsl:with-param name="InternSelect2" select="$InternSelect2"/>
              <xsl:with-param name="InternSelect3" select="$InternSelect3"/>
              <xsl:with-param name="callName" select="$callName"/>
              <xsl:with-param name="callParam" select="$callParam"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
  
            <!-- no more '/' or '.' or '$' found, now ends  variable "select1", the rest is "select2" -->
  
            <!-- write the last selection condition -->
            <xsl:value-of select="$InternSelect1"/>
            <xsl:text>'</xsl:text><xsl:value-of select="$IdentString"/><xsl:text>'</xsl:text>
            <xsl:value-of select="$InternSelect2"/><xsl:text>]</xsl:text><xsl:value-of select="$InternSelect3"/>
            <xsl:text>"&gt;
                </xsl:text>
  
            <!-- write the call-template -->
            <xsl:text>&lt;xsl:call-template name="</xsl:text>
            <xsl:value-of select="$callName"/>
            <xsl:text>" &gt;</xsl:text>
            <xsl:value-of select="$callParam"/>
            <xsl:text>&lt;/xsl:call-template&gt;
              </xsl:text>
          </xsl:otherwise></xsl:choose>
        </xsl:otherwise></xsl:choose>
      </xsl:otherwise></xsl:choose>

    </xsl:otherwise></xsl:choose>

	</xsl:template>




  <xsl:template match="dataStruct">
    <xsl:text>
        &lt;!-- xsl:for-each select="/root/Cheader/class[@name='</xsl:text><xsl:value-of select="@select"/><xsl:text>']" --&gt;
        &lt;xsl:for-each select="/root"&gt;
          &lt;xsl:call-template name="dataStruct"&gt;
            &lt;xsl:with-param name="className" select="'</xsl:text><xsl:value-of select="@select"/><xsl:text>'" /&gt;
          &lt;/xsl:call-template&gt;
        &lt;/xsl:for-each&gt;
        &lt;xsl:if test="count(/root/Cheader/class[@name='</xsl:text><xsl:value-of select="@select"/><xsl:text>'])=0"&gt;
          &lt;p style='standard'&gt;&lt;b&gt;ERROR: not found ---</xsl:text><xsl:value-of select="@select"/><xsl:text>---&lt;/b&gt;&lt;/p&gt;
        &lt;/xsl:if&gt;
    </xsl:text>
	</xsl:template>



  <xsl:template match="CLASS_C">
    <xsl:text>
        &lt;!-- xsl:for-each select="/root/Cheader/class[@name='</xsl:text><xsl:value-of select="@select"/><xsl:text>']" --&gt;
        &lt;xsl:for-each select="/root"&gt;
          &lt;xsl:call-template name="headerClass"&gt;
            &lt;xsl:with-param name="className" select="'</xsl:text><xsl:value-of select="@select"/><xsl:text>'" /&gt;
          &lt;/xsl:call-template&gt;
        &lt;/xsl:for-each&gt;
        &lt;xsl:if test="count(/root/Cheader/class[@name='</xsl:text><xsl:value-of select="@select"/><xsl:text>'])=0"&gt;
          &lt;p style='standard'&gt;&lt;b&gt;ERROR: not found ---</xsl:text><xsl:value-of select="@select"/><xsl:text>---&lt;/b&gt;&lt;/p&gt;
        &lt;/xsl:if&gt;
    </xsl:text>
	</xsl:template>



  <xsl:template match="DEFINE_C">
    <xsl:text>
        &lt;!-- xsl:for-each select="/root/Cheader/DEFINE_C[@name='</xsl:text><xsl:value-of select="@select"/><xsl:text>']" --&gt;
        &lt;xsl:for-each select="/root"&gt;
          &lt;xsl:call-template name="headerDefine"&gt;
            &lt;xsl:with-param name="name" select="'</xsl:text><xsl:value-of select="@select"/><xsl:text>'" /&gt;
          &lt;/xsl:call-template&gt;
        &lt;/xsl:for-each&gt;
        &lt;xsl:if test="count(/root/Cheader/DEFINE_C[@name='</xsl:text><xsl:value-of select="@select"/><xsl:text>'])=0"&gt;
          &lt;p style='standard'&gt;&lt;b&gt;ERROR: not found ---</xsl:text><xsl:value-of select="@select"/><xsl:text>---&lt;/b&gt;&lt;/p&gt;
        &lt;/xsl:if&gt;
    </xsl:text>
	</xsl:template>






  <!-- call -->
  <xsl:template match="call">
    <xsl:text/>
        &lt;xsl:for-each select="/root/<xsl:value-of select="@select"/>"&gt;
          &lt;xsl:call-template name="<xsl:value-of select="@name"/>"&gt;&lt;/xsl:call-template&gt;
        &lt;/xsl:for-each&gt;
        &lt;xsl:if test="count(/root/<xsl:value-of select="@select"/>)=0"&gt;
          &lt;xhtml:p style='standard'&gt;ERROR: not found ---<xsl:value-of select="@select"/>---&lt;/xhtml:p&gt;
        &lt;/xsl:if&gt;
<xsl:text/>
  </xsl:template>



  <xsl:template match="allRequirements">
    <xsl:text/>
      &lt;xhtml:body&gt;
        &lt;xsl:for-each select="/root//Requirement"&gt;
          &lt;xsl:call-template name="Requirement"&gt;&lt;/xsl:call-template&gt;
        &lt;/xsl:for-each&gt;
        &lt;xsl:if test="count(//Requirement)=0"&gt;
          &lt;p style='standard'&gt;&lt;b&gt;ERROR: not found ---Requirement---&lt;/b&gt;&lt;/p&gt;
        &lt;/xsl:if&gt;
      &lt;/xhtml:body&gt;
<xsl:text/>
  </xsl:template>



  <xsl:template match="crossRef">
  <!-- if the element crossRef is found, in the generated xsl script
       the superior node (should be a pre:chapter) will be getted the followed attribute.
   -->
    <xsl:text>
      &lt;xhtml:body crossRefContent="</xsl:text><xsl:value-of select="@content" /><xsl:text>"&gt;
      &lt;/xhtml:body&gt;
</xsl:text>
  </xsl:template>



  <xsl:template name="genErrorNotFound">
  <xsl:param name="select" />
    <xsl:text>
        &lt;xsl:if test="count(</xsl:text><xsl:value-of select="$select" /><xsl:text>)=0"&gt;
          &lt;xhtml:body&gt;&lt;xhtml:p style='standard'&gt;ERROR: not found ---</xsl:text><xsl:value-of select="$select" /><xsl:text>---&lt;/xhtml:p&gt;&lt;/xhtml:body&gt;
        &lt;/xsl:if&gt;
</xsl:text>
  </xsl:template>



  <xsl:template match="HyperlinkAssociation">
  </xsl:template>


</xsl:stylesheet>

