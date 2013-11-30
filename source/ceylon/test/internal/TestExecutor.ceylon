import ceylon.language.meta {
    type
}
import ceylon.language.meta.declaration {
    AnnotatedDeclaration,
    ClassDeclaration,
    FunctionDeclaration,
    Package,
    OpenClassOrInterfaceType
}
import ceylon.language.meta.model {
    Class
}
import ceylon.test {
    AfterTest,
    BeforeTest,
    Test,
    TestComparator,
    TestDescription,
    TestFilter,
    TestListener,
    TestResult,
    TestState,
    Ignore,
    success,
    failure,
    error,
    ignored
}

interface TestExecutor {

    shared formal TestDescription description;

    shared formal void execute(TestListener notifier);

}

class ErrorTestExecutor(String name, Exception exception) satisfies TestExecutor {

    shared actual TestDescription description => TestDescriptionImpl(name);

    shared actual void execute(TestListener notifier) => notifier.testError(TestResultImpl(description, error, exception));

}

class ClassTestExecutor(
        ClassDeclaration classDecl, 
        FunctionDeclaration? funcDecl, 
        TestFilter filter, 
        TestComparator comparator) satisfies TestExecutor {

    function initChildren() {
        value executors = SequenceBuilder<TestExecutor>();
        if( exists funcDecl ) {
            executors.append(FunctionTestExecutor(funcDecl));
        }
        else {
            for(funcDecl in classDecl.annotatedMemberDeclarations<FunctionDeclaration, Test>()) {
                executors.append(FunctionTestExecutor(funcDecl));
            }
        }
        value filteredExecutors = filterExecutors(executors.sequence, filter);
        value sortedExecutors = sortExecutors(filteredExecutors, comparator);
        return sortedExecutors; 
    }

    TestExecutor[] children = initChildren();

    shared actual TestDescription description => TestDescriptionImpl(classDecl.qualifiedName, classDecl, children*.description);

    shared actual void execute(TestListener notifier) {
        Anything() handler =
                verifyTestClass(notifier,
                    handleTestIgnore(notifier,
                        handleTestExecution(notifier)));
        handler();
    }

    void verifyTestClass(TestListener notifier, Anything() handler)() {
        void notifyError(String msg) => notifier.testError(TestResultImpl(description, error, Exception(msg)));

        if( !classDecl.toplevel ) {
            notifyError("should be toplevel");
            return;
        }
        if( classDecl.abstract ) {
            notifyError("should not be abstract");
            return;
        }
        if( classDecl.anonymous ) {
            notifyError("should not be anonymous");
            return;
        }
        if( !classDecl.parameterDeclarations.empty ) {
            notifyError("should have no parameters");
            return;
        }
        if( !classDecl.typeParameterDeclarations.empty ) {
            notifyError("should have no type parameters");
            return;
        }
        if( children.empty ) {
            notifyError("should have testable methods");
            return;
        }

        handler();
    }

    void handleTestIgnore(TestListener notifier, Anything() handler)() {
        value ignoreAnnotations = classDecl.annotations<Ignore>();
        if( !ignoreAnnotations.empty ) {
            notifier.testIgnored(TestResultImpl(description, ignored, IgnoreException(ignoreAnnotations[0]?.reason else "")));
            return;
        }
        handler();
    }

    void handleTestExecution(TestListener notifier)() {
        variable TestState worstState = ignored;

        void updateWorstState(TestResult result) {
            if( compareStates(worstState, result.state) == smaller ) {
                worstState = result.state;
            }
        }

        object wrappedNotifier satisfies TestListener {
            shared actual void testStart(TestDescription description) {
                notifier.testStart(description);
            }
            shared actual void testFinish(TestResult result) {
                updateWorstState(result);
                notifier.testFinish(result);
            }
            shared actual void testIgnored(TestResult result) {
                updateWorstState(result);
                notifier.testIgnored(result);
            }
            shared actual void testError(TestResult result) {
                updateWorstState(result);
                notifier.testError(result);
            }
        }

        notifier.testStart(description);
        value startTime = system.milliseconds;
        children*.execute(wrappedNotifier);
        value endTime = system.milliseconds;
        notifier.testFinish(TestResultImpl(description, worstState, null, endTime-startTime));
    }
    
}

class FunctionTestExecutor(FunctionDeclaration funcDecl) satisfies TestExecutor {
    
    variable Object? instance = null;
    Object getInstance() {
        if( exists i = instance ) {
            return i;
        } else {
            assert(is ClassDeclaration classDecl = funcDecl.container);
            assert(is Class<Object, []> clazz = classDecl.apply<Object>());
            Object i = clazz();
            instance = i;
            return i;
        }
    }
    
    shared actual TestDescription description => TestDescriptionImpl(funcDecl.qualifiedName, funcDecl);
    
    shared actual void execute(TestListener notifier) {
        Anything() handler =          
                verifyTestMethod(notifier,
                    verifyBeforeAfterCallbacks(notifier,
                        handleTestIgnore(notifier, 
                            handleTestExecution(notifier,
                                handleAfterCallbacks(
                                    handleBeforeCallbacks(
                                        invokeTest()))))));
        handler();
    }
    
    void verifyTestMethod(TestListener notifier, Anything() handler)() {
        void notifyError(String msg) => notifier.testError(TestResultImpl(description, error, Exception(msg)));
        
        if( funcDecl.annotations<Test>().empty ) {
            notifyError("should be annotated with test");    
            return;
        }
        if( !funcDecl.parameterDeclarations.empty ) {
            notifyError("should have no parameters");
            return;
        }
        if( !funcDecl.typeParameterDeclarations.empty ) {
            notifyError("should have no type parameters");
            return;
        }
        if(is OpenClassOrInterfaceType openType = funcDecl.openType, openType.declaration != `class Anything`) {
            notifyError("should be void");
            return;
        }
        
        handler();
    }
    
    void verifyBeforeAfterCallbacks(TestListener notifier, Anything() handler)() {
        void notifyError(String msg) => notifier.testError(TestResultImpl(description, error, Exception(msg)));
        
        value callbacks = findCallbacks<BeforeTest|AfterTest>();
        for(callback in callbacks) {
            if( !callback.parameterDeclarations.empty ) {
                notifyError("callback ``callback.qualifiedName`` should have no parameters");
                return;
            }
            if( !callback.typeParameterDeclarations.empty ) {
                notifyError("callback ``callback.qualifiedName`` should have no type parameters");
                return;
            }
            if(is OpenClassOrInterfaceType openType = callback.openType, openType.declaration != `class Anything`) {
                notifyError("callback ``callback.qualifiedName`` should be void");
                return;
            }
        }
        
        handler();
    }
    
    void handleTestIgnore(TestListener notifier, Anything() handler)() {
        value ignoreAnnotations = funcDecl.annotations<Ignore>();
        if( !ignoreAnnotations.empty ) {
            notifier.testIgnored(TestResultImpl(description, ignored, IgnoreException(ignoreAnnotations[0]?.reason else "")));
            return;
        }
        handler();
    }
    
    void handleBeforeCallbacks(Anything() handler)() {
        value callbacks = findCallbacks<BeforeTest>();
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
            value callbacks = findCallbacks<AfterTest>().reversed;
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
    
    void handleTestExecution(TestListener notifier, Anything() handler)() {
        value startTime = system.milliseconds;
        function elapsedTime() => system.milliseconds - startTime; 
        try {
            notifier.testStart(description);
            handler();
            notifier.testFinish(TestResultImpl(description, success, null, elapsedTime()));
        }
        catch(Exception e) {
            if( e is AssertionException ) {
                notifier.testFinish(TestResultImpl(description, failure, e, elapsedTime()));
            }
            else {
                notifier.testFinish(TestResultImpl(description, error, e, elapsedTime()));
            }
        }
    }
    
    void invokeTest()() {
        invokeFunction(funcDecl);
    }
    
    FunctionDeclaration[] findCallbacks<CallbackType>() {
        SequenceBuilder<FunctionDeclaration> callbacks = SequenceBuilder<FunctionDeclaration>();
        
        AnnotatedDeclaration parent = funcDecl.container;
        if( is ClassDeclaration parent ) {
            callbacks.appendAll(parent.containingPackage.annotatedMembers<FunctionDeclaration, CallbackType>());
            
            variable value extendedType = parent.extendedType;
            while(exists extendedDeclaration = extendedType?.declaration) {
                callbacks.appendAll(extendedDeclaration.annotatedDeclaredMemberDeclarations<FunctionDeclaration, CallbackType>());
                extendedType = extendedDeclaration.extendedType;
            }
            
            callbacks.appendAll(parent.annotatedDeclaredMemberDeclarations<FunctionDeclaration, CallbackType>());
        }
        else if( is Package parent ) {
            callbacks.appendAll(parent.annotatedMembers<FunctionDeclaration, CallbackType>());                
        }
        
        return callbacks.sequence;
    }
    
    void invokeFunction(FunctionDeclaration fd) {
        if( fd.toplevel ) {
            fd.invoke();
        }
        else {
            fd.memberInvoke(getInstance());
        }
    }

}

class CallableTestExecutor(Anything() callable, String name = "Unnamed") satisfies TestExecutor {
    
    shared actual TestDescription description => TestDescriptionImpl(name, null);
    
    shared actual void execute(TestListener notifier) {
        Anything() handler =
                handleTestExecution(notifier,
                    invokeTest());
        handler();
    }
    
    void handleTestExecution(TestListener notifier, Anything() handler)() {
        value startTime = system.milliseconds;
        function elapsedTime() => system.milliseconds - startTime;
        try {
            notifier.testStart(description);
            handler();
            notifier.testFinish(TestResultImpl(description, success, null, elapsedTime()));
        }
        catch(Exception e) {
            if( e is AssertionException ) {
                notifier.testFinish(TestResultImpl(description, failure, e, elapsedTime()));
            }
            else {
                notifier.testFinish(TestResultImpl(description, error, e, elapsedTime()));
            }
        }
    }
    
    void invokeTest()() {
        callable();
    }
    
}


class IgnoreException(shared String reason) extends Exception(reason) {
}

class MultipleFailureException(shared Exception[] exceptions) extends Exception() {

    shared actual String message {
        value message = StringBuilder();
        message.append("There were ``exceptions.size`` exceptions:");
        for(Exception e in exceptions) {
            message.appendNewline();
            message.append("    ");
            message.append(type(e).declaration.qualifiedName);
            message.append("(");
            message.append(e.message);
            message.append(")");
        }
        return message.string;
    }

}

TestExecutor[] filterExecutors(TestExecutor[] executors, TestFilter filter) {
    return executors.select((TestExecutor e) => filter(e.description));
}

TestExecutor[] sortExecutors(TestExecutor[] executors, TestComparator comparator) {
    return executors.sort((TestExecutor e1, TestExecutor e2) => comparator(e1.description, e2.description));
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