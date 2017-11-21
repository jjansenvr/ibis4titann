<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://nn.nl/XSD/Publishing/DocumentProcessDataHandling/Integrity/1/StoreData/1" version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:param name="systemDate"/>
	<xsl:param name="archDocId"/>
	<xsl:param name="docIDCreated"/>
	<xsl:param name="direction"/>
	<xsl:param name="sourceTransactionID"/>
	<xsl:template match="/Document">
		<StoreDocumentHandlingProcessDataREQ>
			<ESBUID><xsl:value-of select="$sourceTransactionID"/></ESBUID>
			<RequestorID>IBIS4INFOIMAGE</RequestorID>
			<Channel>Archief</Channel>
			<ProcessDateTime><xsl:value-of select="$systemDate"/></ProcessDateTime>
			<Direction><xsl:value-of select="$direction"/></Direction>
			<xsl:choose>
				<xsl:when test="$docIDCreated!='' and $direction='S'">
					<Finished>Y</Finished>
				</xsl:when>
				<xsl:otherwise>
					<Finished>N</Finished>
				</xsl:otherwise>
			</xsl:choose>
			<DocumentID><xsl:value-of select="MetaData/DocumentID"/></DocumentID>
			<SystemCode>I4II</SystemCode>
			<Freefield1><xsl:value-of select="$docIDCreated"/></Freefield1>
			<Freefield2><xsl:value-of select="MetaData/DescriptionProductGroup"/></Freefield2>
		</StoreDocumentHandlingProcessDataREQ>
	</xsl:template>
</xsl:stylesheet>
