<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="pageSize">1000</xsl:param>
	<xsl:param name="skipCount">0</xsl:param>
      					
	<xsl:template match="/results">
	<FindDocuments_Response>
		<xsl:choose>
 			<xsl:when test="row">
	 			<Paging>
	 				<xsl:if test="FoundItemCount!=''"><FoundItemCount></FoundItemCount></xsl:if>
	 				<HasMoreItems><xsl:choose>
							<xsl:when test="row">true</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</HasMoreItems>
	 			</Paging>
	 			<xsl:apply-templates select="row"/>
	 			</xsl:when>
 			<xsl:otherwise>
 			<Paging>
 				<FoundItemCount>0</FoundItemCount>
 				<HasMoreItems>false</HasMoreItems>
 			</Paging>
 			</xsl:otherwise>
 		</xsl:choose>
 		
	</FindDocuments_Response>
	</xsl:template>


<xsl:template match="row">
<xsl:variable name="pos" select ="position()" />
<xsl:if test="($pos &gt; number($skipCount) ) and ($pos &lt;= number($skipCount + $pageSize))">
<SearchResult>
	<DocumentClass><xsl:if test="property[@name='cmis:objectTypeId']=''">DOCUMENTCLASS UNKNOWN</xsl:if><xsl:value-of select="property[@name='cmis:objectTypeId']"/></DocumentClass>
	<MetaData>
			<AddressedTo><xsl:value-of select="property[@name='AddressedTo']"/></AddressedTo>
			<xsl:if test="property[@name='ArrivedAt']">
			<ArrivedAt><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="property[@name='ArrivedAt']"/></xsl:call-template></ArrivedAt>
			</xsl:if>
			<ArrivedBy><xsl:value-of select="property[@name='ArrivedBy']"/></ArrivedBy>
			<xsl:for-each select="tokenize(property[@name='AuthorizedTo'],',')">
				<AuthorizedTo><xsl:value-of select="."/></AuthorizedTo>
			</xsl:for-each>
			
			
		<xsl:if test="property[@name='BirthDate']" >
				<BirthDt><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="property[@name='BirthDate']"/></xsl:call-template></BirthDt>
		</xsl:if>
			<ClaimNumber><xsl:value-of select="property[@name='ClaimNumber']"/></ClaimNumber>
		<xsl:if test="property[@name='ContentRetentionDate']" >
			<ContentRetentionDate><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="property[@name='ContentRetentionDate']"/></xsl:call-template></ContentRetentionDate>
		</xsl:if>
			<Contract_Nr><xsl:value-of select="property[@name='Contract_Nr']"/></Contract_Nr>
			<Contract_NrAccount><xsl:value-of select="property[@name='Contract_NrAccount']"/></Contract_NrAccount>
			<Contract_NrDeposit><xsl:value-of select="property[@name='Contract_NrDeposit']"/></Contract_NrDeposit>
			<Contract_NrLoan><xsl:value-of select="property[@name='Contract_NrLoan']"/></Contract_NrLoan>
			<Contract_NrPolicy><xsl:value-of select="property[@name='Contract_NrPolicy']"/></Contract_NrPolicy>
			<Contract_NrQuotation><xsl:value-of select="property[@name='Contract_NrQuote']"/></Contract_NrQuotation>
<!-- 		<xsl:if test="property[@name='ConversionDate']" > -->
<!-- 			<ConversionDate><xsl:value-of select="property[@name='ConversionDate']"/></ConversionDate> -->
<!-- 		</xsl:if> -->
			<ConversionOrigin><xsl:value-of select="property[@name='ConversionOrigin']"/></ConversionOrigin>
			<xsl:if test="property[@name='CreatedAt']">
			<CreatedAt><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="property[@name='CreatedAt']"/></xsl:call-template></CreatedAt>
			</xsl:if>
			<CreatedBy><xsl:if test="property[@name='CreatedBy']=''">unknown</xsl:if><xsl:value-of select="property[@name='CreatedBy']"/></CreatedBy>
		<xsl:if test="property[@name='DateContentLastAccessed']" >
			<DateContentLastAccessed><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="property[@name='DateContentLastAccessed']"/></xsl:call-template></DateContentLastAccessed>
		</xsl:if>
			<DescriptionProductGroup><xsl:value-of select="property[@name='DescrProductGroup']"/></DescriptionProductGroup>
			<DocumentDetail><xsl:value-of select="property[@name='DocumentDetail']"/></DocumentDetail>
			<DocumentID><xsl:value-of select="property[@name='DocumentID']"/></DocumentID>
			<DocumentRelationID><xsl:value-of select="property[@name='DocumentRelationID']"/></DocumentRelationID>
			<DocumentRouting><xsl:if test="property[@name='DocumentRouting']!='Unknown'"><xsl:value-of select="property[@name='DocumentRouting']"/></xsl:if></DocumentRouting>
			<DocumentTitle><xsl:value-of select="property[@name='DocumentName']"/></DocumentTitle>
			<DocumentType><xsl:value-of select="property[@name='DocumentType']"/></DocumentType>
		<xsl:if test="property[@name='ExternalEventTriggerDate']">
			<ExternalEventTriggerDate><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="property[@name='ExternalEventTriggerDate']"/></xsl:call-template></ExternalEventTriggerDate>
		</xsl:if>
			<IBAN><xsl:value-of select="property[@name='IBAN']"/></IBAN>
			<ID><xsl:value-of select="property[@name='cmis:objectId']"/></ID>
			<IDNumberFactory><xsl:value-of select="property[@name='IDNumberFactory']"/></IDNumberFactory>
			<IDNumberPersonal><xsl:value-of select="property[@name='IDNumberPersonal']"/></IDNumberPersonal>
			<Label><xsl:value-of select="property[@name='Label']"/></Label>
			<Language><xsl:value-of select="property[@name='Language']"/></Language>
			<MimeType><xsl:value-of select="property[@name='cmis:contentStreamMimeType']"/></MimeType>
<xsl:if test="property[@name='cmis:lastModificationDate']">
			<ModifiedAt><xsl:call-template name="parseToDateTime"><xsl:with-param name="dateString" select="property[@name='cmis:lastModificationDate']"/></xsl:call-template></ModifiedAt>
</xsl:if>			
			<ModifiedBy><xsl:if test="property[@name='cmis:lastModifiedBy']=''">unknown</xsl:if><xsl:value-of select="property[@name='cmis:lastModifiedBy']"/></ModifiedBy>
			<Name_LastInsured><xsl:value-of select="property[@name='Name_Insured']"/></Name_LastInsured>
			<Name_LastPolicyHolder><xsl:value-of select="property[@name='Name_PolicyHolder']"/></Name_LastPolicyHolder>
			<Name_Org><xsl:value-of select="property[@name='Name_Organization']"/></Name_Org>
			<PartnerGold><xsl:value-of select="property[@name='PartnerGold']"/></PartnerGold>
			<PartnerIntermediary><xsl:value-of select="property[@name='PartnerIntermed']"/></PartnerIntermediary>
			<PartnerSilver><xsl:value-of select="property[@name='PartnerSilver']"/></PartnerSilver>
			<ProcessID><xsl:value-of select="property[@name='ProcessID']"/></ProcessID>
			<ProductCode><xsl:value-of select="property[@name='ProductCode']"/></ProductCode>
		<xsl:if test="property[@name='ReferenceDate']" >
			<ReferenceDate><xsl:call-template name="parseToDate"><xsl:with-param name="dateString" select="property[@name='ReferenceDate']"/></xsl:call-template></ReferenceDate>
		</xsl:if>
			<RequestNumber><xsl:value-of select="property[@name='RequestNumber']"/></RequestNumber>
			<RequiredbylawID><xsl:value-of select="property[@name='RequiredbylawID']"/></RequiredbylawID>
<!-- 			<RetentionPolicy><xsl:value-of select="property[@name='RetentionPolicy']"/></RetentionPolicy> -->
			<RetentionTrigger><xsl:value-of select="property[@name='RetentionTrigger']"/></RetentionTrigger>
			<Source><xsl:value-of select="property[@name='Source']"/></Source>
			<SourceTransactionID><xsl:value-of select="property[@name='SourceTransaction']"/></SourceTransactionID>
			<Subject><xsl:value-of select="property[@name='Subject']"/></Subject> 
  			<Year><xsl:value-of select="property[@name='Year']"/></Year> 
 		</MetaData>
</SearchResult>
</xsl:if>
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
