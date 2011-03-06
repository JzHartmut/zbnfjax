<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                 xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:fo="http://www.w3.org/1999/XSL/Format"
                 xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml"
                 xmlns:xhtml="http://www.w3.org/1999/xhtml">
  <xsl:output method="xml" encoding="iso-8859-1"/>




	<xsl:template match= "/">
    <output>
      <xsl:copy-of select="." />
    </output>

	</xsl:template>




</xsl:stylesheet>