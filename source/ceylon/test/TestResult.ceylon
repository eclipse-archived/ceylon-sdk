"Represents a detailed result of the execution of a particular test."
see (`interface TestRunResult`)
shared class TestResult(description, state, combined = false, exception = null, elapsedTime = 0) {
    
    "The test this is the result for."
    shared TestDescription description;
    
    "The result state of this test."
    shared TestState state;
    
    "The flag if this is result of one test, or combined result from multiple tests (eg. result for test class)."
    shared Boolean combined;
    
    "The exception thrown during this test, if any."
    shared Throwable? exception;
    
    "The total elapsed time in milliseconds."
    shared Integer elapsedTime;
    
    string => "``description`` - ``state```` (exception exists) then " (`` exception?.string else "" ``)" else "" ``";
    
}
