﻿<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="/">
    <html>
      <head>
        <title></title>
        <style>
          h1 {
            text-align:center;
          }
        </style>
      </head>

      <body>
        <h1></h1>
        <table border="1" cellspacing="0" align="center">
          <tr>
            <th></th>
          </tr>

          <xsl:for-each select="">
            <xsl:sort select=""/>
            <tr>
              <td align="center"><xsl:value-of select=""/></td>
            </tr>
          </xsl:for-each>
        </table>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
