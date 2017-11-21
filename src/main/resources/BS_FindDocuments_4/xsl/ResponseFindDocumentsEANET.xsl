<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/">
	<FindDocuments_Response>
		<Paging>
			<xsl:if test="FindDocuments_1_Response/Paging/FoundItemCount!=''"><FoundItemCount><xsl:value-of select="FindDocuments_1_Response/Paging/FoundItemCount"/></FoundItemCount></xsl:if>
			<xsl:if test="FindDocuments_1_Response/Paging/HasMoreItems!=''"><HasMoreItems><xsl:value-of select="FindDocuments_1_Response/Paging/HasMoreItems"/></HasMoreItems></xsl:if>
		</Paging>
		<xsl:apply-templates select="FindDocuments_1_Response/SearchResult"/>
		<xsl:apply-templates select="FindDocuments_1_Response/Result" mode="Result"/>
	</FindDocuments_Response>
		</xsl:template>

	<xsl:template match="*" mode="Result">
		<xsl:element name="{local-name()}" namespace="http://nn.nl/XSD/Generic/MessageHeader/1" >
			<xsl:apply-templates mode="#current"/>
		</xsl:element>
	</xsl:template>
		
<xsl:template match="SearchResult">
<SearchResult>
	<DocumentClass><xsl:value-of select="DocumentClass"/></DocumentClass>
	<MetaData>
	 	<AddressedTo><xsl:value-of select="MetaData/AddressedTo"/></AddressedTo>
		<xsl:if test="MetaData/ArrivedAt!=''"><ArrivedAt><xsl:value-of select="MetaData/ArrivedAt"/></ArrivedAt></xsl:if>
		<ArrivedBy><xsl:value-of select="MetaData/ArrivedBy"/></ArrivedBy>
		<xsl:for-each select="tokenize(MetaData/AuthorizedTo,',')">
		 	<AuthorizedTo><xsl:value-of select="."/></AuthorizedTo>
		</xsl:for-each>
		<xsl:if test="MetaData/BirthDt!=''"><BirthDt><xsl:value-of select="MetaData/BirthDt"/></BirthDt></xsl:if>
		<ClaimNumber><xsl:value-of select="MetaData/ClaimNumber"/></ClaimNumber>
		<xsl:if test="MetaData/ContentRetentionDate!=''"><ContentRetentionDate><xsl:value-of select="MetaData/ContentRetentionDate"/></ContentRetentionDate></xsl:if>
		<Contract_Nr><xsl:value-of select="MetaData/Contract_Nr"/></Contract_Nr>
		<Contract_NrAccount><xsl:value-of select="MetaData/Contract_NrAccount"/></Contract_NrAccount>
		<Contract_NrDeposit><xsl:value-of select="MetaData/Contract_NrDeposit"/></Contract_NrDeposit>
		<Contract_NrLoan><xsl:value-of select="MetaData/Contract_NrLoan"/></Contract_NrLoan>
		<Contract_NrPolicy><xsl:value-of select="MetaData/Contract_NrPolicy"/></Contract_NrPolicy>
		<Contract_NrQuotation><xsl:value-of select="MetaData/Contract_NrQuote"/></Contract_NrQuotation>
		<xsl:if test="MetaData/ConversionDate!=''"><ConversionDate><xsl:value-of select="MetaData/ConversionDate"/></ConversionDate></xsl:if>
		<ConversionOrigin><xsl:value-of select="MetaData/ConversionOrigin"/></ConversionOrigin>
		<xsl:if test="MetaData/CreatedAt!=''"><CreatedAt><xsl:value-of select="MetaData/CreatedAt"/></CreatedAt></xsl:if>
		<CreatedBy><xsl:value-of select="MetaData/CreatedBy"/></CreatedBy>
		<xsl:if test="MetaData/DateContentLastAccessed!=''"><DateContentLastAccessed><xsl:value-of select="MetaData/DateContentLastAccessed"/></DateContentLastAccessed></xsl:if>
		<DescriptionProductGroup><xsl:value-of select="MetaData/DescrProductGroup"/></DescriptionProductGroup>
		<DocumentDetail><xsl:value-of select="MetaData/DocumentDetail"/></DocumentDetail>
		<DocumentID><xsl:value-of select="MetaData/DocumentID"/></DocumentID>
		<DocumentRelationID><xsl:value-of select="MetaData/DocumentRelationID"/></DocumentRelationID>
		<DocumentRouting><xsl:value-of select="MetaData/DocumentRouting"/></DocumentRouting>
		<DocumentTitle><xsl:value-of select="MetaData/DocumentTitle"/></DocumentTitle>
		<DocumentType><xsl:value-of select="MetaData/DocumentType"/></DocumentType>
		<xsl:if test="MetaData/ExternalEventTriggerDate!=''"><ExternalEventTriggerDate><xsl:value-of select="MetaData/ExternalEventTriggerDate"/></ExternalEventTriggerDate></xsl:if>
		<IBAN><xsl:value-of select="MetaData/IBAN"/></IBAN>
		<ID><xsl:value-of select="MetaData/ID"/></ID>
		<IDNumberFactory><xsl:value-of select="MetaData/IDNumberFactory"/></IDNumberFactory>
		<IDNumberPersonal><xsl:value-of select="MetaData/IDNumberPersonal"/></IDNumberPersonal>
		<Label><xsl:value-of select="MetaData/Label"/></Label>
		<Language><xsl:value-of select="property[@name='Language']"/></Language>
		<MimeType><xsl:value-of select="MetaData/MimeType"/></MimeType>
		<xsl:if test="MetaData/ModifiedAt!=''"><ModifiedAt><xsl:value-of select="MetaData/ModifiedAt"/></ModifiedAt></xsl:if>
		<ModifiedBy><xsl:value-of select="MetaData/ModifiedBy"/></ModifiedBy>
		<Name_LastInsured><xsl:value-of select="MetaData/Name_Insured"/></Name_LastInsured>
		<Name_LastPolicyHolder><xsl:value-of select="MetaData/Name_PolicyHolder"/></Name_LastPolicyHolder>
		<Name_Org><xsl:value-of select="MetaData/Name_Organization"/></Name_Org>
		<PartnerGold><xsl:value-of select="MetaData/PartnerGold"/></PartnerGold>
		<PartnerIntermediary><xsl:value-of select="MetaData/PartnerIntermed"/></PartnerIntermediary>
		<PartnerSilver><xsl:value-of select="MetaData/PartnerSilver"/></PartnerSilver>
		<ProcessID><xsl:value-of select="MetaData/ProcessID"/></ProcessID>
		<xsl:if test="MetaData/ReferenceDate!=''"><ReferenceDate><xsl:value-of select="MetaData/ReferenceDate"/></ReferenceDate></xsl:if>
		<RequestNumber><xsl:value-of select="MetaData/RequestNumber"/></RequestNumber>
		<RequiredbylawID><xsl:value-of select="MetaData/RequiredbylawID"/></RequiredbylawID>
		<RetentionTrigger><xsl:value-of select="MetaData/RetentionTrigger"/></RetentionTrigger>
		<Source><xsl:value-of select="MetaData/Source"/></Source>
		<SourceTransactionID><xsl:value-of select="MetaData/SourceTransaction"/></SourceTransactionID>
		<Subject><xsl:value-of select="MetaData/Subject"/></Subject>
  		<Year><xsl:value-of select="MetaData/Year"/></Year>
 		</MetaData>
	</SearchResult>
</xsl:template>
</xsl:stylesheet>