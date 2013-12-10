"Represents a detailed result of the execution of a particular test."
see(`interface TestRunResult`)
shared class TestResult(description, state, exception = null, elapsedTime = 0) {

    "The test this is the result for."
    shared TestDescription description;

    "The result state of this test."
    shared TestState state;

    "The exception thrown during this test, if any."
    shared Exception? exception;

    "The total elapsed time in miliseconds."
    shared Integer elapsedTime;

    shared actual String string => "``description`` - ``state````(exception exists) then " (``exception?.string else ""``)" else "" ``";

}