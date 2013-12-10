import ceylon.test.event {
    ...
}

"Represents a listener which will be notified about events that occur during a test run.
 
 Example of simple listener, which triggers alarm whenever test fails.
 
     shared class RingingListener() satisfies TestListener {
         shared actual void testError(TestErrorEvent event) => alarm.ring();
     }
 
 ... such listener can be used directly when creating [[TestRunner]]
 
     TestRunner runner = createTestRunner{
         sources = [`module com.acme`];
         listeners = [RingingListener()];};
 
 ... or better declaratively with usage of [[testListeners]] annotation
 
     testListeners({`class RingingListener`})
     module com.acme;
"
shared interface TestListener {
    
    "Called before any tests have been run."
    shared default void testRunStart(
        "The event object."
        TestRunStartEvent event) {}

    "Called after all tests have finished."
    shared default void testRunFinish(
        "The event object."
        TestRunFinishEvent event) {}

    "Called when a test is about to be started."
    shared default void testStart(
        "The event object."
        TestStartEvent event) {}

    "Called when a test has finished, whether the test succeeds or not."
    shared default void testFinish(
        "The event object."
        TestFinishEvent event) {}

    "Called when a test will *not* be run, because it is marked with [[ignore]] annotation."
    shared default void testIgnore(
        "The event object."
        TestIgnoreEvent event) {}

    "Called when a test will not be run, because some error has occured.
     For example a invalid test function signature."
    shared default void testError(
        "The event object."
        TestErrorEvent event) {}

    "Called when a test is excluded from the test run due [[TestFilter]]"
    shared default void testExclude(
        "The event object."
        TestExcludeEvent event) {}

}