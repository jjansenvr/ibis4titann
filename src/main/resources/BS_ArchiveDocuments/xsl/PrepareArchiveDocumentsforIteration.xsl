<?xml version="1.0" encoding="UTF-8"?>
<!--
	Change Log
	Date 		Author 			Description
	25/07/2016  JJvR            Omgezet naar xsl:Key
	
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	
	<xsl:key name="Files" use="FileRef " match="File"/>
	<xsl:template match="/">
		<root>
			<xsl:apply-templates select="ArchiveDocuments_1_Action/Document" />
		</root>
	</xsl:template>
	<xsl:template match="Document">
		<ArchiveDocument_1_Action>
			<ArchiveType><xsl:value-of select="../ArchiveType"/></ArchiveType>
			<RequestUserId><xsl:value-of select="../RequestUserId"/></RequestUserId>
			<Source><xsl:value-of select="../Source"/></Source>
			<SourceTransactionID><xsl:value-of select="../SourceTransactionID"/></SourceTransactionID>
			<xsl:copy-of select="."/>			
			<xsl:copy-of select="key('Files',FileRef)"/>
		</ArchiveDocument_1_Action>
	</xsl:template>
</xsl:stylesheet>
