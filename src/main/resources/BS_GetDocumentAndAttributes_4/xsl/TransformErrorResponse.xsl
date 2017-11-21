<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/">
	<GetDocumentAndAttributes_Response>
		<Result xmlns="http://nn.nl/XSD/Generic/MessageHeader/2">
			<Status>OK</Status>
			<ErrorList>
				<Error>
					<Code>DATA_ERROR</Code>
					<Reason>Unexpected Result from Archive</Reason>
					<Service>
						<Name>Document</Name>
						<Context>ArchivingDocumentInfoImage</Context>
						<Action>
							<Paradigm>Response</Paradigm>
							<Name>GetDocumentAndAttributes</Name>
							<Version>1</Version>
						</Action>
					</Service>
					<DetailList>
						<Detail>
						<xsl:choose>
							<xsl:when test="count(/cmis/rowset/row)=0">
								<Code>DOCID_NOT_AVAILABLE</Code>
								<Text>No result for documentID</Text>
							</xsl:when>
							<xsl:otherwise>
								<Code>DOCID_NOT_UNIQUE</Code>
								<Text>More than one result document for documentID</Text>
							</xsl:otherwise>
						</xsl:choose>
						</Detail>
					</DetailList>
				</Error>
			</ErrorList>
		</Result>
	</GetDocumentAndAttributes_Response>
	</xsl:template>
</xsl:stylesheet>