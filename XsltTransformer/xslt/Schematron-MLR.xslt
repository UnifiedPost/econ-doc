<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:error="https://doi.org/10.5281/zenodo.1495494#error"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
                xmlns:schxslt-api="https://doi.org/10.5281/zenodo.1495494#api"
                xmlns:u="utils"
                xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0">
   <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/"
                     xmlns:dct="http://purl.org/dc/terms/"
                     xmlns:skos="http://www.w3.org/2004/02/skos/core#">
      <dct:creator>
         <dct:Agent>
            <skos:prefLabel>SchXslt/1.9.5 SAXON/HE 11.5</skos:prefLabel>
            <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
         </dct:Agent>
      </dct:creator>
      <dct:created>2024-02-05T14:31:06.674+02:00</dct:created>
   </rdf:Description>
   <xsl:output indent="yes"/>
   <xsl:key xmlns="http://purl.oclc.org/dsdl/schematron"
             xmlns:xi="http://www.w3.org/2001/XInclude"
             name="k_lineId"
             match="cac:LineItem"
             use="cbc:ID"/>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:gln"
              as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                 select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                 select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (1 + ((($i + 1) mod 2) * 2)))"/>
      <value-of select="(10 - ($weightedSum mod 10)) mod 10 = number(substring($val, $length + 1, 1))"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:mod11"
              as="xs:boolean">
      <param name="val"/>
      <variable name="length" select="string-length($val) - 1"/>
      <variable name="digits"
                 select="reverse(for $i in string-to-codepoints(substring($val, 0, $length + 1)) return $i - 48)"/>
      <variable name="weightedSum"
                 select="sum(for $i in (0 to $length - 1) return $digits[$i + 1] * (($i mod 6) + 2))"/>
      <value-of select="number($val) &gt; 0 and (11 - ($weightedSum mod 11)) mod 11 = number(substring($val, $length + 1, 1))"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkCodiceIPA"
              as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789</variable>
      <sequence select="if ( (string-length(translate($arg, $allowed-characters, '')) = 0) and (string-length($arg) = 6) ) then true() else false()"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:addPIVA"
              as="xs:integer">
      <param name="arg" as="xs:string"/>
      <param name="pari" as="xs:integer"/>
      <variable name="tappo"
                 select="if (not($arg castable as xs:integer)) then 0 else 1"/>
      <variable name="mapper"
                 select="if ($tappo = 0) then 0 else                    ( if ($pari = 1)                     then ( xs:integer(substring('0246813579', ( xs:integer(substring($arg,1,1)) +1 ) ,1)) )                     else ( xs:integer(substring($arg,1,1) ) )                   )"/>
      <sequence select="if ($tappo = 0) then $mapper else ( xs:integer($mapper) + u:addPIVA(substring(xs:string($arg),2), (if($pari=0) then 1 else 0) ) )"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkCF"
              as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <sequence select="   if ( (string-length($arg) = 16) or (string-length($arg) = 11) )      then    (    if ((string-length($arg) = 16))     then    (     if (u:checkCF16($arg))      then     (      true()     )     else     (      false()     )    )    else    (     if(($arg castable as xs:integer)) then true() else false()       )   )   else   (    false()   )   "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkCF16"
              as="xs:boolean">
      <param name="arg" as="xs:string?"/>
      <variable name="allowed-characters">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</variable>
      <sequence select="     if (  (string-length(translate(substring($arg,1,6), $allowed-characters, '')) = 0) and         (substring($arg,7,2) castable as xs:integer) and        (string-length(translate(substring($arg,9,1), $allowed-characters, '')) = 0) and        (substring($arg,10,2) castable as xs:integer) and         (substring($arg,12,3) castable as xs:string) and        (substring($arg,15,1) castable as xs:integer) and         (string-length(translate(substring($arg,16,1), $allowed-characters, '')) = 0)      )      then true()     else false()     "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkPIVA"
              as="xs:integer">
      <param name="arg" as="xs:string?"/>
      <sequence select="     if (not($arg castable as xs:integer))       then 1      else ( u:addPIVA($arg,xs:integer(0)) mod 10 )"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:checkPIVAseIT"
              as="xs:boolean">
      <param name="arg" as="xs:string"/>
      <variable name="paese" select="substring($arg,1,2)"/>
      <variable name="codice" select="substring($arg,3)"/>
      <sequence select="       if ( $paese = 'IT' or $paese = 'it' )    then    (     if ( ( string-length($codice) = 11 ) and ( if (u:checkPIVA($codice)!=0) then false() else true() ))     then      (      true()     )     else     (      false()     )    )    else    (     true()    )      "/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:mod97-0208"
              as="xs:boolean">
      <param name="val"/>
      <variable name="checkdigits" select="substring($val,9,2)"/>
      <variable name="calculated_digits"
                 select="xs:string(97 - (xs:integer(substring($val,1,8)) mod 97))"/>
      <value-of select="number($checkdigits) = number($calculated_digits)"/>
   </function>
   <function xmlns="http://www.w3.org/1999/XSL/Transform"
              xmlns:xi="http://www.w3.org/2001/XInclude"
              name="u:abn"
              as="xs:boolean">
      <param name="val"/>
      <value-of select="( ((string-to-codepoints(substring($val,1,1)) - 49) * 10) + ((string-to-codepoints(substring($val,2,1)) - 48) * 1) + ((string-to-codepoints(substring($val,3,1)) - 48) * 3) + ((string-to-codepoints(substring($val,4,1)) - 48) * 5) + ((string-to-codepoints(substring($val,5,1)) - 48) * 7) + ((string-to-codepoints(substring($val,6,1)) - 48) * 9) + ((string-to-codepoints(substring($val,7,1)) - 48) * 11) + ((string-to-codepoints(substring($val,8,1)) - 48) * 13) + ((string-to-codepoints(substring($val,9,1)) - 48) * 15) + ((string-to-codepoints(substring($val,10,1)) - 48) * 17) + ((string-to-codepoints(substring($val,11,1)) - 48) * 19)) mod 89 = 0 "/>
   </function>
   <xsl:variable name="cleas"
                  select="tokenize('0002 0007 0009 0037 0060 0088 0096 0097 0106 0130 0135 0142 0151 0183 0184 0188 0190 0191 0192 0193 0195 0196 0198 0199 0200 0201 0202 0204 0208 0209 0210 0211 0212 0213 0215 0216 0218 0221 0230 9901 9910 9913 9914 9915 9918 9919 9920 9922 9923 9924 9925 9926 9927 9928 9929 9930 9931 9932 9933 9934 9935 9936 9937 9938 9939 9940 9941 9942 9943 9944 9945 9946 9947 9948 9949 9950 9951 9952 9953 9957 9959', '\s')"/>
   <xsl:variable name="clStatusReason" select="tokenize('BV BW SV', '\s')"/>
   <xsl:variable name="clUNCL4343" select="tokenize('AB AP RE', '\s')"/>
   <xsl:variable name="clUNCL1001"
                  select="tokenize('1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 1999 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 481 482 483 484 485 486 487 488 489 490 491 493 494 495 496 497 498 499 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 550 551 552 553 554 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 610 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 760 761 763 764 765 766 770 775 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 810 811 812 820 821 822 823 824 825 830 833 840 841 850 851 852 853 855 856 860 861 862 863 864 865 870 890 895 896 901 910 911 913 914 915 916 917 925 926 927 929 930 931 932 933 934 935 936 937 938 940 941 950 951 952 953 954 955 960 961 962 963 964 965 966 970 971 972 974 975 976 977 978 979 990 991 995 996 998', '\s')"/>
   <xsl:template match="root()">
      <xsl:variable name="metadata" as="element()?">
         <svrl:metadata xmlns:dct="http://purl.org/dc/terms/"
                         xmlns:skos="http://www.w3.org/2004/02/skos/core#"
                         xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
            <dct:creator>
               <dct:Agent>
                  <skos:prefLabel>
                     <xsl:value-of separator="/"
                                    select="(system-property('xsl:product-name'), system-property('xsl:product-version'))"/>
                  </skos:prefLabel>
               </dct:Agent>
            </dct:creator>
            <dct:created>
               <xsl:value-of select="current-dateTime()"/>
            </dct:created>
            <dct:source>
               <rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/">
                  <dct:creator>
                     <dct:Agent>
                        <skos:prefLabel>SchXslt/1.9.5 SAXON/HE 11.5</skos:prefLabel>
                        <schxslt.compile.typed-variables xmlns="https://doi.org/10.5281/zenodo.1495494#">true</schxslt.compile.typed-variables>
                     </dct:Agent>
                  </dct:creator>
                  <dct:created>2024-02-05T14:31:06.674+02:00</dct:created>
               </rdf:Description>
            </dct:source>
         </svrl:metadata>
      </xsl:variable>
      <xsl:variable name="report" as="element(schxslt:report)">
         <schxslt:report>
            <xsl:call-template name="d13e121"/>
         </schxslt:report>
      </xsl:variable>
      <xsl:variable name="schxslt:report" as="node()*">
         <xsl:sequence select="$metadata"/>
         <xsl:for-each select="$report/schxslt:document">
            <xsl:for-each select="schxslt:pattern">
               <xsl:sequence select="node()"/>
               <xsl:sequence select="../schxslt:rule[@pattern = current()/@id]/node()"/>
            </xsl:for-each>
         </xsl:for-each>
      </xsl:variable>
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                               schemaVersion="iso"
                               title="Rules for PEPPOL Message Level Response transaction 3.0">
         <svrl:ns-prefix-in-attribute-values prefix="cbc"
                                              uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="cac"
                                              uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="ubl"
                                              uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"/>
         <svrl:ns-prefix-in-attribute-values prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
         <svrl:ns-prefix-in-attribute-values prefix="u" uri="utils"/>
         <xsl:sequence select="$schxslt:report"/>
      </svrl:schematron-output>
   </xsl:template>
   <xsl:template match="text() | @*" mode="#all" priority="-10"/>
   <xsl:template match="/" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template match="*" mode="#all" priority="-10">
      <xsl:apply-templates mode="#current" select="@*"/>
      <xsl:apply-templates mode="#current" select="node()"/>
   </xsl:template>
   <xsl:template name="d13e121">
      <schxslt:document>
         <schxslt:pattern id="d13e121">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e130">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e207">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <schxslt:pattern id="d13e435">
            <xsl:if test="exists(base-uri(root()))">
               <xsl:attribute name="documents" select="base-uri(root())"/>
            </xsl:if>
            <xsl:for-each select="root()">
               <svrl:active-pattern xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="documents" select="base-uri(.)"/>
               </svrl:active-pattern>
            </xsl:for-each>
         </schxslt:pattern>
         <xsl:apply-templates mode="d13e121" select="root()"/>
      </schxslt:document>
   </xsl:template>
   <xsl:template match="//*[not(*) and not(normalize-space())]"
                  priority="48"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e121']">
            <schxslt:rule pattern="d13e121">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "//*[not(*) and not(normalize-space())]" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//*[not(*) and not(normalize-space())]</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e121">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">//*[not(*) and not(normalize-space())]</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-COMMON-R001">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST not contain empty elements.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e121')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/*" priority="47" mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(not(@*:schemaLocation))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="warning"
                                       id="PEPPOL-COMMON-R003">
                     <xsl:attribute name="test">not(@*:schemaLocation)</xsl:attribute>
                     <svrl:text>Document SHOULD not contain schema location.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate"
                  priority="46"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:IssueDate | cbc:DueDate | cbc:TaxPointDate | cbc:StartDate | cbc:EndDate | cbc:ActualDeliveryDate</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((string(.) castable as xs:date) and (string-length(.) = 10))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-COMMON-R030">
                     <xsl:attribute name="test">(string(.) castable as xs:date) and (string-length(.) = 10)</xsl:attribute>
                     <svrl:text>A date must be formatted YYYY-MM-DD.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']"
                  priority="45"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0088'] | cac:PartyIdentification/cbc:ID[@schemeID = '0088'] | cbc:CompanyID[@schemeID = '0088']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-COMMON-R040">
                     <xsl:attribute name="test">matches(normalize-space(), '^[0-9]+$') and u:gln(normalize-space())</xsl:attribute>
                     <svrl:text>GLN must have a valid format according to GS1 rules.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']"
                  priority="44"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0192'] | cac:PartyIdentification/cbc:ID[@schemeID = '0192'] | cbc:CompanyID[@schemeID = '0192']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-COMMON-R041">
                     <xsl:attribute name="test">matches(normalize-space(), '^[0-9]{9}$') and u:mod11(normalize-space())</xsl:attribute>
                     <svrl:text>Norwegian organization number MUST be stated in the correct format.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']"
                  priority="43"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0208'] | cac:PartyIdentification/cbc:ID[@schemeID = '0208'] | cbc:CompanyID[@schemeID = '0208']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-COMMON-R043">
                     <xsl:attribute name="test">matches(normalize-space(), '^[0-9]{10}$') and u:mod97-0208(normalize-space())</xsl:attribute>
                     <svrl:text>Belgian enterprise number MUST be stated in the correct format.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']"
                  priority="42"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0201'] | cac:PartyIdentification/cbc:ID[@schemeID = '0201'] | cbc:CompanyID[@schemeID = '0201']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(u:checkCodiceIPA(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="warning"
                                       id="PEPPOL-COMMON-R044">
                     <xsl:attribute name="test">u:checkCodiceIPA(normalize-space())</xsl:attribute>
                     <svrl:text>IPA Code (Codice Univoco Unità Organizzativa) must be stated in the correct format</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']"
                  priority="41"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0210'] | cac:PartyIdentification/cbc:ID[@schemeID = '0210'] | cbc:CompanyID[@schemeID = '0210']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(u:checkCF(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="warning"
                                       id="PEPPOL-COMMON-R045">
                     <xsl:attribute name="test">u:checkCF(normalize-space())</xsl:attribute>
                     <svrl:text>Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '9907']"
                  priority="40"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '9907']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '9907']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '9907']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(u:checkCF(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="warning"
                                       id="PEPPOL-COMMON-R046">
                     <xsl:attribute name="test">u:checkCF(normalize-space())</xsl:attribute>
                     <svrl:text>Tax Code (Codice Fiscale) must be stated in the correct format</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']"
                  priority="39"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0211'] | cac:PartyIdentification/cbc:ID[@schemeID = '0211'] | cbc:CompanyID[@schemeID = '0211']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(u:checkPIVAseIT(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="warning"
                                       id="PEPPOL-COMMON-R047">
                     <xsl:attribute name="test">u:checkPIVAseIT(normalize-space())</xsl:attribute>
                     <svrl:text>Italian VAT Code (Partita Iva) must be stated in the correct format</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '9906']"
                  priority="38"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '9906']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '9906']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '9906']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(u:checkPIVAseIT(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="warning"
                                       id="PEPPOL-COMMON-R048">
                     <xsl:attribute name="test">u:checkPIVAseIT(normalize-space())</xsl:attribute>
                     <svrl:text>Italian VAT Code (Partita Iva) must be stated in the correct format</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']"
                  priority="37"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0007'] | cac:PartyIdentification/cbc:ID[@schemeID = '0007'] | cbc:CompanyID[@schemeID = '0007']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-COMMON-R049">
                     <xsl:attribute name="test">string-length(normalize-space()) = 10 and string(number(normalize-space())) != 'NaN'</xsl:attribute>
                     <svrl:text>Swedish organization number MUST be stated in the correct format.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']"
                  priority="36"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e130']">
            <schxslt:rule pattern="d13e130">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e130">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:EndpointID[@schemeID = '0151'] | cac:PartyIdentification/cbc:ID[@schemeID = '0151'] | cbc:CompanyID[@schemeID = '0151']</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space()))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-COMMON-R050">
                     <xsl:attribute name="test">matches(normalize-space(), '^[0-9]{11}$') and u:abn(normalize-space())</xsl:attribute>
                     <svrl:text>Australian Business Number (ABN) MUST be stated in the correct format.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e130')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse" priority="35" mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:CustomizationID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00101">
                     <xsl:attribute name="test">cbc:CustomizationID</xsl:attribute>
                     <svrl:text>Element 'cbc:CustomizationID' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:ProfileID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00102">
                     <xsl:attribute name="test">cbc:ProfileID</xsl:attribute>
                     <svrl:text>Element 'cbc:ProfileID' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:ID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00103">
                     <xsl:attribute name="test">cbc:ID</xsl:attribute>
                     <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cbc:IssueDate)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00104">
                     <xsl:attribute name="test">cbc:IssueDate</xsl:attribute>
                     <svrl:text>Element 'cbc:IssueDate' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:SenderParty)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00105">
                     <xsl:attribute name="test">cac:SenderParty</xsl:attribute>
                     <svrl:text>Element 'cac:SenderParty' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:ReceiverParty)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00106">
                     <xsl:attribute name="test">cac:ReceiverParty</xsl:attribute>
                     <svrl:text>Element 'cac:ReceiverParty' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:DocumentResponse)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00107">
                     <xsl:attribute name="test">cac:DocumentResponse</xsl:attribute>
                     <svrl:text>Element 'cac:DocumentResponse' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(@*:schemaLocation))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00108">
                     <xsl:attribute name="test">not(@*:schemaLocation)</xsl:attribute>
                     <svrl:text>Document MUST not contain schema location.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cbc:CustomizationID"
                  priority="34"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cbc:CustomizationID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:CustomizationID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:CustomizationID</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cbc:ProfileID"
                  priority="33"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cbc:ProfileID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:ProfileID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:ProfileID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:mlr:3')">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00301">
                     <xsl:attribute name="test">normalize-space(text()) = 'urn:fdc:peppol.eu:poacc:bis:mlr:3'</xsl:attribute>
                     <svrl:text>Element 'cbc:ProfileID' MUST contain value 'urn:fdc:peppol.eu:poacc:bis:mlr:3'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cbc:ID"
                  priority="32"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cbc:ID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:ID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:ID</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cbc:IssueDate"
                  priority="31"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cbc:IssueDate" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:IssueDate</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:IssueDate</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cbc:IssueTime"
                  priority="30"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cbc:IssueTime" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:IssueTime</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cbc:IssueTime</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:SenderParty"
                  priority="29"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:SenderParty" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:SenderParty</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:SenderParty</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:EndpointID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00701">
                     <xsl:attribute name="test">cbc:EndpointID</xsl:attribute>
                     <svrl:text>Element 'cbc:EndpointID' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID"
                  priority="28"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:SenderParty/cbc:EndpointID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@schemeID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00801">
                     <xsl:attribute name="test">@schemeID</xsl:attribute>
                     <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00802">
                     <xsl:attribute name="test">not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)</xsl:attribute>
                     <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:SenderParty/*"
                  priority="27"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:SenderParty/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:SenderParty/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:SenderParty/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00702">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:ReceiverParty"
                  priority="26"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:ReceiverParty" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:ReceiverParty</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:ReceiverParty</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:EndpointID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01001">
                     <xsl:attribute name="test">cbc:EndpointID</xsl:attribute>
                     <svrl:text>Element 'cbc:EndpointID' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID"
                  priority="25"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:ReceiverParty/cbc:EndpointID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(@schemeID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01101">
                     <xsl:attribute name="test">@schemeID</xsl:attribute>
                     <svrl:text>Attribute 'schemeID' MUST be present.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01102">
                     <xsl:attribute name="test">not(@schemeID) or (some $code in $cleas satisfies $code = @schemeID)</xsl:attribute>
                     <svrl:text>Value MUST be part of code list 'Electronic Address Scheme (EAS)'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:ReceiverParty/*"
                  priority="24"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:ReceiverParty/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:ReceiverParty/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:ReceiverParty/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01002">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse"
                  priority="23"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cac:Response)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01301">
                     <xsl:attribute name="test">cac:Response</xsl:attribute>
                     <svrl:text>Element 'cac:Response' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:DocumentReference)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01302">
                     <xsl:attribute name="test">cac:DocumentReference</xsl:attribute>
                     <svrl:text>Element 'cac:DocumentReference' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response"
                  priority="22"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:ResponseCode)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01401">
                     <xsl:attribute name="test">cbc:ResponseCode</xsl:attribute>
                     <svrl:text>Element 'cbc:ResponseCode' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode"
                  priority="21"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:ResponseCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((some $code in $clUNCL4343 satisfies $code = normalize-space(text())))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01501">
                     <xsl:attribute name="test">(some $code in $clUNCL4343 satisfies $code = normalize-space(text()))</xsl:attribute>
                     <svrl:text>Value MUST be part of code list 'Application Response type code (UNCL4343 Subset)'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description"
                  priority="20"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/cbc:Description</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*"
                  priority="19"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:Response/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01402">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference"
                  priority="18"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:ID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01701">
                     <xsl:attribute name="test">cbc:ID</xsl:attribute>
                     <svrl:text>Element 'cbc:ID' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID"
                  priority="17"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:ID</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode"
                  priority="16"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:DocumentTypeCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((some $code in $clUNCL1001 satisfies $code = normalize-space(text())))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01901">
                     <xsl:attribute name="test">(some $code in $clUNCL1001 satisfies $code = normalize-space(text()))</xsl:attribute>
                     <svrl:text>Value MUST be part of code list 'Document name code, full list (UNCL1001)'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:VersionID"
                  priority="15"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:VersionID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:VersionID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/cbc:VersionID</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*"
                  priority="14"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:DocumentReference/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01702">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse"
                  priority="13"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cac:LineReference)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02101">
                     <xsl:attribute name="test">cac:LineReference</xsl:attribute>
                     <svrl:text>Element 'cac:LineReference' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:Response)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02102">
                     <xsl:attribute name="test">cac:Response</xsl:attribute>
                     <svrl:text>Element 'cac:Response' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference"
                  priority="12"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:LineID)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02201">
                     <xsl:attribute name="test">cbc:LineID</xsl:attribute>
                     <svrl:text>Element 'cbc:LineID' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID"
                  priority="11"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/cbc:LineID</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*"
                  priority="10"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:LineReference/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02202">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response"
                  priority="9"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:Description)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02401">
                     <xsl:attribute name="test">cbc:Description</xsl:attribute>
                     <svrl:text>Element 'cbc:Description' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
               <xsl:if test="not(cac:Status)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02402">
                     <xsl:attribute name="test">cac:Status</xsl:attribute>
                     <svrl:text>Element 'cac:Status' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:ResponseCode"
                  priority="8"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:ResponseCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:ResponseCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:ResponseCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((some $code in $clUNCL4343 satisfies $code = normalize-space(text())))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02501">
                     <xsl:attribute name="test">(some $code in $clUNCL4343 satisfies $code = normalize-space(text()))</xsl:attribute>
                     <svrl:text>Value MUST be part of code list 'Application Response type code (UNCL4343 Subset)'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:Description"
                  priority="7"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:Description" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:Description</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cbc:Description</xsl:attribute>
               </svrl:fired-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status"
                  priority="6"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(cbc:StatusReasonCode)">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02701">
                     <xsl:attribute name="test">cbc:StatusReasonCode</xsl:attribute>
                     <svrl:text>Element 'cbc:StatusReasonCode' MUST be provided.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/cbc:StatusReasonCode"
                  priority="5"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/cbc:StatusReasonCode" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/cbc:StatusReasonCode</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/cbc:StatusReasonCode</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not((some $code in $clStatusReason satisfies $code = normalize-space(text())))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02801">
                     <xsl:attribute name="test">(some $code in $clStatusReason satisfies $code = normalize-space(text()))</xsl:attribute>
                     <svrl:text>Value MUST be part of code list 'Status reason code (openPEPPOL)'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/*"
                  priority="4"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/cac:Status/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02702">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/*"
                  priority="3"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/cac:LineResponse/cac:Response/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B02403">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/cac:DocumentResponse/*"
                  priority="2"
                  mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/cac:DocumentResponse/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/cac:DocumentResponse/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B01303">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="/ubl:ApplicationResponse/*" priority="1" mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e207']">
            <schxslt:rule pattern="d13e207">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "/ubl:ApplicationResponse/*" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/*</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e207">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">/ubl:ApplicationResponse/*</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(false())">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-B00109">
                     <xsl:attribute name="test">false()</xsl:attribute>
                     <svrl:text>Document MUST NOT contain elements not part of the data model.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e207')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="cbc:CustomizationID" priority="0" mode="d13e121">
      <xsl:param name="schxslt:patterns-matched" as="xs:string*"/>
      <xsl:choose>
         <xsl:when test="$schxslt:patterns-matched[. = 'd13e435']">
            <schxslt:rule pattern="d13e435">
               <xsl:comment xmlns:svrl="http://purl.oclc.org/dsdl/svrl">WARNING: Rule for context "cbc:CustomizationID" shadowed by preceding rule</xsl:comment>
               <svrl:suppressed-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:CustomizationID</xsl:attribute>
               </svrl:suppressed-rule>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="$schxslt:patterns-matched"/>
            </xsl:next-match>
         </xsl:when>
         <xsl:otherwise>
            <schxslt:rule pattern="d13e435">
               <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
                  <xsl:attribute name="context">cbc:CustomizationID</xsl:attribute>
               </svrl:fired-rule>
               <xsl:if test="not(starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:mlr:3'))">
                  <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                       location="{schxslt:location(.)}"
                                       flag="fatal"
                                       id="PEPPOL-T71-R001">
                     <xsl:attribute name="test">starts-with(normalize-space(.), 'urn:fdc:peppol.eu:poacc:trns:mlr:3')</xsl:attribute>
                     <svrl:text>Specification identifier SHALL start with the value 'urn:fdc:peppol.eu:poacc:trns:mlr:3'.</svrl:text>
                  </svrl:failed-assert>
               </xsl:if>
            </schxslt:rule>
            <xsl:next-match>
               <xsl:with-param name="schxslt:patterns-matched"
                                as="xs:string*"
                                select="($schxslt:patterns-matched, 'd13e435')"/>
            </xsl:next-match>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:function name="schxslt:location" as="xs:string">
      <xsl:param name="node" as="node()"/>
      <xsl:variable name="segments" as="xs:string*">
         <xsl:for-each select="($node/ancestor-or-self::node())">
            <xsl:variable name="position">
               <xsl:number level="single"/>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test=". instance of element()">
                  <xsl:value-of select="concat('Q{', namespace-uri(.), '}', local-name(.), '[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of attribute()">
                  <xsl:value-of select="concat('@Q{', namespace-uri(.), '}', local-name(.))"/>
               </xsl:when>
               <xsl:when test=". instance of processing-instruction()">
                  <xsl:value-of select="concat('processing-instruction(&#34;', name(.), '&#34;)[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of comment()">
                  <xsl:value-of select="concat('comment()[', $position, ']')"/>
               </xsl:when>
               <xsl:when test=". instance of text()">
                  <xsl:value-of select="concat('text()[', $position, ']')"/>
               </xsl:when>
               <xsl:otherwise/>
            </xsl:choose>
         </xsl:for-each>
      </xsl:variable>
      <xsl:value-of select="concat('/', string-join($segments, '/'))"/>
   </xsl:function>
</xsl:transform>
