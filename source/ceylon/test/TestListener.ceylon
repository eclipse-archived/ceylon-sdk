/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.test.engine.spi {
    TestExtension
}
import ceylon.test.event {
    TestRunStartedEvent,
    TestRunFinishedEvent,
    TestStartedEvent,
    TestFinishedEvent,
    TestSkippedEvent,
    TestAbortedEvent,
    TestErrorEvent,
    TestExcludedEvent
}


"Represents a listener which will be notified about events that occur during a test run.
 
 Example of simple listener, which triggers alarm whenever test fails.
 
     shared class RingingListener() satisfies TestListener {
         shared actual void testError(TestErrorEvent event) => alarm.ring();
     }
 
 ... such listener can be used directly when creating [[TestRunner]]
 
     TestRunner runner = createTestRunner{
         sources = [`module com.acme`];
         extensions = [RingingListener()];};
 
 ... or better declaratively with usage of [[testExtension]] annotation
 
     testExtension(`class RingingListener`)
     module com.acme;
"
shared interface TestListener satisfies TestExtension {
    
    "Called before any tests have been run."
    shared default void testRunStarted(
        "The event object."
        TestRunStartedEvent event) {}
    
    "Called after all tests have finished."
    shared default void testRunFinished(
        "The event object."
        TestRunFinishedEvent event) {}
    
    "Called when a test is about to be started."
    shared default void testStarted(
        "The event object."
        TestStartedEvent event) {}
    
    "Called when a test has finished, whether the test succeeds or not."
    shared default void testFinished(
        "The event object."
        TestFinishedEvent event) {}
    
    "Called when a test has been skipped, because its condition wasn't fullfiled."
    shared default void testSkipped(
        "The event object."
        TestSkippedEvent event) {}
    
    "Called when a test has been aborted, because its assumption wasn't met."
    shared default void testAborted(
        "The event object."
        TestAbortedEvent event) {}
    
    "Called when a test will not be run, because some error has occurred.
     For example a invalid test function signature."
    shared default void testError(
        "The event object."
        TestErrorEvent event) {}
    
    "Called when a test is excluded from the test run due [[TestFilter]]"
    shared default void testExcluded(
        "The event object."
        TestExcludedEvent event) {}
    
}
