<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">

	<xsl:output omit-xml-declaration="yes" media-type="text" />
	<xsl:template match="/">
			<xsl:choose>
					<xsl:when test="count(/cmis/rowset/row)=1">
						<xsl:value-of select="'success'" />
					</xsl:when>
					<xsl:when test="count(/cmis/rowset/row)=0">
						<xsl:value-of select="'zero results'" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'multiple results'" />
					</xsl:otherwise>
				</xsl:choose>
		
	</xsl:template>

</xsl:stylesheet>
 
