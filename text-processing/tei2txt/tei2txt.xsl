<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs tei" version="3.0">
  <xsl:output method="text" version="1.0" encoding="UTF-8" indent="yes"
    suppress-indentation="tei:p tei:head tei:orig tei:reg"/>
  <xsl:strip-space elements="tei:*" xmlns:tei="http://www.tei-c.org/ns/1.0"/>
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="text()[not(string-length(normalize-space()))]"/>
  <xsl:template match="text()[string-length(normalize-space()) > 0]">
    <xsl:value-of select="replace(., '\s+', ' ')"/>
  </xsl:template>
  
  <xsl:template match="//tei:teiHeader[not(tei:fileDesc/tei:titleStmt/tei:title)]"/>
  
  <xsl:template match="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title">
    <xsl:value-of select="normalize-space(.)"/><xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="//tei:teiHeader/tei:fileDesc/tei:titleStmt/(tei:author | tei:editor | tei:funder)"/>
  <xsl:template match="//tei:teiHeader/tei:fileDesc/(tei:publicationStmt | tei:sourceDesc)"/>
  <xsl:template match="//tei:teiHeader/(tei:profileDesc | tei:revisionDesc)"/>
  
  <xsl:template match="//tei:front/tei:titlePage"/>
  
  <xsl:template match="tei:item">
    <xsl:value-of select="normalize-space(.)"/><xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:list/tei:item">
    <xsl:value-of select="normalize-space()"/><xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>

  <!--<xsl:template match="//tei:list/tei:head">
    <xsl:value-of select="normalize-space(.)"/><xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>-->

  <xsl:template match="//tei:opener">
    <xsl:value-of select="normalize-space(.)"/><xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="//tei:orig">
    <xsl:value-of select="normalize-space(.)"/><xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="//tei:head/tei:reg"/>
  
  <xsl:template match="//tei:p">
    <xsl:apply-templates/><xsl:text>&#xA;&#xA;</xsl:text>
  </xsl:template>
  
  <xsl:template match="//tei:rdg"/>
  
  
</xsl:stylesheet>