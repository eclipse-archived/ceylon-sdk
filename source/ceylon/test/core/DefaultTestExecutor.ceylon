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
import ceylon.test.internal {
    ...
}


"Default implementation of [[TestExecutor]]."
shared class DefaultTestExecutor(FunctionDeclaration functionDeclaration, ClassDeclaration? classDeclaration) satisfies TestExecutor {
        
    shared actual default TestDescription description => TestDescription(getName(), functionDeclaration, classDeclaration);
    
    shared actual default void execute(TestRunContext context) {
        try {
            verify(context);
            evaluateTestConditions(context);
            
            value argsVariants = DefaultArgumentsResolver().resolve(description);
            
            if( argsVariants.size == 0 ) {
                if( !functionDeclaration.parameterDeclarations.empty ) {
                    throw Exception("parameterized test failed, argument provider probably doesn't return any values");
                }
                executeVariant(context, description, []);
            }
            else if( argsVariants.size == 1, exists args = argsVariants.first ) {
                executeVariant(context, description, args);
            } else {
                executeVariants(context, argsVariants);
            }
        }
        catch(TestSkippedException e) {
            context.fireTestSkipped(TestSkippedEvent(TestResult(description, TestState.skipped, false, e)));
        }
        catch(Throwable e) {
            context.fireTestError(TestErrorEvent(TestResult(description, TestState.error, false, e)));
        }
    }
    
    void executeVariants(TestRunContext context, {Anything[]*} argsVariants) {
        value worstStateListener = WorstStateListener();
        context.addTestListener(worstStateListener);
        try {
            context.fireTestStarted(TestStartedEvent(description));
            value startTime = system.milliseconds;
            
            variable value index = 1;
            for(args in argsVariants) {
                value v = args.string.replaceFirst("[", "(").replaceLast("]", ")");
                value d = description.forVariant(v, index);
                executeVariant(context, d, args);
                index++;
            }
            
            value endTime = system.milliseconds;
            context.fireTestFinished(TestFinishedEvent(TestResult(description, worstStateListener.result, true, null, endTime - startTime)));
        }
        finally {
            context.removeTestListener(worstStateListener);
        }
    }
    
    void executeVariant(TestRunContext context, TestDescription d, {Anything*} args) {
        Object? instance = getInstance();
        Anything() executor = handleTestExecution(context, d, instance,
            handleAfterCallbacks(context, instance,
                handleBeforeCallbacks(context, instance,
                    handleTestInvocation(context, instance, args.sequence()))));
        executor();
    }
    
    "Verifies that the test context does not contain any errors."
    shared default void verify(TestRunContext context) {
        if (exists classDeclaration) {
            verifyClassAttributes(classDeclaration);
            verifyClassParameters(classDeclaration);
            verifyClassTypeParameters(classDeclaration);
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
        if (!callbackDeclaration.parameterDeclarations.empty) {
            throw Exception("``callbackName`` should have no parameters");
        }
        if (!callbackDeclaration.typeParameterDeclarations.empty) {
            throw Exception("``callbackName`` should have no type parameters");
        }
        if (is OpenClassOrInterfaceType openType = callbackDeclaration.openType, openType.declaration != `class Anything`) {
            throw Exception("``callbackName`` should be void");
        }
    }
    
    shared default void evaluateTestConditions(TestRunContext context) {
        value conditions = findAnnotations<Annotation&TestCondition>(functionDeclaration, classDeclaration);
        for(condition in conditions) {
            value result = condition.evaluate(description);
            if (!result.successful) {
                throw TestSkippedException(result.reason);
            }
        }
    }
        
    shared default void handleTestExecution(TestRunContext context, TestDescription d, Object? instance, void execute())() {
        value startTime = system.milliseconds;
        value elapsedTime => system.milliseconds - startTime;
        
        try {
            context.fireTestStarted(TestStartedEvent(d, instance));
            execute();
            context.fireTestFinished(TestFinishedEvent(TestResult(d, TestState.success, false, null, elapsedTime), instance));
        }
        catch (Throwable e) {
            if (e is TestSkippedException) {
                context.fireTestSkipped(TestSkippedEvent(TestResult(d, TestState.skipped, false, e)));
            } else if (e is TestAbortedException) {
                context.fireTestAborted(TestAbortedEvent(TestResult(d, TestState.aborted, false, e)));
            } else if (e is AssertionError) {
                context.fireTestFinished(TestFinishedEvent(TestResult(d, TestState.failure, false, e, elapsedTime), instance));
            } else {
                context.fireTestFinished(TestFinishedEvent(TestResult(d, TestState.error, false, e, elapsedTime), instance));
            }
        }
    }
    
    shared default void handleBeforeCallbacks(TestRunContext context, Object? instance, void execute())() {
        value callbacks = findCallbacks<BeforeTestAnnotation>().reversed;
        for (callback in callbacks) {
            invokeFunction(callback, instance, []);
        }
        execute();
    }
    
    shared default void handleAfterCallbacks(TestRunContext context, Object? instance, void execute())() {
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
                    invokeFunction(callback, instance, []);
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
    
    shared default void handleTestInvocation(TestRunContext context, Object? instance, Anything[] args)() {
        try {
            invokeFunction(functionDeclaration, instance, args);
        } catch (IncompatibleTypeException|InvocationException e) {
            throw Exception("parameterized test failed, argument provider probably returned incompatible values", e);
        }
    }
    
    shared default String getName() {
        if (functionDeclaration.toplevel) {
            return functionDeclaration.qualifiedName;
        } else {
            assert (exists classDeclaration);
            return classDeclaration.qualifiedName + "." + functionDeclaration.name;
        }
    }
    
    shared default Object? getInstance() {
        if (exists classDeclaration) {
            if( classDeclaration.anonymous ) {
                assert(exists objectInstance = classDeclaration.objectValue?.get());
                return objectInstance;
            } else {
                assert (is Class<Object,[]> classModel = classDeclaration.apply<Object>());
                return classModel();
            }
        } else {
            return null;
        }
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
    case (is ClassOrInterfaceDeclaration){
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
    case (is Package) {
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
        cache.put(key, callbacks);
        return callbacks;
    }
    
}
