<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt">

    <xsl:output method="html" encoding="utf-8"/>
    
    <!-- 样式名称 -->
    <xsl:template match="b:Version">
        <xsl:text>1.0</xsl:text>
    </xsl:template>
    
    <xsl:template match="b:XslVersion">
        <xsl:text>2015</xsl:text>
    </xsl:template>
    
    <xsl:template match="b:StyleName">
        <xsl:text>GB/T 7714（顺序编码）</xsl:text>
    </xsl:template>
    
    <xsl:template match="b:StyleNameLocalized">
        <xsl:choose>
        <xsl:when test="b:Lcid='1033'">
            <xsl:text>GB/T 7714 (Sequential)</xsl:text>
        </xsl:when>
        <xsl:when test="b:Lcid='2052'">
            <xsl:text>GB/T 7714（顺序编码）</xsl:text>
        </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- 重要字段定义 -->
    <xsl:template match="b:GetImportantFields">
        <b:ImportantFields>
            <b:ImportantField>b:Author/b:Author/b:NameList</b:ImportantField>
            <b:ImportantField>b:Title</b:ImportantField>
            <b:ImportantField>b:Year</b:ImportantField>
            <b:ImportantField>b:JournalName</b:ImportantField>
            <b:ImportantField>b:Volume</b:ImportantField>
            <b:ImportantField>b:Pages</b:ImportantField>
            <b:ImportantField>b:Publisher</b:ImportantField>
            <b:ImportantField>b:City</b:ImportantField>
        </b:ImportantFields>
    </xsl:template>

    <!-- 书目模板 -->
    <xsl:template match="b:Bibliography">
        <html xmlns:w="urn:schemas-microsoft-com:office:word">
            <head>
            <style>
            .MsoBib {
                text-indent: -2em;
                margin-left: 2em;
            }
            </style>
            </head>
            <body>
                <xsl:apply-templates select="b:Source">
                <xsl:sort select="b:RefOrder" data-type="number"/>
				<xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:Last" />
				<xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:First" />
				<xsl:sort select="b:Author/b:Main/b:NameList/b:Person[1]/b:Middle"/>
				<xsl:sort select="b:Title"/>
                </xsl:apply-templates>
            </body>
        </html>
    </xsl:template>

    <!-- 通用作者格式（姓氏大写） -->
    <xsl:template name="format-author">
        <xsl:param name="authors"/>
        <xsl:param name="lcid" select="2052"/>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="b:RefOrder"/>
        <xsl:text>]</xsl:text><span style="mso-tab-count:1"> </span>
        <xsl:for-each select="$authors/b:Author/b:NameList/b:Person[position()&lt;4]">
            <xsl:if test="position() > 1">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="b:Last"/>
            <xsl:if test="b:First">
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring(b:First, 1, 1)"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="count($authors/b:Author/b:NameList/b:Person) > 3">
            <xsl:choose>
                <xsl:when test="$lcid = '1033'">
                <xsl:text>, et al</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                <xsl:text>,等</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!-- 文献类型标识 -->
    <xsl:template name="get-type-identifier">
        <xsl:param name="sourceType"/>
        <xsl:choose>
            <xsl:when test="$sourceType = 'JournalArticle'">J</xsl:when>
            <xsl:when test="$sourceType = 'Book'">M</xsl:when>
            <xsl:when test="$sourceType = 'BookSection'">M</xsl:when>
            <xsl:when test="$sourceType = 'ConferenceProceedings'">C</xsl:when>
            <xsl:when test="$sourceType = 'Report'">R</xsl:when>
            <xsl:when test="$sourceType = 'Thesis'">D</xsl:when>
            <xsl:when test="$sourceType = 'Patent'">P</xsl:when>
            <xsl:when test="$sourceType = 'InternetSite'">EB</xsl:when>
            <xsl:when test="$sourceType = 'DocumentFromInternetSite'">EB</xsl:when>
            <xsl:otherwise>Z</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 期刊文章格式 -->
    <xsl:template match="b:Source[b:SourceType = 'JournalArticle']">
        <p class="MsoBib">
            <xsl:call-template name="format-author">
                <xsl:with-param name="authors" select="b:Author"/>
                <xsl:with-param name="lcid" select="b:LCID"/>
            </xsl:call-template>
            <xsl:text>. </xsl:text>
            
            <xsl:value-of select="b:Title"/>
            <xsl:text>[</xsl:text>
            <xsl:call-template name="get-type-identifier">
                <xsl:with-param name="sourceType" select="b:SourceType"/>
            </xsl:call-template>
            <xsl:text>]. </xsl:text>
            
            <xsl:value-of select="b:JournalName"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="b:Year"/>
            <xsl:if test="b:Volume">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="b:Volume"/>
            </xsl:if>
            <xsl:if test="b:Issue">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="b:Issue"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
            <xsl:if test="b:Pages">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="b:Pages"/>
            </xsl:if>
            <xsl:text>.</xsl:text>
        </p>
    </xsl:template>

    <!-- 书籍格式 -->
    <xsl:template match="b:Source[b:SourceType = 'Book']">
        <p class="MsoBib">
            <xsl:call-template name="format-author">
                <xsl:with-param name="authors" select="b:Author"/>
                <xsl:with-param name="lcid" select="b:LCID"/>
            </xsl:call-template>
            <xsl:text>. </xsl:text>
            
            <xsl:value-of select="b:Title"/>
            <xsl:text>[</xsl:text>
            <xsl:call-template name="get-type-identifier">
                <xsl:with-param name="sourceType" select="b:SourceType"/>
            </xsl:call-template>
            <xsl:text>]. </xsl:text>
            
            <xsl:if test="b:Edition">
                <xsl:value-of select="b:Edition"/>
                <xsl:text>版. </xsl:text>
            </xsl:if>
            
            <xsl:if test="b:City">
                <xsl:value-of select="b:City"/>
                <xsl:text>: </xsl:text>
            </xsl:if>
            
            <xsl:value-of select="b:Publisher"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="b:Year"/>
            <xsl:text>.</xsl:text>
        </p>
    </xsl:template>

    <!-- 会议论文格式 -->
    <xsl:template match="b:Source[b:SourceType = 'ConferenceProceedings']">
        <p class="MsoBib">
            <xsl:call-template name="format-author">
                <xsl:with-param name="authors" select="b:Author"/>
                <xsl:with-param name="lcid" select="b:LCID"/>
            </xsl:call-template>
            <xsl:text>. </xsl:text>
            
            <xsl:value-of select="b:Title"/>
            <xsl:text>[C]. </xsl:text>
            
            <xsl:if test="b:ConferenceName">
                <xsl:value-of select="b:ConferenceName"/>
            </xsl:if>
            <xsl:if test="b:ConferenceLocation">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="b:ConferenceLocation"/>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:if test="b:City">
                <xsl:text>, </xsl:text>
                <xsl:value-of select="b:City"/>
            </xsl:if>
            <xsl:if test="b:Publisher">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="b:Publisher"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="b:Year"/>
            <xsl:if test="b:Pages">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="b:Pages"/>
            </xsl:if>
            <xsl:text>.</xsl:text>
        </p>
    </xsl:template>

    <!-- 学位论文格式 -->
    <xsl:template match="b:Source[b:SourceType = 'Report']">
        <p class="MsoBib">
            <xsl:call-template name="format-author">
                <xsl:with-param name="authors" select="b:Author"/>
                <xsl:with-param name="lcid" select="b:LCID"/>
            </xsl:call-template>
            <xsl:text>. </xsl:text>
            
            <xsl:value-of select="b:Title"/>
            <xsl:text>[D]. </xsl:text>
            
            <xsl:if test="b:Department">
                <xsl:value-of select="b:Department"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="b:Institution">
                <xsl:value-of select="b:Institution"/>
            </xsl:if>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="b:Year"/>
            <xsl:text>.</xsl:text>
        </p>
    </xsl:template>

    <!-- 网页资源格式 -->
    <xsl:template match="b:Source[b:SourceType = 'InternetSite' or b:SourceType = 'DocumentFromInternetSite']">
        <p class="MsoBib">
            <xsl:if test="b:Author">
                <xsl:call-template name="format-author">
                    <xsl:with-param name="authors" select="b:Author"/>
                    <xsl:with-param name="lcid" select="b:LCID"/>
                </xsl:call-template>
                <xsl:text>. </xsl:text>
            </xsl:if>
            
            <xsl:value-of select="b:Title"/>
            <xsl:text>[EB/OL]. </xsl:text>
            
            <xsl:if test="b:Year">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="b:Year"/>
                <xsl:if test="b:Month">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="b:Month"/>
                </xsl:if>
                <xsl:if test="b:Day">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="b:Day"/>
                </xsl:if>
                <xsl:text>]. </xsl:text>
            </xsl:if>
            
            <xsl:if test="b:URL">
                <xsl:value-of select="b:URL"/>
            </xsl:if>
            
            <xsl:if test="b:YearAccessed">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="b:YearAccessed"/>
                <xsl:if test="b:MonthAccessed">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="b:MonthAccessed"/>
                </xsl:if>
                <xsl:if test="b:DayAccessed">
                    <xsl:text>-</xsl:text>
                    <xsl:value-of select="b:DayAccessed"/>
                </xsl:if>
                <xsl:text>]</xsl:text>
            </xsl:if>
            <xsl:text>.</xsl:text>
        </p>
    </xsl:template>

    <!-- 默认格式（其他类型） -->
    <xsl:template match="b:Source">
        <p class="MsoBib">
            <xsl:call-template name="format-author">
                <xsl:with-param name="authors" select="b:Author"/>
                <xsl:with-param name="lcid" select="b:LCID"/>
            </xsl:call-template>
            <xsl:text>. </xsl:text>
            
            <xsl:value-of select="b:Title"/>
            <xsl:text>[Z]. </xsl:text>
            
            <xsl:if test="b:Publisher">
                <xsl:value-of select="b:Publisher"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="b:Year"/>
            <xsl:text>.</xsl:text>
        </p>
    </xsl:template>

    <!-- 引文格式（顺序编码） -->
    <xsl:template match="b:Citation">
        <xsl:if test="b:FirstAuthor or b:LastAuthor">
        <sup>
            <xsl:if test="b:FirstAuthor">
            <xsl:text>[</xsl:text>
            </xsl:if>
            <xsl:if test="not(b:FirstAuthor)">
            <xsl:text>-</xsl:text>
            </xsl:if>
            <xsl:value-of select="b:Source/b:RefOrder"/>
            <xsl:if test="b:LastAuthor">
            <xsl:text>]</xsl:text>
            </xsl:if>
        </sup>
        </xsl:if>
    </xsl:template>

    <!-- 处理空文本节点 -->
    <xsl:template match="text()"/>
</xsl:stylesheet>