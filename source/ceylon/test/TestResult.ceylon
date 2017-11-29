/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a detailed result of the execution of a particular test."
see (`interface TestRunResult`)
shared class TestResult(description, state, combined = false, exception = null, elapsedTime = 0) {
    
    "The test this is the result for."
    shared TestDescription description;
    
    "The result state of this test."
    shared TestState state;
    
    "The flag if this is result of one test, or combined result from multiple tests (eg. result for test class)."
    shared Boolean combined;
    
    "The exception thrown during this test, if any."
    shared Throwable? exception;
    
    "The total elapsed time in milliseconds."
    shared Integer elapsedTime;
    
    string => "``description`` - ``state```` (exception exists) then " (`` exception?.string else "" ``)" else "" ``";
    
}
