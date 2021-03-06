<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xs ="http://www.w3.org/2001/XMLSchema"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
>


  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->



  <!-- presentation of the content of a class. The calling may be ransomed from generated DocuCtrl.xsl via GenDocuCtrl2Xsl.xsd -->
  <xsl:template name="dataStruct">
  <xsl:param name="className" select="'?'"/>
  <xsl:param name="methods">all</xsl:param>
  <xsl:param name="attributes">all</xsl:param>
    <xhtml:body>
      <xsl:for-each select="Cheader/class[@name=$className]"><!-- select the requested struct -->
        <xsl:variable name="LABEL"><xsl:text>class_</xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text></xsl:variable>
        <anchor label="{$LABEL}"/>
        <xhtml:p class="standard" id="{$LABEL}"><xhtml:u>struct <xsl:value-of select="$className"/></xhtml:u></xhtml:p>

        <xsl:for-each select="structDefinition/attribute[1]">
          <xsl:call-template name="attributes-bytes" />
        </xsl:for-each>
        <xhtml:p class="standard"><xsl:value-of select="structDefinition/description/brief"/></xhtml:p>
        <xsl:copy-of select="structDefinition/description/rest/xhtml:body/*"/>
        <xsl:call-template name="attributes-list" />
      </xsl:for-each>
    </xhtml:body>
  </xsl:template>



  <!-- presentation of the content of a class. The calling may be ransomed from generated DocuCtrl.xsl via GenDocuCtrl2Xsl.xsd -->
  <xsl:template name="headerClass">
  <xsl:param name="className" select="'?'"/>
  <xsl:param name="methods">all</xsl:param>
  <xsl:param name="attributes">all</xsl:param>
      <xhtml:body>
        <xsl:variable name="LABEL">class_<xsl:value-of select="@name"/></xsl:variable>
        <anchor label="{$LABEL}"/>
        <xhtml:p style="standard"><xhtml:u>Class: <xsl:value-of select="$className"/></xhtml:u></xhtml:p>
        <xsl:for-each select="Cheader/class[@name=$className]"><xsl:value-of select="structDefinition/description/brief"/></xsl:for-each>
        <xsl:for-each select="Cheader/class[@name=$className]"><xsl:copy-of select="structDefinition/description/rest/xhtml:body/*"/></xsl:for-each>

        <xsl:for-each select="Cheader/class[@name=$className]">
          <xsl:if test="$attributes!='no'">
            <xsl:for-each select="structDefinition/attribute[1]">
              <xsl:call-template name="attributes-bytes" />
            </xsl:for-each>
            <xsl:call-template name="attributes-list" />
          </xsl:if>
        </xsl:for-each>

        <xsl:if test="$attributes='no'">
          <xsl:if test="true() or count(Operation/tag[@name='documentation'])>0">
            <xhtml:table width="100%">
            <xhtml:tr><xhtml:th width="30%"></xhtml:th><xhtml:th>Attributes Summary</xhtml:th></xhtml:tr>
              <xsl:for-each select="Cheader/class[@name=$className]/structDefinition/attribute" >
                <!-- xsl:sort select="@name" / -->
                <!-- Label built from Class.method(paramtype,paramtype) -->
                <xsl:variable name="LABEL"><xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/>(<xsl:text/>
                  <xsl:for-each select="typedParameter[@kind!='return']" >
                    <xsl:value-of select="@name"/><xsl:text>,</xsl:text>
                  </xsl:for-each>)<xsl:text/>
                </xsl:variable>

                <xhtml:tr>
                  <xhtml:td class="code"><xsl:call-template name="typeName" /></xhtml:td>
                  <xhtml:td><xhtml:dl>
                      <xhtml:dt class="code"><xsl:text> </xsl:text><xsl:value-of select="@name"/></xhtml:dt>
                      <xhtml:dd><xsl:copy-of select="description/brief/xhtml:body/*" /></xhtml:dd>
                  </xhtml:dl></xhtml:td>
                </xhtml:tr>
                <xsl:for-each select="variante">
                <xhtml:tr>
                  <xhtml:td class="code"><xsl:call-template name="typeName" /></xhtml:td>
                  <xhtml:td><xhtml:dl>
                      <xhtml:dt class="code"><xsl:text></xsl:text><xsl:value-of select="../@name" /><xsl:text>.</xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text></xhtml:dt>
                      <xhtml:dd><xsl:copy-of select="description/brief/xhtml:body/*" /></xhtml:dd>
                  </xhtml:dl></xhtml:td>
                </xhtml:tr>
                </xsl:for-each>
              </xsl:for-each>
            </xhtml:table>
          </xsl:if>
        </xsl:if>

        <xsl:if test="$attributes='no'">
          <xsl:if test="true() or count(Operation/tag[@name='documentation'])>0">
            <xhtml:table width="100%">
            <xhtml:tr><xhtml:th width="30%">Initializers Summary</xhtml:th></xhtml:tr>
              <xsl:for-each select="Cheader/class[@name=$className]/const_initializer|null_initializer" >
                <!-- xsl:sort select="@name" / -->
                <!-- Label built from Class.method(paramtype,paramtype) -->
                <xhtml:tr>
                  <xhtml:td>
                    <xhtml:dl>
                      <xhtml:dt class="code">
                        <xsl:text>CONST</xsl:text><xsl:value-of select="@name"/>
                        <xsl:text>(</xsl:text>
                          <xsl:for-each select="parameter" >
                            <xsl:value-of select="@name"/><xsl:text>,</xsl:text>
                          </xsl:for-each>
                        <xsl:text>)</xsl:text>
                      </xhtml:dt>
                      <xhtml:dd><xsl:copy-of select="description/brief/xhtml:body/*" /></xhtml:dd>
                    </xhtml:dl>
                  </xhtml:td>
                </xhtml:tr>
              </xsl:for-each>
            </xhtml:table>
          </xsl:if>
        </xsl:if>

        <xsl:if test="$methods='no'">
          <xsl:if test="true() or count(Operation/tag[@name='documentation'])>0">
            <xhtml:table width="100%">
            <xhtml:tr><xhtml:th width="30%"></xhtml:th><xhtml:th>Methods - Overview</xhtml:th></xhtml:tr>
              <xsl:for-each select="Cheader/class[@name=$className]/methodDef[not(starts-with(name,'constructor'))]|defineDefinition" >
                <xsl:sort select="@name" />
                <!-- Label built from Class.method(paramtype,paramtype) -->
                <xsl:variable name="LABEL"><xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/>(<xsl:text/>
                  <xsl:for-each select="typedParameter|parameter" >
                    <xsl:value-of select="@name"/><xsl:text>,</xsl:text>
                  </xsl:for-each>)<xsl:text/>
                </xsl:variable>

                <xhtml:tr>
                  <xhtml:td class="code">
                    <xsl:call-template name="typeName" />
                    <xsl:if test="local-name()='defineDefinition'"><xsl:text>#define</xsl:text></xsl:if>
                  </xhtml:td>
                  <xhtml:td>
                    <xhtml:dl>
                      <xhtml:dt class="code">
                        <xsl:text> </xsl:text><b><xsl:value-of select="@name"/></b>
                        <xsl:text>(</xsl:text>
                          <xsl:for-each select="typedParameter|parameter" >
                            <xsl:call-template name="typeName" />
                            <xsl:text> </xsl:text><xsl:value-of select="@name"/>
                            <xsl:text>,</xsl:text>
                          </xsl:for-each>
                        <xsl:text>)</xsl:text>
                      </xhtml:dt>
                      <xhtml:dd><xsl:copy-of select="description/brief/xhtml:body/*" /></xhtml:dd>
                    </xhtml:dl>
                  </xhtml:td>
                </xhtml:tr>
              </xsl:for-each>
            </xhtml:table>
          </xsl:if>
        </xsl:if>

        <xsl:if test="$methods='no'">
          <xsl:if test="true() or count(Operation/tag[@name='documentation'])>0">
            <xhtml:dl>
              <xsl:for-each select="Cheader/class[@name=$className]/methodDef[not(starts-with(name,'constructor'))]" >
                <!-- xsl:sort select="@name" / -->
                <!-- Label built from Class.method(paramtype,paramtype) -->
                <xsl:variable name="LABEL"><xsl:value-of select="../@name"/>.<xsl:value-of select="@name"/>(<xsl:text/>
                  <xsl:for-each select="typedParameter[@kind!='return']" >
                    <xsl:value-of select="@name"/><xsl:text>,</xsl:text>
                  </xsl:for-each>)<xsl:text/>
                </xsl:variable>

                <xhtml:dt class="code">
                  <!-- internref label="{$LABEL}">xxx</internref -->
                    <xsl:value-of select="Parameter[@kind='return']"/>
                    <xsl:text> </xsl:text><b><xsl:value-of select="@name"/></b>
                    <xsl:text>(</xsl:text>
                      <xsl:for-each select="typedParameter[@kind!='return']" >
                        <xsl:value-of select="@name"/><xsl:text>,</xsl:text>
                      </xsl:for-each>
                    <xsl:text>)</xsl:text>
                  </xhtml:dt>
                  <xhtml:dd>
                    <xsl:copy-of select="description/brief/xhtml:body/*" />
                    <xsl:copy-of select="description/rest/xhtml:body/*" />
                    <xhtml:ul>
                      <xsl:for-each select="typedParameter[@kind!='return']" >
                        <xhtml:li>
                          <xsl:value-of select="@name" /><xsl:text>: </xsl:text>
                          <xsl:copy-of select="description/brief/xhtml:body/*" />
                        </xhtml:li>
                      </xsl:for-each>
                    </xhtml:ul>
                  </xhtml:dd>
              </xsl:for-each>
            </xhtml:dl>
          </xsl:if>
        </xsl:if>

        <xsl:if test="count(structDefinition/attribute/description)>0">
          <xhtml:p class="inner-title">Attribute:</xhtml:p>
          <xhtml:dl>
            <xsl:for-each select="structDefinition/attribute[count(description)>0]" >
              <xsl:sort select="@name" />
              <!-- Label built from Class.method(paramtype,paramtype) -->
              <xhtml:dt><xsl:value-of select="@name"/> : <xsl:call-template name="typeName" /></xhtml:dt>
              <xhtml:dd>
                <xsl:copy-of select="description/brief/xhtml:body/*"/>
                <xsl:copy-of select="description/rest/xhtml:body/*"/>
              </xhtml:dd>
            </xsl:for-each>
          </xhtml:dl>
        </xsl:if>

        <!-- xsl:if test="count(Association/tag[@name='documentation'])>0" -->
        <xsl:if test="count(xxxAssociation)>0">
          <p>Assoziationen:</p>
          <table border="1" width="100%"><tr><th width="30%">Assoziation</th><th>Zielklasse</th><th>Beschreibung</th></tr>
            <!-- xsl:for-each select="Association[count(tag[@name='documentation'])>0]" -->
            <xsl:for-each select="Association" >
              <xsl:sort select="@name" />
              <xsl:variable name="LABEL">class_<xsl:value-of select="@classType"/></xsl:variable>
              <tr>
                <td><xsl:value-of select="@name"/></td>
                <td><internref label="{$LABEL}"><xsl:value-of select="@classType"/></internref></td>
                <td>
                  <p expandWikistyle="true" style='standard'><xsl:value-of select="tag[@name='documentation']" /></p>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:if>
      </xhtml:body>

  </xsl:template>




  <xsl:template name="attributes-list">
    <xhtml:ul>
      <xsl:for-each select="structDefinition/attribute">
        <xhtml:li><xhtml:p style="standard"><xhtml:b><xsl:text></xsl:text><xsl:value-of select="@name" /><xsl:text>: </xsl:text><xsl:value-of select="type/@name" /><xsl:text></xsl:text><xsl:choose><xsl:when test="count(pointer)>0"><xsl:text>*</xsl:text></xsl:when></xsl:choose><xsl:text></xsl:text><xsl:choose><xsl:when test="count(arraysize)>0"><xsl:text>[</xsl:text><xsl:value-of select="arraysize/@value" /><xsl:text>]</xsl:text></xsl:when></xsl:choose><xsl:text> </xsl:text></xhtml:b>
          <xsl:value-of select="description/brief" /><xsl:text>. </xsl:text></xhtml:p>
          <xsl:copy-of select="description/rest/xhtml:body/*" />
        </xhtml:li>
      </xsl:for-each>
    </xhtml:ul>
  </xsl:template>





  <xsl:template name="attributes-bytes">
  <!-- writes one attribute block, and recursively via following bytes, the next blocks -->
  <xsl:param name="sumsizeof" select="'0'" /><!--summe of sizeof from the calls before for this line -->
  <xsl:param name="prevsizeof" select="'0'" /><!--bytes in the previous block, lines above. -->
    <xhtml:pre class="bytes">
      <xsl:call-template name="attributes-bytes-top" >
        <xsl:with-param name="prevsizeof" select="$prevsizeof" />
      </xsl:call-template>  
    </xhtml:pre>
    <xhtml:pre class="bytes">
      <xsl:call-template name="attributes-bytes-name" />
    </xhtml:pre>
    <xsl:call-template name="following-bytes">
      <xsl:with-param name="sumsizeof" select="'0'" /><!-- because it is a new line -->
      <xsl:with-param name="prevsizeof" select="$prevsizeof" />
    </xsl:call-template>  
      
  </xsl:template>




  <xsl:template name="sizeof">
    <xsl:choose>
      <xsl:when test="count(type/@pointer)>0">4</xsl:when>
      <xsl:when test="count(type/@arraysize)>0">8</xsl:when>
      <xsl:when test="type/@name='int8'">1</xsl:when>
      <xsl:when test="type/@name='int16'">2</xsl:when>
      <xsl:when test="type/@name='uint16'">2</xsl:when>
      <xsl:when test="type/@name='int32'">4</xsl:when>
      <xsl:when test="type/@name='uint32'">4</xsl:when>
      <xsl:otherwise>8</xsl:otherwise><!-- may be a embedded structure or a pointer -->
    </xsl:choose>
  </xsl:template>


  <xsl:template name="following-bytes">
  <!-- writes a following block if some more attributes exists, or writes the bottom line. -->
  <xsl:param name="sumsizeof" select="'0'" /><!--summe of sizeof from the calls before for this line -->
  <xsl:param name="prevsizeof" select="'64'" /><!--bytes in the previous block, lines above. -->
    <xsl:variable name="sizeof"><xsl:call-template name="sizeof" /></xsl:variable>
    <xsl:variable name="sumNew" select="number($sumsizeof + $sizeof)" />
      <xsl:choose><xsl:when test="$sumNew &lt; 8 and boolean(following-sibling::*[1])">
        <!-- recursively call for next word in this line with max 8 bytes-->
        <xsl:for-each select="following-sibling::*[1]">
          <xsl:call-template name="following-bytes" >
            <xsl:with-param name="sumsizeof" select="$sumNew" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when><xsl:when test="boolean(following-sibling::*[1])">
        <!-- recursively call for next block -->
        <xsl:for-each select="following-sibling::*[1]">
          <xsl:call-template name="attributes-bytes" >
            <xsl:with-param name="prevsizeof" select="$sumNew" /><!-- the size of the block above, it should be 8 -->
            <xsl:with-param name="sumsizeof" select="'0'" /><!-- because it starts in a new line -->
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when><xsl:otherwise>
        <!-- after last calling: -->
        <!-- NOTE: the $sumNew is calculated from the recursively call for next word in the last line. -->
        <xhtml:pre class="bytes">
          <xsl:call-template name="attributes-bytes-bottom">
            <xsl:with-param name="sizeof" select="number($sumNew)" /><!-- number of bytes above -->
          </xsl:call-template>
        </xhtml:pre>
      </xsl:otherwise></xsl:choose>
  </xsl:template>
          
          
          

  <xsl:template name="attributes-bytes-top">
  <!-- writes top line for one attribute, recursive called, inside a xhtml:pre -->
  <xsl:param name="sumsizeof" select="'0'" /><!--summe of sizeof from the calls before for this line -->
  <xsl:param name="prevsizeof" select="'0'" /><!--bytes in the previous block, lines above. -->
    <xsl:variable name="sizeof"><xsl:call-template name="sizeof" /></xsl:variable>
    <xsl:variable name="sumNew" select="number($sumsizeof + $sizeof)" />
      <xsl:choose>
        <xsl:when test="$sizeof=1"><xsl:text>+-------</xsl:text></xsl:when>
        <xsl:when test="$sizeof=2"><xsl:text>+-------'-------</xsl:text></xsl:when>
        <xsl:when test="$sizeof=4"><xsl:text>+-------'-------'-------'-------</xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>+---------------------------------------------------------------</xsl:text></xsl:otherwise>
      </xsl:choose>
      <xsl:choose><xsl:when test="$sumNew &lt; 8 and boolean(following-sibling::*[1])">
        <!-- recursively call for next word only for this line with max 8 bytes-->
        <xsl:for-each select="following-sibling::*[1]">
          <xsl:call-template name="attributes-bytes-top" >
            <xsl:with-param name="sumsizeof" select="$sumNew" />
            <xsl:with-param name="prevsizeof" select="$prevsizeof" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:when><xsl:otherwise>
        <!-- after last calling: -->
        <xsl:call-template name="attributes-bytes-bottom">
          <xsl:with-param name="sizeof" select="number($prevsizeof - $sumNew)" />
        </xsl:call-template>
        <!-- xsl:text>(test: prev=</xsl:text><xsl:value-of select="$prevsizeof" /><xsl:text> sum=</xsl:text><xsl:value-of select="$sumNew" /><xsl:text>)</xsl:text -->
      </xsl:otherwise></xsl:choose>
  </xsl:template>



  <xsl:template name="attributes-bytes-bottom">
  <xsl:param name="sizeof" select="'0'" />
      <xsl:value-of select="substring('+-------------------------------------------------------------------------',1,8 * $sizeof)"/>
      <xsl:text>+</xsl:text>
  </xsl:template>




 <xsl:template name="attributes-bytes-name">
  <xsl:param name="sumsizeof" select="'0'" />
  <!-- writes the name of the next attributes formatted -->
    <!-- NOTE: be carefull by editing the next line, inside there are preserved spaces, code 0xA0 -->
    <xsl:variable name="spaces"><xsl:text>                                                   </xsl:text></xsl:variable>
    <xsl:variable name="sizeof"><xsl:call-template name="sizeof" /></xsl:variable>
    <xsl:variable name="sumNew" select="number($sumsizeof + $sizeof)" />
    <xsl:variable name="value">
      <xsl:text></xsl:text><xsl:value-of select="@name" /><xsl:text></xsl:text>
    </xsl:variable>
    <xsl:variable name="nrofSpace" select="8*number($sizeof) - string-length($value)-1" />
    <xsl:variable name="nrofSpace1" select="floor($nrofSpace div 2)" />
    <xsl:variable name="nrofSpace2" select="$nrofSpace - $nrofSpace1" />
      <xsl:choose><xsl:when test="count(arraysize)>0">
        <xsl:text>|</xsl:text><xsl:value-of select="substring($spaces,1,$nrofSpace1 -4)" /><xsl:text>... </xsl:text><xsl:value-of select="substring($value,1, 8*$sizeof -1)" /><xsl:text> ...</xsl:text><xsl:value-of select="substring($spaces,1,$nrofSpace2 -4)" /><xsl:text></xsl:text>
      </xsl:when><xsl:otherwise>
      <xsl:text>|</xsl:text><xsl:value-of select="substring($spaces,1,$nrofSpace1)" /><xsl:text></xsl:text><xsl:value-of select="substring(@name,1, 8*$sizeof -1)" /><xsl:text></xsl:text><xsl:value-of select="substring($spaces,1,$nrofSpace2)" /><xsl:text></xsl:text>
      </xsl:otherwise></xsl:choose>
      <!-- xsl:value-of select="$nrofSpace" / -->
      <!-- xsl:value-of select="substring($spaces,1,$nrofSpace)" / -->

      <!-- recursively call for next word -->
      <xsl:choose>
        <xsl:when test="$sumNew &lt; 8 and boolean(following-sibling::*[1])">
          <xsl:for-each select="following-sibling::*[1]">
            <xsl:call-template name="attributes-bytes-name">
              <xsl:with-param name="sumsizeof" select="$sumNew" />
            </xsl:call-template>
          </xsl:for-each>
        </xsl:when><xsl:otherwise>
          <!-- after last calling: -->
          <xsl:text>|</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>







  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->
  <!-- ******************************************************************************************* -->



  <!-- presentation of a define in headerfile. The calling may be ransomed from generated DocuCtrl.xsl via GenDocuCtrl2Xsl.xsd -->
  <!-- The presentation is sorted by define names. If some conditions are present, the same defines in several conditions
       are shown one after another.
   -->

  <xsl:template name="oldheaderDefine">
  <xsl:param name="name" select="'?'"/>
      <xhtml:body>
        <xsl:variable name="LABEL">define_<xsl:value-of select="@name"/></xsl:variable>
        <anchor label="{$LABEL}"/>
        <xhtml:p style="standard"><xhtml:u>Define: <xsl:value-of select="$name"/></xhtml:u></xhtml:p>
        <!-- common description(s) if some conditionBlock are present -->
        <xsl:for-each select="Cheader/DEFINE_C[@name=$name]"><xsl:copy-of select="structDefinition/description/brief/xhtml:body/*"/></xsl:for-each>
        <xsl:for-each select="Cheader/DEFINE_C[@name=$name]"><xsl:copy-of select="structDefinition/description/rest/xhtml:body/*"/></xsl:for-each>

        <!-- process every condition block, -->
        <xsl:for-each select="Cheader/DEFINE_C[@name=$name]/conditionBlock" >


        </xsl:for-each>

        <xsl:for-each select="Cheader/DEFINE_C[@name=$name]//defineDefinition" >
          <xsl:sort select="@name" />
          <!-- Label built from Class.method(paramtype,paramtype) -->
          <xsl:variable name="LABEL"><xsl:value-of select="@name"/></xsl:variable>
          <xhtml:dl>
            <xhtml:dt class="code"><xsl:value-of select="@name" />
            <xsl:text>(</xsl:text><xsl:for-each select="parameter"><xsl:call-template name="defineParam" /></xsl:for-each><xsl:text>)</xsl:text>
            </xhtml:dt>
            <xhtml:dd>
              <xsl:if test="local-name(..)='conditionBlock'">
                <xhtml:p>
                  <xsl:text>#if </xsl:text>
                  <xsl:for-each select="..//conditionDef">
                    <xsl:text>defined(</xsl:text><xsl:value-of select="." /><xsl:text>) </xsl:text>
                  </xsl:for-each>
                  <xsl:for-each select="..//conditionDefNot">
                    <xsl:text>!defined(</xsl:text><xsl:value-of select="." /><xsl:text>) </xsl:text>
                  </xsl:for-each>
                </xhtml:p>
              </xsl:if>
              <xsl:if test="local-name(..)='elseConditionBlock'">
                <xhtml:p>
                  <xsl:text>#if not </xsl:text>
                  <xsl:for-each select="../..//conditionDef">
                    <xsl:text>defined(</xsl:text><xsl:value-of select="." /><xsl:text>) </xsl:text>
                  </xsl:for-each>
                  <xsl:for-each select="../..//conditionDefNot">
                    <xsl:text>!defined(</xsl:text><xsl:value-of select="." /><xsl:text>) </xsl:text>
                  </xsl:for-each>
                </xhtml:p>
              </xsl:if>

              <xsl:copy-of select="description/brief/xhtml:body/*"/>
              <xsl:copy-of select="description/rest/xhtml:body/*"/>
            </xhtml:dd>
          </xhtml:dl>

        </xsl:for-each>

      </xhtml:body>

  </xsl:template>

  <xsl:template name="headerDefine">
  <xsl:param name="name" select="'?'"/>
      <xhtml:body>
        <xsl:variable name="LABEL">define_<xsl:value-of select="@name"/></xsl:variable>
        <anchor label="{$LABEL}"/>
        <xhtml:p style="standard"><xhtml:u>Define: <xsl:value-of select="$name"/></xhtml:u></xhtml:p>
        <!-- common description(s) if some conditionBlock are present -->
        <xsl:for-each select="Cheader/DEFINE_C[@name=$name]"><xsl:copy-of select="description/brief/xhtml:body/*"/></xsl:for-each>
        <xsl:for-each select="Cheader/DEFINE_C[@name=$name]"><xsl:copy-of select="description/rest/xhtml:body/*"/></xsl:for-each>

        <!-- process every condition block, -->
        <xsl:for-each select="Cheader/DEFINE_C[@name=$name]/conditionBlock/defineDefinition | Cheader/DEFINE_C[@name=$name]/defineDefinition" >
          <xsl:sort select="@name" />
          <xsl:variable name="LABEL"><xsl:value-of select="@name"/></xsl:variable>
          <xhtml:dl>
            <xhtml:dt class="code"><xsl:value-of select="@name" />
            <xsl:text>(</xsl:text><xsl:for-each select="parameter"><xsl:call-template name="defineParam" /></xsl:for-each><xsl:text>)</xsl:text>
            </xhtml:dt>
            <xhtml:dd>
              <xsl:choose><xsl:when test="local-name(..)='conditionBlock'">
                <xsl:copy-of select="../description/brief/xhtml:body/*"/>
                <xsl:copy-of select="../description/rest/xhtml:body/*"/>
              </xsl:when><xsl:otherwise>
                <xsl:copy-of select="description/brief/xhtml:body/*"/>
                <xsl:copy-of select="description/rest/xhtml:body/*"/>
              </xsl:otherwise></xsl:choose>
              <!-- xsl:if test="local-name(..)='elseConditionBlock'">
                <xhtml:p>
                  <xsl:text>#if not </xsl:text>
                  <xsl:for-each select="../..//conditionDef">
                    <xsl:text>defined(</xsl:text><xsl:value-of select="." /><xsl:text>) </xsl:text>
                  </xsl:for-each>
                  <xsl:for-each select="../..//conditionDefNot">
                    <xsl:text>!defined(</xsl:text><xsl:value-of select="." /><xsl:text>) </xsl:text>
                  </xsl:for-each>
                </xhtml:p>
              </xsl:if -->

            </xhtml:dd>
          </xhtml:dl>


        </xsl:for-each>


      </xhtml:body>

  </xsl:template>


  <xsl:template name="defineParam">
    <xsl:value-of select="@name" />
    <xsl:if test="boolean(following-sibling)">
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:template>


  <xsl:template name="typeName">
    <xsl:value-of select="type/@name"/>
    <xsl:value-of select="type/@tagname"/><!-- either tagname or name will be present -->
    <xsl:choose><xsl:when test="count(type/@pointer)>0"><xsl:text>*</xsl:text></xsl:when>
      <xsl:when test="count(type/@constPointer)>0"><xsl:text> const*</xsl:text></xsl:when>
      <xsl:when test="count(type/@volatilePointer)>0"><xsl:text> volatile*</xsl:text></xsl:when>
    </xsl:choose>
    <xsl:if test="count(variante)>0"><xsl:text>union</xsl:text></xsl:if>
  </xsl:template>



</xsl:stylesheet>

