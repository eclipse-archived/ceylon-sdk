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
import ceylon.collection {
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
            verifyClassAttributes();
            verifyClassParameters();
            verifyClassTypeParameters();
            verifyFunctionAnnotations();
            verifyFunctionParameters();
            verifyFunctionTypeParameters();
            verifyFunctionReturnType();
            verifyBeforeCallbacks();
            verifyAfterCallbacks();
        }
        catch (Exception e) {
            context.fireTestError(TestErrorEvent(TestResult(description, error, e)));
            return;
        }
        
        execute();
    }
    
    shared default void verifyClassAttributes() {
        if (exists classDeclaration) {
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
    }
    
    shared default void verifyClassParameters() {
        if (exists classDeclaration, !classDeclaration.parameterDeclarations.empty) {
            throw Exception("class ``classDeclaration.qualifiedName`` should have no parameters");
        }
    }
    
    shared default void verifyClassTypeParameters() {
        if (exists classDeclaration, !classDeclaration.typeParameterDeclarations.empty) {
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
        value callbacks = HashSet<FunctionDeclaration>();
        
        if (exists classDeclaration) {
            
            void visit(ClassOrInterfaceDeclaration? decl, void do(ClassOrInterfaceDeclaration decl)) {
                if (exists decl) {
                    do(decl);
                    visit(decl.extendedType?.declaration, do);
                    for (satisfiedType in decl.satisfiedTypes) {
                        visit(satisfiedType.declaration, do);
                    }
                }
            }
            
            visit(classDeclaration, void(ClassOrInterfaceDeclaration decl) {
                callbacks.addAll((decl is ClassDeclaration) then decl.annotatedDeclaredMemberDeclarations<FunctionDeclaration,CallbackType>() else []);
            });
            visit(classDeclaration, void(ClassOrInterfaceDeclaration decl) {
                callbacks.addAll((decl is InterfaceDeclaration) then decl.annotatedDeclaredMemberDeclarations<FunctionDeclaration,CallbackType>() else []);
            });
            visit(classDeclaration, void(ClassOrInterfaceDeclaration decl) {
                callbacks.addAll(decl.containingPackage.annotatedMembers<FunctionDeclaration,CallbackType>());
            });
        } else {
            callbacks.addAll(functionDeclaration.containingPackage.annotatedMembers<FunctionDeclaration,CallbackType>());
        }
        
        return callbacks.sequence;
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