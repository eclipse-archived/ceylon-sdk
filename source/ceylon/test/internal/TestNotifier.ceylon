import ceylon.test {
    TestDescription,
    TestListener,
    TestResult,
    TestRunResult,
    error
}

class TestNotifier(TestListener[] listeners) satisfies TestListener {

    shared actual void testRunStart(TestDescription description) => notifyListeners((TestListener l) => l.testRunStart(description));

    shared actual void testRunFinish(TestRunResult result) => notifyListeners((TestListener l) => l.testRunFinish(result));

    shared actual void testStart(TestDescription description) => notifyListeners((TestListener l) => l.testStart(description));

    shared actual void testFinish(TestResult result) => notifyListeners((TestListener l) => l.testFinish(result));

    shared actual void testIgnored(TestResult result) => notifyListeners((TestListener l) => l.testIgnored(result));

    shared actual void testError(TestResult result) => notifyListeners((TestListener l) => l.testError(result));

    void notifyListeners(Anything(TestListener) handler, TestListener* problematicListeners) {
        for(listener in listeners) {
            if( !problematicListeners.contains(listener) ) {
                try {
                    handler(listener);
                }
                catch(Exception e) {
                    value internalDesc = TestDescriptionImpl("test mechanism");
                    value internalResult = TestResultImpl(internalDesc, error, e);
                    notifyListeners((TestListener l) => l.testError(internalResult), listener, *problematicListeners);
                }
            }
        }
    }

}