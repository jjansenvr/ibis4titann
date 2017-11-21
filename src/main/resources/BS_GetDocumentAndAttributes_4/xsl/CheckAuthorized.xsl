<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:param name="AuthorizedToRequest"/>
	<xsl:output omit-xml-declaration="yes" media-type="text"/>
	<xsl:template match="/">
	<xsl:variable name="AuthorizedToArchive" select="cmis/properties/property[@name='AuthorizedTo']"/>
		<xsl:choose>
			<xsl:when test="string-length($AuthorizedToArchive)>0">
				<xsl:choose>
					<xsl:when test="count($AuthorizedToRequest/Request/AuthorizedTo)>0">
						<xsl:choose>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[1]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[1])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[2]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[2])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[3]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[3])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[4]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[4])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[5]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[5])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[6]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[6])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[7]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[7])">>User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[8]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[8])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[9]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[9])">User_Authorized</xsl:when>
							<xsl:when test="$AuthorizedToRequest/Request/AuthorizedTo[10]!='' and contains($AuthorizedToArchive,$AuthorizedToRequest/Request/AuthorizedTo[10])">User_Authorized</xsl:when>
							<xsl:otherwise>User_Not_Authorized</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>Authorized_Empty_Request</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>Authorized_Empty_Archive</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
