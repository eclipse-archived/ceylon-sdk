/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a summary result of the test run."
shared interface TestRunResult {
    
    "Determine if all executed tests succeeded."
    shared formal Boolean isSuccess;
    
    "Determine if they are any errors or failures."
    shared formal Boolean isFailed;
    
    "The number of executed tests."
    shared formal Integer runCount;
    
    "The number of tests that finished [[successfully|TestState.success]]."
    shared formal Integer successCount;
    
    "The number of tests that finished with [[failure|TestState.failure]]."
    shared formal Integer failureCount;
    
    "The number of tests that finished with [[error|TestState.error]]."
    shared formal Integer errorCount;
    
    "The number of [[skipped|TestState.skipped]] tests during the test run."
    shared formal Integer skippedCount;
    
    "The number of [[aborted|TestState.aborted]] tests during the test run."
    shared formal Integer abortedCount;
    
    "The number of excluded tests from the test run."
    shared formal Integer excludedCount;
    
    "The time in milliseconds when the test run started."
    shared formal Integer startTime;
    
    "The time in milliseconds when the test run finished."
    shared formal Integer endTime;
    
    "The total elapsed time in milliseconds."
    shared formal Integer elapsedTime;
    
    "The detailed results of each test."
    shared formal TestResult[] results;
    
}
