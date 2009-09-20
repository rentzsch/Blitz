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
				
				<style type="text/css">
					div.slide {
						position:absolute;
						display:none;
					}
					/* wow, this is terrible */
					@media mBGSlide0 { #BGSlide0 { display: block; }}
					@media mBGSlide1 { #BGSlide1 { display: block; }}
					@media mBGSlide2 { #BGSlide2 { display: block; }}
					@media mBGSlide3 { #BGSlide3 { display: block; }}
					@media mBGSlide4 { #BGSlide4 { display: block; }}
					@media mBGSlide5 { #BGSlide5 { display: block; }}
					@media mBGSlide6 { #BGSlide6 { display: block; }}
					@media mBGSlide7 { #BGSlide7 { display: block; }}
					@media mBGSlide8 { #BGSlide8 { display: block; }}
					@media mBGSlide9 { #BGSlide9 { display: block; }}
					@media mBGSlide10 { #BGSlide10 { display: block; }}
					@media mBGSlide11 { #BGSlide11 { display: block; }}
					@media mBGSlide12 { #BGSlide12 { display: block; }}
					@media mBGSlide13 { #BGSlide13 { display: block; }}
					@media mBGSlide14 { #BGSlide14 { display: block; }}
					@media mBGSlide15 { #BGSlide15 { display: block; }}
					@media mBGSlide16 { #BGSlide16 { display: block; }}
					@media mBGSlide17 { #BGSlide17 { display: block; }}
					@media mBGSlide18 { #BGSlide18 { display: block; }}
					@media mBGSlide19 { #BGSlide19 { display: block; }}
					/* wolf said 20 slides dammit! */
					@media mBGSlide20 { #BGSlide20 { display: block; }}
					@media mBGSlide21 { #BGSlide21 { display: block; }}
					@media mBGSlide22 { #BGSlide22 { display: block; }}
					@media mBGSlide23 { #BGSlide23 { display: block; }}
					@media mBGSlide24 { #BGSlide24 { display: block; }}
					/* seriously, aren't you talking too fast (like I'm one to talk...) */
					@media mBGSlide25 { #BGSlide25 { display: block; }}
					@media mBGSlide26 { #BGSlide26 { display: block; }}
					@media mBGSlide27 { #BGSlide27 { display: block; }}
					@media mBGSlide28 { #BGSlide28 { display: block; }}
					@media mBGSlide29 { #BGSlide29 { display: block; }}
		        </style>
			</head>

			<body>
				<xsl:for-each select="key:slide-list/key:slide">
					<div class="slide">
						<xsl:attribute name="id"><xsl:value-of select="str:replace(@sfa:ID, '-', '')"/></xsl:attribute>
						<xsl:for-each select="key:notes/sf:text-storage/sf:text-body/sf:p">
							<p><xsl:value-of select="text()"/></p>
						</xsl:for-each>
					</div>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
