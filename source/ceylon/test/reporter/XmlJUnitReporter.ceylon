/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.collection {
    ArrayList
}
import ceylon.language.meta {
    type
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
import ceylon.test.engine.internal {
    FileWriter
}
import ceylon.test.event {
    TestRunFinishedEvent
}

import java.lang {
    System,
    JString=String
}

"A [[TestListener]] that generate JUnit XML report about test execution."
shared class XmlJUnitReporter(String reportSubdir, String? reportsDir) satisfies TestListener {
    
    shared actual void testRunFinished(TestRunFinishedEvent event) {
        generate(event.runner.description, event.result);
    }
    
    void generate(TestDescription root, TestRunResult result) {
        value testedModules = findTestedModules(result);
        value parentPath = reportsDir else "reports/``reportSubdir``";
        for(mod in testedModules){
            String path = "``parentPath``/TEST-``mod.name``.xml";
            try (fw = FileWriter(path)) {
                fw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
                value tests = result.results.filter((TestResult element) => 
                    if(!element.combined,
                        exists d = element.description.functionDeclaration, 
                        d.containingModule == mod) then true else false);
                variable value testCount = 0;
                variable value time = 0;
                variable value errors = 0;
                variable value skipped = 0;
                variable value failures = 0;
                for(test in tests){
                    testCount++;
                    time += test.elapsedTime;
                    switch(test.state)
                    case (TestState.success) {}
                    case (TestState.failure) {
                        failures++;
                    }
                    case (TestState.error) {
                        errors++;
                    }
                    case (TestState.skipped) {
                        skipped++;
                    }
                    case (TestState.aborted) {}
                }
                fw.write("<testsuite name=\"``xmlArgEscape(mod.name)``\" time=\"``time``\" tests=\"``testCount``\"");
                fw.write(" errors=\"``errors``\" skipped=\"``skipped``\" failures=\"``failures``\">\n");
                printProperties(fw);
                for(test in tests){
                    fw.write(" <testcase name=\"``xmlArgEscape(test.description.name)``\" time=\"``test.elapsedTime``\">\n");
                    switch(test.state)
                    case (TestState.success) {}
                    case (TestState.failure) {
                        assert(exists x = test.exception);
                        fw.write("  <failure message=\"``xmlArgEscape(x.message)``\" type=\"``xmlArgEscape(type(x))``\">");
                        printStackTrace(x, (s) => fw.write(xmlTextEscape(s)));
                        fw.write("</failure>\n");
                    }
                    case (TestState.error) {
                        assert(exists x = test.exception);
                        fw.write("  <error message=\"``xmlArgEscape(x.message)``\" type=\"``xmlArgEscape(type(x))``\">");
                        printStackTrace(x, (s) => fw.write(xmlTextEscape(s)));
                        fw.write("</error>\n");
                    }
                    case (TestState.skipped) {
                        fw.write("  <skipped/>\n");
                    }
                    case (TestState.aborted) {
                        fw.write("  <skipped/>\n");
                    }
                    fw.write(" </testcase>\n");
                }
                fw.write("</testsuite>\n");
            }
        }
    }

    List<Module> findTestedModules(TestRunResult result) {
        value testedModules = ArrayList<Module>();
        for(r in result.results) {
            if( exists m = r.description.functionDeclaration?.containingModule ) {
                if( !m in testedModules ) {
                    testedModules.add(m);
                }
            }
        }
        return testedModules;
    }
    
    native
    void printProperties(FileWriter fw);
    
    native("js")
    void printProperties(FileWriter fw){
    }
    
    native("jvm")
    void printProperties(FileWriter fw){
        fw.write(" <properties>\n");
        for(prop in System.properties.keySet()){
            assert(is JString prop);
            fw.write("   <property name=\"``xmlArgEscape(prop)``\" value=\"``xmlArgEscape(System.getProperty(prop.string))``\"/>\n");
        }
        fw.write(" </properties>\n");
    }
    
    String xmlArgEscape(Object arg){
        String text = arg.string;
        StringBuilder sb = StringBuilder();
        // \n, \t and \r are allowed but better to escape them
        for(c in text){
            if(c == '\''){
                sb.append("&apos;");
            }else if(c == '"'){
                sb.append("&quot;");
            }else if(c == '<'){
                sb.append("&lt;");
            }else if(c == '&'){
                sb.append("&amp;");
            }else if(c.integer >= #20 && c.integer <= #d7ff
                    || c.integer >= #e000 && c.integer <= #fffd
                    || c.integer >= #10000 && c.integer <= #10ffff){
                sb.append(c.string);
            }else{ 
                sb.append("&#``c.integer``;");
            }
        }
        return sb.string;
    }

    String xmlTextEscape(Object arg){
        String text = arg.string;
        StringBuilder sb = StringBuilder();
        // \n, \t and \r are allowed but better to escape them
        for(c in text){
            if(c == '<'){
                sb.append("&lt;");
            }else if(c == '&'){
                sb.append("&amp;");
            }else if(c == '\n'
                || c == '\t'
                || c == '\r'
                || c.integer >= #20 && c.integer <= #d7ff
                || c.integer >= #e000 && c.integer <= #fffd
                || c.integer >= #10000 && c.integer <= #10ffff){
                sb.append(c.string);
            }else{ 
                sb.append("&#``c.integer``;");
            }
        }
        return sb.string.replace("]]>", "]]&gt;");
    }
}
