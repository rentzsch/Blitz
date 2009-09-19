<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:str="http://exslt.org/strings"
	xmlns:func="http://exslt.org/functions"
	xmlns:exsl="http://exslt.org/common"

	xmlns:sfa="http://developer.apple.com/namespaces/sfa"
	xmlns:sf="http://developer.apple.com/namespaces/sf"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:key="http://developer.apple.com/namespaces/keynote2"

	extension-element-prefixes="str exsl func">

	<!--
	
	unzip -p blitz-example.key index.apxl | xsltproc presenter-notes.xsl -
	
	-->
	<xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

	<xsl:template match="key:presentation">
		<html xml:lang="en-US" lang="en-US">
			<head>
				<meta http-equiv="content-type" content="text/html; charset=utf-8" />
			</head>

			<body>
				<xsl:for-each select="key:slide-list/key:slide">
					<div>
						<xsl:for-each select="key:notes/sf:text-storage/sf:text-body/sf:p">
							<p><xsl:value-of select="text()"/></p>
						</xsl:for-each>
					</div>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
