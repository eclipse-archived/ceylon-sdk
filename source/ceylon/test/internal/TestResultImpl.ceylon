import ceylon.test {
    TestDescription,
    TestResult,
    TestState
}

class TestResultImpl(description, state, exception = null, elapsedTime = 0) satisfies TestResult {

    shared actual TestDescription description;

    shared actual TestState state;

    shared actual Exception? exception;

    shared actual Integer elapsedTime;

    shared actual String string => "``description`` - ``state````(exception exists) then " (``exception?.string else ""``)" else "" ``";

}