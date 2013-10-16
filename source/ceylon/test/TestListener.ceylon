"Represents a listener which will be notified about events that occur during a test run."
shared interface TestListener {

    "Called before any tests have been run."
    shared default void testRunStart(
        "The description of the tests to be run."
        TestDescription description) {}

    "Called after all tests have finished."
    shared default void testRunFinish(
        "The summary result of the test run."
        TestRunResult result) {}

    "Called when a test is about to be started."
    shared default void testStart(
        "The description of test to be started"
        TestDescription description) {}

    "Called when a test has finished, whether the test succeeds or not."
    shared default void testFinish(
        "The detailed test result."
        TestResult result) {}

    "Called when a test will *not* be run, because it is marked with [[ignore]] annotation."
    shared default void testIgnored(
        "The detailed test result."
        TestResult result) {}

    "Called when a test will not be run, because some error has occured. 
     For example a invalid test function signature."
    shared default void testError(
        "The test result."
        TestResult result) {}

}