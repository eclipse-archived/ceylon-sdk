<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:param name="featureId"/>
   <xsl:param name="featureVersion"/>
   <xsl:template match="/">
       <xsl:variable name="urlPrefix">https://downloads.ceylon-lang.org/osgi/sdk/<xsl:value-of select="$featureVersion"/></xsl:variable>
       <features xmlns="http://karaf.apache.org/xmlns/features/v1.2.0" name="{$featureId}">
           <feature name="{$featureId}" version="{$featureVersion}" description="Ceylon SDK bundles. http://www.ceylon-lang.org">
                 <xsl:for-each select="/*[local-name()='repository']/*[local-name()='resource']">
                     <xsl:variable name="bundleName" select="./*[(local-name()='capability') and (@namespace='osgi.identity')]/*[(local-name()='attribute') and (@name='osgi.identity')]/@value"/>      
                     <xsl:variable name="url" select="./*[(local-name()='capability') and (@namespace='osgi.content')]/*[(local-name()='attribute') and (@name='url')]/@value"/>      
                     <xsl:if test="$bundleName != 'com.redhat.ceylon.war' and $bundleName != 'ceylon.test' and $bundleName != 'javax.servlet'">
                        <bundle>
                            <xsl:value-of select="$urlPrefix"/>/<xsl:value-of select="$url"/>
                        </bundle>
                     </xsl:if>
                 </xsl:for-each>
           </feature>
       </features>
   </xsl:template>
</xsl:stylesheet>
