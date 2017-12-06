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
    ...
}
import ceylon.language.meta {
    ...
}
import ceylon.language.meta.declaration {
    ...
}
import ceylon.language.meta.model {
    ...
}
import ceylon.test {
    ...
}
import ceylon.test.annotation {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.test.engine.spi {
    ArgumentListResolver,
    TestCondition,
    TestExecutionContext,
    TestExecutor,
    TestInstancePostProcessor,
    TestInstanceProvider,
    TestVariantProvider
}
import ceylon.test.engine.internal {
    GroupTestListener,
    findAnnotations
}


"Default implementation of [[TestExecutor]]."
shared class DefaultTestExecutor(FunctionDeclaration functionDeclaration, ClassDeclaration? classDeclaration) satisfies TestExecutor {
        
    shared actual default TestDescription description => TestDescription(getName(), functionDeclaration, classDeclaration);
    
    shared actual default void execute(TestExecutionContext parent) {
        value context = parent.childContext(description);
        try {
            verify(context);
            evaluateTestConditions(context);
            
            value argLists = context.extension<ArgumentListResolver>().resolve(context, functionDeclaration);
            
            if( argLists.size == 0 ) {
                if( !functionDeclaration.parameterDeclarations.empty ) {
                    throw Exception("parameterized test failed, argument provider didn't return any argument list");
                }
                executeVariant(context, []);
            }
            else if( argLists.size == 1, exists args = argLists.first ) {
                executeVariant(context, args);
            } else {
                executeVariants(context, argLists);
            }
        }
        catch(TestSkippedException e) {
            context.fire().testSkipped(TestSkippedEvent(TestResult(description, TestState.skipped, false, e)));
        }
        catch(Throwable e) {
            context.fire().testError(TestErrorEvent(TestResult(description, TestState.error, false, e)));
        }
    }
    
    void executeVariants(TestExecutionContext context, {Anything[]*} argsVariants) {
        value groupTestListener = GroupTestListener();
        context.registerExtension(groupTestListener);
        
        context.fire().testStarted(TestStartedEvent(description));
        
        variable value index = 1;
        for(args in argsVariants) {
            value v = context.extension<TestVariantProvider>().variant(description, index, args);
            value d = description.forVariant(v, index);
            value contextForVariant = context.childContext(d);
            executeVariant(contextForVariant, args);
            index++;
        }
        
        context.fire().testFinished(TestFinishedEvent(TestResult(description, groupTestListener.worstState, true, null, groupTestListener.elapsedTime)));
    }
    
    void executeVariant(TestExecutionContext context, {Anything*} args) {
        Object? instance = getInstance(context);
        Anything() executor = handleTestExecution(context, instance,
            handleAfterCallbacks(context, instance,
                handleBeforeCallbacks(context, instance,
                    handleTestInvocation(context, instance, args.sequence()))));
        executor();
    }
    
    "Verifies that the test context does not contain any errors."
    shared default void verify(TestExecutionContext context) {
        if (exists classDeclaration) {
            verifyClassAttributes(classDeclaration);
            verifyClassParameters(classDeclaration);
            verifyClassTypeParameters(classDeclaration);
            verifyClassDoesNotContainBeforeTestRunCallbacks(classDeclaration);
            verifyClassDoesNotContainAfterTestRunCallbacks(classDeclaration);
        }
        verifyFunctionAnnotations();
        verifyFunctionTypeParameters();
        verifyFunctionReturnType();
        verifyBeforeCallbacks();
        verifyAfterCallbacks();
    }
    
    shared default void verifyClassAttributes(ClassDeclaration classDeclaration) {
        if (!classDeclaration.toplevel) {
            throw Exception("class ``classDeclaration.qualifiedName`` should be toplevel");
        }
        if (classDeclaration.abstract) {
            throw Exception("class ``classDeclaration.qualifiedName`` should not be abstract");
        }
    }
    
    shared default void verifyClassParameters(ClassDeclaration classDeclaration) {
        if(!classDeclaration.anonymous) {
            if (exists pds=classDeclaration.parameterDeclarations) {
                if (!pds.empty) {
                    throw Exception("class ``classDeclaration.qualifiedName`` should have no parameters");
                }
            } else {
                throw Exception("class ``classDeclaration.qualifiedName`` should either have a parameter list or have a default constructor");
            }
        }
    }
    
    shared default void verifyClassTypeParameters(ClassDeclaration classDeclaration) {
        if (!classDeclaration.typeParameterDeclarations.empty) {
            throw Exception("class ``classDeclaration.qualifiedName`` should have no type parameters");
        }
    }
    
    shared default void verifyClassDoesNotContainBeforeTestRunCallbacks(ClassDeclaration classDeclaration) {
        value beforeTestRunCallbacks = classDeclaration.annotatedMemberDeclarations<FunctionDeclaration, BeforeTestRunAnnotation>();
        if( !beforeTestRunCallbacks.empty ) {
            throw Exception("class ``classDeclaration.qualifiedName`` should not contain before test run callbacks: ``beforeTestRunCallbacks*.name``" );
        }
        
    }
    
    shared default void verifyClassDoesNotContainAfterTestRunCallbacks(ClassDeclaration classDeclaration) {
        value afterTestRunCallbacks = classDeclaration.annotatedMemberDeclarations<FunctionDeclaration, AfterTestRunAnnotation>();
        if( !afterTestRunCallbacks.empty ) {
            throw Exception("class ``classDeclaration.qualifiedName`` should not contain after test run callbacks: ``afterTestRunCallbacks*.name``" );
        }
    }
    
    shared default void verifyFunctionAnnotations() {
        if (functionDeclaration.annotations<TestAnnotation>().empty) {
            throw Exception("function ``functionDeclaration.qualifiedName`` should be annotated with test");
        }
    }
    
    shared default void verifyFunctionTypeParameters() {
        if (!functionDeclaration.typeParameterDeclarations.empty) {
            throw Exception("function ``functionDeclaration.qualifiedName`` should have no type parameters");
        }
    }
    
    shared default void verifyFunctionReturnType() {
        if (is OpenClassOrInterfaceType openType = functionDeclaration.openType, openType.declaration != `class Anything`) {
            throw Exception("function ``functionDeclaration.qualifiedName`` should be void");
        }
    }
    
    shared default void verifyBeforeCallbacks() {
        value beforeCallbacks = findCallbacks<BeforeTestAnnotation>();
        for (beforeCallback in beforeCallbacks) {
            verifyCallback(beforeCallback, "before callback ``beforeCallback.qualifiedName``");
        }
    }
    
    shared default void verifyAfterCallbacks() {
        value afterCallbacks = findCallbacks<AfterTestAnnotation>();
        for (afterCallback in afterCallbacks) {
            verifyCallback(afterCallback, "after callback ``afterCallback.qualifiedName``");
        }
    }
    
    shared default void verifyCallback(FunctionDeclaration callbackDeclaration, String callbackName) {
        if (!callbackDeclaration.typeParameterDeclarations.empty) {
            throw Exception("``callbackName`` should have no type parameters");
        }
        if (is OpenClassOrInterfaceType openType = callbackDeclaration.openType, openType.declaration != `class Anything`) {
            throw Exception("``callbackName`` should be void");
        }
    }
    
    shared default void evaluateTestConditions(TestExecutionContext context) {
        value conditions = findAnnotations<Annotation&TestCondition>(functionDeclaration, classDeclaration);
        for(condition in conditions) {
            value result = condition.evaluate(context);
            if (!result.successful) {
                throw TestSkippedException(result.reason);
            }
        }
    }
        
    shared default void handleTestExecution(TestExecutionContext context, Object? instance, void execute())() {
        value startTime = system.milliseconds;
        value elapsedTime => system.milliseconds - startTime;
        
        try {
            context.fire().testStarted(TestStartedEvent(context.description, instance));
            execute();
            context.fire().testFinished(TestFinishedEvent(TestResult(context.description, TestState.success, false, null, elapsedTime), instance));
        }
        catch (Throwable e) {
            if (e is TestSkippedException) {
                context.fire().testSkipped(TestSkippedEvent(TestResult(context.description, TestState.skipped, false, e)));
            } else if (e is TestAbortedException) {
                context.fire().testAborted(TestAbortedEvent(TestResult(context.description, TestState.aborted, false, e)));
            } else if (e is AssertionError) {
                context.fire().testFinished(TestFinishedEvent(TestResult(context.description, TestState.failure, false, e, elapsedTime), instance));
            } else {
                context.fire().testFinished(TestFinishedEvent(TestResult(context.description, TestState.error, false, e, elapsedTime), instance));
            }
        }
    }
    
    shared default void handleBeforeCallbacks(TestExecutionContext context, Object? instance, void execute())() {
        value callbacks = findCallbacks<BeforeTestAnnotation>().reversed;
        for (callback in callbacks) {
            value args = resolveCallbackArgumentList(context, callback);
            invokeFunction(callback, instance, args);
        }
        execute();
    }
    
    shared default void handleAfterCallbacks(TestExecutionContext context, Object? instance, void execute())() {
        value exceptions = ArrayList<Throwable>();
        try {
            execute();
        }
        catch (Throwable e) {
            exceptions.add(e);
        }
        finally {
            value callbacks = findCallbacks<AfterTestAnnotation>();
            for (callback in callbacks) {
                try {
                    value args = resolveCallbackArgumentList(context, callback);
                    invokeFunction(callback, instance, args);
                }
                catch (Throwable e) {
                    exceptions.add(e);
                }
            }
        }
        
        if (exceptions.size == 1) {
            assert (exists e = exceptions.first);
            throw e;
        } else if (exceptions.size > 1) {
            throw MultipleFailureException(exceptions.sequence());
        }
    }
    
    shared default void handleTestInvocation(TestExecutionContext context, Object? instance, Anything[] args)() {
        try {
            invokeFunction(functionDeclaration, instance, args);
        } catch (IncompatibleTypeException|InvocationException e) {
            throw Exception("parameterized test failed, argument provider probably returned incompatible values", e);
        }
    }
    
    shared Anything[] resolveCallbackArgumentList(TestExecutionContext context, FunctionDeclaration callback) {
        if( callback.parameterDeclarations.empty ) {
            return [];
        }
        
        value argLists = context.extension<ArgumentListResolver>().resolve(context, callback);
        if( argLists.size == 0 ) {
            throw Exception("parameterized callback ``callback.qualifiedName`` failed, argument provider didn't return any argument list");
        } else if( argLists.size > 1) {
            throw Exception("parameterized callback ``callback.qualifiedName`` failed, argument provider returned multiple argument lists");
        }
        
        assert(exists args = argLists.first);
        return args; 
    }
    
    shared default String getName() {
        if (functionDeclaration.toplevel) {
            return functionDeclaration.qualifiedName;
        } else {
            assert (exists classDeclaration);
            return classDeclaration.qualifiedName + "." + functionDeclaration.name;
        }
    }
    
    shared default Object? getInstance(TestExecutionContext context) {
        if( functionDeclaration.toplevel ) {
            return null;
        }
        
        value instance = context.extension<TestInstanceProvider>().instance(context);
        for(instancePostProcessor in context.extensions<TestInstancePostProcessor>()) {
            instancePostProcessor.postProcessInstance(context, instance);
        }
        
        return instance;
    }
    
    FunctionDeclaration[] findCallbacks<CallbackType>() given CallbackType satisfies Annotation {
        return callbackCache.get(classDeclaration else functionDeclaration.containingPackage, typeLiteral<CallbackType>());
    }
    
    void invokeFunction(FunctionDeclaration f, Object? instance, Anything[] args) {
        if (f.toplevel) {
            f.invoke([], *args);
        } else {
            assert(exists i = instance);
            f.memberInvoke(i, [], *args);
        }
    }
    
}


FunctionDeclaration[] doFindCallbacks<CallbackType>(Package|ClassOrInterfaceDeclaration declaration, Type<CallbackType> type)
        given CallbackType satisfies Annotation {
    
    void visit(ClassOrInterfaceDeclaration decl, void do(ClassOrInterfaceDeclaration decl)) {
        do(decl);
        value extendedType = decl.extendedType?.declaration;
        if (exists extendedType, extendedType != `class Basic`) {
            visit(extendedType, do);    
        }
        for (satisfiedType in decl.satisfiedTypes) {
            visit(satisfiedType.declaration, do);
        }
    }
    switch (declaration)
    case (ClassOrInterfaceDeclaration){
        value callbacks = HashMap<Character, HashSet<FunctionDeclaration>> {
            entries = { 'c'-> HashSet<FunctionDeclaration>(),
                        'i' -> HashSet<FunctionDeclaration>(),
                        'p' -> HashSet<FunctionDeclaration>() };
        };
        visit(declaration, void(ClassOrInterfaceDeclaration decl) {
            value key = decl is ClassDeclaration then 'c' else 'i';
            callbacks[key]?.addAll(decl.annotatedDeclaredMemberDeclarations<FunctionDeclaration,CallbackType>());
            callbacks['p']?.addAll(callbackCache.get(decl.containingPackage, type));
        });
        return concatenate(callbacks['c'] else {}, callbacks['i'] else {}, callbacks['p'] else {});
    }
    case (Package) {
        return declaration.annotatedMembers<FunctionDeclaration,CallbackType>();
    }
}


object callbackCache {
    
    value cache = HashMap<String, FunctionDeclaration[]>();
    
    shared FunctionDeclaration[] get<CallbackType>(ClassDeclaration|Package declaration, Type<CallbackType> callbackType)
            given CallbackType satisfies Annotation {
        value key = declaration.string + callbackType.string;
        value cached = cache[key];
        if (exists cached) {
            return cached;
        }
        value callbacks = doFindCallbacks(declaration, callbackType);
        cache[key] = callbacks;
        return callbacks;
    }
    
}
