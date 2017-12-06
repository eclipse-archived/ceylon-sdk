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
    modules
}
import ceylon.test {
    TestListener,
    TestSource,
    TestFilter,
    defaultTestFilter,
    defaultTestComparator
}
import ceylon.test.reporter {
    HtmlReporter,
    TapReporter,
    XmlJUnitReporter
}
import ceylon.test.engine {
    TagFilter,
    DefaultTestRunner
}


shared class Runner() {

    value options = Options.parse();
    value socket = connectSocket(options.port);
    
    shared void run() {
        initializeTestedModules();
        value testSources = getTestSources();
        value testListeners = getTestListeners();
        value testFilter = getTestFilter();
        value testRunner = DefaultTestRunner(testSources, testListeners, testFilter, defaultTestComparator);
        runTests(testRunner);
    }
    
    TestSource[] getTestSources() {
        value testSources = ArrayList<TestSource>();
        
        if (options.tests.empty) {
            for (value mod in options.modules) {
print("find 0 "+mod.string);
                assert (exists m = modules.find(*parseModuleNameAndVersion(mod)));
                testSources.add(m);
            }
        } else {
            testSources.addAll(options.tests);
        }
        
        return testSources.sequence();
    }
    
    TestListener[] getTestListeners() {
        value testListeners = ArrayList<TestListener>();
        
        if (exists socket) {
            testListeners.add(TestEventPublisher(socket.write));
        } else if (exists tap = options.tap) {
            if (tap == "-") {
                testListeners.add(TapReporter());
            } else {
                value writer = FileWriter(tap);
                testListeners.add(TapReporter {
                        void write(String line) => writer.writeLine(line);
                        void close() => writer.destroy(null);
                    });
            }
        } else {
            testListeners.add(TestLoggingListener(options.colorReset, options.colorGreen, options.colorRed));
        }
        if (options.report) {
            testListeners.add(HtmlReporter(getHtmlReportSubdir(), options.reportsDir));
        }
        if (options.xmlJUnitReport) {
            testListeners.add(XmlJUnitReporter(getHtmlReportSubdir(), options.reportsDir));
        }
        
        return testListeners.sequence();
    }
    
    TestFilter getTestFilter() {
        if( options.tags.empty ) {
            return defaultTestFilter;
        } else {
            return TagFilter(options.tags).filterTest;
        }
    }
    
    [String, String] parseModuleNameAndVersion(String mod) {
print("parse module name "+mod);
        assert (exists i = mod.firstInclusion("/"));
        value name = mod[0 .. i-1];
        value version = mod[i+1 ...];
        
        return [name, version];
    }
    
    native
    void runTests(DefaultTestRunner runner);
    
    native("jvm")
    void runTests(DefaultTestRunner runner) {
        try {
            value result = runner.run();
            if (!result.isSuccess) {
                throw TestFailureException();
            }
        } finally {
            socket?.close();
        }
    }
    
    native("js")
    suppressWarnings("expressionTypeNothing")
    void runTests(DefaultTestRunner runner) {
        if( exists socket ) {
            runner.runAsync((result) {
                socket.close();                
            });
        } else {
            value result = runner.run();
            process.exit(result.isSuccess then 0 else 100);
        }
    }
    
    native
    void initializeTestedModules();

    native("jvm")
    void initializeTestedModules() {
        import ceylon.modules.jboss.runtime {
            CeylonModuleLoader
        }
        import org.jboss.modules {
            Module
        }

        if(exists loader = Module.callerModuleLoader){
            assert(is CeylonModuleLoader loader);

            for (value mod in options.modules) {
                loader.loadModuleSynchronous(*parseModuleNameAndVersion(mod));
            }
        }
    }
    
    native("js")
    void initializeTestedModules() {
        for (value mod in options.modules) {
print("find 1 "+mod.string);
            assert (exists m = modules.find(*parseModuleNameAndVersion(mod)));
        }
    }
    
    native
    String getHtmlReportSubdir();
    
    native("jvm")
    String getHtmlReportSubdir() => "test";
    
    native("js")
    String getHtmlReportSubdir() => "test-js";
    
}

class TestFailureException() extends Exception() {
}
