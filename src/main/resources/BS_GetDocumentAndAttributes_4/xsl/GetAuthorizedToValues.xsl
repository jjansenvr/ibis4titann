<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" encoding="UTF-8" indent="no" omit-xml-declaration="yes"/>
	<xsl:template match="/">
		<Request>
		<xsl:copy-of select="GetDocumentAndAttributes_Request/AuthorizedTo"></xsl:copy-of>
		</Request>
	</xsl:template>
</xsl:stylesheet>