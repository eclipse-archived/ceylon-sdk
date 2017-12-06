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

"A [[TestListener]] which prints information about test execution."
shared class DefaultLoggingListener(
    "A function that log the given line."
    void write(String line) => print(line)) satisfies TestListener {
    
    shared actual void testRunStarted(TestRunStartedEvent event) {
        writeBannerStart();
    }
    
    shared actual void testRunFinished(TestRunFinishedEvent event) {
        writeBannerResults(event.result);
        if (event.result.results nonempty) {
            writeSummary(event.result);
            if (event.result.isSuccess) {
                writeBannerSuccess(event.result);
            } else {
                writeFailures(event.result);
                writeBannerFailed(event.result);
            }
        }
    }
    
    shared actual void testStarted(TestStartedEvent event) {
        write("running: ``event.description.name````event.description.variant else ""``");
    }
    
    shared actual void testFinished(TestFinishedEvent event) {
        if (event.result.state == TestState.error || event.result.state == TestState.failure) {
            if (exists e = event.result.exception) {
                e.printStackTrace();
            }
        }
    }
    
    shared actual void testError(TestErrorEvent event) {
        if (event.result.state == TestState.error || event.result.state == TestState.failure) {
            if (exists e = event.result.exception) {
                e.printStackTrace();
            }
        }
    }
    
    shared default void writeBannerStart() {
        write(banner("TESTS STARTED"));
    }
    
    shared default void writeBannerResults(TestRunResult result) {
        write(banner("TEST RESULTS"));
        if (result.results.empty) {
            write("There were no tests!");
        }
    }
    
    shared default void writeBannerSuccess(TestRunResult result) {
        write(banner("TESTS SUCCESS"));
    }
    
    shared default void writeBannerFailed(TestRunResult result) {
        write(banner("TESTS FAILED !"));
    }
    
    shared default void writeSummary(TestRunResult result) {
        write("run:     ``result.runCount``");
        write("success: ``result.successCount``");
        write("failure: ``result.failureCount``");
        write("error:   ``result.errorCount``");
        write("skipped: ``result.skippedCount``");
        write("aborted: ``result.abortedCount``");
        write("time:    `` result.elapsedTime / 1000 ``s");
        write("");
    }
    
    shared default void writeFailures(TestRunResult result) {
        for (r in result.results) {
            if ((r.state == TestState.failure || r.state == TestState.error) && r.description.children.empty) {
                write(r.string);
            }
        }
        write("");
    }
    
    shared default String banner(String title) {
        StringBuilder sb = StringBuilder();
        Integer totalWith = 60;
        Integer bannerWidth = totalWith - title.size - 2;
        for (i in 0 .. bannerWidth / 2) {
            sb.appendCharacter('=');
        }
        if (bannerWidth % 2 == 1) {
            sb.appendCharacter('=');
        }
        sb.append(" ").append(title).append(" ");
        for (i in 0 .. bannerWidth / 2) {
            sb.appendCharacter('=');
        }
        return sb.string;
    }
    
}
