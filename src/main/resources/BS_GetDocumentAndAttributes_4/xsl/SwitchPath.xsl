<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output omit-xml-declaration="yes" media-type="text" />
	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="GetDocumentAndAttributes_Request/ID">
				<xsl:value-of select="'ID'" />
			</xsl:when>
			<xsl:when test="GetDocumentAndAttributes_Request/DocumentID">
				<xsl:value-of select="'DOCUMENTID'" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'ID'" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>