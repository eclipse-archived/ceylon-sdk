import ceylon.collection { LinkedList, MutableList }

shared class TestRunner() {
    
    MutableList<TestUnit> testList = LinkedList<TestUnit>();
    MutableList<TestListener> testListenerList = LinkedList<TestListener>();
    
    shared List<TestUnit> tests { 
        return testList; 
    }
    
    shared void addTest(String name, Void() callable) {
        testList.add(TestUnit(name, callable));
    }
    
    shared void addTestListener(TestListener testListener) {
        testListenerList.add(testListener);
    }
    
    shared TestResult run() {
        TestRunner runner = this;
        TestResult result = TestResult(this);
        
        fire((TestListener l) l.testRunStarted(runner));
        for(test in testList) {
            runTest(test);
        }
        fire((TestListener l) l.testRunFinished(runner, result));
        
        return result;
    }
    
    void runTest(TestUnit test) {
        value startTime = process.milliseconds;
        test.state := running;
        fire((TestListener l) l.testStarted(test));
        try {
            test.callable();
            test.state := success;
        } catch(AssertException e) {
            test.state := failure;
            test.exception := e;
        } catch(Exception e) {
            test.state := error;
            test.exception := e;
        } finally {
          value finishTime = process.milliseconds;
          test.elapsedTimeInMilis := finishTime - startTime;
        }
        fire((TestListener l) l.testFinished(test));
    }
    
    void fire(void fireCallable(TestListener testListener)) {
        for(testListener in testListenerList) { 
            fireCallable(testListener);
        }
    }
    
}