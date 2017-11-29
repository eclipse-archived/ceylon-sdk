/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.language.meta {
    type
}
import ceylon.test {
    TestRunner,
    TestDescription,
    TestRunResult,
    TestResult,
    TestListener
}


"Event fired by [[TestListener.testRunStarted]]."
shared class TestRunStartedEvent(runner, description) {
    
    "The current test runner."
    shared TestRunner runner;
    
    "The description of all tests to be run."
    shared TestDescription description;
    
    shared actual String string => toString(this);
    
}


"Event fired by [[TestListener.testRunFinished]]."
shared class TestRunFinishedEvent(runner, result) {
    
    "The current test runner."
    shared TestRunner runner;
    
    "The summary result of the test run."
    shared TestRunResult result;
    
    shared actual String string => toString(this);
    
}


"Event fired by [[TestListener.testStarted]]."
shared class TestStartedEvent(description, instance = null) {
    
    "The description of the test."
    shared TestDescription description;
    
    "The instance on which the test method is invoked, if exists."
    shared Object? instance;
    
    shared actual String string => toString(this, description);
    
}


"Event fired by [[TestListener.testFinished]]."
shared class TestFinishedEvent(result, instance = null) {
    
    "The result of the test."
    shared TestResult result;
    
    "The instance on which the test method is invoked, if exists."
    shared Object? instance;
    
    shared actual String string => toString(this, result);
    
}


"Event fired by [[TestListener.testSkipped]]."
shared class TestSkippedEvent(result) {
    
    "The result of the test."
    shared TestResult result;
    
    shared actual String string => toString(this, result);
    
}


"Event fired by [[TestListener.testAborted]]."
shared class TestAbortedEvent(result) {
    
    "The result of the test."
    shared TestResult result;
    
    shared actual String string => toString(this, result);
    
}


"Event fired by [[TestListener.testError]]."
shared class TestErrorEvent(result) {
    
    "The result of the test."
    shared TestResult result;
    
    shared actual String string => toString(this, result);
    
}


"Event fired by [[TestListener.testExcluded]]."
shared class TestExcludedEvent(description) {
    
    "The description of the test."
    shared TestDescription description;
    
    shared actual String string => toString(this, description);
    
}


String toString(Object obj, Object?* attributes) {
    return type(obj).declaration.name + (!attributes.empty then "[" + ", ".join({ for (a in attributes) a?.string else "null" }) + "]" else "");
}
