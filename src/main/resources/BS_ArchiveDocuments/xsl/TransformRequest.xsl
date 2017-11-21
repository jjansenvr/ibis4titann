<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="domainLookup" select="document('../../Migration/migrationDomains.xml')" />
	<xsl:param name="systemDate"/>
	<xsl:template match="/">
	<xsl:variable name="Class">
		<xsl:call-template name="lookup">
			<xsl:with-param name="lookupValue" select="ArchiveDocument_1_Action/Document/DocumentClass"/>
			<xsl:with-param name="lookupName" select="'DocumentClass'"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="FileExtension">
		<xsl:call-template name="lookup">
			<xsl:with-param name="lookupValue" select="ArchiveDocument_1_Action/File/MimeType"/>
			<xsl:with-param name="lookupName" select="'FileExtension'"/>
		</xsl:call-template>
	</xsl:variable>
	<cmis>
		<name><xsl:value-of select="normalize-space( replace( replace( replace( substring(ArchiveDocument_1_Action/Document/MetaData/DocumentTitle,1,44) ,'%' ,' ') ,'/' ,' '),'\\' ,' '))" /></name>
		<objectTypeId>
			<xsl:choose>
				<xsl:when test="$Class!=''"><xsl:value-of select="$Class"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="ArchiveDocument_1_Action/Document/DocumentClass"/></xsl:otherwise>
			</xsl:choose>
		</objectTypeId>
		<mediaType><xsl:value-of select="ArchiveDocument_1_Action/File/MimeType"/></mediaType>
		<fileName><xsl:if test="(ArchiveDocument_1_Action/File/FileName='') or  not(ArchiveDocument_1_Action/File/FileName)">file0.<xsl:value-of select="$FileExtension"/></xsl:if><xsl:value-of select="substring(ArchiveDocument_1_Action/File/FileName, 1, 44)"/></fileName>
		<xsl:apply-templates select="ArchiveDocument_1_Action/Document/MetaData">
			<xsl:with-param name="Class" select="$Class"/>
		</xsl:apply-templates>
	</cmis>
	</xsl:template>

	<xsl:template match="MetaData">
	<xsl:param name="Class"/>
		<properties>
			<xsl:if test="AddressedTo"><property name="AddressedTo"><xsl:value-of select="AddressedTo"/></property></xsl:if>
			<xsl:if test="ArrivedAt"><property name="ArrivedAt"><xsl:value-of select="ArrivedAt"/></property></xsl:if>
			<xsl:if test="ArrivedBy"><property name="ArrivedBy"><xsl:value-of select="ArrivedBy"/></property></xsl:if>
			<xsl:if test="AuthorizedTo"><property name="AuthorizedTo"><xsl:value-of  select="string-join(AuthorizedTo, ',')"/></property></xsl:if>
			<xsl:if test="BirthDt"><property name="BirthDate" type="datetime" formatString="yyyy-MM-dd"><xsl:value-of select="format-date(BirthDt,'[Y0001]-[M01]-[D01]')"/></property></xsl:if>
			<xsl:if test="ClaimNumber"><property name="ClaimNumber"><xsl:value-of select="ClaimNumber"/></property></xsl:if>
			<xsl:if test="Contract_Nr"><property name="Contract_Nr"><xsl:value-of select="Contract_Nr"/></property></xsl:if>
			<xsl:if test="Contract_NrAccount"><property name="Contract_NrAccount"><xsl:value-of select="Contract_NrAccount"/></property></xsl:if>
			<xsl:if test="Contract_NrDeposit"><property name="Contract_NrDeposit"><xsl:value-of select="Contract_NrDeposit"/></property></xsl:if>
			<xsl:if test="Contract_NrLoan"><property name="Contract_NrLoan"><xsl:value-of select="Contract_NrLoan"/></property></xsl:if>
			<xsl:if test="Contract_NrPolicy"><property name="Contract_NrPolicy"><xsl:value-of select="Contract_NrPolicy"/></property></xsl:if>
			<xsl:if test="Contract_NrQuotation"><property name="Contract_NrQuote"><xsl:value-of select="Contract_NrQuotation"/></property></xsl:if>
			<xsl:if test="ConversionDate"><property name="ConversionDate" ><xsl:value-of select="ConversionDate"/></property></xsl:if>
			<xsl:if test="ConversionOrigin"><property name="ConversionOrigin"><xsl:value-of select="ConversionOrigin"/></property></xsl:if>
			<property name="CreatedAt"  formatString="yyyy-MM-dd" type="datetime"><xsl:value-of select="$systemDate"/></property>
			<property name="CreatedBy"><xsl:if test="../../RequestUserId=''">cmisuser</xsl:if><xsl:value-of select="../../RequestUserId"/></property>
			<xsl:if test="DescriptionProductGroup"><property name="DescrProductGroup"><xsl:value-of select="DescriptionProductGroup"/></property></xsl:if>
			<xsl:if test="DocumentDetail"><property name="DocumentDetail"><xsl:value-of select="DocumentDetail"/></property></xsl:if>
			<xsl:if test="DocumentID"><property name="DocumentID"><xsl:value-of select="DocumentID"/></property></xsl:if>
			<xsl:if test="DocumentRelationID"><property name="DocumentRelationID"><xsl:value-of select="DocumentRelationID"/></property></xsl:if>
			<xsl:if test="DocumentRouting"><property name="DocumentRouting"><xsl:value-of select="DocumentRouting"/></property></xsl:if>
			<xsl:if test="DocumentTitle"><property name="DocumentName"><xsl:value-of select="DocumentTitle"/></property></xsl:if>
			<xsl:if test="DocumentType"><property name="DocumentType"><xsl:value-of select="DocumentType"/></property></xsl:if>
			<xsl:if test="FileToolVersion"><property name="FileToolVersion"><xsl:value-of select="../../File/FileToolVersion"/></property></xsl:if>
			<xsl:if test="../../File/FileName"><property name="FileName"><xsl:value-of select="../../File/FileName"/></property></xsl:if>
			<xsl:if test="IBAN"><property name="IBAN"><xsl:value-of select="IBAN"/></property></xsl:if>
			<xsl:if test="IDNumberFactory"><property name="IDNumberFactory"><xsl:value-of select="IDNumberFactory"/></property></xsl:if>
			<xsl:if test="IDNumberPersonal"><property name="IDNumberPersonal"><xsl:value-of select="IDNumberPersonal"/></property></xsl:if>
			<xsl:if test="Label"><property name="Label"><xsl:value-of select="Label"/></property></xsl:if>
			<xsl:if test="Language"><property name="Language"><xsl:value-of select="Language"/></property></xsl:if>
			<xsl:if test="Name_LastInsured"><property name="Name_Insured"><xsl:value-of select="Name_LastInsured"/></property></xsl:if>
			<xsl:if test="Name_LastPolicyHolder"><property name="Name_PolicyHolder"><xsl:value-of select="Name_LastPolicyHolder"/></property></xsl:if>
			<xsl:if test="Name_Org"><property name="Name_Organization"><xsl:value-of select="Name_Org"/></property></xsl:if>
			<xsl:if test="PartnerGold"><property name="PartnerGold"><xsl:value-of select="PartnerGold"/></property></xsl:if>
			<xsl:if test="PartnerIntermediary"><property name="PartnerIntermed"><xsl:value-of select="PartnerIntermediary"/></property></xsl:if>
			<xsl:if test="PartnerSilver"><property name="PartnerSilver"><xsl:value-of select="PartnerSilver"/></property></xsl:if>
			<xsl:if test="ProcessID"><property name="ProcessID"><xsl:value-of select="ProcessID"/></property></xsl:if>
			<xsl:if test="ProductCode"><property name="ProductCode"><xsl:value-of select="ProductCode"/></property></xsl:if>
			<xsl:if test="ReferenceDate"><property name="ReferenceDate" type="datetime" formatString="yyyy-MM-dd"><xsl:value-of select="format-date(ReferenceDate,'[Y0001]-[M01]-[D01]')"/></property></xsl:if>
			<xsl:if test="RequestNumber"><property name="RequestNumber"><xsl:value-of select="RequestNumber"/></property></xsl:if>
			<xsl:if test="RequiredbylawID"><property name="RequiredbylawID"><xsl:value-of select="RequiredbylawID"/></property></xsl:if>
			<property name="RetentionPolicy">
				<xsl:choose>
					<xsl:when test="$Class!=''">
						<xsl:call-template name="lookup">
							<xsl:with-param name="lookupValue" select="../DocumentClass"/>
							<xsl:with-param name="lookupName" select="'RetentionPolicy'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="../SetRetention/RetentionPolicy"/></xsl:otherwise>
				</xsl:choose>
			</property>
			<xsl:if test="../SetRetention/RetentionTrigger"><property name="RetentionTrigger"><xsl:value-of select="../SetRetention/RetentionTrigger"/></property></xsl:if>
			<xsl:if test="DocumentTitle">
			<property name="ShortTitle"><xsl:value-of select="normalize-space( replace( replace( replace( substring(DocumentTitle,1,44) ,'%' ,' ') ,'/' ,' '),'\\' ,' '))" /></property>
			</xsl:if>
			<xsl:if test="../../Source"><property name="Source"><xsl:choose><xsl:when test="lower-case(../../Source)='streamserve'">STRS</xsl:when><xsl:otherwise><xsl:value-of select="../../Source"/></xsl:otherwise></xsl:choose></property></xsl:if>
			<xsl:if test="../../SourceTransactionID"><property name="SourceTransaction"><xsl:value-of select="../../SourceTransactionID"/></property></xsl:if>
			<xsl:if test="Subject"><property name="Subject"><xsl:value-of select="Subject"/></property></xsl:if>
			<xsl:if test="Year"><property name="Year"><xsl:value-of select="Year"/></property></xsl:if>
		</properties>
	</xsl:template>
	
	<xsl:template name="lookup">
		<xsl:param name="lookupValue"/>
		<xsl:param name="lookupName"/>
		<xsl:choose>
			<xsl:when test="$domainLookup/domains/domain[@name=$lookupName]/value[@from=$lookupValue]/@to">
				<xsl:value-of select="$domainLookup/domains/domain[@name=$lookupName]/value[@from=$lookupValue]/@to"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$domainLookup/domains/domain[@name=$lookupName]/default/@to"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
			
</xsl:stylesheet>