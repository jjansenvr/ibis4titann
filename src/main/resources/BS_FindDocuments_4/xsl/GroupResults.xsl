<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
<xsl:template match="/">
<results>
	<xsl:for-each-group select="//row" group-by="property[@name='cmis:objectId']"><xsl:copy-of select="."/></xsl:for-each-group>
</results>
</xsl:template>	
</xsl:stylesheet>