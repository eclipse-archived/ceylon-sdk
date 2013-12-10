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

class DefaultTestExecutor(FunctionDeclaration funcDecl, ClassDeclaration? classDecl) satisfies TestExecutor {

    variable Object? instance = null;
    Object getInstance() {
        if( exists i = instance ) {
            return i;
        }
        else {
            assert(exists classDecl);
            assert(is Class<Object, []> classModel = classDecl.apply<Object>());
            Object i = classModel();
            instance = i;
            return i;
        }
    }

    String getName() {
        if( funcDecl.toplevel ) {
            return funcDecl.qualifiedName;
        }
        else {
            assert(exists classDecl);
            return classDecl.qualifiedName + "." + funcDecl.name;
        }
    }

    shared actual default TestDescription description => TestDescription(getName(), funcDecl);

    shared actual default void execute(TestRunContext context) {
        try {
            value listeners = findListeners();
            try {
                context.addTestListener(*listeners);
                
                void fireError(String msg) 
                        => context.fireTestError(TestErrorEvent(TestResult(description, error, Exception(msg))));

                Anything() handler =
                        verifyClass(fireError,
                        verifyFunction(fireError,
                        verifyCallbacks(fireError, 
                        handleTestIgnore(context,  
                        handleTestExecution(context, 
                        handleAfterCallbacks(
                        handleBeforeCallbacks(
                        invokeTest)))))));

                handler();
            }
            finally {
                context.removeTestListener(*listeners);
            }
        }
        finally {
            instance = null;
        }
    }

    void verifyClass(Anything(String) fireError, Anything() handler)() {
        if( exists classDecl ) {
            if( !classDecl.toplevel ) {
                fireError("class ``classDecl.qualifiedName`` should be toplevel");
                return;
            }
            if( classDecl.abstract ) {
                fireError("class ``classDecl.qualifiedName`` should not be abstract");
                return;
            }
            if( classDecl.anonymous ) {
                fireError("class ``classDecl.qualifiedName`` should not be anonymous");
                return;
            }
            if( !classDecl.parameterDeclarations.empty ) {
                fireError("class ``classDecl.qualifiedName`` should have no parameters");
                return;
            }
            if( !classDecl.typeParameterDeclarations.empty ) {
                fireError("class ``classDecl.qualifiedName`` should have no type parameters");
                return;
            }
        }
        handler();
    }

    void verifyFunction(Anything(String) fireError, Anything() handler)() {
        if( funcDecl.annotations<TestAnnotation>().empty ) {
            fireError("function ``funcDecl.qualifiedName`` should be annotated with test");
            return;
        }
        if( !funcDecl.parameterDeclarations.empty ) {
            fireError("function ``funcDecl.qualifiedName`` should have no parameters");
            return;
        }
        if( !funcDecl.typeParameterDeclarations.empty ) {
            fireError("function ``funcDecl.qualifiedName`` should have no type parameters");
            return;
        }
        if(is OpenClassOrInterfaceType openType = funcDecl.openType, openType.declaration != `class Anything`) {
            fireError("function ``funcDecl.qualifiedName`` should be void");
            return;
        }
        handler();
    }

    void verifyCallbacks(Anything(String) fireError, Anything() handler)() {
        value callbacks = findCallbacks<BeforeTestAnnotation|AfterTestAnnotation>();
        for(callback in callbacks) {
            value callbackType = callback.annotations<BeforeTestAnnotation>().empty then "after" else "before";
            if( !callback.parameterDeclarations.empty ) {
                fireError("``callbackType`` callback ``callback.qualifiedName`` should have no parameters");
                return;
            }
            if( !callback.typeParameterDeclarations.empty ) {
                fireError("``callbackType`` callback ``callback.qualifiedName`` should have no type parameters");
                return;
            }
            if(is OpenClassOrInterfaceType openType = callback.openType, openType.declaration != `class Anything`) {
                fireError("``callbackType`` callback ``callback.qualifiedName`` should be void");
                return;
            }
        }
        handler();
    }

    void handleTestIgnore(TestRunContext context, Anything() handler)() {
        value ignoreAnnotation = findAnnotation<IgnoreAnnotation>(funcDecl, classDecl);
        if( exists ignoreAnnotation ) {
            context.fireTestIgnore(TestIgnoreEvent(TestResult(description, ignored, IgnoreException(ignoreAnnotation.reason))));
            return;
        }
        handler();
    }

    void handleTestExecution(TestRunContext context, Anything() handler)() {
        value i = !funcDecl.toplevel then getInstance() else null;
        value startTime = system.milliseconds;
        function elapsedTime() => system.milliseconds - startTime;

        try {
            context.fireTestStart(TestStartEvent(description, i));
            handler();
            context.fireTestFinish(TestFinishEvent(TestResult(description, success, null, elapsedTime()), i));
        }
        catch(Exception e) {
            if( e is AssertionException ) {
                context.fireTestFinish(TestFinishEvent(TestResult(description, failure, e, elapsedTime()), i));
            }
            else {
                context.fireTestFinish(TestFinishEvent(TestResult(description, error, e, elapsedTime()), i));
            }
        }
    }
    
    void handleBeforeCallbacks(Anything() handler)() {
        value callbacks = findCallbacks<BeforeTestAnnotation>().reversed;
        for(callback in callbacks) {
            invokeFunction(callback);
        }
        handler();
    }

    void handleAfterCallbacks(Anything() handler)() {
        value exceptionsBuilder = SequenceBuilder<Exception>();
        try {
            handler();
        }
        catch(Exception e) {
            exceptionsBuilder.append(e);
        }
        finally {
            value callbacks = findCallbacks<AfterTestAnnotation>();
            for(callback in callbacks) {
                try {
                    invokeFunction(callback);
                }
                catch(Exception e) {
                    exceptionsBuilder.append(e);
                }
            }
        }

        value exceptions = exceptionsBuilder.sequence;
        if( exceptions.size == 0 ) {
            // noop
        }
        else if( exceptions.size == 1 ) {
            assert(exists e = exceptions.first);
            throw e;
        }
        else {
            throw MultipleFailureException(exceptions);
        }
    }

    TestListener[] findListeners() {
        value listenersAnnotations = SequenceBuilder<TestListenersAnnotation>();
        if( exists classDecl ) {
            listenersAnnotations.appendAll(funcDecl.annotations<TestListenersAnnotation>());
            listenersAnnotations.appendAll(findAnnotations<TestListenersAnnotation>(classDecl));
            listenersAnnotations.appendAll(classDecl.containingPackage.annotations<TestListenersAnnotation>());
            listenersAnnotations.appendAll(classDecl.containingModule.annotations<TestListenersAnnotation>());
        }
        else {
            listenersAnnotations.appendAll(funcDecl.annotations<TestListenersAnnotation>());
            listenersAnnotations.appendAll(funcDecl.containingPackage.annotations<TestListenersAnnotation>());
            listenersAnnotations.appendAll(funcDecl.containingModule.annotations<TestListenersAnnotation>());
        }

        value listeners = SequenceBuilder<TestListener>();
        for(listenersAnnotation in listenersAnnotations.sequence) {
            for(listenerDecl in listenersAnnotation.listeners) {
                assert(is TestListener listener = listenerDecl.instantiate());
                listeners.append(listener);
            }
        }

        return listeners.sequence;
    }

    FunctionDeclaration[] findCallbacks<CallbackType>() {
        SequenceBuilder<FunctionDeclaration> callbacks = SequenceBuilder<FunctionDeclaration>();
        if( exists classDecl ) {
            variable ClassDeclaration? declVar = classDecl;
            while(exists decl = declVar) {
                callbacks.appendAll(decl.annotatedDeclaredMemberDeclarations<FunctionDeclaration, CallbackType>());
                declVar = decl.extendedType?.declaration;
            }
            declVar = classDecl;
            while(exists decl = declVar) {
                value pkgCallbacks = decl.containingPackage.annotatedMembers<FunctionDeclaration, CallbackType>();
                for(pkgCallback in pkgCallbacks) {
                    if( !callbacks.sequence.contains(pkgCallback) ) {
                       callbacks.append(pkgCallback);
                    }
                }
                declVar = decl.extendedType?.declaration;
            }
        }
        else {
            callbacks.appendAll(funcDecl.containingPackage.annotatedMembers<FunctionDeclaration, CallbackType>());
        }

        return callbacks.sequence;
    }

    void invokeTest() {
        invokeFunction(funcDecl);
    }
    
    void invokeFunction(FunctionDeclaration f) {
        if( f.toplevel ) {
            f.invoke();
        }
        else {
            f.memberInvoke(getInstance());
        }
    }

}

class GroupTestExecutor(description, TestExecutor[] children) satisfies TestExecutor {
    
    shared actual TestDescription description;

    shared actual void execute(TestRunContext context) {
        variable TestState worstState = ignored;
        void updateWorstState(TestState state) {
            if( compareStates(worstState, state) == smaller ) {
                worstState = state;
            }
        }
        object updateWorstStateListener satisfies TestListener {
            shared actual void testFinish(TestFinishEvent event) => updateWorstState(event.result.state);
            shared actual void testError(TestErrorEvent event) => updateWorstState(event.result.state);
            shared actual void testIgnore(TestIgnoreEvent event) => updateWorstState(ignored);
        }

        context.addTestListener(updateWorstStateListener);
        try {
            context.fireTestStart(TestStartEvent(description));
            value startTime = system.milliseconds;
            children*.execute(context);
            value endTime = system.milliseconds;
            context.fireTestFinish(TestFinishEvent(TestResult(description, worstState, null, endTime-startTime)));
        }
        finally {
            context.removeTestListener(updateWorstStateListener);
        }
    }

    Comparison compareStates(TestState state1, TestState state2) {
        if( state1 == state2 ) {
            return equal;
        }
        else if( state1 == ignored && (state2 == success || state2 == failure || state2 == error)) {
            return smaller;
        }
        else if( state1 == success && (state2 == failure || state2 == error)) {
            return smaller;
        }
        else if( state1 == failure && state2 == error) {
            return smaller;
        }
        else {
            return larger;
        }
    }

}

class ErrorTestExecutor(description, Exception exception) satisfies TestExecutor {

    shared actual TestDescription description;

    shared actual void execute(TestRunContext context) {
        context.fireTestError(TestErrorEvent(TestResult(description, error, exception)));
    }

}