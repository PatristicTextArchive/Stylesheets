<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		version="2.0">
	<xsl:output method="text"/>

	<xsl:strip-space elements="*"/>

    <xsl:template match="text()[normalize-space()]">
        <xsl:value-of select="replace(., '^\s+|\s+$', ' ')"/>
    </xsl:template>

 <xsl:key name="elements-by-id" match="*[@xml:id]" use="@xml:id"/>

	<xsl:template match="tei:teiHeader">
		<xsl:text>--- &#10;</xsl:text>
		<xsl:text>title: </xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
		<xsl:text> (</xsl:text><xsl:text>CPG </xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='CPG']"/><xsl:text>)  </xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>author: </xsl:text>
		<xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName"/>
		<xsl:text>  </xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>date: </xsl:text>
		<xsl:value-of  select="current-dateTime()"/>
		<xsl:text>  </xsl:text>
		<xsl:text>&#10;output: word_document  </xsl:text>
		<xsl:text>&#10;---&#10;</xsl:text>
		<xsl:text>&#10;# Bezeugung</xsl:text>
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
		<xsl:text>&#10;## </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	 <xsl:template match="tei:witness">
	   <xsl:text>&#10;- **[</xsl:text>
		 <xsl:value-of select="tei:abbr"/>
		 <xsl:text>]{#</xsl:text>
		 <xsl:value-of select="@xml:id"/>
		 <xsl:text>}** </xsl:text>
	   <xsl:value-of select="tei:name"/>
	   <xsl:text> (</xsl:text><xsl:value-of select="tei:origDate"/>
	   <xsl:text>)</xsl:text>
	   <xsl:text>, </xsl:text><xsl:value-of select="tei:locus"/>
	   <xsl:if test="@source">
	     <xsl:text> (Abschrift von [</xsl:text><xsl:value-of select="translate(@source, '#', '')"/><xsl:text>](</xsl:text><xsl:value-of select="@source"/><xsl:text>))</xsl:text>
	   </xsl:if>
	 </xsl:template>

	 <xsl:template match="tei:listBibl">
		 <xsl:text>&#10; </xsl:text>
	   <xsl:apply-templates/>
	   <xsl:text>&lt;!-- end of list --></xsl:text>
	</xsl:template>

	<xsl:template match="tei:listBibl[not(parent::tei:listBibl)]/tei:head[1]">
	  <xsl:text>&#10;&#10;## </xsl:text>
	  <xsl:apply-templates/>
	  <xsl:text>&#10;</xsl:text>
	  <xsl:text>&#10;</xsl:text>
	</xsl:template>


	<xsl:template match="tei:bibl">
	  <xsl:choose>
	    <xsl:when test='ancestor::tei:teiHeader'>
		  <xsl:text>&#10;&#10;* </xsl:text>
	      <xsl:choose>
	      <xsl:when test="@facs">
	      	   <xsl:text>[[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]{#</xsl:text>
		<xsl:value-of select="@xml:id"/>
		<xsl:text>}</xsl:text>
	   <xsl:text>](</xsl:text>
	   <xsl:value-of select="@facs"/>
	   <xsl:text>)&#10;</xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
					<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]{#</xsl:text>
		<xsl:value-of select="@xml:id"/>
		<xsl:text>} </xsl:text>
	      </xsl:otherwise>
	      </xsl:choose>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:text> </xsl:text>
	      <xsl:apply-templates/>
	      <xsl:text> </xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:template>

	<xsl:template match="tei:body">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:div">
	  <xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:div[@type = 'textpart']">

	  <xsl:text>&#10;</xsl:text>
	  <xsl:if test="ancestor::tei:div[not(@type='transcription')]">
            <xsl:if test="@subtype='book'">
              <xsl:number format="I" value="@n"/>
            </xsl:if>

            <xsl:if test="@subtype='chapter'">
              <xsl:text>ch. </xsl:text><xsl:number value="@n"/>
            </xsl:if>

            <xsl:if test="@subtype='section'">
              <xsl:text>§ </xsl:text><xsl:number value="@n"/>
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
		<xsl:text>&#10;# Praefatio</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:div[@type='praefatio']/tei:div/tei:head">
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;## </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:div[@type='edition']/tei:head">
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;# Edition^[Codices descripti sind eliminiert. Steht die Sigle einer Handschrift in Klammern, so bedeutet das, dass die Lesart dieser Handschrift nur orthographisch abweicht. Seitenumbrüche in früheren Editionen und Handschriften sind mit ›|‹ markiert.]</xsl:text>
		<xsl:text>&#10;### </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

  <xsl:template match="tei:pb">
    <xsl:choose>
      <xsl:when test="@break">
	    <xsl:text>|^</xsl:text>
    <xsl:if test="@edRef">
            <xsl:value-of select="translate(@edRef,'#','')"/>
            <xsl:text>:\ </xsl:text>
      </xsl:if>
      <xsl:value-of select="@n"/>
      <xsl:text>^</xsl:text>
      </xsl:when>
      <xsl:otherwise>
    <xsl:text> |^</xsl:text>
    <xsl:if test="@edRef">
            <xsl:value-of select="translate(@edRef,'#','')"/>
            <xsl:text>:\ </xsl:text>
      </xsl:if>
      <xsl:value-of select="@n"/>
      <xsl:text>^ </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

	<xsl:template match="tei:rdg|tei:rdgGrp/tei:rdg">
			<!-- Descripti und ihre Lesarten werden eleminiert -->
			<xsl:variable name="witness-id" select="tokenize(@wit|@resp|@source, ' ')"/>
			<xsl:variable name="wit" select="for $id in $witness-id return key('elements-by-id',substring-after($id, '#'))[not(@source)]//@xml:id"/>
			<xsl:if test="$wit">
		<xsl:choose>
			<xsl:when test="@cause='addition'">
				<xsl:text>*add.* </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> *</xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@cause='omission'">
				<xsl:text>*om. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@cause='deletion'">
				<xsl:text>*del. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@cause='illegible'">
				<xsl:apply-templates/>
				<xsl:text> *non leg. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@cause='transposition'">
				<xsl:apply-templates/>
				<xsl:text> ~ *</xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@varSeq='1'">
				<xsl:apply-templates/>
				<xsl:if test='@copyOf'>
					<xsl:value-of select="key('elements-by-id',substring-after(@copyOf, '#'))"/>
				</xsl:if>
				<xsl:text> *a.c. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@varSeq='2'">
				<xsl:apply-templates/>
				<xsl:if test='@copyOf'>
					<xsl:value-of select="key('elements-by-id',substring-after(@copyOf, '#'))"/>
				</xsl:if>
				<xsl:text> *p.c. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@cause='correction'">
				<xsl:text>*corr. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@cause='conjecture'">
				<xsl:apply-templates/>
				<xsl:text> *coni. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@cause='proposition'">
				<xsl:apply-templates/>
				<xsl:text> *prop. </xsl:text>
				<xsl:if test="exists(@cert)">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="@cert"/>
					<xsl:text>) </xsl:text>
				</xsl:if>
				<xsl:value-of select="$wit"/>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@type='orthographic'">
				<!-- orthographische Varianten werden nicht ausgegeben, nur Sigle kursiv -->
				<xsl:text> *(</xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:text>)* </xsl:text>
			</xsl:when>
			<xsl:when test="@type='dittography'">
				<xsl:apply-templates/>
				<xsl:text> *iter. </xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:text>* </xsl:text>
			</xsl:when>
			<xsl:when test="@type='homoioteleuton'">
				<xsl:apply-templates/>
				<xsl:text> *</xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:text>* (homoioteleuton) </xsl:text>
			</xsl:when>
			<xsl:when test="@type='homoiarkton'">
				<xsl:apply-templates/>
				<xsl:text> *</xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:text>* (homoiarkton) </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
				<xsl:text> *</xsl:text>
				<xsl:value-of select="$wit"/>
				<xsl:if test="exists(@hand)">
					<xsl:text>^</xsl:text>
					<xsl:value-of select="replace(@hand, '#m', '')"/>
					<xsl:text>^</xsl:text>
				</xsl:if>
				<xsl:text>* </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:if>
</xsl:template>

	<xsl:template match="tei:app">
			<!-- Fall: Bezeugung -->
			<xsl:if test="(@type='witnesses')">
				<xsl:choose>
					<xsl:when test="tei:rdg/tei:witStart|tei:rdg/tei:lacunaEnd">
					<xsl:value-of select="tei:rdg"/>
						<xsl:text>^[inc. </xsl:text>
						<xsl:value-of select="tei:rdg/replace(@wit, '#', '')"/>
						<xsl:text>] </xsl:text>
					</xsl:when>
					<xsl:when test="tei:rdg/tei:witEnd|tei:rdg/tei:lacunaStart">
					<xsl:value-of select="tei:rdg"/>
						<xsl:text>^[des. </xsl:text>
						<xsl:value-of select="tei:rdg/replace(@wit, '#', '')"/>
						<xsl:text>] </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<!-- Fall: Varianten -->
			<xsl:if test="(@type='textcritical')">
					<xsl:variable name="varianten">
						<xsl:apply-templates select="tei:rdg|tei:rdgGrp/tei:rdg"/>
					</xsl:variable>
					<xsl:text> </xsl:text>
			    <xsl:choose>
					<!-- Fall: nur Varianten von descripti -->
					<xsl:when test="$varianten=''">
					<!-- Varianten werden nicht ausgegeben, nur Lemma -->
						<xsl:apply-templates select="tei:lem//text()"/>
					</xsl:when>
      		<!-- Fall: nur Schreibfehler, keine anderen Varianten -->
      		<xsl:when test="tei:rdg[@type='orthographic' and not(following-sibling::tei:rdg[not(@type='orthographic')]) and not(preceding-sibling::tei:rdg[not(@type='orthographic')]) and not(parent::tei:rdgGrp) and not(preceding-sibling::tei:lem[@cause]) and not(ancestor::tei:lem)]">
        <!-- Varianten werden nicht ausgegeben, nur Lemma -->
        	<xsl:apply-templates select="tei:lem//text()"/>
					</xsl:when>
      	<!-- Fall: lem leer, weil andere Handschriften etwas hinzufügen -->
      		<xsl:when test="tei:lem[not(descendant::tei:app)]=''">
          	<xsl:text>^[</xsl:text>
          	<xsl:apply-templates select="tei:rdg|tei:rdgGrp/tei:rdg"/>
            <xsl:text>] </xsl:text>
					</xsl:when>
      		<xsl:otherwise>
						<xsl:if test="@xml:id">
						<xsl:text>[</xsl:text>
					</xsl:if>
				<xsl:value-of select="tei:rdgGrp/tei:lem|tei:lem"/>
				<xsl:if test="@xml:id">
		 		 <xsl:text>]{#</xsl:text>
	 		 <xsl:value-of select="@xml:id"/>
				<xsl:text>}</xsl:text></xsl:if>
 				<xsl:text>^[</xsl:text>
				<xsl:value-of select="tei:rdgGrp/tei:lem|tei:lem"/>
				<xsl:text> *</xsl:text>
				<xsl:if test="tei:lem[@cause='correction']">
					<xsl:text>corr. </xsl:text>
				</xsl:if>
				<xsl:if test="tei:lem[@cause='conjecture']">
					<xsl:text>coni. </xsl:text>
				</xsl:if>
				<xsl:if test="tei:lem[@cause='proposition']">
					<xsl:text>prop. </xsl:text>
				</xsl:if>
				<xsl:if test="tei:lem[@cause='deletion']">
					<xsl:text>del. </xsl:text>
				</xsl:if>
				<!--  Falls Konjektur, Sigle ausgeben, selbst wenn Zeuge descriptus -->
				<xsl:if test="tei:lem[@cause='conjecture']">
				<xsl:value-of select="for $x in tokenize(tei:lem/@wit|tei:lem/@resp|tei:lem/@source, ' ') return key('elements-by-id',substring-after($x, '#'))/@xml:id"/>
				</xsl:if>
				<xsl:value-of select="for $x in tokenize(tei:rdgGrp/tei:lem/@wit|tei:lem/@wit|tei:lem/@resp|tei:lem/@source, ' ') return key('elements-by-id',substring-after($x, '#'))[not(@source)]/@xml:id"/>
				<xsl:text>* </xsl:text>
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
						<xsl:text></xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>] </xsl:text>
			</xsl:otherwise>
					</xsl:choose>
			</xsl:if>
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
				<xsl:text disable-output-escaping="yes"> &lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt; </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text disable-output-escaping="yes"> &lt;</xsl:text>
				<xsl:apply-templates/>
				<xsl:text disable-output-escaping="yes">&gt; </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note">
		<xsl:text>^[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>] </xsl:text>
	</xsl:template>

	<xsl:template match="tei:quote">
		<xsl:choose>
			<xsl:when test="@type='marked'">
				<xsl:text>»</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>«^[</xsl:text>
				<xsl:value-of select="concat(substring-before(substring-after(tei:ref/@cRef,':'),':'),' ',translate(substring-after(substring-after(tei:ref/@cRef,':'),':'),':',','))"/>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:when test="@type='unmarked'">
				<xsl:text>›</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>‹^[</xsl:text>
				<xsl:value-of select="concat(substring-before(substring-after(tei:ref/@cRef,':'),':'),' ',translate(substring-after(substring-after(tei:ref/@cRef,':'),':'),':',','))"/>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:when test="@type='paraphrase'">
				<xsl:apply-templates/>
				<xsl:text>^[Cf. </xsl:text>
				<xsl:value-of select="concat(substring-before(substring-after(tei:ref/@cRef,':'),':'),' ',translate(substring-after(substring-after(tei:ref/@cRef,':'),':'),':',','))"/>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>*</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>*^[</xsl:text>
				<xsl:value-of select="concat(substring-before(substring-after(tei:ref/@cRef,':'),':'),' ',translate(substring-after(substring-after(tei:ref/@cRef,':'),':'),':',','))"/>
				<xsl:text>]</xsl:text>
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
			<xsl:when test="(@type='allusion')"> <!-- Anspielung-->
				<xsl:text> *</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>*^[</xsl:text>
				<xsl:value-of select="concat(substring-before(substring-after(tei:ref/@cRef,':'),':'),' ',translate(substring-after(substring-after(tei:ref/@cRef,':'),':'),':',','))"/>
				<xsl:text>]</xsl:text>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='insertion')"> <!-- Einschub in Zitat-->
				<xsl:text>« </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> »</xsl:text>
			</xsl:when>
			<xsl:when test="(@type='fq')"> <!--false quote-->
				<xsl:text> _</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>_ </xsl:text>
			</xsl:when>
			<xsl:when test="(@type='psq')"> <!-- pseudo-quote-->
				<xsl:text>« </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> »</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:mentioned">
		<xsl:text> *</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>* </xsl:text>
	</xsl:template>

	<xsl:template match="tei:said">
		<xsl:text> »</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>« </xsl:text>
	</xsl:template>

	<xsl:template match="tei:persName|tei:placeName[not(parent::tei:orgName)]|tei:orgName">
		<xsl:text> [</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>](</xsl:text>
		<xsl:value-of select="@ref"/>
		<xsl:text>) </xsl:text>
	</xsl:template>


	<xsl:template match="tei:witDetail">
		<xsl:text>&#10;- </xsl:text>
		<xsl:value-of select="replace(@target, '#', '')"/>
		<xsl:text> (Hs.: </xsl:text>
		<xsl:value-of select="replace(@wit, '#', '')"/>
		<xsl:text>): </xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:ref">
<xsl:choose>
	  <xsl:when test="@target">

	    <xsl:choose>

              <xsl:when test="substring(@target,1,1)='#'">
		    <xsl:text>*</xsl:text>
				<xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>](</xsl:text><xsl:value-of select="@target"/><xsl:text>)</xsl:text>
		    <xsl:text>*</xsl:text>
              </xsl:when>

              <xsl:otherwise>
		<xsl:choose>
		  <xsl:when test='parent::tei:note'>
		    <xsl:text> </xsl:text>
		    <xsl:apply-templates/><xsl:text> (&lt;</xsl:text>
		    <xsl:value-of select="@target"/>
		    <xsl:text>&gt;) </xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:text> </xsl:text>
		    <xsl:apply-templates/><xsl:text>^[&lt;</xsl:text>
		    <xsl:value-of select="@target"/>
		    <xsl:text>&gt;] </xsl:text>
		  </xsl:otherwise>
		</xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates/>
		</xsl:otherwise>
	</xsl:choose>
	  </xsl:template>
</xsl:stylesheet>
