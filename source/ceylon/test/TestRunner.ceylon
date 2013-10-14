"Capable of running tests, notifying [[TestListener]]s about each test"
shared class TestRunner() {
    
    value testList = SequenceBuilder<TestUnit>();
    value testListenerList = SequenceBuilder<TestListener>();
    
    "The tests held by this instance"
    shared List<TestUnit> tests { 
        return testList.sequence; 
    }
    
    "Adds a test to be run"
    shared void addTest(String name, Anything() callable) {
        testList.append(TestUnit(name, callable));
    }
    
    "Adds a test listener to be notified about the execution of tests"
    shared void addTestListener(TestListener testListener) {
        testListenerList.append(testListener);
    }
    
    "Runs the [[tests]]"
    shared TestResult run() {
        TestRunner runner = this;
        TestResult result = TestResult(this);
        
        fire((TestListener l) => l.testRunStarted(runner));
        for(test in testList.sequence) {
            runTest(test);
        }
        fire((TestListener l) => l.testRunFinished(runner, result));
        
        return result;
    }
    
    void runTest(TestUnit test) {
        value startTime = system.milliseconds;
        test.state = running;
        fire((TestListener l) => l.testStarted(test));
        try {
            test.callable();
            test.state = success;
        } catch(AssertException e) {
            test.state = failure;
            test.exception = e;
        } catch(Exception e) {
            test.state = error;
            test.exception = e;
        } finally {
          value finishTime = system.milliseconds;
          test.elapsedTimeInMilis = finishTime - startTime;
        }
        fire((TestListener l) => l.testFinished(test));
    }
    
    void fire(void fireCallable(TestListener testListener)) {
        for(testListener in testListenerList.sequence) { 
            fireCallable(testListener);
        }
    }
    
}