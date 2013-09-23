"Represents a detailed result of the execution of a 
 particular test."
see(`interface TestRunResult`)
shared interface TestResult {

    "The test this is the result for."
    shared formal TestDescription description;

    "The result state of this test."
    shared formal TestState state;

    "The exception thrown during this test, if any."
    shared formal Exception? exception;

    "The total elapsed time in miliseconds."
    shared formal Integer elapsedTime;

}