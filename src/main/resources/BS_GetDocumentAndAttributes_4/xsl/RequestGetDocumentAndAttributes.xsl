<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!-- used for operationversions 2 and 3-->
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:variable name="domainLookup" select="document('../../Migration/migrationDomains.xml')" />
	<xsl:param name="systemDate"/>
	<xsl:template match="FindDocuments_Request">
	<xsl:variable name="Class">
		<xsl:call-template name="lookup">
			<xsl:with-param name="lookupValue" select="DocumentClass"/>
			<xsl:with-param name="lookupName" select="'DocumentClass'"/>
		</xsl:call-template>
	</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length(CMISSearch)>0">
				<query>
					<statement><xsl:value-of select="CMISSearch"/></statement>
					<searchAllVersions>false</searchAllVersions>
					<includeAllowableActions>false</includeAllowableActions>
					<includeRelationships>none</includeRelationships>
					<maxItems><xsl:choose><xsl:when  test="string-length(Paging/MaxItems)>0"><xsl:value-of select="Paging/MaxItems"/></xsl:when><xsl:otherwise>1000</xsl:otherwise></xsl:choose></maxItems>
					<skipCount><xsl:value-of select="Paging/SkipCount"/></skipCount>
				</query>
			</xsl:when>
			<xsl:otherwise>
				<query>
					<statement><xsl:text>SELECT * FROM </xsl:text>
						<xsl:choose>
							<xsl:when test="DocumentClass!=''">
								<xsl:choose>
									<xsl:when test="$Class!=''">
										<xsl:value-of select="$Class"/>
									</xsl:when>
									<xsl:otherwise><xsl:value-of select="DocumentClass"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>NN1_L_GENERIEK</xsl:otherwise>
						</xsl:choose>
						<xsl:text> WHERE </xsl:text>
						<xsl:call-template name="BuildQuery"/>
					<xsl:call-template name="Sorting"/>
					</statement>
					<searchAllVersions>false</searchAllVersions>
					<includeAllowableActions>false</includeAllowableActions>
					<includeRelationships>none</includeRelationships>
					<maxItems><xsl:choose><xsl:when  test="string-length(Paging/MaxItems)>0"><xsl:value-of select="Paging/MaxItems"/></xsl:when><xsl:otherwise>1000</xsl:otherwise></xsl:choose></maxItems>
					<skipCount><xsl:value-of select="Paging/SkipCount"/></skipCount>
				</query>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="Sorting">
		<!-- <xsl:choose>
		<xsl:when test="string-length(Paging/SortAttribute)>0"><xsl:text> ORDER BY </xsl:text><xsl:value-of select="Paging/SortAttribute"/></xsl:when>
		<xsl:otherwise>--><xsl:text> ORDER BY cmis:objectId</xsl:text> <!-- </xsl:otherwise>
		</xsl:choose>-->
		<xsl:choose>
			<xsl:when test="Paging/SortOrder='Ascending'">
				<xsl:text> ASC</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text> DESC</xsl:text>
			</xsl:otherwise>
			</xsl:choose>
	</xsl:template>
	<xsl:template name="BuildQuery">
		<xsl:variable name="searchstrings">
			<searchAttributes>
				<!-- <xsl:apply-templates select="SearchRanges"/> -->
				<xsl:apply-templates select="SearchRanges" mode="infoimage"/>
				<xsl:apply-templates select="SearchAttributes"/>
			</searchAttributes>
		</xsl:variable>
		<xsl:value-of select="$searchstrings/searchAttributes/searchAttribute" separator=" and "/>
	</xsl:template>
	<xsl:template match="SearchRanges" mode="infoimage">
	<xsl:choose>
		<xsl:when test="string-length(ArrivedAtBegin)>0 and string-length(ArrivedAtEnd)>0">
			<searchAttribute>ArrivedAt = &apos;~BETWEEN <xsl:value-of select="ArrivedAtBegin"/>|<xsl:value-of select="ArrivedAtEnd"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ArrivedAtBegin)>0">
			<searchAttribute>ArrivedAt &gt;= &apos;<xsl:value-of select="ArrivedAtBegin"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ArrivedAtEnd)>0">
			<searchAttribute>ArrivedAt &lt;= &apos;<xsl:value-of select="ArrivedAtEnd"/>&apos;</searchAttribute>
		</xsl:when>
	</xsl:choose>
	
	<xsl:choose>
		<xsl:when test="string-length(ConversionDateBegin)>0 and string-length(ConversionDateEnd)>0">
			<searchAttribute>ConversionDate = &apos;~BETWEEN <xsl:value-of select="ConversionDateBegin"/>|<xsl:value-of select="ConversionDateEnd"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ConversionDateBegin)>0">
			<searchAttribute>ConversionDate &gt;= &apos;<xsl:value-of select="ConversionDateBegin"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ConversionDateEnd)>0">
			<searchAttribute>ConversionDate &lt;= &apos;<xsl:value-of select="ConversionDateEnd"/>&apos;</searchAttribute>
		</xsl:when>
	</xsl:choose>
	
	<xsl:choose>
		<xsl:when test="string-length(CreatedAtBegin)>0 and string-length(CreatedAtEnd)>0">
			<searchAttribute>CreatedAt = &apos;~BETWEEN <xsl:value-of select="CreatedAtBegin"/>|<xsl:value-of select="CreatedAtEnd"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(CreatedAtBegin)>0">
			<searchAttribute>CreatedAt &gt;= &apos;<xsl:value-of select="CreatedAtBegin"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(CreatedAtEnd)>0">
			<searchAttribute>CreatedAt &lt;= &apos;<xsl:value-of select="CreatedAtEnd"/>&apos;</searchAttribute>
		</xsl:when>
	</xsl:choose>
		
	<xsl:choose>
		<xsl:when test="string-length(ExternalEventTriggerDateBegin)>0 and string-length(ExternalEventTriggerDateEnd)>0">
			<searchAttribute>ExternalEventTriggerDate = &apos;~BETWEEN <xsl:value-of select="ExternalEventTriggerDateBegin"/>|<xsl:value-of select="ExternalEventTriggerDateEnd"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ExternalEventTriggerDateBegin)>0">
			<searchAttribute>ExternalEventTriggerDate &gt;= &apos;<xsl:value-of select="ExternalEventTriggerDateBegin"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ExternalEventTriggerDateEnd)>0">
			<searchAttribute>ExternalEventTriggerDate &lt;= &apos;<xsl:value-of select="ExternalEventTriggerDateEnd"/>&apos;</searchAttribute>
		</xsl:when>
	</xsl:choose>

	<xsl:choose>
		<xsl:when test="string-length(ModifiedAtBegin)>0 and string-length(ModifiedAtEnd)>0">
			<searchAttribute>ModifiedAt = &apos;~BETWEEN <xsl:value-of select="ModifiedAtBegin"/>|<xsl:value-of select="ModifiedAtEnd"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ModifiedAtBegin)>0">
			<searchAttribute>ModifiedAt &gt;= &apos;<xsl:value-of select="ModifiedAtBegin"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ModifiedAtEnd)>0">
			<searchAttribute>ModifiedAt &lt;= &apos;<xsl:value-of select="ModifiedAtEnd"/>&apos;</searchAttribute>
		</xsl:when>
	</xsl:choose>

	<xsl:choose>
		<xsl:when test="string-length(ReferenceDateBegin)>0 and string-length(ReferenceDateEnd)>0">
			<searchAttribute>ReferenceDate = &apos;~BETWEEN <xsl:value-of select="ReferenceDateBegin"/>|<xsl:value-of select="ReferenceDateEnd"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ReferenceDateBegin)>0">
			<searchAttribute>ReferenceDate &gt;= &apos;<xsl:value-of select="ReferenceDateBegin"/>&apos;</searchAttribute>
		</xsl:when>
		<xsl:when test="string-length(ReferenceDateEnd)>0">
			<searchAttribute>ReferenceDate &lt;= &apos;<xsl:value-of select="ReferenceDateEnd"/>&apos;</searchAttribute>
		</xsl:when>
	</xsl:choose>
	
	</xsl:template>



<!-- 	<xsl:template match="SearchRanges">
		<xsl:if test="string-length(ArrivedAtBegin)>0">
			<searchAttribute>ArrivedAt &gt;= &apos;<xsl:value-of select="ArrivedAtBegin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ArrivedAtEnd)>0">
			<searchAttribute>ArrivedAt &lt;= &apos;<xsl:value-of select="ArrivedAtEnd"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ConversionDateBegin)>0">
			<searchAttribute>ConversionDate &gt;= &apos;<xsl:value-of select="ConversionDateBegin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ConversionDateEnd)>0">
			<searchAttribute>ConversionDate &lt;= &apos;<xsl:value-of select="ConversionDate"/>&apos;</searchAttribute>
		</xsl:if>		
		<xsl:if test="string-length(CreatedAtBegin)>0">
			<searchAttribute>CreatedAt &gt;= &apos;<xsl:value-of select="CreatedAtBegin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(CreatedAtEnd)>0">
			<searchAttribute>CreatedAt &lt;= &apos;<xsl:value-of select="CreatedAtEnd"/>&apos;</searchAttribute>
		</xsl:if>		
		<xsl:if test="string-length(DateContentLastAccessedBegin)>0">
			<searchAttribute>DateContentLastAccessed &gt;= &apos;<xsl:value-of select="DateContentLastAccessedBegin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DateContentLastAccessedEnd)>0">
			<searchAttribute>DateContentLastAccessed &lt;= &apos;<xsl:value-of select="DateContentLastAccessedEnd"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ExternalEventTriggerDateBegin)>0">
			<searchAttribute>ExternalEventTriggerDate &gt;= &apos;<xsl:value-of select="ExternalEventTriggerDateBegin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ExternalEventTriggerDateEnd)>0">
			<searchAttribute>ExternalEventTriggerDate &lt;= &apos;<xsl:value-of select="ExternalEventTriggerDateEnd"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ModifiedAtBegin)>0">
			<searchAttribute>cmis:lastModificationDate &gt;= &apos;<xsl:value-of select="ModifiedAtBegin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ModifiedAtEnd)>0">
			<searchAttribute>cmis:lastModificationDate &lt;= &apos;<xsl:value-of select="ModifiedAtEnd"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ReferenceDateBegin)>0">
			<searchAttribute>ReferenceDate &gt;= &apos;<xsl:value-of select="ReferenceDateBegin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ReferenceDateEnd)>0">
			<searchAttribute>ReferenceDate &lt;= &apos;<xsl:value-of select="ReferenceDateEnd"/>&apos;</searchAttribute>
		</xsl:if>
	</xsl:template> -->
	<xsl:template match="SearchAttributes">
		<xsl:if test="string-length(AddressedTo)>0">
			<searchAttribute>AddressedTo=&apos;<xsl:value-of select="AddressedTo"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ArrivedBy)>0">
			<searchAttribute>ArrivedBy=&apos;<xsl:value-of select="ArrivedBy"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(AuthorizedTo)>0">
			<searchAttribute>AuthorizedTo=&apos;%<xsl:value-of select="AuthorizedTo"/>%&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(BirthDt)>0">
			<searchAttribute>BirthDate=&apos;<xsl:value-of select="BirthDt"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ClaimNumber)>0">
			<searchAttribute>ClaimNumber=&apos;<xsl:value-of select="ClaimNumber"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Contract_Nr)>0">
			<searchAttribute>Contract_Nr=&apos;<xsl:value-of select="Contract_Nr"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Contract_NrAccount)>0">
			<searchAttribute>Contract_NrAccount=&apos;<xsl:value-of select="Contract_NrAccount"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Contract_NrDeposit)>0">
			<searchAttribute>Contract_NrDeposit=&apos;<xsl:value-of select="Contract_NrDeposit"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Contract_NrLoan)>0">
			<searchAttribute>Contract_NrLoan=&apos;<xsl:value-of select="Contract_NrLoan"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Contract_NrPolicy)>0">
			<searchAttribute>Contract_NrPolicy=&apos;<xsl:value-of select="Contract_NrPolicy"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Contract_NrQuotation)>0">
			<searchAttribute>Contract_NrQuote=&apos;<xsl:value-of select="Contract_NrQuotation"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ConversionOrigin)>0">
			<searchAttribute>ConversionOrigin=&apos;<xsl:value-of select="ConversionOrigin"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(CreatedBy)>0">
			<searchAttribute>CreatedBy=&apos;<xsl:value-of select="CreatedBy"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DescriptionProductGroup)>0">
			<searchAttribute>DescrProductGroup=&apos;<xsl:value-of select="replace(DescriptionProductGroup ,' ','%')"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DocumentDetail)>0">
			<searchAttribute>DocumentDetail=&apos;<xsl:value-of select="replace(DocumentDetail,' ','%')"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DocumentID)>0">
			<searchAttribute>DocumentID=&apos;<xsl:value-of select="DocumentID"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DocumentRelationID)>0">
			<searchAttribute>DocumentRelationID=&apos;<xsl:value-of select="DocumentRelationID"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DocumentRouting)>0">
			<searchAttribute>DocumentRouting=&apos;<xsl:value-of select="DocumentRouting"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DocumentTitle)>0">
			<searchAttribute>DocumentName=&apos;<xsl:value-of select="DocumentTitle"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(DocumentType)>0">
			<searchAttribute>DocumentType=&apos;<xsl:value-of select="DocumentType"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(FileName)>0">
			<searchAttribute>FileName=&apos;<xsl:value-of select="FileName"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(IBAN)>0">
			<searchAttribute>IBAN=&apos;<xsl:value-of select="IBAN"/>&apos;</searchAttribute>
		</xsl:if>
<!-- 		<xsl:if test="string-length(ID)>0"> -->
<!-- 			<searchAttribute>ID=&apos;<xsl:value-of select="ID"/>&apos;</searchAttribute> -->
<!-- 		</xsl:if> -->
		<xsl:if test="string-length(IDNumberFactory)>0">
			<searchAttribute>IDNumberFactory=&apos;<xsl:value-of select="IDNumberFactory"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(IDNumberPersonal)>0">
			<searchAttribute>IDNumberPersonal=&apos;<xsl:value-of select="IDNumberPersonal"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Label)>0">
			<searchAttribute>Label=&apos;<xsl:value-of select="Label"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Language)>0">
			<searchAttribute>Language=&apos;<xsl:value-of select="Language"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ModifedBy)>0">
			<searchAttribute>cmis:lastModifiedBy=&apos;<xsl:value-of select="ModifedBy"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Name_LastInsured)>0">
			<searchAttribute>Name_Insured=&apos;<xsl:value-of select="Name_LastInsured"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Name_LastPolicyHolder)>0">
			<searchAttribute>Name_PolicyHolder=&apos;<xsl:value-of select="Name_LastPolicyHolder"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Name_Org)>0">
			<searchAttribute>Name_Organization=&apos;<xsl:value-of select="Name_Org"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(PartnerGold)>0">
			<searchAttribute>PartnerGold=&apos;<xsl:value-of select="PartnerGold"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(PartnerIntermediary)>0">
			<searchAttribute>PartnerIntermed=&apos;<xsl:value-of select="PartnerIntermediary"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(PartnerSilver)>0">
			<searchAttribute>PartnerSilver=&apos;<xsl:value-of select="PartnerSilver"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(ProcessID)>0">
			<searchAttribute>ProcessID=&apos;<xsl:value-of select="ProcessID"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(RequestNumber)>0">
			<searchAttribute>RequestNumber=&apos;<xsl:value-of select="RequestNumber"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(RequiredbylawID)>0">
			<searchAttribute>RequiredbylawID=&apos;<xsl:value-of select="RequiredbylawID"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(RetentionPolicy)>0">
			<searchAttribute>RetentionPolicy=&apos;<xsl:value-of select="RetentionPolicy"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(RetentionTrigger)>0">
			<searchAttribute>RetentionTrigger=&apos;<xsl:value-of select="RetentionTrigger"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Source)>0">
			<searchAttribute>Source=&apos;<xsl:value-of select="Source"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(SourceTransactionID)>0">
			<searchAttribute>SourceTransaction=&apos;<xsl:value-of select="SourceTransactionID"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Subject)>0">
			<searchAttribute>Subject=&apos;<xsl:value-of select="Subject"/>&apos;</searchAttribute>
		</xsl:if>
		<xsl:if test="string-length(Year)>0">
			<searchAttribute>Year=&apos;<xsl:value-of select="Year"/>&apos;</searchAttribute>
		</xsl:if>
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