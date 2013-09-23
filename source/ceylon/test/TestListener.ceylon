"Represent a listener which allow to be notified about events that occur during test run."
shared interface TestListener {

    "Called before any tests have been run."
    shared default void testRunStart(
        "Contains description of all tests to be run."
        TestDescription description) {}

    "Called after all tests have finished."
    shared default void testRunFinish(
        "Contains summary result of the test run."
        TestRunResult result) {}

    "Called when a test is about to be started."
    shared default void testStart(
        "Contains description of test."
        TestDescription description) {}

    "Called when a test has finished, whether the test succeeds or not."
    shared default void testFinish(
        "Contains detailed test result."
        TestResult result) {}

    "Called when a test will not be run, because it is marked with [[ignore]] annotation."
    shared default void testIgnored(
        "Contains detailed test result."
        TestResult result) {}

    "Called when a test will not be run, because some error occure (eg. invalid test function signature)."
    shared default void testError(
        "Contains detailed test result."
        TestResult result) {}

}