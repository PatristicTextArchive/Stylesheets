<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
	version="2.0">
	<xsl:output method="text"/>
<!-- TODO: Indices -->
	<xsl:strip-space elements="*"/>

	<xsl:template match="text()[normalize-space()]">
		<xsl:value-of select="replace(., '^\s+|\s+$', ' ')"/>
	</xsl:template>

	<xsl:key name="elements-by-id" match="*[@xml:id]" use="@xml:id"/>

	<xsl:template match="tei:teiHeader">
		<xsl:text>\documentclass[openany,ngerman]{book}&#10;</xsl:text>
		<xsl:text>\usepackage[no-math]{fontspec}&#10;</xsl:text>
		<xsl:text>\usepackage[polutonikogreek,german]{babel}&#10;</xsl:text>
		<xsl:text>\usepackage[medium]{dgruyter}&#10;</xsl:text>
		<xsl:text>\usepackage{microtype}&#10;</xsl:text>
		<xsl:text>\usepackage{csquotes}&#10;</xsl:text>
		<xsl:text>\usepackage[TRE]{bibleref-german}&#10;</xsl:text>
		<xsl:text>\usepackage[divs=latex]{ekdosis}&#10;</xsl:text>
		<xsl:text>\FormatDiv{1}{\begin{center}\Large}{\end{center}}&#10;</xsl:text>
		<xsl:text>\FormatDiv{2}{\begin{center}\large}{\end{center}}&#10;</xsl:text>
		<xsl:text>\FormatDiv{3}{\textbf}{}</xsl:text>
		<xsl:text>\DeclareApparatus{bible}[delim=\hskip0.75em,bhook=,ehook=]%&#10;</xsl:text>
		<xsl:text>\DeclareApparatus{witnesses}[delim=\hskip0.75em,bhook=,ehook=]%&#10;</xsl:text>
		<xsl:text>\DeclareApparatus{default}[delim=\hskip0.75em,ehook=]&#10;</xsl:text>
		<xsl:text>\SetDefaultRule{\rule{0.1\columnwidth}{1.5px}}&#10;</xsl:text>
		<xsl:text>\SetLineation{margin=inner}&#10;</xsl:text>
		<xsl:text>\contributioncopyright[by.png]{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\title{Editionen}&#10;</xsl:text>
		<xsl:text>\author{Patristisches Textarchiv}</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\date{</xsl:text>
		<xsl:value-of select="current-dateTime()"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\DeclareScholar{</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName/@xml:id"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName/@xml:id"/>
		<xsl:text>}[rawname=</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName"/>
		<xsl:text>]&#10; </xsl:text>
		<xsl:apply-templates select="//tei:sourceDesc"/>
	</xsl:template>

	<xsl:template match="//tei:sourceDesc">
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:listWit">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:listWit/tei:head">
		<xsl:text>&#10;% </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:witness">
		<xsl:text>\DeclareWitness{</xsl:text>
		<xsl:value-of select="@xml:id"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of select="tei:abbr"/>
		<xsl:text>}{</xsl:text>
		<xsl:value-of select="tei:name"/>
		<xsl:text>}[msName=</xsl:text>
		<xsl:value-of select="tei:name"/>
		<xsl:text>,origDate=</xsl:text>
		<xsl:value-of select="tei:origDate"/>
		<xsl:text>,locus=</xsl:text>
		<xsl:value-of select="tei:locus"/>
		<xsl:text>‎]&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:listBibl">
		<xsl:text>&#10; </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:listBibl/tei:head">
		<xsl:text>&#10;&#10;% </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>


	<xsl:template match="tei:bibl">
		<xsl:choose>
			<xsl:when test="ancestor::tei:teiHeader">
				<xsl:text>&#10;\DeclareSource{</xsl:text>
				<xsl:value-of select="@xml:id"/>
				<xsl:text>}{</xsl:text>
				<xsl:value-of select="@xml:id"/>
				<xsl:text>}&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:text">
		<xsl:text>\begin{document}&#10;</xsl:text>
		<xsl:text>\maketitle&#10;</xsl:text>
		<xsl:text>\contribution&#10;</xsl:text>
		<xsl:text>\contributionauthor{</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\contributiontitle{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\runningtitle{</xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\contributionsubtitle{CPG </xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='CPG']"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PTA']"/>
		<xsl:text>}&#10;</xsl:text>
		<xsl:text>\makecontributiontitle&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>\end{document}&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:div">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tei:div[@type='edition']">		
		<xsl:text>\section{Edition}&#10;</xsl:text>
		<xsl:text>\begin{ekdosis}&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>\end{ekdosis}&#10;</xsl:text>		
	</xsl:template>

	<xsl:template match="tei:div[@type = 'textpart']">

		<xsl:text>&#10;</xsl:text>
		<xsl:if test="ancestor::tei:div[not(@type='transcription')]">
			<xsl:if test="@subtype='book'">
				<xsl:text>\ekddiv{head=</xsl:text>
				<xsl:number format="I" value="@n"/>
				<xsl:text>,type=chapter,depth=1,</xsl:text>
				<xsl:text>n=</xsl:text>
				<xsl:number value="@n"/>
				<xsl:text>}</xsl:text>
				<xsl:number format="I" value="@n"/>
			</xsl:if>

			<xsl:if test="@subtype='chapter'">
				<xsl:text>\ekddiv{head=</xsl:text>
				<xsl:number value="@n"/>
				<xsl:text>,type=section,depth=2,</xsl:text>
				<xsl:text>n=</xsl:text>
				<xsl:number value="@n"/>
				<xsl:text>}</xsl:text>
			</xsl:if>

			<xsl:if test="@subtype='section'">
				<xsl:text>\ekddiv{head=</xsl:text>
				<xsl:number value="@n"/>
				<xsl:text>,type=paragraph,depth=3,</xsl:text>
				<xsl:text>n=</xsl:text>
				<xsl:number value="@n"/>
				<xsl:text>}</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>


	<xsl:template match="tei:p">
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:div[@type='praefatio']">
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\section{Praefatio}&#10;</xsl:text>
		<xsl:text>\subsection{Handschriften}&#10;</xsl:text>
		<xsl:text>\begin{description}&#10;</xsl:text>
		<xsl:for-each select="//tei:witness">
			<xsl:text>\item[</xsl:text>
			<xsl:value-of select="tei:abbr"/>
			<xsl:text>]\href{https://pta.bbaw.de/manuscripts/</xsl:text>
			<xsl:value-of select="tei:name/@key"/>
			<xsl:text>}{</xsl:text>
			<xsl:value-of select="tei:name"/>
			<xsl:text>} (</xsl:text>
			<xsl:value-of select="tei:origDate"/>
			<xsl:text>), </xsl:text>
			<xsl:value-of select="tei:locus"/>
			<xsl:if test="@source">
				<xsl:text> (Abschrift von </xsl:text>
				<xsl:value-of select="translate(@source, '#', '')"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
		<xsl:text>\end{description}&#10;</xsl:text>
		<xsl:text>\subsection{Konjektoren}&#10;</xsl:text>
		<xsl:text>\begin{description}&#10;</xsl:text>
		<xsl:text>\item[</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName/@xml:id"/>
		<xsl:text>]</xsl:text>
		<xsl:value-of
			select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName"/>
		<xsl:text>&#10;</xsl:text>
		<xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc//tei:listBibl/tei:bibl">
			<xsl:text>\item[</xsl:text>
			<xsl:value-of select="@xml:id"/>
			<xsl:text>]</xsl:text>
			<xsl:choose>
			<xsl:when test="@facs">
			<xsl:text>\href{</xsl:text>
			<xsl:value-of select="@facs"/>
			<xsl:text>}{</xsl:text>
			<xsl:value-of select="."/>
			<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
			<xsl:value-of select="."/>	
			</xsl:otherwise>
			</xsl:choose>
			<xsl:text>&#10;</xsl:text>
		</xsl:for-each>
		<xsl:text>\end{description}&#10;</xsl:text>		
		<xsl:apply-templates/>
		<xsl:text>&#10;Steht die Sigle einer Handschrift in Klammern, so bedeutet das, dass die Lesart dieser Handschrift nur orthographisch abweicht. Seitenumbrüche in früheren Editionen und Handschriften sind mit ›|‹ markiert.</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:div[@type='praefatio']/tei:div/tei:head">
		<xsl:text>&#10;</xsl:text>
		<xsl:text>\section{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:div[@type='edition']/tei:head">
		<xsl:text>\selectlanguage{polutonikogreek}&#10;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>
	
	<xsl:template match="tei:div[@type='edition']/tei:head/tei:title">
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;\section*{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:pb">
		<xsl:choose>
			<xsl:when test="@break">
				<xsl:text>|\marginpar{\tiny{</xsl:text>
				<xsl:if test="@edRef">
					<xsl:value-of select="translate(@edRef,'#','')"/>
					<xsl:text>: </xsl:text>
				</xsl:if>
				<xsl:value-of select="@n"/>
				<xsl:text>}}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> |\marginpar{\tiny{</xsl:text>
				<xsl:if test="@edRef">
					<xsl:value-of select="translate(@edRef,'#','')"/>
					<xsl:text>: </xsl:text>
				</xsl:if>
				<xsl:value-of select="@n"/>
				<xsl:text>}} </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:rdg|tei:rdgGrp/tei:rdg">
		<!-- Descripti und ihre Lesarten werden eleminiert -->
		<xsl:variable name="witness-id" select="tokenize(@wit|@resp|@source, ' ')"/>
		<xsl:variable name="wit"
			select="for $id in $witness-id return key('elements-by-id',substring-after($id, '#'))[not(@source)]//@xml:id"/>
		<xsl:if test="$wit">
			<xsl:text>\rdg[wit={</xsl:text>
			<xsl:value-of select="$wit" separator=', '/>
			<!-- <xsl:if test="exists(@hand)">
						<xsl:text>^</xsl:text>
						<xsl:value-of select="replace(@hand, '#m', '')"/>
						<xsl:text>^</xsl:text>
					</xsl:if> Hand noch lösen -->
			<xsl:text>}</xsl:text>
			<xsl:choose>
			<xsl:when test="@type='orthographic'">
			<!-- kein Lemma -->
			<xsl:text>,alt=</xsl:text>
			</xsl:when>
			<xsl:when test="@type='varSeq'">
				<xsl:text>,alt=</xsl:text>
				<xsl:if test="@copyOf">
				<xsl:value-of select="key('elements-by-id',substring-after(@copyOf, '#'))"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>,alt=</xsl:text>
				<xsl:apply-templates/>
			</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="@cause='addition'">
					<xsl:text>,pre=add.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@cause='omission'">
					<xsl:text>,pre=om.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@cause='deletion'">
					<xsl:text>,pre=del.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@cause='illegible'">
					<xsl:text>,prewit=non leg.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@cause='transposition'">
					<xsl:text>,pre=transp.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@varSeq='1'">
					<xsl:text>,prewit=a.c.]{</xsl:text>
					<xsl:if test="@copyOf">
						<xsl:value-of select="key('elements-by-id',substring-after(@copyOf, '#'))"/>
					</xsl:if>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@varSeq='2'">
					<xsl:text>,prewit=p.c.]{</xsl:text>
					<xsl:if test="@copyOf">
						<xsl:value-of select="key('elements-by-id',substring-after(@copyOf, '#'))"/>
					</xsl:if>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@cause='correction'">
					<xsl:text>,prewit=corr.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@cause='conjecture'">
					<xsl:text>,prewit=coni.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@cause='proposition'">
					<xsl:text>,prewit=prop.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@type='orthographic'">
					<!-- orthographische Varianten werden nicht ausgegeben, nur Sigle kursiv -->
					<xsl:text>,prewit=(,postwit=)]{}</xsl:text>
				</xsl:when>
				<xsl:when test="@type='dittography'">
					<xsl:text>,prewit=iter.]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@type='homoioteleuton'">
					<xsl:text>,postwit=(homoioteleuton)]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="@type='homoiarkton'">
					<xsl:text>,postwit=(homoiarkton)]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>]{</xsl:text>
					<xsl:apply-templates/>
					<xsl:text>}</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:app">
		<!-- Fall: Bezeugung -->
		<xsl:if test="(@type='witnesses')">
			<xsl:text>\app[type=witnesses]{</xsl:text>
			<xsl:choose>
				<xsl:when test="tei:rdg/tei:witStart|tei:rdg/tei:lacunaEnd">
					<xsl:value-of select="tei:rdg"/>
					<xsl:text>\lem[wit=</xsl:text>
					<xsl:value-of select="tei:rdg/replace(@wit, '#', '')"/>
					<xsl:text>,alt={inc.},nosep]{}</xsl:text>
				</xsl:when>
				<xsl:when test="tei:rdg/tei:witEnd|tei:rdg/tei:lacunaStart">
					<xsl:value-of select="tei:rdg"/>
					<xsl:text>\lem[wit=</xsl:text>
					<xsl:value-of select="tei:rdg/replace(@wit, '#', '')"/>
					<xsl:text>,alt={des.},nosep]{}</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>}&#10;</xsl:text>
		</xsl:if>
		<!-- Fall: Varianten -->
		<xsl:if test="(@type='textcritical')">
			<xsl:variable name="varianten">
				<xsl:apply-templates select="tei:rdg|tei:rdgGrp/tei:rdg"/>
			</xsl:variable>
			<xsl:choose>
				<!-- Fall: nur Varianten von descripti -->
				<xsl:when test="$varianten=''">
					<!-- Varianten werden nicht ausgegeben, nur Lemma -->
					<xsl:apply-templates select="tei:lem"/>
				</xsl:when>
				<!-- Fall: nur Schreibfehler, keine anderen Varianten -->
				<xsl:when
					test="tei:rdg[@type='orthographic' and not(following-sibling::tei:rdg[not(@type='orthographic')]) and not(preceding-sibling::tei:rdg[not(@type='orthographic')]) and not(parent::tei:rdgGrp) and not(preceding-sibling::tei:lem[@cause]) and not(ancestor::tei:lem)]">
					<!-- Varianten werden nicht ausgegeben, nur Lemma -->
					<xsl:apply-templates select="tei:lem"/>
				</xsl:when>
				<!-- Fall: lem leer, weil andere Handschriften etwas hinzufügen -->
				<xsl:when test="tei:lem[not(descendant::tei:app)]=''">
					<xsl:variable name="currenttPreviousWord">
						<xsl:value-of
							select="tokenize(normalize-space(preceding::text()[1]),' ')[last()]"
						/>
					</xsl:variable>
					<xsl:text>\app[type=default]{&#10;\lem[nosep,alt=</xsl:text>
					<xsl:choose>
						<!-- currenttPreviousWord ist in app: nicht einfach letztes Wort nehmen (käme aus rdg), sondern letztes Wort im lem nehmen -->
						<xsl:when test="preceding-sibling::*[1] [name()='app'] [following-sibling::node()[1] [not(self::text()) or normalize-space(.)='']]">
							<xsl:value-of
								select="translate(lower-case(tokenize(normalize-space(preceding-sibling::*[1] [name()='app'] [following-sibling::node()[1] [not(self::text()) or normalize-space(.)=''] ]/tei:lem//text()[1]),' ')[last()]), ',.!?:;)', '')"
							/>
						</xsl:when>
						<!-- If the "word" immediately preceding the addition is a punctuation mark, then we're going to select the "word" before this one;
            TODO: ideally, this should be recursive -->
						<xsl:when
							test="$currenttPreviousWord = '.' or $currenttPreviousWord = '!' or $currenttPreviousWord = '?' or $currenttPreviousWord = ';' or $currenttPreviousWord = ':' or $currenttPreviousWord = ','">
							<xsl:value-of
								select="translate(lower-case(tokenize(normalize-space(preceding::text()[1]),' ')[last()-1]), ',.!?:;)', '')"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="translate(lower-case(tokenize(normalize-space(preceding::text()[1]),' ')[last()]), ',.!?:;)', '')"
							/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>]{}</xsl:text>
					<xsl:apply-templates select="tei:rdg|tei:rdgGrp/tei:rdg"/>
					<xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>\app[type=default]{&#10;\lem[nosep,wit={</xsl:text>
					<!--  Falls Konjektur, Sigle ausgeben, selbst wenn Zeuge descriptus -->
					<xsl:choose>
					<xsl:when test="tei:lem[@cause='conjecture']">
						<xsl:value-of
							select="for $x in tokenize(tei:lem/@wit|tei:lem/@resp|tei:lem/@source, ' ') return key('elements-by-id',substring-after($x, '#'))/@xml:id" separator=", "
						/>
					</xsl:when>
					<xsl:otherwise>
					<xsl:value-of
						select="for $x in tokenize(tei:rdgGrp/tei:lem/@wit|tei:lem/@wit|tei:lem/@resp|tei:lem/@source, ' ') return key('elements-by-id',substring-after($x, '#'))[not(@source)]/@xml:id" separator=", "/>
					</xsl:otherwise>
					</xsl:choose>
					<xsl:text>}</xsl:text>
					<xsl:if test="tei:lem[@cause='correction']">
						<xsl:text>,prewit=corr.</xsl:text>
					</xsl:if>
					<xsl:if test="tei:lem[@cause='conjecture']">
						<xsl:text>,prewit=coni.</xsl:text>
					</xsl:if>
					<xsl:if test="tei:lem[@cause='proposition']">
						<xsl:text>,prewit=prop.</xsl:text>
					</xsl:if>
					<xsl:if test="tei:lem[@cause='deletion']">
						<xsl:text>,prewit=del.</xsl:text>
					</xsl:if>
					<!-- Lemma kürzen, code angepaßt von https://github.com/MarjorieBurghart/TEI-CAT -->
					<xsl:text>,alt=</xsl:text>
					<xsl:variable name="currentLemmaNote"
						select="tei:lem/tokenize(normalize-space(string-join(descendant-or-self::text(),'')),' ')"/>
					<xsl:choose>
						<xsl:when test="count($currentLemmaNote) > 2"> <!-- Lemma kürzen wenn länger als 2 Worte -->
							<xsl:value-of
								select="translate($currentLemmaNote[position() = 1], ',.!?:;)', '')"/>
							<xsl:text> \ldots{} </xsl:text>
							<xsl:value-of
								select="translate($currentLemmaNote[last()], ',.!?:;)', '')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="tei:lem"/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>]{</xsl:text>
					<xsl:apply-templates select="tei:lem"/>
					<xsl:text>}&#10;</xsl:text>
					<!-- Varianten -->
					<xsl:value-of select="$varianten"/>
					<!-- Bezeugung in Variantenapp -->
					<xsl:choose>
						<xsl:when test="tei:rdg/tei:witStart|tei:rdg/tei:lacunaEnd">
							<xsl:text>*inc. </xsl:text>
							<xsl:value-of select="tei:rdg[1]/replace(@wit, '#', '')"/>
							<xsl:text>*</xsl:text>
						</xsl:when>
						<xsl:when test="tei:rdg/tei:witEnd|tei:rdg/tei:lacunaStart">
							<xsl:text>*des. </xsl:text>
							<xsl:value-of select="tei:rdg[1]/replace(@wit, '#', '')"/>
							<xsl:text>*</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text/>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>&#10;}</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:del">
		<xsl:text>\surplus{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:choose>
			<xsl:when test="(@place='inline')">
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:when>
			<xsl:when test="(@place='top' or @place='above' or @place='margin' or @place='bottom')">
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes">&lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:supplied">
		<xsl:text disable-output-escaping='yes'>&lt;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text disable-output-escaping='yes'>&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="tei:sic">
		<xsl:text>\sic{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template match="tei:gap">
		<xsl:text>\gap[</xsl:text>
		<!-- reason quantity unit -->
		<xsl:text>]{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="tei:note[ancestor::tei:div[@type='praefatio']]">
		<xsl:text>\footnote{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>} </xsl:text>
	</xsl:template>

	<xsl:template match="tei:quote">
		<xsl:choose>
			<xsl:when test="@type='marked'">
				<xsl:text>\app[type=bible]{\lem[alt=</xsl:text>
				<!-- Lemma kürzen, code angepaßt von https://github.com/MarjorieBurghart/TEI-CAT -->
				<xsl:variable name="currentLemmaNote"
					select="tokenize(normalize-space(string-join(descendant-or-self::*[not(//tei:rdg)]/text(),' ')),' ')"/>
				<xsl:choose>
				<xsl:when test="count($currentLemmaNote) > 3"> <!-- Lemma kürzen wenn länger als 3 Worte -->
					<xsl:value-of
						select="translate($currentLemmaNote[position() = 1], ',.!?:;)', '')"/>
					<xsl:text> \ldots{} </xsl:text>
					<xsl:value-of
						select="translate($currentLemmaNote[last()], ',.!?:;)', '')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,nosep]{</xsl:text>
				<xsl:text>\emph{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}}\rdg{</xsl:text>
				<xsl:value-of select="tei:ref/replace(@cRef, '[A-Z]{2,3}:([\w\s]+):?([0-9\-]*):?([0-9\-]*)', '\\ibibleverse[textbf]{$1}($2:$3)')"/>
				<xsl:text>}}</xsl:text>
			</xsl:when>
			<xsl:when test="@type='unmarked'">
				<xsl:text>\app[type=bible]{\lem[alt=</xsl:text>
				<!-- Lemma kürzen, code angepaßt von https://github.com/MarjorieBurghart/TEI-CAT -->
				<xsl:variable name="currentLemmaNote"
					select="tokenize(normalize-space(string-join(descendant-or-self::text(),' ')),' ')"/>
				<xsl:choose>
					<xsl:when test="count($currentLemmaNote) > 3"> <!-- Lemma kürzen wenn länger als 3 Worte -->
						<xsl:value-of
							select="translate($currentLemmaNote[position() = 1], ',.!?:;)', '')"/>
						<xsl:text> \ldots{} </xsl:text>
						<xsl:value-of
							select="translate($currentLemmaNote[last()], ',.!?:;)', '')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,nosep]{</xsl:text>
				<xsl:text>\emph{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}}\rdg{</xsl:text>
				<xsl:value-of select="tei:ref/replace(@cRef, '[A-Z]{2,3}:([\w\s]+):?([0-9\-]*):?([0-9\-]*)', '\\ibibleverse[textbf]{$1}($2:$3)')"/>
				<xsl:text>}}</xsl:text>
			</xsl:when>
			<xsl:when test="@type='paraphrase'">
				<xsl:text>\app[type=bible]{\lem[alt=</xsl:text>
				<!-- Lemma kürzen, code angepaßt von https://github.com/MarjorieBurghart/TEI-CAT -->
				<xsl:variable name="currentLemmaNote"
					select="tokenize(normalize-space(string-join(descendant-or-self::text(),' ')),' ')"/>
				<xsl:choose>
					<xsl:when test="count($currentLemmaNote) > 3"> <!-- Lemma kürzen wenn länger als 3 Worte -->
						<xsl:value-of
							select="translate($currentLemmaNote[position() = 1], ',.!?:;)', '')"/>
						<xsl:text> \ldots{} </xsl:text>
						<xsl:value-of
							select="translate($currentLemmaNote[last()], ',.!?:;)', '')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,nosep]{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}\rdg{cf. </xsl:text>
				<xsl:value-of select="tei:ref/replace(@cRef, '[A-Z]{2,3}:([\w\s]+):?([0-9\-]*):?([0-9\-]*)', '\\ibibleverse[textit]{$1}($2:$3)')"/>
				<xsl:text>}}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>\app[type=bible]{\lem[alt=</xsl:text>
				<!-- Lemma kürzen, code angepaßt von https://github.com/MarjorieBurghart/TEI-CAT -->
				<xsl:variable name="currentLemmaNote"
					select="tokenize(normalize-space(string-join(descendant-or-self::*/text(),' ')),' ')"/>
				<xsl:choose>
					<xsl:when test="count($currentLemmaNote) > 3"> <!-- Lemma kürzen wenn länger als 3 Worte -->
						<xsl:value-of
							select="translate($currentLemmaNote[position() = 1], ',.!?:;·)', '')"/>
						<xsl:text> \ldots{} </xsl:text>
						<xsl:value-of
							select="translate($currentLemmaNote[last()], ',.!?:;·)', '')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,nosep]{</xsl:text>
				<xsl:text>\emph{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}}\rdg{</xsl:text>
				<xsl:value-of select="tei:ref/replace(@cRef, '[A-Z]{2,3}:([\w\s]+):?([0-9\-]*):?([0-9\-]*)', '\\ibibleverse[textbf]{$1}($2:$3)')"/>
				<xsl:text>}}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:cit">
		<xsl:text> </xsl:text>
		<xsl:if test="tei:ref[following-sibling::tei:quote]">
			<xsl:apply-templates select="tei:ref"/>
		</xsl:if>
		<xsl:apply-templates select="tei:quote"/>
		<xsl:if test="tei:ref[preceding-sibling::tei:quote]">
			<xsl:apply-templates select="tei:ref"/>
		</xsl:if>
	</xsl:template>


	<xsl:template match="tei:seg">
		<xsl:choose>
			<xsl:when test="(@type='allusion')">
				<!-- Anspielung-->
				<xsl:text>\app[type=bible]{\lem[alt=</xsl:text>
				<!-- Lemma kürzen, code angepaßt von https://github.com/MarjorieBurghart/TEI-CAT -->
				<xsl:variable name="currentLemmaNote"
					select="tokenize(normalize-space(string-join(descendant-or-self::text(),'')),' ')"/>
				<xsl:choose>
					<xsl:when test="count($currentLemmaNote) > 3"> <!-- Lemma kürzen wenn länger als 3 Worte -->
						<xsl:value-of
							select="translate($currentLemmaNote[position() = 1], ',.!?:;)', '')"/>
						<xsl:text> \ldots{} </xsl:text>
						<xsl:value-of
							select="translate($currentLemmaNote[last()], ',.!?:;)', '')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>,nosep]{</xsl:text>
				<xsl:text>\emph{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}}\rdg{cf. </xsl:text>
				<xsl:value-of select="tei:ref/replace(@cRef, '[A-Z]{2,3}:([\w\s]+):?([0-9\-]*):?([0-9\-]*)', '\\ibibleverse[textit]{$1}($2:$3)')"/>
				<xsl:text>}}</xsl:text>
			</xsl:when>
			<xsl:when test="(@type='insertion')">
				<!-- Einschub in Zitat-->
				<xsl:text>\emph{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="(@type='fq')">
				<!--false quote-->
				<xsl:text> ›</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>‹ </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='psq')">
				<!-- pseudo-quote-->
				<xsl:text> ›</xsl:text>
				<xsl:apply-templates/>
				<xsl:text> ‹</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:mentioned">
		<xsl:text> \emph{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>} </xsl:text>
	</xsl:template>

	<xsl:template match="tei:said">
		<xsl:text> \enquote{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>} </xsl:text>
	</xsl:template>

	<xsl:template match="tei:persName|tei:placeName[not(parent::tei:orgName)]|tei:orgName">
		<xsl:text>\href{</xsl:text>
		<xsl:value-of select="@ref"/>
		<xsl:text>}{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>



	<xsl:template match="tei:ref[ancestor::tei:div[@type='praefatio']]">
		<xsl:text>\emph{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>
</xsl:stylesheet>
