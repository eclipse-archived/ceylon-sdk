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
    TestDescription
}


"Represent a strategy how to run test.
 During test execution notifies test mechanism about significant events via given [[TestExecutionContext]].
 
 Custom implementation can be specify via [[ceylon.test::testExecutor]] annotation. It should accept two parameters:
 
    - the first parameter is own test function, 
      represented like [[FunctionDeclaration|ceylon.language.meta.declaration::FunctionDeclaration]]
    - the second parameter is class containg this test function, if exists, 
      represented like [[ClassDeclaration?|ceylon.language.meta.declaration::ClassDeclaration]]
 
"
shared interface TestExecutor {
    
    "The description of the test to be run."
    shared formal TestDescription description;
    
    "Run the test."
    shared formal void execute(
        "The context of this test."
        TestExecutionContext context);
    
}
