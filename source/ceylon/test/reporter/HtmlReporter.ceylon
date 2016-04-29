import ceylon.collection {
    ArrayList,
    HashMap
}
import ceylon.language.meta.declaration {
    Module
}
import ceylon.test {
    TestResult,
    TestRunResult,
    TestDescription,
    TestListener,
    TestState
}
import ceylon.test.event {
    TestRunFinishedEvent
}
import ceylon.test.engine.internal {
    FileWriter
}

import java.text {
    NumberFormat
}

"A [[TestListener]] that generate simple HTML report about test execution."
shared class HtmlReporter(String reportSubdir) satisfies TestListener {
    
    shared actual void testRunFinished(TestRunFinishedEvent event) {
        generate(event.runner.description, event.result);
    }
    
    void generate(TestDescription root, TestRunResult result) {
        value testedModules = findTestedModules(result);
        
        String path;
        if( testedModules.size == 1 ) {
            assert(exists testedModule = testedModules[0]);
            path = "reports/``reportSubdir``/results-``testedModule.name``-``testedModule.version``.html";
        } else {
            path = "reports/``reportSubdir``/results.html";
        }
        try (fw = FileWriter(path)) {
            fw.write("<!DOCTYPE html>");
            fw.write("<html>");
            generateHead(fw);
            fw.write("<body>");
            generateBanner(fw, result);
            generateSummary(fw, result);
            generateResultsTable(fw, root, result);
            fw.write("</body>");
            generateScript(fw);
            fw.write("</html>");
        }
    }
    
    void generateHead(FileWriter fw) {
        fw.write("<head>
                  <meta charset='UTF-8'>
                  <title>Results</title>
                 ");
        generateCss(fw);
        fw.write("</head>");
    }
    
    void generateCss(FileWriter fw) {
        value resultsCss = `module`.resourceByPath("results.css");
        assert(exists resultsCss);
        
        fw.write("<style type='text/css'>");
        fw.write(resultsCss.textContent());
        fw.write("</style>");
    }
    
    void generateBanner(FileWriter fw, TestRunResult result) {
        if( result.isSuccess ) {
            fw.write("<div class='banner success'>Success</div>");
        } else {
            fw.write("<div class='banner failed'>Failed</div>");
        }
    }
    
    void generateSummary(FileWriter fw, TestRunResult result) {
        fw.write("
                  <table class='summary'>
                      <tbody>
                          <tr>
                              <td class='value total'>``result.runCount``</td>
                              <td class='value succeeded'>``result.successCount``</td>
                              <td class='value failures'>``result.failureCount``</td>
                              <td class='value errors'>``result.errorCount``</td>
                              <td class='value skipped'>``result.skippedCount``</td>
                              <td class='value aborted'>``result.abortedCount``</td>
                              <td class='value time'>``escapeHtml(formatTime(result.elapsedTime))``<span class='label'>sec</span></td>
                          </tr>
                          <tr>
                              <td class='label'>Total</td>
                              <td class='label'>Succeeded</td>
                              <td class='label'>Failures</td>
                              <td class='label'>Errors</td>
                              <td class='label'>Skipped</td>
                              <td class='label'>Aborted</td>
                              <td class='label'>Time</td>
                          </tr>
                      </tbody>
                  </table>
                  ");
    }
    
    void generateResultsTable(FileWriter fw, TestDescription root, TestRunResult result) {
        fw.write("
                  <table class='results'>
                      <thead>
                          <tr>
                              <th>Tests</th>
                          </tr>
                      </thead>
                      <tbody>
                  ");
        
        void traverseTests(TestDescription d, Integer depth) {
            for( child in d.children ) {
                value r = result.results.find((TestResult r) => r.description == child);
                if( exists r ) {
                    generateResultRow(fw, d, r, depth);
                    
                    if( r.description.children.empty ) {
                        result.results
                                .select((v) => v.description.children.empty &&
                                               v.description.name == r.description.name &&
                                               v.description.variant exists &&
                                               v.description.variantIndex exists)
                                .each((v) => generateResultRow(fw, r.description, v, depth+1));
                    }
                }
                
                traverseTests(child, depth+1);
            }
        }
        
        traverseTests(root, 0);
        
        fw.write("
                      </tbody>
                  </table>
                 ");
    }
    
    void generateResultRow(FileWriter fw, TestDescription parent, TestResult result, Integer depth) {
        value expandableFlag = result.exception exists;
        value expandableSnippet = " expandable' onclick='toggleStackTrace(event)' title='Show/Hide more details'>";
        
        switch(result.state)
            case (TestState.success) {
                fw.write("<tr class='success'>");
                fw.write("<td>");
                fw.write("<i class='icon success'></i>");
            }
            case(TestState.error | TestState.failure) {
                fw.write("<tr class='failure``expandableFlag then expandableSnippet else "'>"``");
                fw.write("<td>");
                fw.write("<i class='icon failure'></i>");
            }
            case(TestState.skipped) {
                fw.write("<tr class='skipped``expandableFlag then expandableSnippet else "'>"``");
                fw.write("<td>");
                fw.write("<i class='icon skipped'></i>");
            }
            case(TestState.aborted) {
                fw.write("<tr class='aborted``expandableFlag then expandableSnippet else "'>"``");
                fw.write("<td>");
                fw.write("<i class='icon aborted'></i>");
            }

        String name;
        if( exists variant = result.description.variant,
            exists variantIndex = result.description.variantIndex) {
            name = "#``variantIndex`` ``variant``";
        }
        else if( result.description.name.startsWith(parent.name) ) {
            name = result.description.name.replaceFirst(parent.name+".", "");
        }
        else {
            name = result.description.name;
        }
        
        if( depth > 0 ) {
            for(i in 1..depth ) {
                fw.write("<span class='indent'></span>");
            }
        }
        
        fw.write("<span class='name``result.description.children.empty then "" else " suite"``' title='``escapeHtml(result.description.name)``'>``escapeHtml(name)``</span>");
        fw.write("<span class='duration'>``escapeHtml(formatTime(result.elapsedTime))``s</span>");
        
        if( exists e = result.exception ) {
            fw.write("<div class='stack-trace' style='display: none;'>");
            fw.write("<span class='stack-trace-arrow'><span class='stack-trace-arrow-inner'></span></span>");
            fw.write("<pre>");
            printStackTrace(e, (s) { fw.write(escapeHtml(s)); });
            fw.write("</pre>");
            fw.write("</div>");
        }
        
        fw.write("</td>");
        fw.write("</tr>");
        fw.write(operatingSystem.newline);
    }
                    
    void generateScript(FileWriter fw) {
        fw.write(
            """
               <script type='text/javascript'>
                   function toggleStackTrace(e) {
                       var st = e.currentTarget.getElementsByClassName('stack-trace')[0];
                       if (st.style.display == 'none') {
                           st.style.display = '';
                       } else {
                           st.style.display = 'none';
                       }
                   }
               </script>
            """);
    }
    
    List<Module> findTestedModules(TestRunResult result) {
        value testedModules = ArrayList<Module>();
        for(r in result.results) {
            if( exists m = r.description.functionDeclaration?.containingModule ) {
                if( !testedModules.contains(m) ) {
                    testedModules.add(m);
                }
            }
        }
        return testedModules;
    }
    
    native
    String formatTime(Integer timeInMilliseconds);
    
    native("js")
    String formatTime(Integer timeInMilliseconds) {
        dynamic {
            dynamic t = timeInMilliseconds/1000.0;
            return t.toFixed(3);
        }
    }
    
    native("jvm")
    String formatTime(Integer timeInMilliseconds) {
        NumberFormat timeFormat = NumberFormat.numberInstance;
        timeFormat.groupingUsed = true;
        timeFormat.minimumFractionDigits = 3;
        timeFormat.maximumFractionDigits = 3;
        timeFormat.minimumIntegerDigits = 1;
        
        return timeFormat.format(timeInMilliseconds/1000.0);
    }
    
}

Map<Character, String> htmlEntitiesMap = createHtmlEntitiesMap();

Map<Character, String> createHtmlEntitiesMap() {
    value htmlEntitiesMap = HashMap<Character, String>();
    
    htmlEntitiesMap.put('\"', "&quot;"); // " - double-quote
    htmlEntitiesMap.put('&', "&amp;"); // & - ampersand
    htmlEntitiesMap.put('<', "&lt;"); // < - less-than
    htmlEntitiesMap.put('>', "&gt;"); // > - greater-than
    
    htmlEntitiesMap.put('\{#00A0}', "&nbsp;"); // non-breaking space
    htmlEntitiesMap.put('\{#00A1}', "&iexcl;"); // inverted exclamation mark
    htmlEntitiesMap.put('\{#00A2}', "&cent;"); // cent sign
    htmlEntitiesMap.put('\{#00A3}', "&pound;"); // pound sign
    htmlEntitiesMap.put('\{#00A4}', "&curren;"); // currency sign
    htmlEntitiesMap.put('\{#00A5}', "&yen;"); // yen sign = yuan sign
    htmlEntitiesMap.put('\{#00A6}', "&brvbar;"); // broken bar = broken vertical bar
    htmlEntitiesMap.put('\{#00A7}', "&sect;"); // section sign
    htmlEntitiesMap.put('\{#00A8}', "&uml;"); // diaeresis = spacing diaeresis
    htmlEntitiesMap.put('\{#00A9}', "&copy;"); // © - copyright sign
    htmlEntitiesMap.put('\{#00AA}', "&ordf;"); // feminine ordinal indicator
    htmlEntitiesMap.put('\{#00AB}', "&laquo;"); // left-pointing double angle quotation mark = left pointing guillemet
    htmlEntitiesMap.put('\{#00AC}', "&not;"); // not sign
    htmlEntitiesMap.put('\{#00AD}', "&shy;"); // soft hyphen = discretionary hyphen
    htmlEntitiesMap.put('\{#00AE}', "&reg;"); // ® - registered trademark sign
    htmlEntitiesMap.put('\{#00AF}', "&macr;"); // macron = spacing macron = overline = APL overbar
    htmlEntitiesMap.put('\{#00B0}', "&deg;"); // degree sign
    htmlEntitiesMap.put('\{#00B1}', "&plusmn;"); // plus-minus sign = plus-or-minus sign
    htmlEntitiesMap.put('\{#00B2}', "&sup2;"); // superscript two = superscript digit two = squared
    htmlEntitiesMap.put('\{#00B3}', "&sup3;"); // superscript three = superscript digit three = cubed
    htmlEntitiesMap.put('\{#00B4}', "&acute;"); // acute accent = spacing acute
    htmlEntitiesMap.put('\{#00B5}', "&micro;"); // micro sign
    htmlEntitiesMap.put('\{#00B6}', "&para;"); // pilcrow sign = paragraph sign
    htmlEntitiesMap.put('\{#00B7}', "&middot;"); // middle dot = Georgian comma = Greek middle dot
    htmlEntitiesMap.put('\{#00B8}', "&cedil;"); // cedilla = spacing cedilla
    htmlEntitiesMap.put('\{#00B9}', "&sup1;"); // superscript one = superscript digit one
    htmlEntitiesMap.put('\{#00BA}', "&ordm;"); // masculine ordinal indicator
    htmlEntitiesMap.put('\{#00BB}', "&raquo;"); // right-pointing double angle quotation mark = right pointing guillemet
    htmlEntitiesMap.put('\{#00BC}', "&frac14;"); // vulgar fraction one quarter = fraction one quarter
    htmlEntitiesMap.put('\{#00BD}', "&frac12;"); // vulgar fraction one half = fraction one half
    htmlEntitiesMap.put('\{#00BE}', "&frac34;"); // vulgar fraction three quarters = fraction three quarters
    htmlEntitiesMap.put('\{#00BF}', "&iquest;"); // inverted question mark = turned question mark
    htmlEntitiesMap.put('\{#00C0}', "&Agrave;"); // À - uppercase A, grave accent
    htmlEntitiesMap.put('\{#00C1}', "&Aacute;"); // Á - uppercase A, acute accent
    htmlEntitiesMap.put('\{#00C2}', "&Acirc;"); // Â - uppercase A, circumflex accent
    htmlEntitiesMap.put('\{#00C3}', "&Atilde;"); // Ã - uppercase A, tilde
    htmlEntitiesMap.put('\{#00C4}', "&Auml;"); // Ä - uppercase A, umlaut
    htmlEntitiesMap.put('\{#00C5}', "&Aring;"); // Å - uppercase A, ring
    htmlEntitiesMap.put('\{#00C6}', "&AElig;"); // Æ - uppercase AE
    htmlEntitiesMap.put('\{#00C7}', "&Ccedil;"); // Ç - uppercase C, cedilla
    htmlEntitiesMap.put('\{#00C8}', "&Egrave;"); // È - uppercase E, grave accent
    htmlEntitiesMap.put('\{#00C9}', "&Eacute;"); // É - uppercase E, acute accent
    htmlEntitiesMap.put('\{#00CA}', "&Ecirc;"); // Ê - uppercase E, circumflex accent
    htmlEntitiesMap.put('\{#00CB}', "&Euml;"); // Ë - uppercase E, umlaut
    htmlEntitiesMap.put('\{#00CC}', "&Igrave;"); // Ì - uppercase I, grave accent
    htmlEntitiesMap.put('\{#00CD}', "&Iacute;"); // Í - uppercase I, acute accent
    htmlEntitiesMap.put('\{#00CE}', "&Icirc;"); // Î - uppercase I, circumflex accent
    htmlEntitiesMap.put('\{#00CF}', "&Iuml;"); // Ï - uppercase I, umlaut
    htmlEntitiesMap.put('\{#00D0}', "&ETH;"); // Ð - uppercase Eth, Icelandic
    htmlEntitiesMap.put('\{#00D1}', "&Ntilde;"); // Ñ - uppercase N, tilde
    htmlEntitiesMap.put('\{#00D2}', "&Ograve;"); // Ò - uppercase O, grave accent
    htmlEntitiesMap.put('\{#00D3}', "&Oacute;"); // Ó - uppercase O, acute accent
    htmlEntitiesMap.put('\{#00D4}', "&Ocirc;"); // Ô - uppercase O, circumflex accent
    htmlEntitiesMap.put('\{#00D5}', "&Otilde;"); // Õ - uppercase O, tilde
    htmlEntitiesMap.put('\{#00D6}', "&Ouml;"); // Ö - uppercase O, umlaut
    htmlEntitiesMap.put('\{#00D7}', "&times;"); // multiplication sign
    htmlEntitiesMap.put('\{#00D8}', "&Oslash;"); // Ø - uppercase O, slash
    htmlEntitiesMap.put('\{#00D9}', "&Ugrave;"); // Ù - uppercase U, grave accent
    htmlEntitiesMap.put('\{#00DA}', "&Uacute;"); // Ú - uppercase U, acute accent
    htmlEntitiesMap.put('\{#00DB}', "&Ucirc;"); // Û - uppercase U, circumflex accent
    htmlEntitiesMap.put('\{#00DC}', "&Uuml;"); // Ü - uppercase U, umlaut
    htmlEntitiesMap.put('\{#00DD}', "&Yacute;"); // Ý - uppercase Y, acute accent
    htmlEntitiesMap.put('\{#00DE}', "&THORN;"); // Þ - uppercase THORN, Icelandic
    htmlEntitiesMap.put('\{#00DF}', "&szlig;"); // ß - lowercase sharps, German
    htmlEntitiesMap.put('\{#00E0}', "&agrave;"); // à - lowercase a, grave accent
    htmlEntitiesMap.put('\{#00E1}', "&aacute;"); // á - lowercase a, acute accent
    htmlEntitiesMap.put('\{#00E2}', "&acirc;"); // â - lowercase a, circumflex accent
    htmlEntitiesMap.put('\{#00E3}', "&atilde;"); // ã - lowercase a, tilde
    htmlEntitiesMap.put('\{#00E4}', "&auml;"); // ä - lowercase a, umlaut
    htmlEntitiesMap.put('\{#00E5}', "&aring;"); // å - lowercase a, ring
    htmlEntitiesMap.put('\{#00E6}', "&aelig;"); // æ - lowercase ae
    htmlEntitiesMap.put('\{#00E7}', "&ccedil;"); // ç - lowercase c, cedilla
    htmlEntitiesMap.put('\{#00E8}', "&egrave;"); // è - lowercase e, grave accent
    htmlEntitiesMap.put('\{#00E9}', "&eacute;"); // é - lowercase e, acute accent
    htmlEntitiesMap.put('\{#00EA}', "&ecirc;"); // ê - lowercase e, circumflex accent
    htmlEntitiesMap.put('\{#00EB}', "&euml;"); // ë - lowercase e, umlaut
    htmlEntitiesMap.put('\{#00EC}', "&igrave;"); // ì - lowercase i, grave accent
    htmlEntitiesMap.put('\{#00ED}', "&iacute;"); // í - lowercase i, acute accent
    htmlEntitiesMap.put('\{#00EE}', "&icirc;"); // î - lowercase i, circumflex accent
    htmlEntitiesMap.put('\{#00EF}', "&iuml;"); // ï - lowercase i, umlaut
    htmlEntitiesMap.put('\{#00F0}', "&eth;"); // ð - lowercase eth, Icelandic
    htmlEntitiesMap.put('\{#00F1}', "&ntilde;"); // ñ - lowercase n, tilde
    htmlEntitiesMap.put('\{#00F2}', "&ograve;"); // ò - lowercase o, grave accent
    htmlEntitiesMap.put('\{#00F3}', "&oacute;"); // ó - lowercase o, acute accent
    htmlEntitiesMap.put('\{#00F4}', "&ocirc;"); // ô - lowercase o, circumflex accent
    htmlEntitiesMap.put('\{#00F5}', "&otilde;"); // õ - lowercase o, tilde
    htmlEntitiesMap.put('\{#00F6}', "&ouml;"); // ö - lowercase o, umlaut
    htmlEntitiesMap.put('\{#00F7}', "&divide;"); // division sign
    htmlEntitiesMap.put('\{#00F8}', "&oslash;"); // ø - lowercase o, slash
    htmlEntitiesMap.put('\{#00F9}', "&ugrave;"); // ù - lowercase u, grave accent
    htmlEntitiesMap.put('\{#00FA}', "&uacute;"); // ú - lowercase u, acute accent
    htmlEntitiesMap.put('\{#00FB}', "&ucirc;"); // û - lowercase u, circumflex accent
    htmlEntitiesMap.put('\{#00FC}', "&uuml;"); // ü - lowercase u, umlaut
    htmlEntitiesMap.put('\{#00FD}', "&yacute;"); // ý - lowercase y, acute accent
    htmlEntitiesMap.put('\{#00FE}', "&thorn;"); // þ - lowercase thorn, Icelandic
    htmlEntitiesMap.put('\{#00FF}', "&yuml;"); // ÿ - lowercase y, umlaut
    
    htmlEntitiesMap.put('\{#0192}', "&fnof;"); // latin small f with hook = function= florin, U+0192 ISOtech -->
    htmlEntitiesMap.put('\{#0391}', "&Alpha;"); // greek capital letter alpha, U+0391 -->
    htmlEntitiesMap.put('\{#0392}', "&Beta;"); // greek capital letter beta, U+0392 -->
    htmlEntitiesMap.put('\{#0393}', "&Gamma;"); // greek capital letter gamma,U+0393 ISOgrk3 -->
    htmlEntitiesMap.put('\{#0394}', "&Delta;"); // greek capital letter delta,U+0394 ISOgrk3 -->
    htmlEntitiesMap.put('\{#0395}', "&Epsilon;"); // greek capital letter epsilon, U+0395 -->
    htmlEntitiesMap.put('\{#0396}', "&Zeta;"); // greek capital letter zeta, U+0396 -->
    htmlEntitiesMap.put('\{#0397}', "&Eta;"); // greek capital letter eta, U+0397 -->
    htmlEntitiesMap.put('\{#0398}', "&Theta;"); // greek capital letter theta,U+0398 ISOgrk3 -->
    htmlEntitiesMap.put('\{#0399}', "&Iota;"); // greek capital letter iota, U+0399 -->
    htmlEntitiesMap.put('\{#039A}', "&Kappa;"); // greek capital letter kappa, U+039A -->
    htmlEntitiesMap.put('\{#039B}', "&Lambda;"); // greek capital letter lambda,U+039B ISOgrk3 -->
    htmlEntitiesMap.put('\{#039C}', "&Mu;"); // greek capital letter mu, U+039C -->
    htmlEntitiesMap.put('\{#039D}', "&Nu;"); // greek capital letter nu, U+039D -->
    htmlEntitiesMap.put('\{#039E}', "&Xi;"); // greek capital letter xi, U+039E ISOgrk3 -->
    htmlEntitiesMap.put('\{#039F}', "&Omicron;"); // greek capital letter omicron, U+039F -->
    htmlEntitiesMap.put('\{#03A0}', "&Pi;"); // greek capital letter pi, U+03A0 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03A1}', "&Rho;"); // greek capital letter rho, U+03A1 -->
    htmlEntitiesMap.put('\{#03A3}', "&Sigma;"); // greek capital letter sigma,U+03A3 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03A4}', "&Tau;"); // greek capital letter tau, U+03A4 -->
    htmlEntitiesMap.put('\{#03A5}', "&Upsilon;"); // greek capital letter upsilon,U+03A5 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03A6}', "&Phi;"); // greek capital letter phi,U+03A6 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03A7}', "&Chi;"); // greek capital letter chi, U+03A7 -->
    htmlEntitiesMap.put('\{#03A8}', "&Psi;"); // greek capital letter psi,U+03A8 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03A9}', "&Omega;"); // greek capital letter omega,U+03A9 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B1}', "&alpha;"); // greek small letter alpha,U+03B1 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B2}', "&beta;"); // greek small letter beta, U+03B2 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B3}', "&gamma;"); // greek small letter gamma,U+03B3 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B4}', "&delta;"); // greek small letter delta,U+03B4 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B5}', "&epsilon;"); // greek small letter epsilon,U+03B5 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B6}', "&zeta;"); // greek small letter zeta, U+03B6 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B7}', "&eta;"); // greek small letter eta, U+03B7 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B8}', "&theta;"); // greek small letter theta,U+03B8 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03B9}', "&iota;"); // greek small letter iota, U+03B9 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03BA}', "&kappa;"); // greek small letter kappa,U+03BA ISOgrk3 -->
    htmlEntitiesMap.put('\{#03BB}', "&lambda;"); // greek small letter lambda,U+03BB ISOgrk3 -->
    htmlEntitiesMap.put('\{#03BC}', "&mu;"); // greek small letter mu, U+03BC ISOgrk3 -->
    htmlEntitiesMap.put('\{#03BD}', "&nu;"); // greek small letter nu, U+03BD ISOgrk3 -->
    htmlEntitiesMap.put('\{#03BE}', "&xi;"); // greek small letter xi, U+03BE ISOgrk3 -->
    htmlEntitiesMap.put('\{#03BF}', "&omicron;"); // greek small letter omicron, U+03BF NEW -->
    htmlEntitiesMap.put('\{#03C0}', "&pi;"); // greek small letter pi, U+03C0 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C1}', "&rho;"); // greek small letter rho, U+03C1 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C2}', "&sigmaf;"); // greek small letter final sigma,U+03C2 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C3}', "&sigma;"); // greek small letter sigma,U+03C3 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C4}', "&tau;"); // greek small letter tau, U+03C4 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C5}', "&upsilon;"); // greek small letter upsilon,U+03C5 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C6}', "&phi;"); // greek small letter phi, U+03C6 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C7}', "&chi;"); // greek small letter chi, U+03C7 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C8}', "&psi;"); // greek small letter psi, U+03C8 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03C9}', "&omega;"); // greek small letter omega,U+03C9 ISOgrk3 -->
    htmlEntitiesMap.put('\{#03D1}', "&thetasym;"); // greek small letter theta symbol,U+03D1 NEW -->
    htmlEntitiesMap.put('\{#03D2}', "&upsih;"); // greek upsilon with hook symbol,U+03D2 NEW -->
    htmlEntitiesMap.put('\{#03D6}', "&piv;"); // greek pi symbol, U+03D6 ISOgrk3 -->
    htmlEntitiesMap.put('\{#2022}', "&bull;"); // bullet = black small circle,U+2022 ISOpub -->
    htmlEntitiesMap.put('\{#2026}', "&hellip;"); // horizontal ellipsis = three dot leader,U+2026 ISOpub -->
    htmlEntitiesMap.put('\{#2032}', "&prime;"); // prime = minutes = feet, U+2032 ISOtech -->
    htmlEntitiesMap.put('\{#2033}', "&Prime;"); // double prime = seconds = inches,U+2033 ISOtech -->
    htmlEntitiesMap.put('\{#203E}', "&oline;"); // overline = spacing overscore,U+203E NEW -->
    htmlEntitiesMap.put('\{#2044}', "&frasl;"); // fraction slash, U+2044 NEW -->
    htmlEntitiesMap.put('\{#2118}', "&weierp;"); // script capital P = power set= Weierstrass p, U+2118 ISOamso -->
    htmlEntitiesMap.put('\{#2111}', "&image;"); // blackletter capital I = imaginary part,U+2111 ISOamso -->
    htmlEntitiesMap.put('\{#211C}', "&real;"); // blackletter capital R = real part symbol,U+211C ISOamso -->
    htmlEntitiesMap.put('\{#2122}', "&trade;"); // trade mark sign, U+2122 ISOnum -->
    htmlEntitiesMap.put('\{#2135}', "&alefsym;"); // alef symbol = first transfinite cardinal,U+2135 NEW -->
    htmlEntitiesMap.put('\{#2190}', "&larr;"); // leftwards arrow, U+2190 ISOnum -->
    htmlEntitiesMap.put('\{#2191}', "&uarr;"); // upwards arrow, U+2191 ISOnum-->
    htmlEntitiesMap.put('\{#2192}', "&rarr;"); // rightwards arrow, U+2192 ISOnum -->
    htmlEntitiesMap.put('\{#2193}', "&darr;"); // downwards arrow, U+2193 ISOnum -->
    htmlEntitiesMap.put('\{#2194}', "&harr;"); // left right arrow, U+2194 ISOamsa -->
    htmlEntitiesMap.put('\{#21B5}', "&crarr;"); // downwards arrow with corner leftwards= carriage return, U+21B5 NEW -->
    htmlEntitiesMap.put('\{#21D0}', "&lArr;"); // leftwards double arrow, U+21D0 ISOtech -->
    htmlEntitiesMap.put('\{#21D1}', "&uArr;"); // upwards double arrow, U+21D1 ISOamsa -->
    htmlEntitiesMap.put('\{#21D2}', "&rArr;"); // rightwards double arrow,U+21D2 ISOtech -->
    htmlEntitiesMap.put('\{#21D3}', "&dArr;"); // downwards double arrow, U+21D3 ISOamsa -->
    htmlEntitiesMap.put('\{#21D4}', "&hArr;"); // left right double arrow,U+21D4 ISOamsa -->
    htmlEntitiesMap.put('\{#2200}', "&forall;"); // for all, U+2200 ISOtech -->
    htmlEntitiesMap.put('\{#2202}', "&part;"); // partial differential, U+2202 ISOtech -->
    htmlEntitiesMap.put('\{#2203}', "&exist;"); // there exists, U+2203 ISOtech -->
    htmlEntitiesMap.put('\{#2205}', "&empty;"); // empty set = null set = diameter,U+2205 ISOamso -->
    htmlEntitiesMap.put('\{#2207}', "&nabla;"); // nabla = backward difference,U+2207 ISOtech -->
    htmlEntitiesMap.put('\{#2208}', "&isin;"); // element of, U+2208 ISOtech -->
    htmlEntitiesMap.put('\{#2209}', "&notin;"); // not an element of, U+2209 ISOtech -->
    htmlEntitiesMap.put('\{#220B}', "&ni;"); // contains as member, U+220B ISOtech -->
    htmlEntitiesMap.put('\{#220F}', "&prod;"); // n-ary product = product sign,U+220F ISOamsb -->
    htmlEntitiesMap.put('\{#2211}', "&sum;"); // n-ary summation, U+2211 ISOamsb -->
    htmlEntitiesMap.put('\{#2212}', "&minus;"); // minus sign, U+2212 ISOtech -->
    htmlEntitiesMap.put('\{#2217}', "&lowast;"); // asterisk operator, U+2217 ISOtech -->
    htmlEntitiesMap.put('\{#221A}', "&radic;"); // square root = radical sign,U+221A ISOtech -->
    htmlEntitiesMap.put('\{#221D}', "&prop;"); // proportional to, U+221D ISOtech -->
    htmlEntitiesMap.put('\{#221E}', "&infin;"); // infinity, U+221E ISOtech -->
    htmlEntitiesMap.put('\{#2220}', "&ang;"); // angle, U+2220 ISOamso -->
    htmlEntitiesMap.put('\{#2227}', "&and;"); // logical and = wedge, U+2227 ISOtech -->
    htmlEntitiesMap.put('\{#2228}', "&or;"); // logical or = vee, U+2228 ISOtech -->
    htmlEntitiesMap.put('\{#2229}', "&cap;"); // intersection = cap, U+2229 ISOtech -->
    htmlEntitiesMap.put('\{#222A}', "&cup;"); // union = cup, U+222A ISOtech -->
    htmlEntitiesMap.put('\{#222B}', "&int;"); // integral, U+222B ISOtech -->
    htmlEntitiesMap.put('\{#2234}', "&there4;"); // therefore, U+2234 ISOtech -->
    htmlEntitiesMap.put('\{#223C}', "&sim;"); // tilde operator = varies with = similar to,U+223C ISOtech -->
    htmlEntitiesMap.put('\{#2245}', "&cong;"); // approximately equal to, U+2245 ISOtech -->
    htmlEntitiesMap.put('\{#2248}', "&asymp;"); // almost equal to = asymptotic to,U+2248 ISOamsr -->
    htmlEntitiesMap.put('\{#2260}', "&ne;"); // not equal to, U+2260 ISOtech -->
    htmlEntitiesMap.put('\{#2261}', "&equiv;"); // identical to, U+2261 ISOtech -->
    htmlEntitiesMap.put('\{#2264}', "&le;"); // less-than or equal to, U+2264 ISOtech -->
    htmlEntitiesMap.put('\{#2265}', "&ge;"); // greater-than or equal to,U+2265 ISOtech -->
    htmlEntitiesMap.put('\{#2282}', "&sub;"); // subset of, U+2282 ISOtech -->
    htmlEntitiesMap.put('\{#2283}', "&sup;"); // superset of, U+2283 ISOtech -->
    htmlEntitiesMap.put('\{#2286}', "&sube;"); // subset of or equal to, U+2286 ISOtech -->
    htmlEntitiesMap.put('\{#2287}', "&supe;"); // superset of or equal to,U+2287 ISOtech -->
    htmlEntitiesMap.put('\{#2295}', "&oplus;"); // circled plus = direct sum,U+2295 ISOamsb -->
    htmlEntitiesMap.put('\{#2297}', "&otimes;"); // circled times = vector product,U+2297 ISOamsb -->
    htmlEntitiesMap.put('\{#22A5}', "&perp;"); // up tack = orthogonal to = perpendicular,U+22A5 ISOtech -->
    htmlEntitiesMap.put('\{#22C5}', "&sdot;"); // dot operator, U+22C5 ISOamsb -->
    htmlEntitiesMap.put('\{#2308}', "&lceil;"); // left ceiling = apl upstile,U+2308 ISOamsc -->
    htmlEntitiesMap.put('\{#2309}', "&rceil;"); // right ceiling, U+2309 ISOamsc -->
    htmlEntitiesMap.put('\{#230A}', "&lfloor;"); // left floor = apl downstile,U+230A ISOamsc -->
    htmlEntitiesMap.put('\{#230B}', "&rfloor;"); // right floor, U+230B ISOamsc -->
    htmlEntitiesMap.put('\{#2329}', "&lang;"); // left-pointing angle bracket = bra,U+2329 ISOtech -->
    htmlEntitiesMap.put('\{#232A}', "&rang;"); // right-pointing angle bracket = ket,U+232A ISOtech -->
    htmlEntitiesMap.put('\{#25CA}', "&loz;"); // lozenge, U+25CA ISOpub -->
    htmlEntitiesMap.put('\{#2660}', "&spades;"); // black spade suit, U+2660 ISOpub -->
    htmlEntitiesMap.put('\{#2663}', "&clubs;"); // black club suit = shamrock,U+2663 ISOpub -->
    htmlEntitiesMap.put('\{#2665}', "&hearts;"); // black heart suit = valentine,U+2665 ISOpub -->
    htmlEntitiesMap.put('\{#2666}', "&diams;"); // black diamond suit, U+2666 ISOpub -->
    htmlEntitiesMap.put('\{#0152}', "&OElig;"); // -- latin capital ligature OE,U+0152 ISOlat2 -->
    htmlEntitiesMap.put('\{#0153}', "&oelig;"); // -- latin small ligature oe, U+0153 ISOlat2 -->
    htmlEntitiesMap.put('\{#0160}', "&Scaron;"); // -- latin capital letter S with caron,U+0160 ISOlat2 -->
    htmlEntitiesMap.put('\{#0161}', "&scaron;"); // -- latin small letter s with caron,U+0161 ISOlat2 -->
    htmlEntitiesMap.put('\{#0178}', "&Yuml;"); // -- latin capital letter Y with diaeresis,U+0178 ISOlat2 -->
    htmlEntitiesMap.put('\{#02C6}', "&circ;"); // -- modifier letter circumflex accent,U+02C6 ISOpub -->
    htmlEntitiesMap.put('\{#02DC}', "&tilde;"); // small tilde, U+02DC ISOdia -->
    htmlEntitiesMap.put('\{#2002}', "&ensp;"); // en space, U+2002 ISOpub -->
    htmlEntitiesMap.put('\{#2003}', "&emsp;"); // em space, U+2003 ISOpub -->
    htmlEntitiesMap.put('\{#2009}', "&thinsp;"); // thin space, U+2009 ISOpub -->
    htmlEntitiesMap.put('\{#200C}', "&zwnj;"); // zero width non-joiner,U+200C NEW RFC 2070 -->
    htmlEntitiesMap.put('\{#200D}', "&zwj;"); // zero width joiner, U+200D NEW RFC 2070 -->
    htmlEntitiesMap.put('\{#200E}', "&lrm;"); // left-to-right mark, U+200E NEW RFC 2070 -->
    htmlEntitiesMap.put('\{#200F}', "&rlm;"); // right-to-left mark, U+200F NEW RFC 2070 -->
    htmlEntitiesMap.put('\{#2013}', "&ndash;"); // en dash, U+2013 ISOpub -->
    htmlEntitiesMap.put('\{#2014}', "&mdash;"); // em dash, U+2014 ISOpub -->
    htmlEntitiesMap.put('\{#2018}', "&lsquo;"); // left single quotation mark,U+2018 ISOnum -->
    htmlEntitiesMap.put('\{#2019}', "&rsquo;"); // right single quotation mark,U+2019 ISOnum -->
    htmlEntitiesMap.put('\{#201A}', "&sbquo;"); // single low-9 quotation mark, U+201A NEW -->
    htmlEntitiesMap.put('\{#201C}', "&ldquo;"); // left double quotation mark,U+201C ISOnum -->
    htmlEntitiesMap.put('\{#201D}', "&rdquo;"); // right double quotation mark,U+201D ISOnum -->
    htmlEntitiesMap.put('\{#201E}', "&bdquo;"); // double low-9 quotation mark, U+201E NEW -->
    htmlEntitiesMap.put('\{#2020}', "&dagger;"); // dagger, U+2020 ISOpub -->
    htmlEntitiesMap.put('\{#2021}', "&Dagger;"); // double dagger, U+2021 ISOpub -->
    htmlEntitiesMap.put('\{#2030}', "&permil;"); // per mille sign, U+2030 ISOtech -->
    htmlEntitiesMap.put('\{#2039}', "&lsaquo;"); // single left-pointing angle quotation mark,U+2039 ISO proposed -->
    htmlEntitiesMap.put('\{#203A}', "&rsaquo;"); // single right-pointing angle quotation mark,U+203A ISO proposed -->
    htmlEntitiesMap.put('\{#20AC}', "&euro;"); // -- euro sign, U+20AC NEW -->
    
    return htmlEntitiesMap;
}

String escapeHtml(String s) {
    value sb = StringBuilder();
    for (c in s) {
        if( exists v = htmlEntitiesMap[c] ) {
            sb.append(v);
        } else {
            sb.appendCharacter(c);
        }
    }
    return sb.string;
}