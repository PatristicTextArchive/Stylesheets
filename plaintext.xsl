<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0">

	<xsl:output method="text"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="text()">
			<xsl:value-of select="replace(., '\s+', ' ')"/>
	</xsl:template>

	<xsl:template match="tei:teiHeader"/>

	<xsl:template match="tei:body">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:div">
		<xsl:choose>
			<xsl:when test="(@type='edition')">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="(@type='translation')">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="(@subtype='chapter')">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="(@subtype='section')">
				<xsl:if test="parent::*[@subtype='commentary']">
					<xsl:text>§ </xsl:text>
                    <xsl:value-of select="@n"/>
					<xsl:text>

</xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="(@subtype='commentary')">
				<xsl:value-of select="replace(@n,':',' ')"/>
				<xsl:text>

</xsl:text>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="(@subtype='fragment')">
				<xsl:text>Frg. </xsl:text>
                <xsl:value-of select="@n"/>
				<xsl:text>

</xsl:text>
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:p[1][not(ancestor::*[@subtype='commentary'])]">
		<xsl:if test="number(../../@n)">
				<xsl:value-of select="../../@n"/>
				<xsl:text>,</xsl:text>
		</xsl:if>
		<xsl:value-of select="../@n"/>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>

</xsl:text>
	</xsl:template>

	<xsl:template match="tei:p">
		<xsl:text>
</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>

</xsl:text>
	</xsl:template>


	<xsl:template match="tei:div/tei:head">
		<xsl:apply-templates/>
		<xsl:text>

</xsl:text>
	</xsl:template>

	<xsl:template match="tei:app">
		<xsl:choose>
			<xsl:when test="(@type='witnesses')">
				<xsl:value-of select="normalize-space(tei:rdg)"/>
			</xsl:when>
			<xsl:when test="(@type='textcritical')">
				<xsl:value-of select="normalize-space(tei:lem|tei:rdgGrp/tei:lem)"/>
			 <xsl:if test="following-sibling::node()[1][not(self::text())]">
				  <xsl:text> </xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	 </xsl:template>

	<xsl:template match="tei:del">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:choose>
			<xsl:when test="(@place='inline')">
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:when>
			<xsl:when test="(@place='top' or @place='margin' or @place='bottom')">
				<xsl:text disable-output-escaping="yes"> &lt;&lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt;&gt; </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes"> &lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt; </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:supplied">
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:note"/>

	<xsl:template match="tei:quote">
		<xsl:choose>
			<xsl:when test="(@type='marked')">
				<xsl:text>»</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>«</xsl:text>
			</xsl:when>
			<xsl:when test="(@type='unmarked')">
				<xsl:text>›</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>‹</xsl:text>
			</xsl:when>
			<xsl:when test="(@type='paraphrase')">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>»</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>«</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="following-sibling::node()[1][not(self::text())]">
	 		<xsl:text> </xsl:text>
 		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:cit">
		<xsl:apply-templates/>
		<xsl:if test="following-sibling::node()[1][not(self::text())]">
	 		<xsl:text> </xsl:text>
 		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:ref">
		<xsl:apply-templates/>
		<xsl:choose>
		<xsl:when test="tei:ref = ''"/>
		<xsl:otherwise>
		<xsl:if test="following-sibling::node()[1][not(self::text())]">
	 		<xsl:text> </xsl:text>
 		</xsl:if>
	</xsl:otherwise>
</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:seg">
		<xsl:choose>
			<xsl:when test="(@type='allusion')">
				<!-- Anspielung-->
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='insertion')">
				<!-- Einschub in Zitat-->
				<xsl:text>«</xsl:text>
				<xsl:apply-templates/>
				<xsl:text> »</xsl:text>
			</xsl:when>
			<xsl:when test="(@type='fq')">
				<!--false quote-->
				<xsl:text> _</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>_ </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='psq')">
				<!-- pseudo-quote-->
				<xsl:text>« </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> »</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="following-sibling::node()[1][not(self::text())]">
			 <xsl:text> </xsl:text>
		 </xsl:if>
	</xsl:template>

	<xsl:template match="tei:mentioned">
		<xsl:text> </xsl:text>

		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:said">
		<xsl:text> »</xsl:text>

		<xsl:apply-templates/>
		<xsl:text>« </xsl:text>
	</xsl:template>

	<xsl:template match="tei:persName">
		<xsl:apply-templates/>
			<xsl:if test="following-sibling::node()[1][not(self::text())]">
				<xsl:text> </xsl:text>
			</xsl:if>
	</xsl:template>

	<xsl:template match="tei:placeName">
		<xsl:apply-templates/>
			<xsl:if test="following-sibling::node()[1][not(self::text())]">
				<xsl:text> </xsl:text>
			</xsl:if>
	</xsl:template>

	<xsl:template match="tei:witDetail"/>

</xsl:stylesheet>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             