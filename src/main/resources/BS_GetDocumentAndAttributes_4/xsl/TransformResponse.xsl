<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/">
	<GetDocumentAndAttributes_Response>
 		<File>
 			<FileContent><xsl:value-of select="'{sessionKey:ref_filecontent}'" disable-output-escaping="yes"/></FileContent>
			<xsl:choose>
	 			<xsl:when test="/cmis/properties/property[@name='FileName']!=''">
					<FileName><xsl:value-of select="/cmis/properties/property[@name='FileName']"/></FileName>
				</xsl:when>
				<xsl:otherwise>
					<FileName><xsl:value-of select="/cmis/properties/property[@name='cmis:contentStreamFileName']"/></FileName>
				</xsl:otherwise>	
			</xsl:choose>
			<FileSize><xsl:value-of select="/cmis/properties/property[@name='cmis:contentStreamLength']"/></FileSize>
			<FileToolVersion><xsl:if test="/cmis/properties/property[@name='FileToolVersion']=''">unknown</xsl:if><xsl:value-of select="/cmis/properties/property[@name='FileToolVersion']"/></FileToolVersion>
			<MimeType><xsl:if test="/cmis/properties/property[@name='cmis:contentStreamMimeType']=''">unknown</xsl:if><xsl:value-of select="/cmis/properties/property[@name='cmis:contentStreamMimeType']"/></MimeType>
 		
 		</File>
<!--  		<DocumentClass><xsl:value-of select="/atom:entry/cmisra:object/cmis:objectTypeId"/></DocumentClass> -->
 		<MetaData>
 			<AddressedTo><xsl:value-of select="/cmis/properties/property[@name='AddressedTo']"/></AddressedTo>
			<!-- Annotation -->
			<ArrivedAt><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='ArrivedAt']"/></xsl:call-template></ArrivedAt>
			<ArrivedBy><xsl:value-of select="/cmis/properties/property[@name='ArrivedBy']"/></ArrivedBy>
			<xsl:for-each select="tokenize(/cmis/properties/property[@name='AuthorizedTo'],',')">
				<AuthorizedTo><xsl:value-of select="."/></AuthorizedTo>
			</xsl:for-each>
		<xsl:if test="/cmis/properties/property[@name='BirthDt']" >
				<BirthDt><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='BirthDt']"/></xsl:call-template></BirthDt>
		</xsl:if>
			<ClaimNumber><xsl:value-of select="/cmis/properties/property[@name='ClaimNumber']"/></ClaimNumber>
		<xsl:if test="/cmis/properties/property[@name='ContentRetentionDate']" >
			<ContentRetentionDate><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='ContentRetentionDate']"/></xsl:call-template></ContentRetentionDate>
		</xsl:if>
			<Contract_Nr><xsl:value-of select="/cmis/properties/property[@name='Contract_Nr']"/></Contract_Nr>
			<Contract_NrAccount><xsl:value-of select="/cmis/properties/property[@name='Contract_NrAccount']"/></Contract_NrAccount>
			<Contract_NrDeposit><xsl:value-of select="/cmis/properties/property[@name='Contract_NrAccount']"/></Contract_NrDeposit>
			<Contract_NrLoan><xsl:value-of select="/cmis/properties/property[@name='Contract_NrLoan']"/></Contract_NrLoan>
			<Contract_NrPolicy><xsl:value-of select="/cmis/properties/property[@name='Contract_NrPolicy']"/></Contract_NrPolicy>
			<Contract_NrQuotation><xsl:value-of select="/cmis/properties/property[@name='Contract_NrQuote']"/></Contract_NrQuotation>
<!-- 		<xsl:if test="/cmis/properties/property[@name='ConversionDate']" > -->
<!-- 			<ConversionDate><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='ConversionDate']"/></xsl:call-template></ConversionDate> -->
<!-- 		</xsl:if> -->
			<ConversionOrigin><xsl:value-of select="/cmis/properties/property[@name='ConversionOrigin']"/></ConversionOrigin>
			<CreatedAt><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='CreatedAt']"/></xsl:call-template></CreatedAt>
			<CreatedBy><xsl:if test="/cmis/properties/property[@name='CreatedBy']=''">unknown</xsl:if><xsl:value-of select="/cmis/properties/property[@name='CreatedBy']"/></CreatedBy>
		<xsl:if test="/cmis/properties/property[@name='DateContentLastAccessed']" >
			<DateContentLastAccessed><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='DateContentLastAccessed']"/></xsl:call-template></DateContentLastAccessed>
		</xsl:if>
			<DescriptionProductGroup><xsl:value-of select="/cmis/properties/property[@name='DescrProductGroup']"/></DescriptionProductGroup>
			<DocumentDetail><xsl:value-of select="/cmis/properties/property[@name='DocumentDetail']"/></DocumentDetail>
			<DocumentID><xsl:value-of select="/cmis/properties/property[@name='DocumentID']"/></DocumentID>
			<DocumentRelationID><xsl:value-of select="/cmis/properties/property[@name='DocumentRelationID']"/></DocumentRelationID>
			<DocumentRouting><xsl:choose><xsl:when test="/cmis/properties/property[@name='DocumentRouting']=''">Internal</xsl:when><xsl:when test="/cmis/properties/property[@name='DocumentRouting']!='Unknown'"><xsl:value-of select="/cmis/properties/property[@name='DocumentRouting']"/></xsl:when><xsl:otherwise>Internal</xsl:otherwise></xsl:choose></DocumentRouting>
			<DocumentTitle><xsl:if test="/cmis/properties/property[@name='DocumentName']=''">no title</xsl:if><xsl:value-of select="/cmis/properties/property[@name='DocumentName']"/></DocumentTitle>
			<DocumentType><xsl:if test="/cmis/properties/property[@name='DocumentType']=''">no_documenttype</xsl:if><xsl:value-of select="/cmis/properties/property[@name='DocumentType']"/></DocumentType>
		<xsl:if test="/cmis/properties/property[@name='ExternalEventTriggerDate']">
			<ExternalEventTriggerDate><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='ExternalEventTriggerDate']"/></xsl:call-template></ExternalEventTriggerDate>
		</xsl:if>
			<IBAN><xsl:value-of select="/cmis/properties/property[@name='IBAN']"/></IBAN>
			<ID><xsl:value-of select="/cmis/properties/property[@name='cmis:objectId']"/></ID>
			<IDNumberFactory><xsl:value-of select="/cmis/properties/property[@name='IDNumberFactory']"/></IDNumberFactory>
			<IDNumberPersonal><xsl:value-of select="/cmis/properties/property[@name='IDNumberPersonal']"/></IDNumberPersonal>
			<Label><xsl:if test="/cmis/properties/property[@name='Label']=''">NN</xsl:if><xsl:value-of select="/cmis/properties/property[@name='Label']"/></Label>
			<Language><xsl:value-of select="/cmis/properties/property[@name='Language']"/></Language>
<xsl:if test="/cmis/properties/property[@name='cmis:lastModificationDate']">
			<ModifiedAt><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='cmis:lastModificationDate']"/></xsl:call-template></ModifiedAt>
</xsl:if>			
			<ModifiedBy><xsl:if test="/cmis/properties/property[@name='cmis:lastModifiedBy']=''">unknown</xsl:if><xsl:value-of select="/cmis/properties/property[@name='cmis:lastModifiedBy']"/></ModifiedBy>
			<Name_LastInsured><xsl:value-of select="/cmis/properties/property[@name='Name_Insured']"/></Name_LastInsured>
			<Name_LastPolicyHolder><xsl:value-of select="/cmis/properties/property[@name='Name_PolicyHolder']"/></Name_LastPolicyHolder>
			<Name_Org><xsl:value-of select="/cmis/properties/property[@name='Name_Organization']"/></Name_Org>
			<PartnerGold><xsl:value-of select="/cmis/properties/property[@name='PartnerGold']"/></PartnerGold>
			<PartnerIntermediary><xsl:value-of select="/cmis/properties/property[@name='PartnerIntermed']"/></PartnerIntermediary>
			<PartnerSilver><xsl:value-of select="/cmis/properties/property[@name='PartnerSilver']"/></PartnerSilver>
			<ProcessID><xsl:value-of select="/cmis/properties/property[@name='ProcessID']"/></ProcessID>
			<ProductCode><xsl:value-of select="/cmis/properties/property[@name='ProductCode']"/></ProductCode>
			<xsl:if test="/cmis/properties/property[@name='ReferenceDate']" >
				<ReferenceDate><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="/cmis/properties/property[@name='ReferenceDate']"/></xsl:call-template></ReferenceDate>
			</xsl:if>
			<RequestNumber><xsl:value-of select="/cmis/properties/property[@name='RequestNumber']"/></RequestNumber>
			<RequiredbylawID><xsl:value-of select="/cmis/properties/property[@name='RequiredbylawID']"/></RequiredbylawID>
			<RetentionTrigger><xsl:value-of select="/cmis/properties/property[@name='RetentionTrigger']"/></RetentionTrigger>
			<Source><xsl:value-of select="/cmis/properties/property[@name='Source']"/></Source>
			<SourceTransactionID><xsl:value-of select="/cmis/properties/property[@name='SourceTransaction']"/></SourceTransactionID>
			<Subject><xsl:value-of select="/cmis/properties/property[@name='Subject']"/></Subject> 
			<Year><xsl:value-of select="/cmis/properties/property[@name='Year']"/></Year> 
 		</MetaData>
	</GetDocumentAndAttributes_Response>
	</xsl:template>
<xsl:template name="parseToDateTime">
		<xsl:param name="dateString"/>
		
		<xsl:choose>
			<xsl:when test="contains($dateString,'+')">
				<xsl:value-of select="substring-before($dateString,'+')"/>
			</xsl:when>
			<xsl:when test="contains($dateString,'T')">
				<xsl:value-of select="$dateString"/>
			</xsl:when>
				<xsl:when test="contains($dateString,'-')">
				<xsl:value-of select="format-date($dateString,'[Y0001]-[M01]-[D01]')"/><xsl:text>T00:00:00</xsl:text>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

<xsl:template name="parseToDate">
		<xsl:param name="dateString"/>
		
		<xsl:choose>
			<xsl:when test="contains($dateString,'+')">
				<xsl:value-of select="substring-before($dateString,'T')"/>
			</xsl:when>
			<xsl:when test="contains($dateString,'T')">
				<xsl:value-of select="substring-before($dateString,'T')"/>
			</xsl:when>
				<xsl:when test="contains($dateString,'-')">
				<xsl:value-of select="format-date($dateString,'[Y0001]-[M01]-[D01]')"/>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>