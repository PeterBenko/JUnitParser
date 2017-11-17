<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
                xmlns:t="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"
                xmlns:trxreport="urn:my-scripts"
>  
  <xsl:output method="html" indent="yes"/>
  
  <xsl:template match="/testsuites" >
    <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <meta charset="utf-8"/>
        <link rel="stylesheet" type="text/css" href="Trxer.css"/>
        <link rel="stylesheet" type="text/css" href="TrxerTable.css"/>
        <script language="javascript" type="text/javascript" src="functions.js"></script>
        <title>
          <xsl:value-of select="@name"/>
        </title>
      </head>
    </html>
    <body>
      <div id="divToRefresh" class="wrapOverall">
        <div id="floatingImageBackground" class="floatingImageBackground" style="visibility: hidden;">
          <div class="floatingImageCloseButton" onclick="hide('floatingImageBackground');"></div>
          <img src="" id="floatingImage"/>
        </div>
        <br />
          
        <xsl:variable name="testsFailed" select="@failures"/>
        <xsl:variable name="testRunOutcome">
          <xsl:choose>
            <xsl:when test="$testsFailed = 0">Passed</xsl:when>
            <xsl:otherwise>Failed</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
      
        <div class="StatusBar statusBar{$testRunOutcome}">
          <div class="statusBarInner">
            <center>
              <h1 class="hWhite">
                <div class="titleCenterd">
                  <xsl:value-of select="@name"/>@<xsl:value-of select="@timestamp"/>
                </div>
              </h1>
            </center>
          </div>
        </div>
        <div class="SummaryDiv">
          <h1>General</h1>
          <xsl:call-template name="summaryTable" />
        </div>
      </div>
      
      <div>
        <xsl:apply-templates select="testsuite" />
      </div>
    </body>
  </xsl:template>

  <xsl:template name="summaryTable">
    <table class="DetailsTable StatusesTable">
      <caption>Summary</caption>
      <tbody>
        <tr>
          <th scope="row" class="column1 statusCount">
            <xsl:text>Test count</xsl:text>
          </th>
          <th scope="row" class="column1 statusCount">
            <xsl:text>Success</xsl:text>
          </th>
          <th scope="row" class="column1 statusCount">
            <xsl:text>Failures</xsl:text>
          </th>
          <th scope="row" class="column1 statusCount">
            <xsl:text>Disabled</xsl:text>
          </th>
          <th scope="row" class="column1 statusCount">
            <xsl:text>Errors</xsl:text>
          </th>
          <th scope="row" class="column1 statusCount">
            <xsl:text>Time elapsed</xsl:text>
          </th>
        </tr>
        <tr>
          <td class="statusCount">
            <xsl:value-of select="@tests" />
          </td>
          <td class="statusCount">
            <xsl:value-of select="@tests - @failures - @disabled - @errors" />
          </td>
          <td class="statusCount">
            <xsl:value-of select="@failures" />
          </td>
          <td class="statusCount">
            <xsl:value-of select="@disabled" />
          </td>
          <td class="statusCount">
            <xsl:value-of select="@errors" />
          </td>
          <td class="statusCount">
            <xsl:value-of select="@time" />s
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>


  <xsl:template match="testsuite">
    <xsl:variable name="suiteSuccess">
      <xsl:choose>
        <xsl:when test="@failures &gt; 0">suiteFailed</xsl:when>
        <xsl:when test="@errors &gt; 0">suiteFailed</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <div class="suite {$suiteSuccess}">
      <h3>
        <xsl:value-of select="@name" />
      </h3>
      <xsl:call-template name="summaryTable" />
      <xsl:apply-templates select="system-out" />
      <xsl:apply-templates select="system-err" />
      <br/>

      <table class="testcases">
        <thead>
          <tr>
            <th>
              Test case
            </th>
            <th>
              Duration
            </th>
            <th>
              Output
            </th>
          </tr>
        </thead>
        <tbody>
          <xsl:apply-templates select="testcase" />
        </tbody>
      </table>
    </div>
  </xsl:template>

  <xsl:template match="testcase">

    <xsl:variable name="success">
      <xsl:choose>
        <xsl:when test="failure">failed</xsl:when>
        <xsl:when test="error">error</xsl:when>
        <xsl:when test="skipped">warn</xsl:when>
        <xsl:otherwise>passed</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <tr>
      <td class="{$success}">
        <xsl:value-of select="@name" />
      </td>
      <td>
        <xsl:value-of select="@time" />s
      </td>
      <td>
        <xsl:apply-templates select="system-out" />
        <xsl:apply-templates select="system-err" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="system-out">
    <xsl:text>
      ------ Standard output ------
    </xsl:text>
    <xsl:value-of select="." />
    <br/>
  </xsl:template>

  <xsl:template match="system-err">
    <xsl:text>
      ------ Error output ------
    </xsl:text>
    <xsl:value-of select="." />
    <br/>
  </xsl:template>

</xsl:stylesheet>