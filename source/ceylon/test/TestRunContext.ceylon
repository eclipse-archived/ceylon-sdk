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
        "The listeners for adding." TestListener* listeners);

    "Remove given listeners into test context."
    shared formal void removeTestListener(
        "The listeners for removing." TestListener* listeners);

    "Fire [[TestListener.testRunStart]] event."
    shared formal void fireTestRunStart(
        "The event object." TestRunStartEvent event);

    "Fire [[TestListener.testRunFinish]] event."
    shared formal void fireTestRunFinish(
        "The event object." TestRunFinishEvent event);

    "Fire [[TestListener.testStart]] event."
    shared formal void fireTestStart(
        "The event object." TestStartEvent event);

    "Fire [[TestListener.testFinish]] event."
    shared formal void fireTestFinish(
        "The event object." TestFinishEvent event);

    "Fire [[TestListener.testIgnore]] event."
    shared formal void fireTestIgnore(
        "The event object." TestIgnoreEvent event);

    "Fire [[TestListener.testError]] event."
    shared formal void fireTestError(
        "The event object." TestErrorEvent event);

    "Fire [[TestListener.testExclude]] event."
    shared formal void fireTestExclude(
        "The event object." TestExcludeEvent event);

}