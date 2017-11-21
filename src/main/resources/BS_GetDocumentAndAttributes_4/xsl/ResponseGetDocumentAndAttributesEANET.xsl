<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/GetDocumentAndAttributes_1_Response">
		<GetDocumentAndAttributes_Response>
			<xsl:apply-templates select="File"/>
			<xsl:apply-templates select="MetaData"/>
			<xsl:apply-templates select="Result" mode="Result"/>
		</GetDocumentAndAttributes_Response>
	</xsl:template>
    
    	<xsl:template match="*" mode="Result">
        <xsl:element name="{local-name()}" namespace="http://nn.nl/XSD/Generic/MessageHeader/2" >
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template>


	<xsl:template match="File">
			<File>
 			<FileContent><xsl:value-of select="FileContent"/></FileContent>
			<FileName><xsl:value-of select="FileName"/></FileName>
			<FileSize><xsl:value-of select="FileSize"/></FileSize>
			<FileToolVersion><xsl:value-of select="FileToolVersion"/></FileToolVersion>
			<MimeType><xsl:if test="MimeType=''">unknown</xsl:if><xsl:value-of select="MimeType"/></MimeType>
 		</File>
	</xsl:template>
	<xsl:template match="MetaData">	
		<MetaData>
 			<AddressedTo><xsl:value-of select="AddressedTo"/></AddressedTo>
			<!-- Annotation -->
			<ArrivedAt><xsl:value-of select="AddressedTo"/></ArrivedAt>
			<ArrivedBy><xsl:value-of select="ArrivedBy"/></ArrivedBy>
			<BirthDt><xsl:value-of select="BirthDt"/></BirthDt>
			<ClaimNumber><xsl:value-of select="BirthDt"/></ClaimNumber>
			<ContentRetentionDate><xsl:value-of select="ContentRetentionDate"/></ContentRetentionDate>
			<Contract_Nr><xsl:value-of select="Contract_Nr"/></Contract_Nr>
			<Contract_NrAccount><xsl:value-of select="Contract_NrAccount"/></Contract_NrAccount>
			<Contract_NrDeposit><xsl:value-of select="Contract_NrAccount"/></Contract_NrDeposit>
			<Contract_NrLoan><xsl:value-of select="Contract_NrLoan"/></Contract_NrLoan>
			<Contract_NrPolicy><xsl:value-of select="Contract_NrPolicy"/></Contract_NrPolicy>
			<Contract_NrQuotation><xsl:value-of select="Contract_NrQuote"/></Contract_NrQuotation>
<!-- 		<xsl:if test="ConversionDate"> -->
<!-- 			<ConversionDate><xsl:call-template name="parseToDateTime"><xsl:value-of select="ConversionDate"/></ConversionDate> -->
<!-- 		</xsl:if> -->
			<ConversionOrigin><xsl:value-of select="ConversionOrigin"/></ConversionOrigin>
			<CreatedAt><xsl:value-of select="CreatedAt"/></CreatedAt>
			<CreatedBy><xsl:value-of select="CreatedBy"/></CreatedBy>
			<DateContentLastAccessed><xsl:value-of select="DateContentLastAccessed"/></DateContentLastAccessed>
			<DescriptionProductGroup><xsl:value-of select="DescrProductGroup"/></DescriptionProductGroup>
			<DocumentDetail><xsl:value-of select="DocumentDetail"/></DocumentDetail>
			<DocumentID><xsl:value-of select="DocumentID"/></DocumentID>
			<DocumentRelationID><xsl:value-of select="DocumentRelationID"/></DocumentRelationID>
			<DocumentRouting><xsl:value-of select="DocumentRouting"/></DocumentRouting>
			<DocumentTitle><xsl:value-of select="DocumentName"/></DocumentTitle>
			<DocumentType><xsl:value-of select="DocumentType"/></DocumentType>
			<ExternalEventTriggerDate><xsl:value-of select="ExternalEventTriggerDate"/></ExternalEventTriggerDate>
			<IBAN><xsl:value-of select="IBAN"/></IBAN>
			<ID><xsl:value-of select="ID"/></ID>
			<IDNumberFactory><xsl:value-of select="IDNumberFactory"/></IDNumberFactory>
			<IDNumberPersonal><xsl:value-of select="IDNumberPersonal"/></IDNumberPersonal>
			<Label><xsl:if test="Label=''">NN</xsl:if><xsl:value-of select="Label"/></Label>
			<ModifiedAt><xsl:value-of select="ModifiedAt"/></ModifiedAt>
			<ModifiedBy><xsl:value-of select="ModifiedBy"/></ModifiedBy>
			<Name_LastInsured><xsl:value-of select="Name_Insured"/></Name_LastInsured>
			<Name_LastPolicyHolder><xsl:value-of select="Name_PolicyHolder"/></Name_LastPolicyHolder>
			<Name_Org><xsl:value-of select="Name_Organization"/></Name_Org>
			<PartnerGold><xsl:value-of select="PartnerGold"/></PartnerGold>
			<PartnerIntermediary><xsl:value-of select="PartnerIntermed"/></PartnerIntermediary>
			<PartnerSilver><xsl:value-of select="PartnerSilver"/></PartnerSilver>
			<ProcessID><xsl:value-of select="ProcessID"/></ProcessID>
			<ReferenceDate><xsl:value-of select="ReferenceDate"/></ReferenceDate>
			<RequestNumber><xsl:value-of select="RequestNumber"/></RequestNumber>
			<RequiredbylawID><xsl:value-of select="RequiredbylawID"/></RequiredbylawID>
			<RetentionTrigger><xsl:value-of select="RetentionTrigger"/></RetentionTrigger>
			<Source><xsl:value-of select="Source"/></Source>
			<SourceTransactionID><xsl:value-of select="SourceTransaction"/></SourceTransactionID>
			<Subject><xsl:value-of select="Subject"/></Subject> 
			<Year><xsl:value-of select="Year"/></Year> 
 		</MetaData>
	</xsl:template>

</xsl:stylesheet>