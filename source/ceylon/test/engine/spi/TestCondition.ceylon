/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
"Represents a contract for annotation, which serves as condition, that has to be 
 fullfiled to execute test, in other case the test execution is [[ceylon.test::TestState.skipped]].
 The [[ceylon.test::ignore]] annotation is one simple implementation of this mechanism.
 
 The example below shows `bug` annotation, which allow to skip test, 
 until the reported issue is resolved. 
 
     shared annotation BugAnnotation bug(String id) => BugAnnotation(id);
     
     shared final annotation class BugAnnotation(String id)
              satisfies OptionalAnnotation<BugAnnotation,FunctionDeclaration> & TestCondition {
         
         shared actual Result evaluate(TestDescription description) {
             // check if the issue is already resolved
         }
         
     } 
 
     test
     bug(\"1205\")
     shared void shouldTestSomethingButThereIsBug() {
     }
 
"
shared interface TestCondition {
    
    "Evaluate the condition for the given test."
    shared formal Result evaluate(TestExecutionContext context);
    
    "The result of evaluating."
    shared class Result(successful, reason = null) {
        
        "The flag if the condition was fulfilled or not."
        shared Boolean successful;
        
        "The reason why the test is skipped."
        shared String? reason;
        
        /*
         
        WORKAROUND Can't invoke ctor of nested class #5785
        https://github.com/ceylon/ceylon/issues/5785
         
        new init(Boolean successful, String? reason) {
            successful = successful; 
            reason = reason2;
        }
        
        shared new success(String reason) extends init(true, reason) {}
        
        shared new failed(String reason) extends init(false, reason) {}
         
        */
        
    }
    
}