"Represent a detailed result of the test."
shared interface TestResult {

    "The description of this test."
    shared formal TestDescription description;

    "The result state of this test."
    shared formal TestState state;

    "The exception thrown during this test, if any."
    shared formal Exception? exception;

    "The total elapsed time in miliseconds."
    shared formal Integer elapsedTime;

}