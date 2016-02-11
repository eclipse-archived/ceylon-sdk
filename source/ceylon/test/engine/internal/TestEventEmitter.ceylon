import ceylon.test {
    TestListener,
    TestResult,
    TestDescription,
    TestState
}
import ceylon.test.event {
    TestFinishedEvent,
    TestRunFinishedEvent,
    TestExcludedEvent,
    TestStartedEvent,
    TestErrorEvent,
    TestRunStartedEvent,
    TestAbortedEvent,
    TestSkippedEvent
}

shared class TestEventEmitter({TestListener*} listeners) satisfies TestListener {
    
    shared actual void testRunStarted(TestRunStartedEvent event)
            => fire((l) => l.testRunStarted(event));
    
    shared actual void testRunFinished(TestRunFinishedEvent event)
            => fire((l) => l.testRunFinished(event));
    
    shared actual void testStarted(TestStartedEvent event)
            => fire((l) => l.testStarted(event), true);
    
    shared actual void testFinished(TestFinishedEvent event)
            => fire((l) => l.testFinished(event));
    
    shared actual void testError(TestErrorEvent event)
            => fire((l) => l.testError(event));
    
    shared actual void testSkipped(TestSkippedEvent event)
            => fire((l) => l.testSkipped(event));
    
    shared actual void testAborted(TestAbortedEvent event)
            => fire((l) => l.testAborted(event));
    
    shared actual void testExcluded(TestExcludedEvent event)
            => fire((l) => l.testExcluded(event));
    
    void fire(Anything(TestListener) handler, Boolean propagateException = false, TestListener* problematicListeners) {
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
                        fire((l) => l.testError(errorEvent), false, listener, *problematicListeners);
                    }
                }
            }
        }
    }
    
}