import ceylon.test.event {
    ...
}

"Represents a context in which a test is executed, it's used by [[TestExecutor]]s."
shared interface TestRunContext {
    
    "The current test runner."
    shared formal TestRunner runner;
    
    "The summary result of the test run."
    shared formal TestRunResult result;
    
    "Add given listeners into test context."
    shared formal void addTestListener(
        "The listeners for adding."
        TestListener* listeners);
    
    "Remove given listeners into test context."
    shared formal void removeTestListener(
        "The listeners for removing."
        TestListener* listeners);
    
    "Fire [[TestListener.testRunStarted]] event."
    shared formal void fireTestRunStarted(
        "The event object."
        TestRunStartedEvent event);
    
    "Fire [[TestListener.testRunFinished]] event."
    shared formal void fireTestRunFinished(
        "The event object."
        TestRunFinishedEvent event);
    
    "Fire [[TestListener.testStarted]] event."
    shared formal void fireTestStarted(
        "The event object."
        TestStartedEvent event);
    
    "Fire [[TestListener.testFinished]] event."
    shared formal void fireTestFinished(
        "The event object."
        TestFinishedEvent event);
    
    "Fire [[TestListener.testSkipped]] event."
    shared formal void fireTestSkipped(
        "The event object."
        TestSkippedEvent event);
    
    "Fire [[TestListener.testAborted]] event."
    shared formal void fireTestAborted(
        "The event object."
        TestAbortedEvent event);
    
    "Fire [[TestListener.testError]] event."
    shared formal void fireTestError(
        "The event object."
        TestErrorEvent event);
    
    "Fire [[TestListener.testExcluded]] event."
    shared formal void fireTestExcluded(
        "The event object."
        TestExcludedEvent event);
}
