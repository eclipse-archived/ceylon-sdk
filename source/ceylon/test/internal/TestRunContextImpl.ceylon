import ceylon.collection {
    ...
}
import ceylon.language.meta.declaration {
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

shared class TestRunContextImpl(runner, result) satisfies TestRunContext {
    
    shared actual TestRunner runner;
    
    shared actual TestRunResult result;
    
    value listenersList = ArrayList<TestListener>();
    
    value listenersCache = HashMap<ClassDeclaration,TestListener>();
    
    shared actual void addTestListener(TestListener* listeners)
            => listenersList.addAll(listeners);
    
    shared actual void removeTestListener(TestListener* listeners)
            => listenersList.removeAll(listeners);
    
    shared actual void fireTestRunStarted(TestRunStartedEvent event)
            => fire(event.runner.description, (TestListener l) => l.testRunStarted(event));
    
    shared actual void fireTestRunFinished(TestRunFinishedEvent event)
            => fire(event.runner.description, (TestListener l) => l.testRunFinished(event));
    
    shared actual void fireTestStarted(TestStartedEvent event)
            => fire(event.description, (TestListener l) => l.testStarted(event), true);
    
    shared actual void fireTestFinished(TestFinishedEvent event)
            => fire(event.result.description, (TestListener l) => l.testFinished(event));
    
    shared actual void fireTestError(TestErrorEvent event)
            => fire(event.result.description, (TestListener l) => l.testError(event));
    
    shared actual void fireTestSkipped(TestSkippedEvent event)
            => fire(event.result.description, (TestListener l) => l.testSkipped(event));
    
    shared actual void fireTestAborted(TestAbortedEvent event)
            => fire(event.result.description, (TestListener l) => l.testAborted(event));
    
    shared actual void fireTestExcluded(TestExcludedEvent event)
            => fire(null, (TestListener l) => l.testExcluded(event));
    
    void fire(TestDescription? description, Anything(TestListener) handler, Boolean propagateException = false) {
        value listeners = ArrayList<TestListener>();
        listeners.addAll(listenersList);
        listeners.addAll(findListeners(description));
        
        fire2(listeners, handler, propagateException);
    }
    
    void fire2({TestListener*} listeners, Anything(TestListener) handler, Boolean propagateException, TestListener* problematicListeners) {
        for (listener in listeners) {
            if (!problematicListeners.contains(listener)) {
                try {
                    handler(listener);
                }
                catch (Throwable e) {
                    if (propagateException) {
                        throw e;
                    } else {
                        value errorEvent = TestErrorEvent {
                            result = TestResult {
                                description = TestDescription("test mechanism");
                                state = TestState.error;
                                exception = e;
                            };
                        };
                        fire2(listeners, (TestListener l) => l.testError(errorEvent), false, listener, *problematicListeners);
                    }
                }
            }
        }
    }
    
    {TestListener*} findListeners(TestDescription? description) {
        value listeners = ArrayList<TestListener>();
        if (exists description) {
            
            value listenerClasses = HashSet<ClassDeclaration>();
            findListenerClasses(description, listenerClasses);
            
            for (listenerClass in listenerClasses) {
                if (listenersCache.keys.contains(listenerClass)) {
                    assert (exists listener = listenersCache.get(listenerClass));
                    listeners.add(listener);
                } else {
                    if( listenerClass.anonymous ) {
                        assert(is TestListener listener = listenerClass.objectValue?.get());
                        listeners.add(listener);
                    } else {
                        assert (is TestListener listener = listenerClass.instantiate());
                        listenersCache.put(listenerClass, listener);
                        listeners.add(listener);
                    }
                }
            }
        }
        return listeners;
    }
    
    void findListenerClasses(TestDescription description, MutableSet<ClassDeclaration> listenerClasses) {
        if (exists funcDecl = description.functionDeclaration) {
            if (exists classDecl = description.classDeclaration) {
                findListenerClasses2(funcDecl, listenerClasses);
                findListenerClasses2(classDecl, listenerClasses);
                findListenerClasses2(classDecl.containingPackage, listenerClasses);
                findListenerClasses2(classDecl.containingModule, listenerClasses);
            } else {
                findListenerClasses2(funcDecl, listenerClasses);
                findListenerClasses2(funcDecl.containingPackage, listenerClasses);
                findListenerClasses2(funcDecl.containingModule, listenerClasses);
            }
        }
        for (child in description.children) {
            findListenerClasses(child, listenerClasses);
        }
    }
    
    void findListenerClasses2(AnnotatedDeclaration declaration, MutableSet<ClassDeclaration> listenerClasses) {
        if (is ClassDeclaration declaration) {
            variable ClassDeclaration? declVar = declaration;
            while (exists decl = declVar) {
                for (a in decl.annotations<TestListenersAnnotation>()) {
                    listenerClasses.addAll(a.listeners);
                }
                declVar = decl.extendedType?.declaration;
            }
        } else {
            for (a in declaration.annotations<TestListenersAnnotation>()) {
                listenerClasses.addAll(a.listeners);
            }
        }
    }
}
