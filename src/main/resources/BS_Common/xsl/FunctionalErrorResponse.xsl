<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="rootTag"/>
	<xsl:param name="errorCode"/>
	<xsl:param name="errorReason"/>
	<xsl:param name="errorDetailCode"/>
	<xsl:param name="errorDetailText"/>
	<xsl:param name="operation"/>
	<xsl:param name="operationVersion"/>
	<xsl:template match="/">
		<xsl:element name="{$rootTag}">
			<Result xmlns="http://nn.nl/XSD/Generic/MessageHeader/1">
				<Status>OK</Status>
					<ErrorList>
						<Error>
							<Code><xsl:value-of select="$errorCode"/></Code>
							<Reason><xsl:value-of select="$errorReason"/></Reason>
							<Service>
								<Name>Document</Name>
								<Context>Document</Context>
								<Action>
									<Paradigm>Response</Paradigm>
									<Name><xsl:value-of select="$operation"/></Name>
									<Version><xsl:value-of select="$operationVersion"/></Version>
								</Action>
							</Service>
							<xsl:if test="$errorDetailCode">
							<DetailList>
								<Detail>
									<Code><xsl:value-of select="$errorDetailCode"/></Code>
									<Text><xsl:value-of select="$errorDetailText"/></Text>
								</Detail>
							</DetailList>
							</xsl:if>
						</Error>
					</ErrorList>
				</Result>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
