import ceylon.collection {
    ...
}
import ceylon.language.meta {
    typeLiteral
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
        Object?() instance = getInstanceProvider();
        Anything() executor = verify(context,
            handleTestIgnore(context,
                handleTestExecution(context, instance,
                    handleAfterCallbacks(context, instance,
                        handleBeforeCallbacks(context, instance,
                            handleTestInvocation(context, instance))))));
        executor();
    }
    
    shared default void verify(TestRunContext context, void execute())() {
        try {
            if (exists classDeclaration,
                is Exception result = classValidationCache.getResultFor(classDeclaration, this)) {
                throw result;
            }
            verifyFunctionAnnotations();
            verifyFunctionParameters();
            verifyFunctionTypeParameters();
            verifyFunctionReturnType();
            verifyBeforeCallbacks();
            verifyAfterCallbacks();
            execute();
        }
        catch (Exception e) {
            context.fireTestError(TestErrorEvent(TestResult(description, error, e)));
        }
    }
    
    shared default void verifyClassAttributes(ClassDeclaration classDeclaration) {
        if (!classDeclaration.toplevel) {
            throw Exception("class ``classDeclaration.qualifiedName`` should be toplevel");
        }
        if (classDeclaration.abstract) {
            throw Exception("class ``classDeclaration.qualifiedName`` should not be abstract");
        }
        if (classDeclaration.anonymous) {
            throw Exception("class ``classDeclaration.qualifiedName`` should not be anonymous");
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
    
    shared default void handleTestIgnore(TestRunContext context, void execute())() {
        value ignoreAnnotation = findAnnotation<IgnoreAnnotation>(functionDeclaration, classDeclaration);
        if (exists ignoreAnnotation) {
            context.fireTestIgnore(TestIgnoreEvent(TestResult(description, ignored, IgnoreException(ignoreAnnotation.reason))));
            return;
        }
        execute();
    }
    
    shared default void handleTestExecution(TestRunContext context, Object?() instance, void execute())() {
        value startTime = system.milliseconds;
        value elapsedTime => system.milliseconds - startTime;
        
        try {
            context.fireTestStart(TestStartEvent(description, instance()));
            execute();
            context.fireTestFinish(TestFinishEvent(TestResult(description, success, null, elapsedTime), instance()));
        }
        catch (Throwable e) {
            if (e is AssertionError) {
                context.fireTestFinish(TestFinishEvent(TestResult(description, failure, e, elapsedTime), instance()));
            } else {
                context.fireTestFinish(TestFinishEvent(TestResult(description, error, e, elapsedTime), instance()));
            }
        }
    }
    
    shared default void handleBeforeCallbacks(TestRunContext context, Object?() instance, void execute())() {
        value callbacks = findCallbacks<BeforeTestAnnotation>().reversed;
        for (callback in callbacks) {
            invokeFunction(callback, instance);
        }
        execute();
    }
    
    shared default void handleAfterCallbacks(TestRunContext context, Object?() instance, void execute())() {
        value exceptionsBuilder = SequenceBuilder<Throwable>();
        try {
            execute();
        }
        catch (Throwable e) {
            exceptionsBuilder.append(e);
        }
        finally {
            value callbacks = findCallbacks<AfterTestAnnotation>();
            for (callback in callbacks) {
                try {
                    invokeFunction(callback, instance);
                }
                catch (Throwable e) {
                    exceptionsBuilder.append(e);
                }
            }
        }
        
        value exceptions = exceptionsBuilder.sequence;
        if (exceptions.size == 0) {
            // noop
        } else if (exceptions.size == 1) {
            assert (exists e = exceptions.first);
            throw e;
        } else {
            throw MultipleFailureException(exceptions);
        }
    }
    
    shared default void handleTestInvocation(TestRunContext context, Object?() instance)() {
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
    
    shared default Object?() getInstanceProvider() {
        object instanceProvider {
            variable Object? instance = null;
            shared Object? getInstance() {
                if (exists classDeclaration) {
                    if (!(instance exists)) {
                        assert (is Class<Object,[]> classModel = classDeclaration.apply<Object>());
                        instance = classModel();
                    }
                    return instance;
                } else {
                    return null;
                }
            }
        }
        return instanceProvider.getInstance;
    }
    
    FunctionDeclaration[] findCallbacks<CallbackType>() given CallbackType satisfies Annotation {
        if (exists classDeclaration) {
            return callbackCache.get(classDeclaration, typeLiteral<CallbackType>());
        } else {
            return functionDeclaration.containingPackage.annotatedMembers<FunctionDeclaration,CallbackType>();
        }
    }
    
    void invokeFunction(FunctionDeclaration f, Object?() instance) {
        if (f.toplevel) {
            f.invoke();
        } else {
            assert(exists i = instance());
            f.memberInvoke(i);
        }
    }
    
}

object classValidationCache {
    
    value validatedClasses = HashMap<ClassDeclaration, Exception|Boolean>();
    
    shared Exception? getResultFor(ClassDeclaration declaration, DefaultTestExecutor executor) {
        value result = validatedClasses.get(declaration) else doValidate(declaration, executor) else true;
        validatedClasses.put(declaration, result);
        switch(result)
        case (is Exception) {
            return result;
        }
        case (is Boolean) {
            return null;
        }
    }
    
    Exception? doValidate(ClassDeclaration classDeclaration, DefaultTestExecutor executor) {
        try {
            executor.verifyClassAttributes(classDeclaration);
            executor.verifyClassParameters(classDeclaration);
            executor.verifyClassTypeParameters(classDeclaration);
            return null;
        } catch(e) {
            return e;
        }
    }
    
}


FunctionDeclaration[] findClassCallbacks<CallbackType>(ClassOrInterfaceDeclaration? classDeclaration)
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
    value callbacks = HashSet<FunctionDeclaration>();
    
    if (exists classDeclaration) {
        visit(classDeclaration, void(ClassOrInterfaceDeclaration decl) {
            callbacks.addAll((decl is ClassDeclaration) then decl.annotatedDeclaredMemberDeclarations<FunctionDeclaration,CallbackType>() else []);
        });
        visit(classDeclaration, void(ClassOrInterfaceDeclaration decl) {
            callbacks.addAll((decl is InterfaceDeclaration) then decl.annotatedDeclaredMemberDeclarations<FunctionDeclaration,CallbackType>() else []);
        });
        visit(classDeclaration, void(ClassOrInterfaceDeclaration decl) {
            callbacks.addAll(decl.containingPackage.annotatedMembers<FunctionDeclaration,CallbackType>());
        });    
    }
    return callbacks.sequence;    
}

object callbackCache {
    
    value cache = HashMap<String, FunctionDeclaration[]>();
    
    shared FunctionDeclaration[] get(ClassDeclaration classDeclaration, Type<Object> callbackType) {
        value key = classDeclaration.string + callbackType.string;
        value cached = cache[key];
        if (exists cached) {
            return cached;
        }
        value callbacks = findClassCallbacks(classDeclaration);
        cache.put(key, callbacks);
        return callbacks;
    }
    
}

