<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl"
	xmlns:arco-fn="https://w3id.org/arco/saxon-extension" 
	xmlns:arco-core="https://w3id.org/arco/ontology/core/"
	xmlns:arco-arco="https://w3id.org/arco/ontology/arco/"
	xmlns:arco-ce="https://w3id.org/arco/ontology/cultural-event/"
	xmlns:arco-catalogue="https://w3id.org/arco/ontology/catalogue/"
	xmlns:arco-dd="https://w3id.org/arco/ontology/denotative-description/" xmlns:cis="http://dati.beniculturali.it/cis/"
	xmlns:l0="https://w3id.org/italia/onto/l0/" xmlns:clvapit="https://w3id.org/italia/onto/CLV/"
	xmlns:tiapit="https://w3id.org/italia/onto/TI/" xmlns:roapit="https://w3id.org/italia/onto/RO/"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/creator"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:frbr="http://purl.org/vocab/frbr/core#"
	xmlns:arco-location="https://w3id.org/arco/ontology/location/" xmlns:language="https://w3id.org/italia/onto/Language/"
	xmlns:arco-cd="https://w3id.org/arco/ontology/context-description/"
	xmlns:mu="https://w3id.org/italia/onto/MU/"
	exclude-result-prefixes="xsl php">

	<xsl:output method="xml" encoding="utf-8" indent="yes" />
	<xsl:param name="item" />
	
	<xsl:variable name="itemURI">
		<xsl:choose>
			<xsl:when test="schede/*/RV/RVE/RVEL">
				<xsl:value-of
					select="concat(schede/*/CD/NCT/NCTR, schede/*/CD/NCT/NCTN, schede/*/CD/NCT/NCTS, '-', arco-fn:urify(normalize-space(schede/*/RV/RVE/RVEL)))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="concat(schede/*/CD/NCT/NCTR, schede/*/CD/NCT/NCTN, schede/*/CD/NCT/NCTS)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="NS" select="'https://w3id.org/arco/resource/'" />
	
	<xsl:variable name="culturalPropertyComponent"
			select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI, '-component')" />

		<xsl:variable name="culturalProperty"
			select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI)" />
	
	<xsl:variable name="sheetVersion" select="schede/*/@version"></xsl:variable>
	<xsl:variable name="sheetType" select="name(schede/*)"></xsl:variable>
	<xsl:variable name="cp-name" select="''"></xsl:variable>
	
	<xsl:variable name="objectOfDescription">
		<xsl:choose>
			<xsl:when test="schede/*/OG/OGT/OGTP and ($sheetVersion='4.00_ICCD0' or $sheetVersion='4.00')">
				<xsl:value-of select="$culturalPropertyComponent" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$culturalProperty" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">

		<rdf:RDF>
			<xsl:for-each select="schede/*/VM/VMC">
				<xsl:choose>
					<xsl:when
						test="./VMCE and not(lower-case(normalize-space(./VMCE))='intero bene') and not(lower-case(normalize-space(./VMCE))='integrale') 
							and not(lower-case(normalize-space(./VMCE))='tutta') and not(lower-case(normalize-space(./VMCE))='totale') 
							and (not(starts-with(lower-case(normalize-space(./VMCE)), 'nr')) and not(starts-with(lower-case(normalize-space(./VMCE)), 'n.r')) 
							and not(starts-with(lower-case(normalize-space(./VMCE)), 'esemplar')) and not(starts-with(lower-case(normalize-space(./VMCE)), 'intero')) 
							and not(starts-with(lower-case(normalize-space(./VMCE)), 'intera')))">
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="$objectOfDescription" />
							</xsl:attribute>
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(./VMCE)))" />
								</xsl:attribute>
							</arco-core:hasPart>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(./VMCE)))" />
							</xsl:attribute>
							<rdfs:label>
								<xsl:value-of select="normalize-space(./VMCE)" />
							</rdfs:label>
							<l0:name>
								<xsl:value-of select="normalize-space(./VMCE)" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/arco/ontology/arco/CulturalPropertyPart" />
							<arco-dd:hasMeasurementCollection>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'MeasurementCollection/', $itemURI, '-', arco-fn:urify(normalize-space(./VMCE)))" />
								</xsl:attribute>
							</arco-dd:hasMeasurementCollection>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'MeasurementCollection/', $itemURI, '-', arco-fn:urify(normalize-space(./VMCE)))" />
							</xsl:attribute>
							<rdfs:label xml:lang="en">
								<xsl:value-of select="concat('Measurmements of cultural property ', $itemURI, ' ', normalize-space(./VMCE))" />
							</rdfs:label>
							<rdfs:label xml:lang="it">
								<xsl:value-of select="concat('Misurazioni del bene culturale ', $itemURI, ' ', normalize-space(./VMCE))" />
							</rdfs:label>
							<l0:name xml:lang="en">
								<xsl:value-of select="concat('Measurmements of cultural property ', $itemURI, ' ', normalize-space(./VMCE))" />
							</l0:name>
							<l0:name xml:lang="it">
								<xsl:value-of select="concat('Misurazioni del bene culturale ', $itemURI, ' ', normalize-space(./VMCE))" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/arco/ontology/arco/MeasurementCollection" />
							<arco-dd:hasMeasurement>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Measurement/', $itemURI, '-', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))))" />
								</xsl:attribute>
							</arco-dd:hasMeasurement>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'Measurement/', $itemURI, '-', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))))" />
							</xsl:attribute>
							<rdfs:label xml:lang="en">
								<xsl:value-of select="concat('Measurement of cultural property ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</rdfs:label>
							<rdfs:label xml:lang="it">
								<xsl:value-of select="concat('Misurazione del bene culturale ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</rdfs:label>
							<l0:name xml:lang="en">
								<xsl:value-of select="concat('Measurement of cultural property ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</l0:name>
							<l0:name xml:lang="it">
								<xsl:value-of select="concat('Misurazione del bene culturale ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/arco/ontology/denotative-description/Measurement"/>
							<arco-dd:hasMeasurementType>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat('https://w3id.org/arco/ontology/denotative-description/', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))))" />
								</xsl:attribute>
							</arco-dd:hasMeasurementType>
							<mu:hasValue>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Value/', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))), '-', arco-fn:urify(normalize-space(./VMCV)), '-', arco-fn:urify(normalize-space(./VMCU)))" />
								</xsl:attribute>
							</mu:hasValue>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'Value/', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))), '-', arco-fn:urify(normalize-space(./VMCV)), '-', arco-fn:urify(normalize-space(./VMCU)))" />
							</xsl:attribute>
							<rdfs:label>
								<xsl:value-of select="concat(./VMCV, ' ', normalize-space(./VMCU))" />
							</rdfs:label>
							<l0:name>
								<xsl:value-of select="concat(./VMCV, ' ', normalize-space(./VMCU))" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/italia/onto/MU/Value"/>
							<mu:hasMeasurementUnit>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'MeasurementUnit/', arco-fn:urify(normalize-space(./VMCU)))" />
								</xsl:attribute>
							</mu:hasMeasurementUnit>
							<mu:value>
								<xsl:value-of select="./VMCV" />
							</mu:value>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'MeasurementUnit/', arco-fn:urify(normalize-space(./VMCU)))" />
							</xsl:attribute>
							<rdfs:label>
								<xsl:value-of select="normalize-space(./VMCU)" />
							</rdfs:label>
							<l0:name>
								<xsl:value-of select="normalize-space(./VMCU)" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/italia/onto/MU/MeasurementUnit"/>
						</rdf:Description>
					</xsl:when>
					<xsl:otherwise>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="$objectOfDescription" />
							</xsl:attribute>
							<arco-dd:hasMeasurementCollection>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'MeasurementCollection/', $itemURI)" />
								</xsl:attribute>
							</arco-dd:hasMeasurementCollection>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'MeasurementCollection/', $itemURI)" />
							</xsl:attribute>
							<rdfs:label xml:lang="en">
								<xsl:value-of select="concat('Measurmements of cultural property ', $itemURI)" />
							</rdfs:label>
							<rdfs:label xml:lang="it">
								<xsl:value-of select="concat('Misurazioni del bene culturale ', $itemURI)" />
							</rdfs:label>
							<l0:name xml:lang="en">
								<xsl:value-of select="concat('Measurmements of cultural property ', $itemURI)" />
							</l0:name>
							<l0:name xml:lang="it">
								<xsl:value-of select="concat('Misurazioni del bene culturale ', $itemURI)" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/arco/ontology/arco/MeasurementCollection" />
							<arco-dd:hasMeasurement>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Measurement/', $itemURI, '-', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))))" />
								</xsl:attribute>
							</arco-dd:hasMeasurement>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'Measurement/', $itemURI, '-', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))))" />
							</xsl:attribute>
							<rdfs:label xml:lang="en">
								<xsl:value-of select="concat('Measurement of cultural property ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</rdfs:label>
							<rdfs:label xml:lang="it">
								<xsl:value-of select="concat('Misurazione del bene culturale ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</rdfs:label>
							<l0:name xml:lang="en">
								<xsl:value-of select="concat('Measurement of cultural property ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</l0:name>
							<l0:name xml:lang="it">
								<xsl:value-of select="concat('Misurazione del bene culturale ', $itemURI, ': ', ./VMCV, ' ', normalize-space(./VMCU))" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/arco/ontology/denotative-description/Measurement"/>
							<arco-dd:hasMeasurementType>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat('https://w3id.org/arco/ontology/denotative-description/', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))))" />
								</xsl:attribute>
							</arco-dd:hasMeasurementType>
							<mu:hasValue>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Value/', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))), '-', arco-fn:urify(normalize-space(./VMCV)), '-', arco-fn:urify(normalize-space(./VMCU)))" />
								</xsl:attribute>
							</mu:hasValue>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'Value/', arco-fn:uncamelize(arco-fn:map-measure(lower-case(./VMCT))), '-', arco-fn:urify(normalize-space(./VMCV)), '-', arco-fn:urify(normalize-space(./VMCU)))" />
							</xsl:attribute>
							<rdfs:label>
								<xsl:value-of select="concat(./VMCV, ' ', normalize-space(./VMCU))" />
							</rdfs:label>
							<l0:name>
								<xsl:value-of select="concat(./VMCV, ' ', normalize-space(./VMCU))" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/italia/onto/MU/Value"/>
							<mu:hasMeasurementUnit>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'MeasurementUnit/', arco-fn:urify(normalize-space(./VMCU)))" />
								</xsl:attribute>
							</mu:hasMeasurementUnit>
							<mu:value>
								<xsl:value-of select="./VMCV" />
							</mu:value>
						</rdf:Description>
						<rdf:Description>
							<xsl:attribute name="rdf:about">
								<xsl:value-of select="concat($NS, 'MeasurementUnit/', arco-fn:urify(normalize-space(./VMCU)))" />
							</xsl:attribute>
							<rdfs:label>
								<xsl:value-of select="normalize-space(./VMCU)" />
							</rdfs:label>
							<l0:name>
								<xsl:value-of select="normalize-space(./VMCU)" />
							</l0:name>
							<rdf:type rdf:resource="https://w3id.org/italia/onto/MU/MeasurementUnit"/>
						</rdf:Description>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>
</xsl:stylesheet>