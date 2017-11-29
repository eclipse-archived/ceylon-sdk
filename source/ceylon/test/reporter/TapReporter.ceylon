/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.test.annotation {
    ...
}
import ceylon.test.engine {
    AssertionComparisonError
}


"A [[TestListener]] that prints information about test execution to a given logging function,
 in [Test Anything Protocol v13](http://testanything.org/tap-version-13-specification.html) format.
 
 ### YAML keys used
 
 * `elapsed` for the [[elapsed time|TestResult.elapsedTime]], in milliseconds (not for skipped tests)
 * `reason` for the [[ignore reason|IgnoreAnnotation.reason]], if present
 * `severity` for the [[state|TestResult.state]], one of `failure` or `error` (omitted for successful tests)
 * `actual`, `expected` if the [[exception|TestResult.exception]] is an [[AssertionComparisonError]]
 * `exception` for the exception’s stack trace if it exists, but isn’t an [[AssertionComparisonError]].
 
 ### Example
 
 ~~~text
 TAP version 13
 1..4
 ok 1 - test.my.module::testFeature
   ---
   elapsed: 163
   ...
 not ok 2 - test.my.module::testOtherFeature
   ---
   elapsed: 11
   severity: failure
   actual: |
     Lorem ipsum dolor sit amet ,
     consetetur sadipscing elitr ,
     sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat ,
     sed diam voluptua .
   expected: |
     Lorem ipsum dolor sit amet,
     consetetur sadipscing elitr,
     sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,
     sed diam voluptua.
   ...
 not ok 3 - test.my.module::testProposedFeature # SKIP skipped
   ---
   reason: not yet implemented
   ...
 not ok 4 - test.my.module::testBrokenFeature 
   ---
   elapsed: 15
   severity: error
   exception: |
     java.lang.Exception: Error
         at test.my.module.testBrokenFeature_.testBrokenFeature(testBrokenFeature.ceylon:3)
         at org.eclipse.ceylon.compiler.java.runtime.metamodel.AppliedFunction.$call$(AppliedFunction.java:257)
         at org.eclipse.ceylon.compiler.java.Util.apply(Util.java:934)
         at org.eclipse.ceylon.compiler.java.runtime.metamodel.Metamodel.apply(Metamodel.java:1099)
         at org.eclipse.ceylon.compiler.java.runtime.metamodel.AppliedFunction.apply(AppliedFunction.java:413)
         at org.eclipse.ceylon.compiler.java.runtime.metamodel.FreeFunction.invoke(FreeFunction.java:262)
         at org.eclipse.ceylon.compiler.java.runtime.metamodel.FreeFunction.invoke(FreeFunction.java:251)
         at org.eclipse.ceylon.compiler.java.runtime.metamodel.FreeFunction.invoke(FreeFunction.java:244)
         at ceylon.test.internal.DefaultTestExecutor.invokeFunction$priv$(executors.ceylon:254)
         at ceylon.test.internal.DefaultTestExecutor.invokeTest$priv$(executors.ceylon:249)
         at ceylon.test.internal.DefaultTestExecutor.access$000(executors.ceylon:253)
         at ceylon.test.internal.DefaultTestExecutor$4.$call$(executors.ceylon)
         at ceylon.test.internal.DefaultTestExecutor$10.$call$(executors.ceylon:168)
         at ceylon.test.internal.DefaultTestExecutor$11.$call$(executors.ceylon:174)
         at ceylon.test.internal.DefaultTestExecutor$9.$call$(executors.ceylon:150)
         at ceylon.test.internal.DefaultTestExecutor$8.$call$(executors.ceylon:140)
         at ceylon.test.internal.DefaultTestExecutor$7.$call$(executors.ceylon:131)
         at ceylon.test.internal.DefaultTestExecutor$6.$call$(executors.ceylon:111)
         at ceylon.test.internal.DefaultTestExecutor$5.$call$(executors.ceylon:91)
         at ceylon.test.internal.DefaultTestExecutor.execute(executors.ceylon:61)
         at ceylon.test.internal.TestRunnerImpl.run(TestRunnerImpl.ceylon:49)
         at test.ceylon.formatter.run_.run(run.ceylon:4)
         at test.ceylon.formatter.run_.main(run.ceylon)
         at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
         at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
         at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
         at java.lang.reflect.Method.invoke(Method.java:606)
         at ceylon.modules.api.runtime.SecurityActions.invokeRunInternal(SecurityActions.java:58)
         at ceylon.modules.api.runtime.SecurityActions.invokeRun(SecurityActions.java:48)
         at ceylon.modules.api.runtime.AbstractRuntime.invokeRun(AbstractRuntime.java:85)
         at ceylon.modules.api.runtime.AbstractRuntime.execute(AbstractRuntime.java:145)
         at ceylon.modules.api.runtime.AbstractRuntime.execute(AbstractRuntime.java:129)
         at ceylon.modules.Main.execute(Main.java:69)
         at ceylon.modules.Main.main(Main.java:42)
         at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
         at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
         at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
         at java.lang.reflect.Method.invoke(Method.java:606)
         at org.jboss.modules.Module.run(Module.java:270)
         at org.jboss.modules.Main.main(Main.java:294)
         at ceylon.modules.bootstrap.CeylonRunTool.run(CeylonRunTool.java:208)
         at org.eclipse.ceylon.common.tools.CeylonTool.run(CeylonTool.java:343)
         at org.eclipse.ceylon.common.tools.CeylonTool.execute(CeylonTool.java:283)
         at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
         at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
         at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
         at java.lang.reflect.Method.invoke(Method.java:606)
         at org.eclipse.ceylon.launcher.Launcher.run(Launcher.java:89)
         at org.eclipse.ceylon.launcher.Launcher.main(Launcher.java:21)
   ...
 ~~~"
shared class TapReporter(write = print, close = noop) satisfies TestListener {
    
    "A function that logs the given line, for example [[print]]."
    void write(String line);
    "A function that is called at the end of reporting and may, for example, close an underlying stream."
    void close();
    
    variable Integer count = 1;
    
    shared actual void testRunStarted(TestRunStartedEvent event) {
        write("TAP version 13");
    }
    
    shared actual void testRunFinished(TestRunFinishedEvent event) {
        write("1..`` count - 1 ``");
        close();
    }
    
    shared actual void testFinished(TestFinishedEvent event) => writeProtocol(event);
    
    shared actual void testSkipped(TestSkippedEvent event) => writeProtocol(event);
    
    shared actual void testAborted(TestAbortedEvent event) => writeProtocol(event);
    
    shared actual void testError(TestErrorEvent event) => writeProtocol(event);
    
    void writeProtocol(TestFinishedEvent|TestSkippedEvent|TestAbortedEvent|TestErrorEvent event) {
        TestResult result;
        Throwable? exception;
        Integer? elapsed;
        String? reason;
        
        switch (event)
        case (TestFinishedEvent) {
            result = event.result;
            exception = event.result.exception;
            elapsed = event.result.elapsedTime;
            reason = null;
        }
        case (TestSkippedEvent) {
            result = event.result;
            reason = result.exception?.message;
            exception = null;
            elapsed = null;
        }
        case (TestAbortedEvent) {
            result = event.result;
            reason = result.exception?.message;
            exception = null;
            elapsed = null;
        }
        case (TestErrorEvent) {
            result = event.result;
            exception = event.result.exception;
            elapsed = null;
            reason = null;
        }
        
        String name = "``result.description.name````result.description.variant else ""``";
        String okOrNotOk = (result.state == TestState.success) then "ok" else "not ok";
        String directive = (result.state == TestState.skipped || result.state == TestState.aborted) then "# SKIP skipped" else "";
        String? severity = (result.state == TestState.failure) then "failure" else (result.state == TestState.error then "error");
        
        write("``okOrNotOk`` ``count`` - ``name`` ``directive``");
        
        if (elapsed exists || reason exists || exception exists) {
            write("  ---");
            if (exists elapsed) {
                write("  elapsed: ``elapsed``");
            }
            if (exists reason) {
                write("  reason: ``reason``");
            }
            if (exists severity) {
                write("  severity: ``severity``");
            }
            if (exists exception) {
                if (is AssertionComparisonError exception) {
                    write("  actual: |");
                    for (line in exception.actualValue.replace("\r\n", "\n").split('\n'.equals)) {
                        write("    ``line``");
                    }
                    write("  expected: |");
                    for (line in exception.expectedValue.replace("\r\n", "\n").split('\n'.equals)) {
                        write("    ``line``");
                    }
                } else {
                    write("  exception: |");
                    printStackTrace(exception, void(String string) {
                            for (line in string.replace("\r\n", "\n").split('\n'.equals).filter((String s) => !s.empty)) {
                                write("    ``line.replace("\t", "    ")``");
                            }
                        });
                }
            }
            write("  ...");
        }
        
        count++;
    }
}
