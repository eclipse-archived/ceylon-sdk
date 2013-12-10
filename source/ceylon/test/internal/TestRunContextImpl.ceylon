import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

class TestRunContextImpl(runner, result, listeners = []) satisfies TestRunContext {

    shared actual TestRunner runner;

    shared actual TestRunResult result;

    variable TestListener[] listeners;

    shared actual void addTestListener(TestListener* listenerArgs)
            => listeners = concatenate(listeners, listenerArgs);

    shared actual void removeTestListener(TestListener* listenerArgs)
            => listeners = listeners.select((TestListener l) => !listenerArgs.contains(l));

    shared actual void fireTestRunStart(TestRunStartEvent event)
            => fire((TestListener l)=> l.testRunStart(event));

    shared actual void fireTestRunFinish(TestRunFinishEvent event)
            => fire((TestListener l) => l.testRunFinish(event));

    shared actual void fireTestStart(TestStartEvent event)
            => fire((TestListener l) => l.testStart(event), true);

    shared actual void fireTestFinish(TestFinishEvent event)
            => fire((TestListener l) => l.testFinish(event));

    shared actual void fireTestError(TestErrorEvent event)
            => fire((TestListener l) => l.testError(event));

    shared actual void fireTestIgnore(TestIgnoreEvent event)
            => fire((TestListener l) => l.testIgnore(event));

    shared actual void fireTestExclude(TestExcludeEvent event)
            => fire((TestListener l) => l.testExclude(event));

    void fire(Anything(TestListener) handler, Boolean propagateException = false, TestListener* problematicListeners) {
        for(listener in listeners) {
            if( !problematicListeners.contains(listener) ) {
                try {
                    handler(listener);
                }
                catch(Exception e) {
                    if( propagateException ) {
                        throw e;
                    }
                    else {
                        value errorEvent = TestErrorEvent{
                                result = TestResult{
                                    description = TestDescription("test mechanism");
                                    state = error;
                                    exception = e;
                                };};
                        fire((TestListener l) => l.testError(errorEvent), false, listener, *problematicListeners);
                    }
                }
            }
        }
    }

}