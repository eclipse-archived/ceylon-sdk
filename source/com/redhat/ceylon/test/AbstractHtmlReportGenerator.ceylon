import ceylon.collection {
    ArrayList
}
import ceylon.language.meta.declaration {
    Module
}
import ceylon.test {
    success,
    error,
    failure,
    ignored,
    TestResult,
    TestRunResult,
    TestDescription
}

shared abstract class AbstractHtmlReportGenerator(String reportSubdir) {
    
    shared void generate(TestDescription root, TestRunResult result) {
        value testedModules = findTestedModules(result);
        
        FileWriter fw;
        if( testedModules.size == 1 ) {
            assert(exists testedModule = testedModules[0]);
            fw = createFile("reports/``reportSubdir``/results-``testedModule.name``-``testedModule.version``.html");
        } else {
            fw = createFile("reports/``reportSubdir``/results.html");
        }
        
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
        fw.close();
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
        fw.write("""<style type='text/css'>
                    body {
                        font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
                        font-size: 14px;
                        line-height: 24px;
                        margin-left: 15%;
                        margin-right: 15%;
                    }
                    
                    .banner {
                        font-size: 32px;
                        font-weight: bold;
                        text-align: center;
                        text-transform: uppercase;
                        padding: 14px 0px;
                    }
                    .banner.success {
                        color: rgb(60, 118, 61);
                        border: 1px solid rgb(60, 118, 61);
                        background-color: rgb(223, 240, 216);
                    }
                    .banner.failed {
                        color: rgb(169, 68, 66);
                        border: 1px solid rgb(169, 68, 66);
                        background-color: rgb(242, 222, 222);
                    }
                    
                    .summary {
                        padding: 30px 0px;
                        width: 100%;
                        text-align: center;
                    }
                    .summary .label {
                        font-size: 14px;
                        font-weight: normal;
                        color: rgb(119, 119, 119);
                    }
                    .summary .value {
                        width: 16%;
                        font-size: 36px;
                        font-weight: bold;
                    }
                    .summary .total {
                        color: rgb(51, 51, 51);
                    }
                    .summary .succeeded {
                        color: rgb(60, 118, 61);
                    }
                    .summary .failures {
                        color: rgb(169, 68, 66);
                    }
                    .summary .errors {
                       color: rgb(169, 68, 66);
                    }
                    .summary .ignored {
                        color: rgb(119, 119, 119);
                    }
                    .summary .time {
                       color: rgb(51, 51, 51);
                    }
                    
                    .results {
                        border-spacing: 0px;
                        border-collapse: collapse;
                        width: 100%;
                    }
                    .results thead th {
                        border: 1px solid rgb(240, 240, 240);
                        background-color: rgb(245, 245, 245);
                        text-align: left;
                        padding: 4px 4px;
                    }
                    .results td {
                        border: 1px solid rgb(240, 240, 240);
                        vertical-align: top;
                    }
                    .results .suite {
                      font-weight: bold;
                    }
                    .results .success {
                        color: rgb(51, 51, 51);
                    }
                    .results .failure {
                        color: rgb(169, 68, 66);
                    }
                    .results .ignored {
                        color: rgb(119, 119, 119);
                    }
                    .results .expandable {
                        cursor: pointer;
                    }
                    .results .duration {
                        float: right;
                        padding: 0px 4px;
                    }
                    
                    .stack-trace {
                        font-family: Menlo, Monaco, Consolas, 'Courier New', monospace;
                        font-size: 13px;
                        color: rgb(51, 51, 51);
                        margin-top: 10px;
                        padding-left: 10px;
                    }
                    .stack-trace pre {
                        margin: 0;
                    }
                    .stack-trace-arrow {
                        display: block;
                        position: relative;
                        left: 30px;
                        top: -10px;
                        width: 0;
                        height: 0;
                        border-left: 10px solid transparent;
                        border-right: 10px solid transparent;    
                    }
                    .stack-trace-arrow-inner {
                        display: block;
                        position: relative;
                        left: -10px;
                        top: 1px;
                        border-left: 10px solid transparent;
                        border-right: 10px solid transparent;    
                    }
                    .failure .stack-trace {
                        background-color: rgb(242, 222, 222);
                        border-top: 1px solid rgb(169, 68, 66);
                    }
                    .failure .stack-trace-arrow {
                        border-bottom: 10px solid rgb(169, 68, 66);
                    }
                    .failure .stack-trace-arrow-inner {
                        border-bottom: 10px solid rgb(242, 222, 222);
                    }
                    .ignored .stack-trace {
                        background-color: rgb(245, 245, 245);
                        border-top: 1px solid rgb(240, 240, 240);
                    }
                    .ignored .stack-trace-arrow {
                        border-bottom: 10px solid rgb(240, 240, 240);
                    }
                    .ignored .stack-trace-arrow-inner {
                        border-bottom: 10px solid rgb(245, 245, 245);
                    }
                    
                    .icon {
                        font-weight: normal;
                        font-style: normal;
                        display: inline-block;
                        padding: 0px 4px;
                        width: 16px;
                    }
                    .icon.success:BEFORE {
                        content: '\2714';
                        color: rgb(60, 118, 61);
                    }
                    .icon.failure:BEFORE {
                        content: '\2716';
                        color: rgb(169, 68, 66);
                    }
                    .icon.ignored:BEFORE {
                        content: '\2753';
                        color: rgb(119, 119, 119);
                    }
                    
                    .indent {
                        padding-left: 20px;
                    }
                    
                    </style>
                 """);
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
                              <td class='value ignored'>``result.ignoreCount``</td>
                              <td class='value time'>``formatTime(result.elapsedTime)``<span class='label'>sec</span></td>
                          </tr>
                          <tr>
                              <td class='label'>Total</td>
                              <td class='label'>Succeeded</td>
                              <td class='label'>Failures</td>
                              <td class='label'>Errors</td>
                              <td class='label'>Ignored</td>
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
            case (success) {
                fw.write("<tr class='success'>");
                fw.write("<td>");
                fw.write("<i class='icon success'></i>");
            }
            case(error, failure) {
                fw.write("<tr class='failure``expandableFlag then expandableSnippet else "'>"``");
                fw.write("<td>");
                fw.write("<i class='icon failure'></i>");
            }
            case(ignored) {
                fw.write("<tr class='ignored``expandableFlag then expandableSnippet else "'>"``");
                fw.write("<td>");
                fw.write("<i class='icon ignored'></i>");
            }

        String name;
        if( result.description.name.startsWith(parent.name) ) {
            name = result.description.name.replaceFirst(parent.name+".", "");
        } else {
            name = result.description.name;
        }
        
        if( depth > 0 ) {
            for(i in 1..depth ) {
                fw.write("<span class='indent'></span>");
            }
        }
        
        fw.write("<span class='name``result.description.children.empty then "" else " suite"``' title='``result.description.name``'>``name``</span>");
        fw.write("<span class='duration'>``formatTime(result.elapsedTime)``s</span>");
        
        if( exists e = result.exception ) {
            fw.write("<div class='stack-trace' style='display: none;'>");
            fw.write("<span class='stack-trace-arrow'><span class='stack-trace-arrow-inner'></span></span>");
            fw.write("<pre>");
            printStackTrace(e, void (String s) { fw.write(s); });
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
    
    shared formal String formatTime(Integer timeInMilliseconds);
    
    shared formal FileWriter createFile(String filePath);
    
    shared interface FileWriter {
        
        shared formal void write(String content);
        
        shared formal void close();
        
    }
    
}
