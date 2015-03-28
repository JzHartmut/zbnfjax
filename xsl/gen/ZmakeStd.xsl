<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
  extension-element-prefixes="saxon"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="XSL"
  xmlns:saxon="http://saxon.sf.net/"
>
<!-- This file is used to translate make rules given in a short text format (Zmake) to a Apache.ANT script.
  In this file all possible generating algorithm should be known. The selecting routine is contained in the first template match="....Zmake",
  look for >>>xsl:when test="@translator=<<<.
  All other xsl:template are matching to the several rules
  made by Hartmut Schorrig, www.vishia.org
  changes:
  2010-04-11 Hartmut adap because xsl:template name="evaluateInput": template name="genTargetForInput The param pathbase is used to build the srcfile1-variable to use.
  2010-04-11 Hartmut bugfix: xsl:template name="XML2XMI-inputs" uses the srcpath and the srcfile now, so a pathbase can be given in the inputSet of the input files
                             which is used only for converting the headerfiles to xml. The XMI-builder uses only the local path/name.ext.  
  2010-04-11 Hartmut chg: xsl:template name="evaluateInput" gets 1 new param: srcpath. It is the srcpath=... param evaluated in the input or inputSet node.
                          The param srcfile does not the pathbase and the srcpath now, only the local path/name.ext.
						  Therfore all called routines should be adapted to this change. See above.
  2010-01-02 Hartmut bugfix: <xsl:template name="XML2XMI"> output.xmi was written in ${tmp}/* 
  2009-06-15 Hartmut: corr: xsl:template name="evaluateInput", the with-param pathbase should contain also the pathbase data of the input node.
  2007-2009 some changes
  2007-01-01 creation Hartmut Schorrig, www.vishia.org
  -->
<xsl:output method="xml" encoding="ISO-8859-1"/>
<xsl:param name="ctrl" select="'?'" /><!-- it is a control parameter from outside. -->
<xsl:param name="tmp" select="'../tmp'" /><!-- it is a control parameter from outside. -->

<xsl:variable name="curDir"><xsl:text>${curDir}</xsl:text></xsl:variable>
<xsl:variable name="env.ZBNFJAX_HOME"><xsl:text>${env.ZBNFJAX_HOME}</xsl:text></xsl:variable>
<xsl:variable name="ClasspathZbnf"><xsl:text>-cp ${env.JAVACP_XSLT}</xsl:text></xsl:variable>
<xsl:variable name="ClasspathXslt"><xsl:text>-cp ${env.JAVACP_XSLT}</xsl:text></xsl:variable>
<xsl:variable name="ClasspathHeader2Reflection"><xsl:text>-cp ${env.JAVACP_Header2Reflection}</xsl:text></xsl:variable>




<!-- ROOT TEMPLATE ************************************************************************************************-->
<xsl:template match= "/root/Zmake | /Zmake">
<project name="ZmakeAnt" default="ZmakeAnt" basedir=".">
  <xsl:comment>Generated with ZmakeStd.xslp </xsl:comment>
  <!-- taskdef name="Zcopy" classname="org.vishia.ant.Zcopy" / -->
  <property environment="env" />
  
  <property name="tmp" value="{$tmp}" />
  
  <xsl:variable name="depends">
    <xsl:for-each select="target|forInput">
      <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
      <xsl:text></xsl:text><xsl:value-of select="$targetName" /><xsl:text></xsl:text><xsl:choose><xsl:when test="last()>position()"><xsl:text>,</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text><!-- The first output file determines the name of the template. -->
    </xsl:for-each>
  </xsl:variable>
  
  <xsl:comment>This target is the start target, it produces a screen-output and calls than all targets for result elements. </xsl:comment>
  <xsl:text>
    </xsl:text>
  <target name="ZmakeAnt" description="ZmakeStd.xslp:The whole xmake">
    <echo message="current dir: {'${curDir}'}" />
    <echo message="ZBNFJAX_HOME: {'${env.ZBNFJAX_HOME}'}" />
    <antcall target="ZmakeAntExec"/>
  </target>
  
  <xsl:comment>This target contains the dependency to all result elements. </xsl:comment>
  <xsl:text>
    </xsl:text>
    <target name="ZmakeAntExec"  description="ZmakeStd.xslp:The whole xmake1"
    depends="{$depends}" >
  </target>
  
  <!-- The loop for all founded target in input -->
  <xsl:for-each select="target|forInput">
    <xsl:choose><xsl:when test="local-name()='forInput'"><!-- do-element, a rule is given-->
      <xsl:call-template name="genTarget-forInput" />
    </xsl:when><xsl:otherwise>
      <xsl:call-template name="genTarget_ZmakeStd" />
    </xsl:otherwise></xsl:choose>
  </xsl:for-each>
  
  <target name="ZmakeDummy"></target>
  

  <xsl:call-template name="genXsltpreStandardTargets" />
  
</project>

</xsl:template>



<!-- call for each <target> -->
<xsl:template name="genTarget_ZmakeStd">
<!-- current node should be target, in ZBNF target::= -->
<!-- generates the requested target depending from the "target/@translator" -->
  <xsl:variable name="targetfile"><xsl:for-each select="output"><xsl:call-template name="absPathfile" /></xsl:for-each></xsl:variable>
  <!-- targets without isUptodate and wiht special target frame: -->
  <xsl:text>
        

  </xsl:text>
  <xsl:choose><xsl:when test="doForAll"><xsl:call-template name="doForAll"/>
  </xsl:when><xsl:when test="for-exec"><xsl:call-template name="target_for-exec"/>
  </xsl:when><xsl:when test="execCmd"><xsl:call-template name="target_exec"/>
  </xsl:when><xsl:when test="do"><xsl:call-template name="specials"/>
  </xsl:when><xsl:when test="@translator='Xsltpre'"><xsl:call-template name="Xsltpre"/>
  </xsl:when><xsl:when test="@translator='exec'"><xsl:call-template name="execCmd"/>
  </xsl:when><xsl:when test="@translator='zbnfCheader'"><xsl:call-template name="zbnfCheader"/>
  </xsl:when><xsl:when test="@translator='zbnfJava'"><xsl:call-template name="zbnfJava"/>
  </xsl:when><xsl:when test="@translator='genXmiFromZbnfCheader'"><xsl:call-template name="genXmiFromZbnfCheader"/>
  </xsl:when><xsl:when test="@translator='file2Html'"><xsl:call-template name="file2Html"/>
  </xsl:when><xsl:when test="@translator='stdMake' or @translator='msMake'">
    <xsl:call-template name="genTargetWithAvaileableTestFirstInput_UptodateAllInput">
      <xsl:with-param name="genExec" select="@translator" />
      <xsl:with-param name="targetfile" select="$targetfile" />
    </xsl:call-template>
  </xsl:when><xsl:when test="@translator='copyNewerFiles'"><xsl:call-template name="copyNewerFiles"/>
  </xsl:when><xsl:when test="@translator='copyFiles'"><xsl:call-template name="copyFiles"/>
  </xsl:when><xsl:when test="@translator='copyChangedFiles'"><xsl:call-template name="copyChangedFiles"/>
  </xsl:when><xsl:otherwise>
    <!-- targets with isUptodate and common target frame: -->
    <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
    <xsl:variable name="isUptodate"><xsl:text>isUptodate_</xsl:text><xsl:value-of select="$targetName" /></xsl:variable>
    <xsl:comment>generated ANT-targets from src:  destination :={$targetName}..., in ZBNF target::=... </xsl:comment>
    <xsl:text>
    </xsl:text>
    <target name="{$targetName}" description="ZmakeStd.xslp:{inputSet/@name}">
      <xsl:if test="input | inputSet" >
        <xsl:attribute name="depends"><xsl:value-of select="$isUptodate" /></xsl:attribute>
        <xsl:attribute name="unless"><xsl:value-of select="$isUptodate" /></xsl:attribute>
      </xsl:if>
      <xsl:comment>Generated with ZmakeStd.xslp:genTarget_ZmakeStd </xsl:comment>

      <!-- depends="{$isUptodate}" unless="{$isUptodate}" -->
      <xsl:choose><xsl:when test="@translator='genMsg_h'"><xsl:call-template name="genMsg_h"/>
      </xsl:when><xsl:when test="@translator='Cheader2ReflectionC'">
        <xsl:call-template name="Cheader2Reflection"><xsl:with-param name="c_only" select="'c_only'" /><xsl:with-param name="targetfile" select="$targetfile" /></xsl:call-template>
      </xsl:when><xsl:when test="@translator='Cheader2Reflection'">
        <xsl:call-template name="Cheader2Reflection"><xsl:with-param name="targetfile" select="$targetfile" /></xsl:call-template>
      </xsl:when><xsl:when test="@translator='genXmiFromHeader2'"><xsl:call-template name="genXmiFromHeader2"/>
      </xsl:when><xsl:when test="@translator='genXmiFromHeader'"><xsl:call-template name="genXmiFromHeaderTarget"/>
      </xsl:when><xsl:when test="@translator='javaXML2XMI'"><xsl:call-template name="javaXML2XMI"/>
      </xsl:when><xsl:when test="@translator='CHeaderXML2XMI'"><xsl:call-template name="CHeaderXML2XMI"/>
      </xsl:when><xsl:when test="@translator='CHeader2JavaByteCoding'"><xsl:call-template name="CHeader2JavaByteCoding"/>
      </xsl:when><xsl:when test="@translator='zipFiles'"><xsl:call-template name="zipFiles"/>
      </xsl:when><xsl:otherwise><echo message="no rule found for {@translator}" />
      </xsl:otherwise></xsl:choose>
    </target>

    <xsl:if test="input | inputSet" >
    <target name="{$isUptodate}"  description="ZmakeStd.xslp:genTarget_ZmakeStd-uptd">
      <xsl:comment>Generated with ZmakeStd.xslp:genTarget_ZmakeStd </xsl:comment>
      <uptodate property="{$isUptodate}" targetfile="{$targetfile}">
        <xsl:call-template name="evaluateInput">
          <xsl:with-param name="call" select="'uptodateSource'" />
        </xsl:call-template>
      </uptodate>
    </target>
    </xsl:if>
  </xsl:otherwise></xsl:choose>
</xsl:template>  
    
      
        
          


<!-- for(input) dst := exec -->
<xsl:template name="genTarget-forInput">
  <xsl:variable name="dotarget" select="@target" />
  <xsl:variable name="depends">
    <xsl:for-each select="input">
      <xsl:text></xsl:text><xsl:value-of select="$dotarget" /><xsl:text>-</xsl:text><xsl:value-of select="@file" /><xsl:text>,</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="inputSet">
      <xsl:variable name="nameInputSet" select="@name" />
      <xsl:for-each select="/.//variable[@name=$nameInputSet]/fileset/file">
        <xsl:text></xsl:text><xsl:value-of select="$dotarget" /><xsl:text>-</xsl:text><xsl:value-of select="@file" /><xsl:text>,</xsl:text>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:text></xsl:text><xsl:value-of select="$dotarget" /><xsl:text>-lastdummy</xsl:text>
  </xsl:variable>
  
  <xsl:text>
        

  </xsl:text>
  <!-- The depends target for all members of this do -->
  <target name="{$dotarget}" description="ZmakeStd:xslp:genTargetsPerRule({@rule})" depends="{$depends}">

  </target>
  <target name="{$dotarget}-lastdummy" description="ZmakeStd.xslp:genTarget-forInput-dummy" />

  <!-- all targets for inputs -->
  <xsl:call-template name="evaluateInput">
    <xsl:with-param name="call" select="'exec-genTarget-forInput'" />
    <xsl:with-param name="p1" select="$dotarget" />
    <xsl:with-param name="p2" select="." /><!-- The xmlNode in <target/for-exec> where <execCmd>, <execVariable>, <dst> is found. -->
    <xsl:with-param name="p3" select="curdir" /><!-- cmdDir -->
  </xsl:call-template>
</xsl:template>

<!-- Called for each input of a do target:Rule(input,...) 
     actual node: any <input>, or <fileset/file>
  -->
<xsl:template name="exec-genTarget-forInput">
<xsl:param name="p1" /><!-- The name of the do-target -->
<xsl:param name="p2" /><!-- The xmlNode in <target/for-exec> where <execCmd>, <execVariable>, <dst> is found. -->
<xsl:param name="p3" /><!-- cmdDir -->
<xsl:param name="p4" />
  <xsl:variable name="xmlInput" select="." />
  <xsl:variable name="dst" ><!-- The dst of the rule, assembled from content of rule variable + input node -->
    <xsl:for-each select="$p2">
      <xsl:call-template name="concatString"><xsl:with-param name="xmlInput" select="$xmlInput" /></xsl:call-template>
    </xsl:for-each>
  </xsl:variable>
  <xsl:text>
        

  </xsl:text>
  <target name="{$p1}-{@file}" description="generated by ZmakeStd.xsl, exec-genTarget-forInput" >
    <xsl:comment><xsl:value-of select="$dst" /></xsl:comment>  
    <xsl:for-each select="$p2"><!-- context is <for-exec>, where <execCmd> or <execVariable> is found. -->
      <xsl:call-template name="gen_exec">
        <xsl:with-param name="xmlInput" select="$xmlInput" />
        <xsl:with-param name="cmdDir" select="$p3" />
      </xsl:call-template>
    </xsl:for-each>     
  </target>
</xsl:template>
  





            


<!-- called if for(...): exec is found. -->
<xsl:template name="target_for-exec">
  <xsl:variable name="dotarget"><xsl:call-template name="targetName" /></xsl:variable>
  <xsl:variable name="cmdDir"><xsl:text></xsl:text><xsl:choose><xsl:when test="param[@name='curDir']"><xsl:text></xsl:text><xsl:value-of select="param[@name='curDir']/@value" /><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text></xsl:text><xsl:value-of select="$curDir" /><xsl:text></xsl:text></xsl:otherwise></xsl:choose><xsl:text></xsl:text></xsl:variable>
  <xsl:variable name="cmdDir2">
    <xsl:for-each select="param[@name='curDir']"><xsl:call-template name="pathbase_Reg_srcpath" /></xsl:for-each>
  </xsl:variable>
  <xsl:variable name="depends">
    <xsl:for-each select="for-exec/input">
      <xsl:text></xsl:text><xsl:value-of select="$dotarget" /><xsl:text>-</xsl:text><xsl:value-of select="@file" /><xsl:text>,</xsl:text>
    </xsl:for-each>
    <xsl:for-each select="for-exec/inputSet">
      <xsl:variable name="nameInputSet" select="@name" />
      <xsl:for-each select="/.//variable[@name=$nameInputSet]/fileset/file">
        <xsl:text></xsl:text><xsl:value-of select="$dotarget" /><xsl:text>-</xsl:text><xsl:value-of select="@file" /><xsl:text>,</xsl:text>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:text></xsl:text><xsl:value-of select="$dotarget" /><xsl:text>-lastdummy</xsl:text>
  </xsl:variable>
  
  <xsl:text>
        

  </xsl:text>
  <!-- The depends target for all members of this do -->
  <target name="{$dotarget}" description="ZmakeStd.xslp:for-inputs-exec" depends="{$depends}">

  </target>
  <target name="{$dotarget}-lastdummy"  description="ZmakeStd.xslp:target_for-exec-dummy"/>

  <!-- all targets for inputs -->
  <xsl:for-each select="for-exec" >
    <xsl:call-template name="evaluateInput">
      <xsl:with-param name="call" select="'exec_do'" />
      <xsl:with-param name="p1" select="$dotarget" />
      <xsl:with-param name="p2" select="." /><!-- The xmlNode in <target/for-exec> where <execCmd> is found. -->
      <xsl:with-param name="p3" select="$cmdDir" /><!-- cmdDir -->
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>




<!-- Called for each input of a for(input) exec... 
     actual node: any <input>, or <fileset/file>
  -->
<xsl:template name="exec_do">
<xsl:param name="p1" /><!-- The name of the do-target -->
<xsl:param name="p2" /><!-- The xmlNode in <target/for-exec> where <execCmd> is found. -->
<xsl:param name="p3" /><!-- cmdDir -->
<xsl:param name="p4" />
  <xsl:variable name="xmlInput" select="." />
  <xsl:text>
        

  </xsl:text>
  <target name="{$p1}-{@file}" description="ZmakeStd.xslp:for-exec" >
    <xsl:for-each select="$p2"><!-- context is <for-exec>, where <execCmd> or <execVariable> is found. -->
      <xsl:call-template name="gen_exec">
        <xsl:with-param name="xmlInput" select="$xmlInput" />
        <xsl:with-param name="cmdDir" select="$p3" />
      </xsl:call-template>
    </xsl:for-each>     
  </target>
</xsl:template>
  





<!-- call if mkdir(...) is found. -->
<xsl:template name="specials"><!-- see execCmd -->
  <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
  <target name="{$targetName}" description="ZmakeStd.xslp:specials">
    <xsl:for-each select="do/(mkdir|deltree|execCmd)">
      <xsl:variable name="name" select="local-name()" />
        <saxon:call-template name="{$name}" />
    </xsl:for-each>
    <!-- xsl:apply-templates select="do/(mkdir|deltree|execCmd)" / -->
  </target>
</xsl:template>


<xsl:template name="mkdir">
  <mkdir dir="{text()}" />
</xsl:template>


<!-- call if exec { ... } is found. -->
<xsl:template name="target_exec"><!-- see execCmd -->
  <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
  <xsl:variable name="cmdDir"><xsl:text></xsl:text><xsl:choose><xsl:when test="param[@name='curDir']"><xsl:text></xsl:text><xsl:value-of select="param[@name='curDir']/@value" /><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text></xsl:text><xsl:value-of select="$curDir" /><xsl:text></xsl:text></xsl:otherwise></xsl:choose><xsl:text></xsl:text></xsl:variable>
  <xsl:variable name="cmdDir2">
    <xsl:for-each select="param[@name='curDir']"><xsl:call-template name="pathbase_Reg_srcpath" /></xsl:for-each>
  </xsl:variable>
  <target name="{$targetName}" description="generated from ZmakeStd.xslp:execCmd">
    <!-- echo message="execute {$cmd}" / -->
    <xsl:variable name="xmlInput" select="." /><!-- The <target> may contain <input> or <inputSet> -->
     <xsl:call-template name="gen_exec">
       <xsl:with-param name="xmlInput" select="$xmlInput" />
       <xsl:with-param name="cmdDir" select="$cmdDir" />
     </xsl:call-template>   
  </target>  
  
</xsl:template>

<!-- generates <exec ...> (more as one possible)
  current xml node is node, where <execCmd> or <execVariable> is located. 
  -->
<xsl:template name="gen_exec">
<xsl:param name="xmlInput" />
<xsl:param name="cmdDir" />
  <xsl:for-each select="execCmd|execVariable"><!-- more as one <exec ...> -->
    <xsl:choose><xsl:when test="local-name()=('execVariable')">
      <xsl:variable name="execVariableName" select="@name" />
      <xsl:comment> execVariable: <xsl:value-of select="$execVariableName" /></xsl:comment>
      <xsl:variable name="cmdVariable" select="/.//variable[@name=$execVariableName]" />
      <xsl:for-each select="$cmdVariable">
        <xsl:call-template name="gen_exec"><!-- call recursively with currrent node inside variable -->
          <xsl:with-param name="xmlInput" select="$xmlInput" />
          <xsl:with-param name="cmdDir" select="$cmdDir" />
        </xsl:call-template>
      </xsl:for-each> 
    </xsl:when><xsl:otherwise>  
      <xsl:variable name="executable">
        <xsl:for-each select="executable">
          <xsl:call-template name="concatString">
            <xsl:with-param name="xmlInput" select="xxx" /><!-- no input available here.-->
          </xsl:call-template>  
        </xsl:for-each>  
      </xsl:variable>
      <!-- a curdir to execute the command may be given in the < execCmd > -->
      <xsl:variable name="cmdDirLocal">
        <xsl:choose><xsl:when test="curdir"><xsl:text>${curDir}/</xsl:text><xsl:value-of select="curdir" />
        </xsl:when><xsl:otherwise><xsl:value-of select="$cmdDir" />
        </xsl:otherwise></xsl:choose>
      </xsl:variable>
      <xsl:text>
        
      </xsl:text>
      <exec dir="{$cmdDirLocal}" executable= "{$executable}" failonerror="true">
        <xsl:for-each select="arg">
          <xsl:variable name="arg">
            <xsl:call-template name="concatString"><xsl:with-param name="xmlInput" select="$xmlInput" /></xsl:call-template>
          </xsl:variable>
          <arg line="{$arg}" />
        </xsl:for-each>
      </exec>
    </xsl:otherwise></xsl:choose>
  </xsl:for-each>  
</xsl:template>



              
                
<!-- This template translates a Zmake-expression like

       tmp/*.zbnf.xml := file2Html($Headerfiles);

     in some targets to translate the individually files from special text formats to html readable text.
     a common target is build with the depends of all some translating targets.
 -->
<xsl:template name="file2Html">
  <xsl:comment>Generated with ZmakeStd.xslp:file2Html, calling genTargetForEachInput:exec_file2Html </xsl:comment>
  <xsl:call-template name="genTargetForEachInput">
    <xsl:with-param name="genExecForEachInput" select="'exec_file2Html'" />
    <xsl:with-param name="xmlTool_srcFiles" >
      <srcfiles file="{'${env.ZBNFJAX_HOME}/Xslt.jar'}" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="exec_file2Html">
<xsl:param name="targetfile" />
<xsl:param name="srcfile" />
<xsl:param name="xmlInputNode" />
<xsl:param name="xmlTargetNode" />
  <echo message="gen HTML" />
  <exec dir="{$curDir}" executable= "java" failonerror="false">
    <xsl:variable name="i"><xsl:text>-i</xsl:text><xsl:value-of select="@srcpath" /><xsl:text>/</xsl:text><xsl:value-of select="@srcfile" /></xsl:variable>
    <xsl:variable name="o"><xsl:text>-o../html/</xsl:text><xsl:value-of select="@srcfile" /><xsl:value-of select="@dstext"/></xsl:variable>
    <arg line="{$ClasspathXslt}" />
    <arg line ="{'org.vishia.xml.Textfile2Html'}" />
    <arg line="{'-i'}{$srcfile}" />
    <arg line="{'-o'}{$targetfile}" />
  </exec>
</xsl:template>





<xsl:template name="execCmd">
  <xsl:variable name="cmdDir1"><xsl:text></xsl:text><xsl:choose><xsl:when test="param[@name='curDir']"><xsl:text></xsl:text><xsl:value-of select="param[@name='curDir']/@value" /><xsl:text></xsl:text></xsl:when><xsl:otherwise><xsl:text></xsl:text><xsl:value-of select="$curDir" /><xsl:text></xsl:text></xsl:otherwise></xsl:choose><xsl:text></xsl:text></xsl:variable>
  <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
  <xsl:variable name="cmdDir">
    <xsl:for-each select="param[@name='cmd']"><xsl:call-template name="pathbase_Reg_srcpath" /></xsl:for-each>
  </xsl:variable>
  <xsl:variable name="cmd"><xsl:value-of select="param[@name='cmd']/@value" /></xsl:variable>
  <target name="{$targetName}" description="generated from ZmakeStd.xslp:execCmd">
    <echo message="execute {$cmd}" />
    <exec dir="{$cmdDir}" executable= "{$cmd}" failonerror="true">
      <xsl:for-each select="param[@name='arg']">
        <arg line="{param[@name='arg']/@value}" />
      </xsl:for-each>
    </exec>
  </target>  
</xsl:template>



<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="genMsg_h">
  <echo message="XmakeAnt.xslp template genMsg_: generate {output/@path}{output/@file}" />
  <echo message="input: {input/@path}{input/@file}.xml" />
  <echo message="ZBNFJAX_HOME=${'{env.ZBNFJAX_HOME}'}/xslt.jar" />
  <xsl:comment>Generated with ZmakeStd.xslp:genMsg_h </xsl:comment>
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <xsl:variable name="i"><xsl:text>-i</xsl:text><xsl:value-of select="@srcpath" /><xsl:text>/</xsl:text><xsl:value-of select="@srcfile" /></xsl:variable>
    <xsl:variable name="o"><xsl:text>-o../html/</xsl:text><xsl:value-of select="@srcfile" /><xsl:value-of select="@dstext"/></xsl:variable>
    <xsl:variable name="s"><xsl:text>-o../html/</xsl:text><xsl:value-of select="@srcfile" /><xsl:value-of select="@dstext"/></xsl:variable>
    <arg line="{$ClasspathZbnf}" />
    <arg line ="org.vishia.zbnfXml.Zbnf2Xml" />
	  <arg line="-i{input/@path}{input/@file}{input/@ext}" />
    <arg line="-s{'${env.ZBNFJAX_HOME}'}/XslTRA/OamMessages.sbnf" />
	  <arg line="-y{'${tmp}'}/{input/@file}.sbnf.xml" />
  </exec>
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <arg line="{$ClasspathXslt}{';${env.ZBNFJAX_HOME}/saxon8.jar'}" />
    <arg line ="net.sf.saxon.Transform" />
	  <arg line="-o {output/@path}{output/@file}.h" />
	  <arg line="{'${tmp}'}/{input/@file}.sbnf.xml" />
	  <arg line="{'${env.ZBNFJAX_HOME}'}/XslTRA/gen/OamMessages_WinCC.xsl" />
  </exec>
</xsl:template>






<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<!-- NOTE: its the oldest variant, TODO check if it is necessary-->
<xsl:template name="genXmiFromHeaderTarget">
  <xsl:comment>Generated with ZmakeStd.xslp:genXmiFromHeaderTarget </xsl:comment>
  <echo message="gen XMI from Header" />
  <!-- ZBNFparser-->
  <xsl:for-each select=".//input[boolean(@file)]">
    <xsl:variable name="filepath"><xsl:text></xsl:text><xsl:value-of select="../param[@name='srcpath']/@value" /><xsl:text></xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text>.h</xsl:text></xsl:variable>
    <xsl:variable name="msg"><xsl:text>parsing with zbnf/Cheader.zbnf: </xsl:text><xsl:value-of select="$filepath" /><xsl:text></xsl:text></xsl:variable>
    <echo message="{$msg}" />
    <exec dir="{$curDir}" executable= "java" failonerror="true">
      <!-- arg line="{$ClasspathZbnf}" / -->
      <arg line ="org.vishia.zbnf.Zbnf2Xml" />
      <xsl:variable name="i"><xsl:text>-i</xsl:text><xsl:value-of select="$filepath" /><xsl:text></xsl:text></xsl:variable>
      <arg line="{$i}" />
      <arg line="{'-s${env.ZBNFJAX_HOME}/zbnf/Cheader.zbnf'}" />
      <xsl:variable name="o"><xsl:text>-y${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$o}" />
      <arg line="{'--report:${tmp}/zbnf.rpt --rlevel:334'}" />
    </exec>
  </xsl:for-each>
  <!-- generate .types.xml -->
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <!-- arg line="{$ClasspathXslt}" / -->
    <arg line ="org.vishia.xml.Xslt" />
    <xsl:for-each select="input">
      <xsl:variable name="i"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$i}" />
    </xsl:for-each>
    <arg line="{'-t${env.ZBNFJAX_HOME}/xsl/CHeaderTypes.xsl'}" />
    <arg line="-w+" />
    <xsl:variable name="o"><xsl:text>-y${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.types.xml</xsl:text></xsl:variable>
    <arg line="{$o}" />
  </exec>
  <!-- generate XMI -->
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <!-- arg line="{$ClasspathXslt}" / -->
    <arg line ="org.vishia.xml.Xslt" />
    <xsl:for-each select=".//input[boolean(@file)]">
      <xsl:variable name="i"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$i}" />
    </xsl:for-each>
    <xsl:variable name="iTypes"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.types.xml</xsl:text></xsl:variable>
    <arg line="{$iTypes}" />
    <arg line="{'-t:${tmp}/Cheader2Xmi.xsl'}" />
    <arg line="-w+" />
    <xsl:variable name="y"><xsl:text>-y</xsl:text><xsl:value-of select="output/@file" /><xsl:text></xsl:text><xsl:value-of select="output/@ext" /><xsl:text></xsl:text></xsl:variable>
    <arg line="{$y}" />
  </exec>
</xsl:template>



<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="javaXML2XMI">
  <xsl:call-template name="XML2XMI">
    <xsl:with-param name="XML2Types_xsl" select="'${env.ZBNFJAX_HOME}/xsl/Java2xmiTypes.xsl'" />
    <xsl:with-param name="XML2XMI_xsl" select="'${env.ZBNFJAX_HOME}/xsl/gen/Java2xmi.xsl'" />
  </xsl:call-template>
</xsl:template>
  

<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="CHeaderXML2XMI">
  <xsl:call-template name="XML2XMI">
    <xsl:with-param name="XML2Types_xsl" select="'${env.ZBNFJAX_HOME}/xsl/CheaderTypes.xsl'" />
    <xsl:with-param name="XML2XMI_xsl" select="'${env.ZBNFJAX_HOME}/xsl/gen/Cheader2Xmi.xsl'" />
  </xsl:call-template>
</xsl:template>
  

<!-- internal template for XML2XMI used both for Java and CHeader -->    
<xsl:template name="XML2XMI">
<xsl:param name="XML2Types_xsl" />  
<xsl:param name="XML2XMI_xsl" />  
  <xsl:comment><xsl:text>Generated by ZmakeStd.xslp:XML2XMI: </xsl:text><xsl:value-of select="$XML2XMI_xsl" /><xsl:text></xsl:text></xsl:comment>
  <echo message="XML2XMI" />
  <!-- generate .types.xml -->
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <!-- arg line="{$ClasspathXslt}" / -->
    <arg line ="org.vishia.xml.Xslt" />
    <xsl:call-template name="evaluateInput"><xsl:with-param name="call" select="'XML2XMI-inputs'" /></xsl:call-template>

    <xsl:for-each select="input">
      <xsl:variable name="i"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$i}" />
    </xsl:for-each>
    <arg line="{'-t'}{$XML2Types_xsl}" />
    <xsl:variable name="o"><xsl:text>-y:${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.XmiTypes.xml</xsl:text></xsl:variable>
    <arg line="{$o}" />
  </exec>
  <!-- generate XMI -->
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <!-- arg line="{$ClasspathXslt}" / -->
    <arg line ="org.vishia.xml.Xslt" />
    <xsl:call-template name="evaluateInput"><xsl:with-param name="call" select="'XML2XMI-inputs'" /></xsl:call-template>
    <xsl:variable name="iTypes"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.XmiTypes.xml</xsl:text></xsl:variable>
    <arg line="{$iTypes}" />
    <arg line="{'-t'}{$XML2XMI_xsl}" />
    <arg line="-w+" />
    <xsl:variable name="y"><xsl:text>-y:</xsl:text><xsl:value-of select="output/@file" /><xsl:text></xsl:text><xsl:value-of select="output/@ext" /><xsl:text></xsl:text></xsl:variable>
    <arg line="{$y}" />
  </exec>
</xsl:template>



<xsl:template name="XML2XMI-inputs">
<xsl:param name="srcpath" />  
<xsl:param name="srcfile" />  
  <arg line="{'-i:'}{$srcpath}{$srcfile}" /><xsl:comment>TEST1</xsl:comment>  
</xsl:template>




  <!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="genXmiFromHeader2">
  <xsl:comment>Generated with ZmakeStd.xslp :genXmiFromHeader2 </xsl:comment>
  <echo message="gen XMI from Header" />
  <!-- ZBNFparser-->
  <xsl:for-each select=".//input[boolean(@file)]">
    <xsl:variable name="filepath"><xsl:text></xsl:text><xsl:value-of select="../param[@name='srcpath']/@value" /><xsl:text></xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text>.h</xsl:text></xsl:variable>
    <xsl:variable name="msg"><xsl:text>parsing with zbnf/Cheader.zbnf: </xsl:text><xsl:value-of select="$filepath" /><xsl:text></xsl:text></xsl:variable>
    <echo message="{$msg}" />
    <exec dir="{$curDir}" executable= "java" failonerror="true">
      <!-- arg line="{$ClasspathZbnf}" / -->
      <arg line ="org.vishia.zbnf.Zbnf2Xml" />
      <xsl:variable name="i"><xsl:text>-i</xsl:text><xsl:value-of select="$filepath" /><xsl:text></xsl:text></xsl:variable>
      <arg line="{$i}" />
      <arg line="{'-s${env.ZBNFJAX_HOME}/zbnf/Cheader.zbnf'}" />
      <xsl:variable name="o"><xsl:text>-y${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$o}" />
      <arg line="{'--report:${tmp}/zbnf.rpt --rlevel:334'}" />
    </exec>
  </xsl:for-each>
  <!-- generate .types.xml -->
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <!-- arg line="{$ClasspathXslt}" / -->
    <arg line ="org.vishia.xml.Xslt" />
    <xsl:for-each select="input">
      <xsl:variable name="i"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$i}" />
    </xsl:for-each>
    <arg line="{'-t${env.ZBNFJAX_HOME}/xsl/CheaderTypes.xsl'}" />
    <arg line="-w+" />
    <xsl:variable name="o"><xsl:text>-y${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.types.xml</xsl:text></xsl:variable>
    <arg line="{$o}" />
  </exec>
  <!-- generate XMI -->
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <!-- arg line="{$ClasspathXslt}" / -->
    <arg line ="org.vishia.xml.Xslt" />
    <xsl:for-each select=".//input[boolean(@file)]">
      <xsl:variable name="i"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$i}" />
    </xsl:for-each>
    <xsl:variable name="iTypes"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.types.xml</xsl:text></xsl:variable>
    <arg line="{$iTypes}" />
    <arg line="{'-t:${tmp}/Cheader2Xmi.xsl'}" />
    <arg line="-w+" />
    <xsl:variable name="y"><xsl:text>-y</xsl:text><xsl:value-of select="output/@file" /><xsl:text></xsl:text><xsl:value-of select="output/@ext" /><xsl:text></xsl:text></xsl:variable>
    <arg line="{$y}" />
  </exec>
</xsl:template>






<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="CHeader2JavaByteCoding">
  <xsl:comment>Generated with ZmakeStd.xslp: CHeader2JavaByteCoding </xsl:comment>
  <!-- ZbnfParser-->
  <xsl:for-each select=".//input[boolean(@file)]">
    <xsl:variable name="filepath"><xsl:text></xsl:text><xsl:value-of select="../param[@name='srcpath']/@value" /><xsl:text></xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text>.h</xsl:text></xsl:variable>
    <xsl:variable name="msg"><xsl:text>gen CHeader2JavaByteCoding: parsing </xsl:text><xsl:value-of select="$filepath" /><xsl:text></xsl:text></xsl:variable>
    <echo message="{$msg}" />
    <exec dir="{$curDir}" executable= "java" failonerror="true">
      <arg line="{$ClasspathZbnf}" />
      <arg line ="org.vishia.zbnf.Zbnf2Xml" />
      <xsl:variable name="i"><xsl:text>-i</xsl:text><xsl:value-of select="$filepath" /><xsl:text></xsl:text></xsl:variable>
      <arg line="{$i}" />
      <arg line="{'-s${env.ZBNFJAX_HOME}/zbnf/Cheader.zbnf'}" />
      <xsl:variable name="o"><xsl:text>-y${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
      <arg line="{$o}" />
      <xsl:variable name="report"><xsl:text>--report:${tmp}/</xsl:text><xsl:value-of select="@file" /><xsl:text>.zbnf.rpt --rlevel:335</xsl:text></xsl:variable>
      <arg line="{$report }" />
    </exec>
  </xsl:for-each>
  <xsl:variable name="outPathFile"><xsl:text></xsl:text><xsl:value-of select="output/@pathbase" /><xsl:text></xsl:text><xsl:choose><xsl:when test="output/@pathbase"><xsl:text>/</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text><xsl:value-of select="output/@path" /><xsl:text></xsl:text><xsl:value-of select="output/@file" /><xsl:text></xsl:text><xsl:value-of select="output/@ext" /><xsl:text></xsl:text></xsl:variable>
  <delete file="{$outPathFile}" />
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <arg line="{$ClasspathXslt}" />
    <arg line ="net.sf.saxon.Transform" />

    <xsl:variable name="s"><xsl:text>-s ${tmp}/</xsl:text><xsl:value-of select="input[1]/@file" /><xsl:text>.zbnf.xml</xsl:text></xsl:variable>
    <arg line="{$s}" />

    <xsl:variable name="o"><xsl:text>-o </xsl:text><xsl:value-of select="$outPathFile" /><xsl:text></xsl:text></xsl:variable>
    <arg line="{$o}" />

    <arg line="{'${env.ZBNFJAX_HOME}/xsl/gen/CHeader2ByteDataAccess_Java.xsl'}" />

    <xsl:variable name="outPackageArg"><xsl:text>outPackage="</xsl:text><xsl:value-of select="translate(substring(output/@path,1,string-length(output/@path)-1), '/','.')" /><xsl:text>"</xsl:text></xsl:variable>
    <arg line="{$outPackageArg}" />

    <xsl:variable name="outFile"><xsl:text>outFile="</xsl:text><xsl:value-of select="output/@file" /><xsl:text>"</xsl:text></xsl:variable>
    <arg line="{$outFile}" />
  </exec>
</xsl:template>



<xsl:template name="copyNewerFiles">
  <xsl:comment>Generated with ZmakeStd.xslp: copyNewerFiles </xsl:comment>
  <xsl:call-template name="copyFiles">
    <xsl:with-param name="mode" select="'+newer+replace+'" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="copyChangedFiles">
  <xsl:comment>Generated with ZmakeStd.xslp: copyChangedFiles </xsl:comment>
  <xsl:call-template name="copyFiles">
    <xsl:with-param name="mode" select="'+newer+replace+'" />
    <xsl:with-param name="testContent" select="'bytewise'" />
  </xsl:call-template>
</xsl:template>



<xsl:template name="copyFiles">
<xsl:param name="mode" select="'+everytime+replace+'" />
<xsl:param name="testContent"/>
  <xsl:comment>Generated with ZmakeStd.xslp: copyFiles </xsl:comment>
  <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
  <xsl:variable name="outputPath">
    <xsl:for-each select="output">
      <xsl:call-template name="pathbase" /><!-- not Reg_SrcPath -->
      <xsl:value-of select="@path" />
      <xsl:value-of select="@file" /><!-- if no attribute file, it is empty but replaced by input/@file-->
      <xsl:value-of select="@ext" /><!-- if no attribute ext, it is empty but replaced by input/@ext -->
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="copyCmd">
    <xsl:choose><xsl:when test="string-length($testContent) gt 0">
      <!-- xsl:text>Zcopy</xsl:text -->
    </xsl:when><xsl:otherwise>
      <xsl:text>copy</xsl:text>
    </xsl:otherwise></xsl:choose>
  </xsl:variable>
  <xsl:comment>generated ANT-target copyFile from src:  destination :=<xsl:text></xsl:text><xsl:value-of select="$targetName"/>..., in ZBNF target::=... </xsl:comment>
  <xsl:text>
  </xsl:text>
  <target name="{$targetName}" description="ZmakeStd.xslp:copyFiles">
    <!-- this target contains some copy tasks, every copy tests the uptodate inside. -->
    <xsl:variable name="mode1">
      <xsl:value-of select="$mode" />
      <xsl:if test="output/@allTree"><xsl:text>+toDir+</xsl:text></xsl:if>
      <xsl:if test="output/@someFiles"><xsl:text>+toInputFile+</xsl:text></xsl:if>
      <xsl:if test="output/@ext='.*'"><xsl:text>+toInputExt+</xsl:text></xsl:if>
    </xsl:variable>
    <xsl:call-template name="evaluateInput">
      <xsl:with-param name="call" select="'copyFiles-exec'" />
      <xsl:with-param name="p1" select="$mode1" />
      <xsl:with-param name="p2" select="$outputPath" />
      <xsl:with-param name="p3" select="output" />
      <xsl:with-param name="p4" select="$copyCmd" />
      <xsl:with-param name="p5" select="$testContent" />
    </xsl:call-template>
  </target>
</xsl:template>

<xsl:template name="copyFiles-exec"><!-- the template called inside evaluateInput -->
<xsl:param name="pathbase" /><!-- built in evaluateInput for the inputfile -->
<xsl:param name="p1" /><!-- mode -->
<xsl:param name="p2" /><!-- outputPath -->
<xsl:param name="p3" /><!-- xmlOutput -->
<xsl:param name="p4" /><!-- copyCmd copy or Zcopy -->
<xsl:param name="p5" /><!-- testContent -->
  <!-- copy -->
  <xsl:comment>Generated with ZmakeStd.xslp: copyFiles-exec </xsl:comment>
  <xsl:element name="{$p4}" >
    <!-- dst: tofile or todir: -->
    <xsl:choose><xsl:when test="contains($p1,'+toDir+')" ><!-- xsl:when test="@allTree" -->
      <xsl:attribute name="todir"><xsl:text></xsl:text><xsl:value-of select="$p2" /><xsl:text></xsl:text></xsl:attribute>
    </xsl:when><xsl:otherwise>
      <xsl:attribute name="tofile" >
        <xsl:value-of select="$p2"/>
        <xsl:choose><xsl:when test="boolean($p3/@allTree) and not($p3/@ext)">
          <!-- use the local path/file.ext from input but the extension from output-->
          <xsl:text></xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text></xsl:text><xsl:choose><xsl:when test="@someFiles"><xsl:text>*</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text><xsl:value-of select="@ext" /><xsl:text></xsl:text>
        </xsl:when><xsl:when test="boolean($p3/@allTree)">
          <xsl:call-template name="localPathfile" /><!-- use local path/file.ext from input. -->
        </xsl:when><xsl:otherwise>
          <!-- the $outputPath contains always file.ext, its all ready. -->
        </xsl:otherwise></xsl:choose>
      </xsl:attribute>
    </xsl:otherwise></xsl:choose>
    <!-- -->
    <!-- src: -->
    <xsl:variable name="dir"><xsl:text></xsl:text><xsl:value-of select="$pathbase" /><xsl:text></xsl:text></xsl:variable>
    <xsl:variable name="file">
      <xsl:choose><xsl:when test="boolean(@allTree) and false() and (boolean(@file) or boolean(@ext))">
      </xsl:when><xsl:when test="boolean(@allTree)">
        <!-- allTree -->
          <xsl:if test="true() or boolean(@file) or boolean(@ext)">
            <xsl:text></xsl:text><xsl:value-of select="@path" /><xsl:text>**/</xsl:text><xsl:value-of select="@file" /><xsl:text>*</xsl:text><xsl:value-of select="@ext" /><xsl:text></xsl:text>
          </xsl:if>
        <!-- -->
        <!-- /allTree -->
      </xsl:when><xsl:otherwise>
        <!-- use extension from input -->
        <xsl:text></xsl:text><xsl:call-template name="localPathfile"></xsl:call-template><xsl:text></xsl:text>
      </xsl:otherwise></xsl:choose>
    </xsl:variable>
    <!-- -->
    <!-- consideres different argument syntax between copy and Zcopy: -->
    <xsl:choose><xsl:when test="$p4='copy' and contains($p1,'+toDir+')">
      <fileset dir="{$dir}">
        <include name="{$file}" />
      </fileset>
    </xsl:when><xsl:when test="$p4='copy'">
      <!-- ant-copy does not accept the construct <copy tofile... with a <fileset> -->
      <xsl:attribute name="file"><xsl:value-of select="$dir" /><xsl:value-of select="$file" /></xsl:attribute>
    </xsl:when><xsl:otherwise>
      <xsl:attribute name="dir"><xsl:value-of select="$dir" /></xsl:attribute>
      <xsl:attribute name="file"><xsl:value-of select="$file" /></xsl:attribute>
    </xsl:otherwise></xsl:choose>
    <!-- -->
  </xsl:element>
</xsl:template>




<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="zipFiles">
  <xsl:variable name="zipdir"><xsl:for-each select="output"><xsl:call-template name="pathbase" /><xsl:value-of select="@path" /></xsl:for-each></xsl:variable>
  <xsl:variable name="zipfile"><xsl:for-each select="output"><xsl:call-template name="absPathfile" /></xsl:for-each></xsl:variable>
  <xsl:comment>Generated with ZmakeStd.xslp: zipFiles </xsl:comment>
  <mkdir dir="{$zipdir}" />
  <chmod file="{$zipfile}" perm="777"/>
  <delete file="{$zipfile}" />
  <zip destfile="{$zipfile}">
    <xsl:for-each select=".//input">
      <xsl:variable name="pathbase"><xsl:call-template name="pathbase_Reg_srcpath" /></xsl:variable>
      <!-- NOTE: $pathbase contains also the current dir path! -->
      <xsl:choose><xsl:when test="boolean(@allTree) and boolean(@pathbase)">
        <fileset dir="{$pathbase}" includes="{@path}**/*.*" />
      </xsl:when><xsl:when test="boolean(@allTree)">
        <fileset dir="{$pathbase}{@path}" />
      </xsl:when><xsl:when test="boolean(@someFiles) and boolean(@pathbase)">
        <fileset dir="{$pathbase}" includes="{@path}{@file}*{@ext}" />
      </xsl:when><xsl:when test="boolean(@someFiles)">
        <fileset dir="{$pathbase}{@path}" includes="{@file}*{@ext}" />
      </xsl:when><xsl:when test="boolean(@pathbase)">
        <fileset dir="{$pathbase}" includes="{@path}{@file}{@ext}" />
      </xsl:when><xsl:otherwise>
        <fileset file="{$pathbase}{@path}{@file}{@ext}" />
      </xsl:otherwise></xsl:choose>

    </xsl:for-each>
  </zip>
</xsl:template>







  <!-- This template translates a Zmake-expression like

       tmp/*.xsl := Xsltpre(file1.xslp, file2.xslp);

     in some targets to translate the individually files from xslp via Xsltpre.java to xsl.
     a common target is build with the depends of all some xslp-translating targets.
 -->
<xsl:template name="Xsltpre">
  <xsl:comment>Generated by ZmakeStd.xslp: template Xsltpre calling genExecForEachInput: exec_Xsltpre </xsl:comment>
  <xsl:call-template name="genTargetForEachInput">
    <xsl:with-param name="genExecForEachInput" select="'exec_Xsltpre'" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="exec_Xsltpre"><!-- this template will be called inside for each inputfile. -->
<xsl:param name="targetfile" />
<xsl:param name="srcfile" />
<xsl:param name="xmlInputNode" />
<xsl:param name="xmlTargetNode" />
  <!-- the srcfile without extension .h -->
  <xsl:comment>Generated by ZmakeStd.xslp: template exec_Xsltpre </xsl:comment>
  <echo message="{'Xsltpre: '}{$targetfile}" />
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <arg line="{$ClasspathXslt}" />
    <arg line ="org.vishia.xmlSimple.Xsltpre" />
    <arg line="{'-i'}{$srcfile}" />
    <arg line="{'-o'}{$targetfile}" />
  </exec>
</xsl:template>






<!-- This template translates a Zmake-expression like

       tmp/*.zbnf.xml := zbnfCheader($Headerfiles);

     in some targets to translate the individually files from c-header via Cheader.zbnf in xml.
     a common target is build with the depends of all some zbnf-translating targets.
 -->
<xsl:template name="zbnfCheader">
  <xsl:comment>Generated by ZmakeStd.xslp: template zbnfCheader calling genExecForEachInput: exec_Zbnf2Xml_Cheader </xsl:comment>
  <xsl:call-template name="genTargetForEachInput">
    <xsl:with-param name="genExecForEachInput" select="'exec_Zbnf2Xml_Cheader'" />
    <xsl:with-param name="xmlTool_srcFiles" >
      <srcfiles file="{'${env.ZBNFJAX_HOME}/zbnf/Cheader.zbnf'}" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="exec_Zbnf2Xml_Cheader">
<xsl:param name="targetfile" />
<xsl:param name="srcfile" />
<xsl:param name="xmlInputNode" />
<xsl:param name="xmlTargetNode" />
  <!-- the srcfile without extension .h -->
  <echo message="{'Zbnf2Xml-Cheader.zbnf: '}{$targetfile}" />
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <arg line="{$ClasspathZbnf}" />
    <arg line ="org.vishia.zbnf.Zbnf2Xml" />
    <arg line="{'-i:'}{$srcfile}" />
    <arg line="{'-s:${env.ZBNFJAX_HOME}/zbnf/Cheader.zbnf'}" />
    <arg line="{'-y:'}{$targetfile}" />
    <arg line="{'--report:'}{$targetfile}{'.rpt'}" />
    <arg line="--rlevel:335" />
    <xsl:variable name="file"><xsl:text>-a:@filename="</xsl:text><xsl:value-of select="$xmlInputNode/@path" /><xsl:text></xsl:text><xsl:value-of select="$xmlInputNode/@file" /><xsl:text>"</xsl:text></xsl:variable>
    <arg line="{$file}" />
  </exec>
</xsl:template>







<!-- This template translates a Zmake-expression like

       tmp/*.zbnf.xml := zbnfCheader($Headerfiles);

     in some targets to translate the individually files from c-header via Cheader.zbnf in xml.
     a common target is build with the depends of all some zbnf-translating targets.
 -->
<xsl:template name="zbnfJava">
  <xsl:comment>Generated by ZmakeStd.xslp: template zbnfJava calling genExecForEachInput: exec_Zbnf2Xml_Java </xsl:comment>
  <xsl:text>
  </xsl:text>
  <xsl:call-template name="genTargetForEachInput">
    <xsl:with-param name="genExecForEachInput" select="'exec_Zbnf2Xml_Java'" />
    <xsl:with-param name="xmlTool_srcFiles" >
      <srcfiles file="{'${env.ZBNFJAX_HOME}/zbnf/Java2C.zbnf'}" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="exec_Zbnf2Xml_Java">
<xsl:param name="targetfile" />
<xsl:param name="srcfile" />
<xsl:param name="xmlInputNode" />
<xsl:param name="xmlTargetNode" />
  <!-- the srcfile without extension .h -->
  <echo message="{'Zbnf2Xml-Java.zbnf: '}{$targetfile}" />
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <arg line="{$ClasspathZbnf}" />
    <arg line ="org.vishia.zbnf.Zbnf2Xml" />
    <arg line="{'-i:'}{$srcfile}" />
    <arg line="{'-s:${env.ZBNFJAX_HOME}/zbnf/Java2C.zbnf'}" />
    <arg line="{'-y:'}{$targetfile}" />
    <arg line="{'--report:'}{$targetfile}{'.log'}" />
    <arg line="{'--rlevel:334'}" />
    <xsl:variable name="file"><xsl:text>-a:@filename="</xsl:text><xsl:value-of select="$xmlInputNode/@path" /><xsl:text></xsl:text><xsl:value-of select="$xmlInputNode/@file" /><xsl:text>"</xsl:text></xsl:variable>
    <arg line="{$file}" />
  </exec>
</xsl:template>







  <!-- This template translates a Zmake-expression like

       GenSrc/Reflection_Xyz.cpp := Cheader2Reflection($Headerfiles);

 -->
<xsl:template name="Cheader2Reflection">
<xsl:param name="targetfile" />
<xsl:param name="c_only" />
  <xsl:comment>Generated by ZmakeStd.xslp: template zbnfCheader calling genExecForEachInput: exec_Zbnf2Xml_Cheader </xsl:comment>
  <echo message="{'Zbnf2Xml-Cheader.zbnf: '}{$targetfile}" />
  <exec dir="{$curDir}" executable= "java" failonerror="true">
    <arg line="{$ClasspathHeader2Reflection}" />
    <arg line ="org.vishia.header2Reflection.CmdHeader2Reflection" />
    <arg line="{'-out.c:'}{$targetfile}" />
    <xsl:call-template name="evaluateInput">
      <xsl:with-param name="call" select="'execLines_Cheader2Reflection'" />
    </xsl:call-template>
    <arg line="-b:src/ReflectionBlockedTypes.txt" />
    <arg line="{'-z:${env.ZBNFJAX_HOME}/zbnf/Cheader.zbnf'}" />
    <xsl:if test="$c_only = 'c_only'" >
      <arg line="{'-c_only'}" />
    </xsl:if>  
    <arg line="{'--report:'}{$targetfile}{'.rpt'}" />
    <arg line="--rlevel:333" />
  </exec>
</xsl:template>

<xsl:template name="execLines_Cheader2Reflection">
<xsl:param name="pathbase" />
<xsl:param name="srcfile" />
  <xsl:variable name="arg"><xsl:text>-i:</xsl:text><xsl:value-of select="$pathbase" /><xsl:text></xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:choose><xsl:when test="@allTree"><xsl:text>**/</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text></xsl:text><xsl:choose><xsl:when test="@someFiles"><xsl:text>*</xsl:text></xsl:when></xsl:choose><xsl:text>.h</xsl:text>
  </xsl:variable>
  <arg line="{$arg}" />
</xsl:template>







  <!-- This template translates a Zmake-expression like

     MyOutput.xmi := genXmiFromZbnfCheader($Headerfiles);

     in a targets to translate the zbnf.xml-Headerfiles to one XMI-File.
     It is assumed that targets to parse the Headerfiles and convert to *.zbnf.xml are always exist.
     Use the Zmake operation zbnfCheader therefore.
 -->
<!-- NOTE: Old variant, TODO check if necessary -->
<xsl:template name="genXmiFromZbnfCheader">
  <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
  <xsl:variable name="targetUptodate"><xsl:value-of select="$targetName" />_isUptodate</xsl:variable>
  <xsl:variable name="types_xml"><xsl:text>${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.types.xml</xsl:text></xsl:variable>
  <xsl:variable name="targetfile"><xsl:text></xsl:text><xsl:for-each select="output"><xsl:call-template name="absPathfile"></xsl:call-template></xsl:for-each><xsl:text></xsl:text></xsl:variable>
  <xsl:if test="not(param[@name='zbnfCheaderTarget'])">
    <xsl:message terminate="yes"><xsl:text>
ABORT: The zmake routine 'genXmiFromZbnfCheader()' must have a argument 'zbnfCheaderTarget="target"'.
This argument have to be refer the target responsible for making the xml files from Header via parsing with Cheader.zbnf.
      </xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:comment>Generated with ZmakeStd.xslp: genXmiFromZbnfCheader, calling evaluateInput: genDependsToTarget-dependsInput </xsl:comment>
  <target name="{$targetName}" description="generated from Zmake-routine: genXmiFromZbnfCheader" unless="{$targetUptodate}">
    <xsl:variable name="depends">
      <xsl:call-template name="evaluateInput">
        <xsl:with-param name="call" select="'genDependsToTarget-dependsInput'" />
        <xsl:with-param name="p1" select="param[@name='zbnfCheaderTarget']/@value" />
        <xsl:with-param name="p2" select="''" />
        <xsl:with-param name="p3" select="''" />
        <xsl:with-param name="p4" select="''" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:attribute name="depends"><xsl:text></xsl:text><xsl:value-of select="$depends" /><xsl:text></xsl:text><xsl:value-of select="$targetUptodate" /><xsl:text>,Cheader2Xmi.xslp</xsl:text></xsl:attribute>
    <echo message="{'Xslt-CheaderTypes.xsl: '}{$types_xml}" />
    <exec dir="{$curDir}" executable= "java" failonerror="true">
      <!-- arg line="{$ClasspathXslt}" / -->
      <arg line ="org.vishia.xml.Xslt" />
      <!-- generate an arg line for all inputs -->
      <xsl:comment>Generated with ZmakeStd.xslp: genXmiFromZbnfCheader, calling evaluateInput: evaluateInput_XsltPath </xsl:comment>
      <xsl:call-template name="evaluateInput">
        <xsl:with-param name="call" select="'evaluateInput_XsltPath'" />
        <xsl:with-param name="p1" select="'${tmp}/'" />
        <xsl:with-param name="p2" select="'.zbnf.xml'" />
      </xsl:call-template>
      <!-- arg line="{'-t${env.ZBNFJAX_HOME}/xsl/CheaderTypes.xsl'}" / -->
      <arg line="{'-t${env.ZBNFJAX_HOME}/xsl/CHeaderTypes.xsl'}" />
      <arg line="-w+" />
      <xsl:variable name="o"><xsl:text>-y${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.types.xml</xsl:text></xsl:variable>
      <arg line="{$o}" />
    </exec>
    <exec dir="{$curDir}" executable= "java" failonerror="true">
      <!-- arg line="{$ClasspathXslt}" / -->
      <arg line ="org.vishia.xml.Xslt" />
      <xsl:comment>Generated with ZmakeStd.xslp: genXmiFromZbnfCheader, calling evaluateInput: evaluateInput_XsltPath </xsl:comment>
      <xsl:call-template name="evaluateInput">
        <xsl:with-param name="call" select="'evaluateInput_XsltPath'" />
        <xsl:with-param name="p1" select="'${tmp}/'" />
        <xsl:with-param name="p2" select="'.zbnf.xml'" />
      </xsl:call-template>
      <xsl:variable name="iTypes"><xsl:text>-i${tmp}/</xsl:text><xsl:value-of select="output/@file" /><xsl:text>.types.xml</xsl:text></xsl:variable>
      <arg line="{$iTypes}" />
      <arg line="{'-t:${tmp}/Cheader2Xmi.xsl'}" />
      <!-- arg line="{'-t${env.ZBNFJAX_HOME}/xsl/gen/Cheader2Xmi.xsl'}" / -->
      <arg line="-w+" />
      <arg line="{'-y:'}{$targetfile}" />
    </exec>
  </target>
  <target name="{$targetUptodate}" description="ZmakeStd.xslp:genXmiFromZbnfCheader-uptd">
    <uptodate property="{$targetUptodate}" targetfile="{$targetfile}">
      <xsl:comment>Generated with ZmakeStd.xslp: genXmiFromZbnfCheader, calling evaluateInput: uptodateSource </xsl:comment>
      <xsl:call-template name="evaluateInput">
        <xsl:with-param name="call" select="'uptodateSource'" />
      </xsl:call-template>
      <srcfiles file="{'${env.ZBNFJAX_HOME}/xsl/CheaderTypes.xsl'}" />
      <srcfiles file="{'${env.ZBNFJAX_HOME}/xsl/ZmakeStd.xslp'}" />
      <srcfiles file="{'${env.ZBNFJAX_HOME}/xsl/Cheader2Xmi.xslp'}" />
    </uptodate>
  </target>
</xsl:template>






<!-- ***********************************************************************************************************
     ***********************************************************************************************************
     ***********************************************************************************************************
     commonly useable routines:
 -->



<xsl:template name="targetName">
  <xsl:choose><xsl:when test="@target">
    <xsl:value-of select="@target" />
  </xsl:when><xsl:when test="param[@name='target']">
    <xsl:value-of select="param[@name='target']/@value" />
  </xsl:when><xsl:when test="param[@name='task']">
    <xsl:value-of select="param[@name='task']/@value" />
  </xsl:when><xsl:otherwise>
    <xsl:variable name="targetNameRaw"><xsl:text></xsl:text><xsl:value-of select="output/@path" /><xsl:text></xsl:text><xsl:value-of select="output/@file" /><xsl:text></xsl:text><xsl:value-of select="output/@ext" /><xsl:text></xsl:text></xsl:variable>
    <xsl:value-of select="translate($targetNameRaw, '/\:', '/\:')" />
  </xsl:otherwise></xsl:choose>
</xsl:template>


<xsl:template name="doForAll">
  <xsl:call-template name="genTargetForEachInput">
    <xsl:with-param name="genExecForEachInput" select="'exec_doForAll'" />
  </xsl:call-template>
</xsl:template>    

<xsl:template name="exec_doForAll">
<xsl:param name="targetfile" />
<xsl:param name="srcfile" />
<xsl:param name="xmlInputNode" />
<xsl:param name="xmlTargetNode" />
  <echo message="gen doForAll" />
  <xsl:variable name="test"><xsl:value-of select="local-name($xmlTargetNode)"/></xsl:variable>
  <echo message="{$test}" />
  <xsl:for-each select="$xmlTargetNode/doForAll">
    <xsl:call-template name="gen_exec">
      <xsl:with-param name="xmlInput" select="$xmlInputNode" />  
    </xsl:call-template>
  </xsl:for-each>
</xsl:template>
    
    


<!-- This template is commonly useable to translate all input files with the same given algorithmus
     in some targets.
     a common target is build with the depends of all some zbnf-translating targets.
 -->
<xsl:template name="genTargetForEachInput">
<xsl:param name="genExecForEachInput" /><!-- name of the generateExec-Routine. -->
<xsl:param name="xmlTool_srcFiles" /><!-- contains some <srcfiles ...> elements there are additinal to consider -->
  <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
  <xsl:variable name="outputPre"><xsl:for-each select="output"><xsl:call-template name="pathPre" /></xsl:for-each></xsl:variable>
  <xsl:variable name="outputPost"><xsl:for-each select="output"><xsl:call-template name="pathPost" /></xsl:for-each></xsl:variable>
  <xsl:comment> The next targets are generated with ZmakeStd.xslp: genTargetForEachInput </xsl:comment>
  
  <!-- creation of all targets for the inputs. -->
  <xsl:call-template name="evaluateInput">
    <xsl:with-param name="call" select="'genTargetForInput'" />
    <xsl:with-param name="p1" select="$targetName" /><!-- base for the some targets names -->
    <xsl:with-param name="p2" select="$outputPre" />
    <xsl:with-param name="p3" select="$outputPost" />
    <xsl:with-param name="p4" select="$genExecForEachInput" />
    <xsl:with-param name="p5" select="." /><!-- xmlTargetNode -->
    <xsl:with-param name="p6" select="$xmlTool_srcFiles" />
    <xsl:with-param name="p7" select="srcpath/@pathbase" />
  </xsl:call-template>
  <xsl:text>
    <!-- xxx -->
  </xsl:text>
  <xsl:variable name="targetUptodate"><xsl:value-of select="$targetName" />_isUptodate</xsl:variable>
  <xsl:variable name="targetfile"><xsl:text></xsl:text><xsl:for-each select="output"><xsl:call-template name="absPathfile"></xsl:call-template></xsl:for-each><xsl:text></xsl:text></xsl:variable>
  <!-- xxx -->
  
  <!-- target to call all targets above as dependencies. -->
  <target name="{$targetName}" description="ZmakeStd.xslp:genTargetForEachInput input({$genExecForEachInput})">
    <!-- unless="{$targetUptodate}" -->
    <xsl:variable name="depends">
      <xsl:call-template name="evaluateInput"> <!-- KK1 -->
        <xsl:with-param name="call" select="'genDependsToTarget-dependsInput'" />
        <xsl:with-param name="p1" select="$targetName" /><!-- base for the some targets names -->
      </xsl:call-template>
    </xsl:variable>
    <xsl:attribute name="depends"><xsl:text></xsl:text><xsl:value-of select="$depends" /><xsl:text>ZmakeDummy</xsl:text></xsl:attribute>
  </target>
  <!-- xxx 
  <target name="{$targetUptodate}" description="ZmakeStd.xslp:genTargetForEachInput-uptd"> 
    <uptodate property="{$targetUptodate}" targetfile="{$targetfile}">
      <xsl:call-template name="evaluateInput">
        <xsl:with-param name="call" select="'uptodateSource'" />
      </xsl:call-template>
      <xsl:copy-of select="$xmlTool_srcFiles" />
    </uptodate>
  </target>
  xxx -->
</xsl:template>


  
    
<!-- This template is called inside genTargetForEachInput for each input using call-template name="evaluateInput". 
     A <target>... will be generated with uptodate-check. The content of the target will be defined
     calling the template given in $p4. This called template keep the following parameters:
     * srcfile
     * targetfile
     * xmlInputNode: The node from the input.zbnf.xml-file, additional informations may be kept from here.
     * xmlOutputNode: like xmlInputNode
  -->
<xsl:template name="genTargetForInput">
<xsl:param name="srcpath" />
<xsl:param name="pathbase" />
<xsl:param name="srcfile" />
<xsl:param name="p1" /><!-- name of the superior target as basename -->
<xsl:param name="p2" /><!-- pre-part to build the targetfile name with input file path/name.ext -->
<xsl:param name="p3" /><!-- post-part,the targetfile name is built with p2+inputfilfile.ext+p3 -->
<xsl:param name="p4" /><!-- name of the template to generate the ant.xml-code for the exec routine -->
<xsl:param name="p5" /><!-- The xml target node of the Zmake Routine to get parameters -->
<xsl:param name="p6" /><!-- additional uptodate src $xmlTool_srcFiles -->
<xsl:param name="p7" /><!-- src fir -->
  <!-- current node is target/input -->
  <xsl:variable name="targetName"><xsl:text></xsl:text><xsl:value-of select="$p1" /><xsl:text>:</xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text></xsl:text><xsl:value-of select="@ext" /><xsl:text></xsl:text></xsl:variable>
  <xsl:variable name="targetUptodate"><xsl:value-of select="$targetName" />_isUptodate</xsl:variable>
  
  <xsl:variable name="srcfile1"><!-- note: a srcpath is included in pathbase, the whole path, part before ':' too. -->
    <xsl:value-of select="$pathbase" />
    <xsl:value-of select="$srcfile" />
  </xsl:variable>
  <xsl:variable name="targetfile">
    <!-- assemble the targetfile-path from outputfile informations and from inputfile local path, name and ext. -->
    <xsl:value-of select="$p2"/>     <!-- pre-path from output node -->
    <xsl:value-of select="@path"/>   <!-- path and file name from input node -->
    <xsl:value-of select="@file"/>
    <xsl:if test="string-length($p3)=0 or boolean($p5/output/@wildcardExt)">
      <xsl:value-of select="@ext"/>  <!-- the ext if no other ext is given or *.* is written. -->
    </xsl:if>
    <xsl:value-of select="$p3"/>     <!-- post path from output node -->
  </xsl:variable>
  
  <xsl:variable name="description"><xsl:text>generate from ZmakeStd.xslp: genTargetForInput:</xsl:text><xsl:value-of select="$p4" /><xsl:text>, input:</xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text></xsl:text><xsl:value-of select="@ext" /><xsl:text></xsl:text></xsl:variable>
  <xsl:text>
  </xsl:text>
  <target name="{$targetName}" description="ZmakeStd.xslp:genTargetForInput-target"
    depends="{$targetUptodate}" unless="{$targetUptodate}"><xsl:text>
    </xsl:text>
    <xsl:comment><xsl:text>Generated with ZmakeStd.xslp: genTargetForInput node = </xsl:text><xsl:value-of select="local-name($p5)" /><xsl:text></xsl:text></xsl:comment><xsl:text>
    </xsl:text>
    <saxon:call-template name="{$p4}">
      <xsl:with-param name="srcfile" select="$srcfile1" />
      <xsl:with-param name="targetfile" select="$targetfile" />
      <xsl:with-param name="xmlInputNode" select="." />
      <xsl:with-param name="xmlTargetNode" select="$p5" />
    </saxon:call-template>
  </target>
  <target name="{$targetUptodate}" description="ZmakeStd.xslp:genTargetForInput-uptd">
    <uptodate property="{$targetUptodate}" targetfile="{$targetfile}">
      <srcfiles file="{$srcfile1}" />
      <xsl:copy-of select="$p6" />
    </uptodate>
  </target>
  <xsl:text>


  </xsl:text>
</xsl:template>









<!-- This template is commonly useable to translate all input files with the same given algorithmus
     in some targets.
     a common target is build with the depends of all some zbnf-translating targets.
 -->
<xsl:template name="genTargetWithAvaileableTestFirstInput_UptodateAllInput">
<xsl:param name="genExec" /><!-- name of the generateExec-Routine. -->
<xsl:param name="xmlTool_srcFiles" /><!-- contains some <srcfiles ...> elements there are additinal to consider -->
<xsl:param name="targetfile" />
  <xsl:variable name="targetName"><xsl:call-template name="targetName" /></xsl:variable>
  <xsl:variable name="isUptodate"><xsl:text>isUptodate:</xsl:text><xsl:value-of select="$targetName" /></xsl:variable>
  <xsl:variable name="isAvailable"><xsl:text>isAvailable:</xsl:text><xsl:value-of select="$targetName" /></xsl:variable>
  <xsl:variable name="firstInput"><xsl:for-each select="input[1]"><xsl:call-template name="absPathfile_Reg_srcpath" /></xsl:for-each><!-- xsl:text></xsl:text><xsl:value-of select="output/@path" /><xsl:text></xsl:text><xsl:value-of select="output/@file" /><xsl:text></xsl:text><xsl:value-of select="output/@ext" /><xsl:text></xsl:text --></xsl:variable>
  <xsl:comment>generated ANT-targets from src:  destination :={$targetName}..., in ZBNF target::=... </xsl:comment>
  <xsl:text>
  </xsl:text>
  <xsl:comment>Generated with ZmakeStd.xslp: genTargetWithAvaileableTestFirstInput_UptodateAllInput </xsl:comment>
  <target name="{$targetName}" depends="{$isAvailable}" if="{$isAvailable}"  description="ZmakeStd.xslp:ZmakeStd.xslp:genTargetWithAvaileableTestFirstInput_UptodateAllInput-call-exec">
    <antcall target="exec:{$targetName}" />
  </target>
  <target name="exec:{$targetName}" depends="{$isUptodate}" unless="{$isUptodate}"  description="ZmakeStd.xslp:ZmakeStd.xslp:genTargetWithAvaileableTestFirstInput_UptodateAllInput-exec">
    <saxon:call-template name="{$genExec}">
      <xsl:with-param name="targetfile" select="$targetfile" />
    </saxon:call-template>
  </target>
  <target name="{$isUptodate}"  description="ZmakeStd.xslp:ZmakeStd.xslp:genTargetWithAvaileableTestFirstInput_UptodateAllInput-isUptodate">
    <uptodate property="{$isUptodate}" targetfile="{$targetfile}">
      <xsl:call-template name="evaluateInput">
        <xsl:with-param name="call" select="'uptodateSource'" />
      </xsl:call-template>
    </uptodate>
  </target>
  <target name="{$isAvailable}"  description="ZmakeStd.xslp:genTargetWithAvaileableTestFirstInput_UptodateAllInput-isAvailable({$isAvailable})">
    <available property="{$isAvailable}" file="{$firstInput}" />
  </target>
</xsl:template>





  <!-- This template generates the input arg for org.vishia.xml.Xslt.
     Acutal xml node is a <file> for input. The template may be used within template name="evaluateInput".
 -->
<xsl:template name="evaluateInput_XsltPath" >
<xsl:param name="p1" />
<xsl:param name="p2" />
  <xsl:variable name="i"><xsl:text>-i</xsl:text><xsl:value-of select="$p1" /><xsl:text></xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text></xsl:text><xsl:value-of select="$p2" /><xsl:text></xsl:text></xsl:variable>
  <arg line="{$i}" />
</xsl:template>


<!-- This template generates a text for depends-attribute with all input files.
     Acutal xml node is a <file> for input. The template may be used within template name="evaluateInput".
     The names of the targets are built with p1 + @path + @file + @ext
 -->
<xsl:template name="genDependsToTarget-dependsInput" >
<xsl:param name="p1" /><!-- base name for target -->
  <xsl:variable name="dependsTarget"><xsl:text></xsl:text><xsl:value-of select="$p1" /><xsl:text>:</xsl:text><xsl:value-of select="@path" /><xsl:text></xsl:text><xsl:value-of select="@file" /><xsl:text></xsl:text><xsl:value-of select="@ext" /><xsl:text></xsl:text></xsl:variable>
  <xsl:text></xsl:text><xsl:value-of select="$dependsTarget" /><xsl:text>,</xsl:text>
</xsl:template>

<!-- This template generates one entry for <update ...> element in <target> with all input files.
     It is useable universally, typical called via call-template name="evaluateInput"
     Acutal xml node is a <file> for input. The template may be used within template name="evaluateInput".
 -->
<xsl:template name="uptodateSource" >
<xsl:param name="srcfile" />
  <xsl:choose><xsl:when test="@allTree">
    <xsl:variable name="srcpath"><xsl:call-template name="pathbase_Reg_srcpath" /><xsl:value-of select="@path" /></xsl:variable>
    <srcfiles dir="{$srcpath}" includes="**/{@file}*{@ext}" />
  </xsl:when><xsl:otherwise>
    <!-- xsl:variable name="srcfile"><xsl:call-template name="absPathfile_Reg_srcpath" /></xsl:variable -->
    <srcfiles file="{$srcfile}" />
  </xsl:otherwise></xsl:choose>

</xsl:template>




<!--This template calls the given named template for all input nodes, considering also inputSet.
    It uses the saxon:call-template because the name of the called template is given as param.
    All params to call are named p1...
    * current XML-node is a node, which contains <input> or <inputSet>.
    * An element <srcpath> is considered, it is a path valid for all inputs. 
    In the called template the <input ext="" file="" path="" pathbase="" someFiles="" /> 
    is the current node, all its content is useable.
	
	The name of the called template is param call. The called routine gets the param:
	* srcpath: content of a given srcpath-element in the current XML-node, may be emtpy.
	* pathbase: The base-path inclusive given srcpath until ':' in the path of input or inputset.
	* srcfile: The path and file inclusively extension without pathbase (without content before ':') of input or inputset.
	* p1..p8 all param given here.
 -->
<xsl:template name="evaluateInput">
<xsl:param name="call" />
<xsl:param name="p1" />
<xsl:param name="p2" />
<xsl:param name="p3" />
<xsl:param name="p4" />
<xsl:param name="p5" />
<xsl:param name="p6" />
<xsl:param name="p7" />
<xsl:param name="p8" />
  <xsl:variable name="srcpath1"><!-- The variable will be empty if no srcpath-param is given in the current node. -->
    <xsl:if test="not(srcpath)">${curDir}/</xsl:if><!-- since 2009-12-08 if srcpath isn't given, curdir is the offer if no abspath is given. -->
      <xsl:for-each select="srcpath"><xsl:call-template name="pathbase" /><!-- or add srcpath  if given. -->
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="srcext" select="srcext" /><!-- my be empty -->
  <!-- xsl:comment> Generated by ZmakeStd.xslp: evaluateInput(call=<xsl:value-of select="$call"/>, srcpath=<xsl:value-of select="$srcpath1"/>) </xsl:comment>
  <xsl:text> 
  </xsl:text -->

  <xsl:for-each select="input">
    <!-- prepare the pathbase regarding a srcpath given above. -->
    <xsl:variable name="pathbase">
      <xsl:call-template name="pathbase" ><xsl:with-param name="srcpath" select="$srcpath1" /></xsl:call-template>
    </xsl:variable>
    <!-- xsl:variable name="pathbase"><xsl:text></xsl:text><xsl:call-template name="pathbase_Reg_srcpath"></xsl:call-template><xsl:text></xsl:text></xsl:variable -->
    <!-- NOTE: no comment, because this routine creates a part of text - sometimes. xsl:comment> Generated by ZmakeStd.xslp: evaluateInput-input </xsl:comment>
    <xsl:text>
    </xsl:text -->
    <saxon:call-template name="{$call}">
      <xsl:with-param name="srcpath" select="$srcpath1" /><!--chg Hartmut 100410: new argument. Reason: possibility to use srcpath independently of pathbase too. -->
      <xsl:with-param name="pathbase" select="$pathbase" />
      <xsl:with-param name="srcfile" >
        <!-- xsl:value-of select="$pathbase" / --> <!--chg Hartmut 100410: do not supply pathbase twice! it is disturbed for Header2XMI -->
        <!-- xsl:call-template name="pathbase" ><xsl:with-param name="srcpath" select="$srcpath1" /></xsl:call-template -->
        <xsl:call-template name="localPathfile" />
        <xsl:value-of select="$srcext" />
      </xsl:with-param>
      <xsl:with-param name="p1" select="$p1" />
      <xsl:with-param name="p2" select="$p2" />
      <xsl:with-param name="p3" select="$p3" />
      <xsl:with-param name="p4" select="$p4" />
      <xsl:with-param name="p5" select="$p5" />
      <xsl:with-param name="p6" select="$p6" />
      <xsl:with-param name="p7" select="$p7" />
      <xsl:with-param name="p8" select="$p8" />
    </saxon:call-template>
  </xsl:for-each>
  <xsl:for-each select="inputSet">
    
    <xsl:variable name="nameInputSet" select="@name" />
    <!-- capture a <srcpath> in the whole input set, it is from a fileset( ..., srcpath="...") in user.zmake. -->
    <xsl:variable name="srcpathInputSet"><!-- The variable will be empty if no srcpath is given in the input set. -->
      <xsl:choose><xsl:when test="string-length($srcpath1) gt 0 and not($srcpath1='///')"><xsl:value-of select="$srcpath1"/>
      </xsl:when><xsl:when test="/.//variable[@name=$nameInputSet]/fileset/srcpath">
        <!-- use a <srcpath> in the inputSet if no srcpath in calling level is given. -->
        <xsl:for-each select="/.//variable[@name=$nameInputSet]/fileset/srcpath"><xsl:call-template name="pathbase" />
        </xsl:for-each>
      </xsl:when><xsl:otherwise>${CurDir}</xsl:otherwise></xsl:choose>
    </xsl:variable>

    <xsl:comment> Generated by ZmakeStd.xslp: evaluateInput-inputSet <xsl:value-of select="$nameInputSet"/>(#srcpath1=<xsl:value-of select="$srcpath1" />#inputset-srcpath=<xsl:value-of select="/.//variable[@name=$nameInputSet]/fileset/srcpath/@pathbase" />#<xsl:value-of select="$srcpath1"/># srcpathInputSet=<xsl:value-of select="$srcpathInputSet"/>) </xsl:comment>
    <xsl:text>
    </xsl:text>
    <xsl:for-each select="/.//variable[@name=$nameInputSet]/fileset/file">
      <!-- prepare the pathbase regarding a srcpath given above. -->
      <xsl:variable name="pathbase">
        <xsl:call-template name="pathbase" ><xsl:with-param name="srcpath" select="$srcpathInputSet" /></xsl:call-template>
      </xsl:variable>
      <saxon:call-template name="{$call}">
        <xsl:with-param name="srcpath" select="$srcpath1" /><!--chg Hartmut 100410: new argument. Reason: possibility to use srcpath independently of pathbase too. -->
        <xsl:with-param name="pathbase" select="$pathbase" /><!-- KK1 -->
        <xsl:with-param name="srcfile" >
          <!-- xsl:value-of select="$pathbase" / --> <!--chg Hartmut 100410: do not supply pathbase twice! it is disturbed for Header2XMI -->
          <xsl:call-template name="localPathfile" />
          <xsl:value-of select="$srcext" />
        </xsl:with-param>
        <xsl:with-param name="p1" select="$p1" />
        <xsl:with-param name="p2" select="$p2" />
        <xsl:with-param name="p3" select="$p3" />
        <xsl:with-param name="p4" select="$p4" />
        <xsl:with-param name="p5" select="$p5" />
        <xsl:with-param name="p6" select="$p6" />
        <xsl:with-param name="p7" select="$p7" />
        <xsl:with-param name="p8" select="$p8" />
      </saxon:call-template>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>




<!--Generates the absolute or relative path and file from given node with possible pre-path -->
<xsl:template name="absPathfile">
<xsl:param name="srcpath" select="'${curDir}/'" />
  <!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:call-template name="pathbase" ><xsl:with-param name="srcpath" select="$srcpath" /></xsl:call-template>
  <xsl:call-template name="localPathfile" />
</xsl:template>


<xsl:template name="absPathfile_Reg_srcpath">
  <!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:call-template name="pathbase_Reg_srcpath" /><xsl:call-template name="localPathfile" />
</xsl:template>


<xsl:template name="localPathfile">
  <!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:value-of select="@path" /><xsl:value-of select="@file" />
  <xsl:if test="@someFiles"><xsl:text>*</xsl:text></xsl:if>
  <xsl:value-of select="@ext" />
</xsl:template>


<xsl:template name="pathfileAllTree">
  <!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:call-template name="pathbase" />
  <xsl:value-of select="@path" />
  <xsl:choose><xsl:when test="@allTree"><xsl:text>**/*</xsl:text>
  </xsl:when><xsl:otherwise><xsl:value-of select="@file" /><xsl:value-of select="@ext" />
  </xsl:otherwise></xsl:choose>
</xsl:template>


<xsl:template name="pathPre">
<!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:call-template name="pathbase" /><xsl:value-of select="@path" />
</xsl:template>


<xsl:template name="pathPost">
<!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:value-of select="@file" /><xsl:value-of select="@ext" />
</xsl:template>



<!-- generate the base of path with given absolute path or given srcpath.
     * current XML-node: should contain @pathbase, @drive, @absPath.
     * If the current XML-node contains a @drive or @absPath, it is used and the param pathbase is ignored.
     * If the current XML-node doesn't contain an absolute path, the param pathbase is used.
     It may be set from a complexly input like zmake-Parameter srcpath=...
     * The param pathbase has the defaultvalue ${curDir}, so it will be used if a srcpath isn't given. 
     * If the pathbase is "", no ${curDir} will be created. The relative path is returned.
-->
<xsl:template name="pathbase"><!-- KK1 -->
<xsl:param name="srcpath" select="'${curDir}/'" />
<!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:choose><xsl:when test="boolean(@drive) or boolean(@absPath)" >
    <!-- If a @drive or @absPath argument is given, the srcpath isn't use. -->
    <!-- NOTE @absPath is only a flag attribute, it means, the path starts with /, no curDir should used. -->
    <xsl:if test="@drive"><xsl:value-of select="@drive" />:</xsl:if>
    <xsl:if test="@absPath">/</xsl:if>
  </xsl:when><xsl:otherwise>
    <!--regard srcpath only if the path isn't absolute or doesn't start with a drive letter. -->
    <xsl:value-of select="$srcpath"/><!-- since 2009-12: use always srcpath, it is ${curDir}/ per default. -->
    <!-- xsl:choose><xsl:when test="string-length($srcpath) gt 0"><xsl:value-of select="$srcpath"/>
    </xsl:when><xsl:otherwise><xsl:text>${curDir}/</xsl:text>
    </xsl:otherwise></xsl:choose -->
  </xsl:otherwise></xsl:choose>  
  <!-- the core value of pathbase: -->
  <xsl:value-of select="@pathbase" />  
  <xsl:if test="@pathbase">/</xsl:if><!-- slash only if @pathbase is given!-->
</xsl:template>



<!-- generate the base of path with curDir or not, regarding a ../srcpath from param srcpath="" in ZmakeStd.zbnf -->
<xsl:template name="pathbase_Reg_srcpath"> <!-- KK1 -->
<!-- actual xml node is input or output, containing @file @path etc. -->
  <xsl:call-template name="pathbase">
    <xsl:with-param name="srcpath">
      <xsl:choose><xsl:when test="boolean(../srcpath)">
        <!-- The srcpath is given as cmd input -->
        <xsl:for-each select="../srcpath">
          <!-- get the content of ../srcpath regarding curDir or absPath -->
          <xsl:call-template name="pathbase" />
        </xsl:for-each>
      </xsl:when><xsl:otherwise>
        <!-- No input srcpath is specified, use current directory -->
        <xsl:text>${curDir}/</xsl:text>
      </xsl:otherwise></xsl:choose>  
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>





<!-- A String is defined in ZmakeStd.zbnf like 
     string::= { <""?literal> |<?for> for ( <input?> : <string?> ) | $<$?variable> ? + }.
  It is an concatenation between "literal", content of variables 
  and last not least expansion of inputs with building of a substring.
  Inputs may be contained in a variable, or it is a list of files.   
  -->
<xsl:template name="concatString">
<xsl:param name="xmlInput" />  
  <xsl:for-each select="literal|contentOfVariable|inputField|forInputString">
    <xsl:choose><xsl:when test="local-name()='literal'">
      <xsl:value-of select="." />
    </xsl:when><xsl:when test="local-name()='forInputString'">
      <!-- expansion of inputs with building of a substring -->
      <xsl:call-template name="evaluateInput">
        <xsl:with-param name="call" select="'forInputString'" />
        <xsl:with-param name="p1" select="." /><!-- xmlNode for String elements inside <for> -->
      </xsl:call-template>
    </xsl:when><xsl:when test="local-name()='inputField'">
      <xsl:variable name="field" select="." />
      <xsl:call-template name="selectInputField">
        <xsl:with-param name="input" select="$xmlInput" />
        <xsl:with-param name="field" select="$field" />
      </xsl:call-template>
    </xsl:when><xsl:otherwise>
      <xsl:text>??ZmakeStd.xslp-concatString: unknown </xsl:text><xsl:value-of select="local-name()" /><xsl:text></xsl:text> 
    </xsl:otherwise></xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template name="forInputString">
<xsl:param name="p1" />
  <xsl:variable name="xmlInput" select="." />
  <xsl:for-each select="$p1"><!-- switch xml-context to string members inside <for> -->
    <xsl:call-template name="concatString">
      <xsl:with-param name="xmlInput" select="$xmlInput" />
    </xsl:call-template>  
  </xsl:for-each>
</xsl:template> 



<xsl:template name="selectInputField">
<xsl:param name="input" />  
<xsl:param name="field" />
  <xsl:choose><xsl:when test="$field='srcpath'"><xsl:for-each select="$input/../srcpath" ><xsl:call-template name="absPathfile" /></xsl:for-each>
  </xsl:when><xsl:when test="$field='file'"><xsl:value-of select="$input/@file" />
  </xsl:when><xsl:when test="$field='ext'"><xsl:value-of select="$input/@ext" />
  </xsl:when><xsl:when test="$field='path'"><xsl:value-of select="$input/@path" />
  </xsl:when><xsl:otherwise><xsl:text>??ZmakeStd.xslp-selectInputField - unknown:</xsl:text><xsl:value-of select="$field" /><xsl:text>?</xsl:text>
  </xsl:otherwise></xsl:choose>
</xsl:template>




<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="stdMake">
<xsl:param name="targetfile" />
  <xsl:variable name="makefilePath">
    <xsl:for-each select="input[1]"><xsl:call-template name="pathbase" /><xsl:value-of select="@path" /></xsl:for-each>
  </xsl:variable>
  <xsl:comment>Generated with ZmakeStd.xslp: stdMake </xsl:comment>
  <echo message="stdMake: {$makefilePath}{input[1]/@file}{input[1]/@ext}" />
  <!-- exec dir="{$makefilePath}" executable="d:\ARS\Framework_7_0\AAXDF\Framework_RC\Share\etc\rmosmake.bat" failonerror="true" -->
  <exec dir="{$makefilePath}" executable="make" failonerror="true">
    <arg line="{'-f'}" />
    <arg line="{input[1]/@file}{input[1]/@ext}" />
    <!-- arg line="{'clean all'}" / -->
  </exec>
</xsl:template>




<!-- Note: the output is embedded in <target  name="{output/@file}" depends="{$isUptodate}" unless="{$isUptodate}"> ... </target> -->
<xsl:template name="msMake">
<xsl:param name="targetfile" />
  <xsl:variable name="makefilePath">
    <xsl:for-each select="input[1]"><xsl:call-template name="pathbase" /><xsl:value-of select="@path" /></xsl:for-each>
  </xsl:variable>
  <xsl:comment>Generated with ZmakeStd.xslp: msMake </xsl:comment>
  <xsl:for-each select="param[@name='delete']">
    <xsl:variable name="deleteDir" ><xsl:text>${curDir}/</xsl:text><xsl:value-of select="@value" /><xsl:text></xsl:text></xsl:variable>
    <echo message="delete {$deleteDir}" />
    <delete dir="{$deleteDir}" />
  </xsl:for-each>
  <echo message="nmake {input[1]/@file}{input[1]/@ext}" />
  <!-- exec dir="{$makefilePath}" executable="d:\ARS\Framework_7_0\AAXDF\Framework_RC\Share\etc\rmosmake.bat" failonerror="true" -->
  <exec dir="{$makefilePath}" executable="nmake" failonerror="true">
    <arg line="{'/nologo'}" />
    <arg line="{'/S'}" />
    <arg line="{'/F'}" />
    <arg line="{input[1]/@file}{input[1]/@ext}" />
    <arg line="{'all'}" />
  </exec>
</xsl:template>


<!-- Some targets to convert xslp to xsl and copy it to the tmp directory. -->
<xsl:template name="genXsltpreStandardTargets" >
  <xsl:comment> Some targets to convert xslp to xsl and copy it to the tmp directory. </xsl:comment>
  <xsl:text>
  </xsl:text>
  
  <target name="TODO_XmiDocu.xslp" depends="TODO_isUptodate_XmiDocu.xslp"
          unless="isUptodate_XmiDocu.xslp" description="ZmakeStd.xslp:TODO_XmiDocu.xslp">
     <echo message="{'use and Xsltpre: ${env.ZBNFJAX_HOME}/XmlDocu_Xsl/XmiDocu.xslp'}"/>
     <exec dir="{'${curDir}'}" executable="java" failonerror="true">
        <arg line="-cp {'${env.JAVACP_XSLT}'} org.vishia.xmlSimple.Xsltpre"/>
        <arg line="--report:{'${tmp}'}/xsltpre.rpt --rlevel:324 "/>
        <arg line="{'-i${env.ZBNFJAX_HOME}/XmlDocu_Xsl/XmiDocu.xslp -o${tmp}/XmiDocu.xsl'}"/>
     </exec>
  </target>
  <target name="TODO_isUptodate_XmiDocu.xslp" description="ZmakeStd.xslp:TODO_isUptodate_XmiDocu.xslp">
     <uptodate property="isUptodate_XmiDocu.xslp" targetfile="{'${tmp}'}/XmiDocu.xsl">
        <srcfiles file="{'${env.ZBNFJAX_HOME}/XmlDocu_Xsl/XmiDocu.xslp'}"/>
     </uptodate>
  </target>
  <xsl:text>
  </xsl:text>
  
  <!-- HINT: write some attribute content in {'...'} if they contain {...} 
       because the {...} should active not until in ANT. -->
  <target name="Cheader2Xmi.xslp" depends="isUptodate_Cheader2Xmi.xslp"
          unless="isUptodate_Cheader2Xmi.xslp"
          description="generate from ZmakeStd.xslp: genXsltpreStandardTargets">
     <echo message="use and Xsltpre: {'${env.ZBNFJAX_HOME}'}/xsl/Cheader2Xmi.xslp"/>
     <exec dir="{'${curDir}'}" executable="java" failonerror="true">
        <arg line="-cp {'${env.JAVACP_XSLT}'} org.vishia.xmlSimple.Xsltpre"/>
        <arg line="{'--report:${tmp}/xsltpre.rpt --rlevel:324 '}"/>
        <arg line="{'-i${env.ZBNFJAX_HOME}/xsl/Cheader2Xmi.xslp -o${tmp}/Cheader2Xmi.xsl'}"/>
     </exec>
  </target>
  <target name="isUptodate_Cheader2Xmi.xslp" description="ZmakeStd.xslp:isUptodate_Cheader2Xmi.xslp">
     <uptodate property="isUptodate_Cheader2Xmi.xslp" targetfile="{'${tmp}/Cheader2Xmi.xsl'}">
        <srcfiles file="{'${env.ZBNFJAX_HOME}/xsl/Cheader2Xmi.xslp'}"/>
     </uptodate>
  </target>

</xsl:template>


</xsl:stylesheet>

