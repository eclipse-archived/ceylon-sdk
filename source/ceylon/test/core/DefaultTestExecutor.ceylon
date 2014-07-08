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
import ceylon.test.event {
    ...
}

"Default implementation of [[TestExecutor]]."
shared class DefaultTestExecutor(FunctionDeclaration functionDeclaration, ClassDeclaration? classDeclaration) satisfies TestExecutor {
        
    shared actual default TestDescription description => TestDescription(getName(), functionDeclaration, classDeclaration);
    
    shared actual default void execute(TestRunContext context) {
        if (verify(context) && !handleIgnored(context)) {
            Object? instance = getInstance();
            Anything() executor = handleTestExecution(context, instance,
                    handleAfterCallbacks(context, instance,
                        handleBeforeCallbacks(context, instance,
                            handleTestInvocation(context, instance))));
            executor();
        }
    }
    
    "Verifies that the test context does not contain any errors.
     
     Returns true if the context is ok, false if any errors were fired."
    shared default Boolean verify(TestRunContext context) {
        try {
            if (exists classDeclaration) {
                verifyClassAttributes(classDeclaration);
                verifyClassParameters(classDeclaration);
                verifyClassTypeParameters(classDeclaration);
            }
            verifyFunctionAnnotations();
            verifyFunctionParameters();
            verifyFunctionTypeParameters();
            verifyFunctionReturnType();
            verifyBeforeCallbacks();
            verifyAfterCallbacks();
            return true;
        }
        catch (Exception e) {
            context.fireTestError(TestErrorEvent(TestResult(description, error, e)));
            return false;
        }
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
        if (!classDeclaration.parameterDeclarations.empty) {
            throw Exception("class ``classDeclaration.qualifiedName`` should have no parameters");
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
    
    shared default void verifyFunctionParameters() {
        if (!functionDeclaration.parameterDeclarations.empty) {
            throw Exception("function ``functionDeclaration.qualifiedName`` should have no parameters");
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
    
    shared default Boolean handleIgnored(TestRunContext context) {
        value ignoreAnnotation = findAnnotation<IgnoreAnnotation>(functionDeclaration, classDeclaration);
        if (exists ignoreAnnotation) {
            context.fireTestIgnore(TestIgnoreEvent(TestResult(description, ignored, IgnoreException(ignoreAnnotation.reason))));
            return true;
        }
        return false;
    }
    
    shared default void handleTestExecution(TestRunContext context, Object? instance, void execute())() {
        value startTime = system.milliseconds;
        value elapsedTime => system.milliseconds - startTime;
        
        try {
            context.fireTestStart(TestStartEvent(description, instance));
            execute();
            context.fireTestFinish(TestFinishEvent(TestResult(description, success, null, elapsedTime), instance));
        }
        catch (Throwable e) {
            if (e is AssertionError) {
                context.fireTestFinish(TestFinishEvent(TestResult(description, failure, e, elapsedTime), instance));
            } else {
                context.fireTestFinish(TestFinishEvent(TestResult(description, error, e, elapsedTime), instance));
            }
        }
    }
    
    shared default void handleBeforeCallbacks(TestRunContext context, Object? instance, void execute())() {
        value callbacks = findCallbacks<BeforeTestAnnotation>().reversed;
        for (callback in callbacks) {
            invokeFunction(callback, instance);
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
                    invokeFunction(callback, instance);
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
    
    shared default void handleTestInvocation(TestRunContext context, Object? instance)() {
        invokeFunction(functionDeclaration, instance);
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
    
    void invokeFunction(FunctionDeclaration f, Object? instance) {
        if (f.toplevel) {
            f.invoke();
        } else {
            assert(exists i = instance);
            f.memberInvoke(i);
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

