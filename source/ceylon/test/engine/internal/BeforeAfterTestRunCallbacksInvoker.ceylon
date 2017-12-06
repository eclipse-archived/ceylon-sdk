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
    HashSet,
    ArrayList
}
import ceylon.language.meta.declaration {
    FunctionDeclaration,
    Module
}
import ceylon.test {
    TestListener,
    TestDescription
}
import ceylon.test.annotation {
    BeforeTestRunAnnotation,
    AfterTestRunAnnotation
}
import ceylon.test.event {
    TestRunStartedEvent,
    TestRunFinishedEvent
}
import ceylon.test.engine {
    MultipleFailureException
}

shared class BeforeAfterTestRunCallbacksInvoker() satisfies TestListener {
    
    variable {FunctionDeclaration*} beforeTestRunCallbacks = [];
    variable {FunctionDeclaration*} afterTestRunCallbacks = [];
    
    shared actual void testRunStarted(TestRunStartedEvent event) {
        initialize(event.description);
        invokeBeforeCallbacksAndStopOnFirstException();        
    }
    
    shared actual void testRunFinished(TestRunFinishedEvent event) {
        invokeAfterCallbacksAndCollectExceptions();
    }
    
    void initialize(TestDescription root) {
        value moduleSet = HashSet<Module>();
        void visit(TestDescription d) {
            if (exists fd = d.functionDeclaration) {
                moduleSet.add(fd.containingModule);
            }
            for (TestDescription child in d.children) {
                visit(child);
            }
        }
        visit(root);
       
        beforeTestRunCallbacks = moduleSet
                .flatMap((m) => m.members)
                .flatMap((p) => p.annotatedMembers<FunctionDeclaration, BeforeTestRunAnnotation>())
                .distinct;
        
        afterTestRunCallbacks = moduleSet
                .flatMap((m) => m.members)
                .flatMap((p) => p.annotatedMembers<FunctionDeclaration, AfterTestRunAnnotation>())
                .distinct;
    }
    
    void invokeBeforeCallbacksAndStopOnFirstException() {
        beforeTestRunCallbacks*.invoke();
    }
    
    void invokeAfterCallbacksAndCollectExceptions() {
        value exceptions = ArrayList<Throwable>();
        for (FunctionDeclaration callback in afterTestRunCallbacks) {
            try {
                callback.invoke();
            }
            catch (Throwable e) {
                exceptions.add(e);
            }
        }
        if (exceptions.size == 1) {
            assert (exists e = exceptions.first);
            throw e;
        } else if (exceptions.size > 1) {
            throw MultipleFailureException(exceptions.sequence());
        }        
    }
    
}
