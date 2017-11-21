<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<query>
			<statement>SELECT cmis:objectId FROM cmis:document where DocumentID='<xsl:value-of select="GetDocumentAndAttributes_Request/DocumentID"/>'</statement>
			<searchAllVersions>false</searchAllVersions>
			<includeAllowableActions>false</includeAllowableActions>
			<includeRelationships>none</includeRelationships>
			<maxItems></maxItems>
			<skipCount></skipCount>
		</query>

	</xsl:template>
</xsl:stylesheet>