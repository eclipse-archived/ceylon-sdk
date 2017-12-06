/********************************************************************************
 * Copyright (c) 2011-2017 Red Hat Inc. and/or its affiliates and others
 *
 * This program and the accompanying materials are made available under the 
 * terms of the Apache License, Version 2.0 which is available at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0 
 ********************************************************************************/
import ceylon.language.meta.declaration {
    FunctionDeclaration,
    Declaration,
    ClassDeclaration,
    Package,
    Module,
    FunctionOrValueDeclaration,
    ValueDeclaration
}
import ceylon.test.engine.spi {
    TestCondition,
    ArgumentListProvider,
    ArgumentProvider,
    ArgumentProviderContext,
    TestExecutionContext
}


"Annotation class for [[ceylon.test::test]]."
shared final annotation class TestAnnotation()
        satisfies OptionalAnnotation<TestAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::testSuite]]"
shared final annotation class TestSuiteAnnotation(
    "The program elements from which tests will be executed."
    shared {Declaration+} sources)
        satisfies OptionalAnnotation<TestSuiteAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::testExecutor]]."
shared final annotation class TestExecutorAnnotation(
    "The class declaration of [[ceylon.test.engine.spi::TestExecutor]]."
    shared ClassDeclaration executor)
        satisfies OptionalAnnotation<TestExecutorAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[ceylon.test::testExtension]]."
shared final annotation class TestExtensionAnnotation(
    "The class declarations of [[ceylon.test.engine.spi::TestExtension]]."
    shared {ClassDeclaration+} extensions)
        satisfies SequencedAnnotation<TestExtensionAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[ceylon.test::beforeTest]]."
shared final annotation class BeforeTestAnnotation()
        satisfies OptionalAnnotation<BeforeTestAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::afterTest]]."
shared final annotation class AfterTestAnnotation()
        satisfies OptionalAnnotation<AfterTestAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::beforeTestRun]]."
shared final annotation class BeforeTestRunAnnotation()
        satisfies OptionalAnnotation<BeforeTestRunAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::afterTestRun]]."
shared final annotation class AfterTestRunAnnotation()
        satisfies OptionalAnnotation<AfterTestRunAnnotation,FunctionDeclaration> {}


"Annotation class for [[ceylon.test::ignore]]."
shared final annotation class IgnoreAnnotation(
    "Reason why the test is ignored."
    shared String reason)
        satisfies OptionalAnnotation<IgnoreAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> & TestCondition {
    
    shared actual Result evaluate(TestExecutionContext context) => Result(false, reason);
    
}


"Annotation class for [[ceylon.test::tag]]."
shared final annotation class TagAnnotation(
    "One or more tags associated with the test."
    shared String+ tags)
        satisfies SequencedAnnotation<TagAnnotation,FunctionDeclaration|ClassDeclaration|Package|Module> {}


"Annotation class for [[ceylon.test::parameters]]."
shared final annotation class ParametersAnnotation(
    "The source function or value declaration."
    shared FunctionOrValueDeclaration source)
        satisfies OptionalAnnotation<ParametersAnnotation,FunctionOrValueDeclaration> & ArgumentListProvider & ArgumentProvider {
    
    shared actual {Anything*} arguments(ArgumentProviderContext context) {
        switch (source)
        case (FunctionDeclaration) {
            return source.apply<{Anything*},[]>()();
        }
        case (ValueDeclaration) {
            return source.apply<{Anything*}>().get();
        }
    }
    
    shared actual {Anything[]*} argumentLists(ArgumentProviderContext context) {
        value val = arguments(context);
        if( is Iterable<Anything[], Null> val) {
            return val;
        } else {
            return val.map((Anything e) => [e]); 
        }
    }
    
}