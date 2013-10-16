import ceylon.test {
    createTestRunner,
    TestListener,
    TestDescription,
    TestRunResult,
    TestResult,
    error,
    success
}

void runTestListening() {
    runTests(
        `shouldFireEvents`,
        `shouldFireEventsForIgnored`,
        `shouldRecoverFromExceptions`,
        `shouldHandleExceptionOnTestRunStart`,
        `shouldHandleExceptionOnTestRunFinish`,
        `shouldHandleExceptionOnTestStart`,
        `shouldHandleExceptionOnTestFinish`,
        `shouldHandleExceptionDuringHandlingException`
    );
}

void shouldFireEvents() {
    createTestRunner(
        [`methodFoo`, `methodThrowingAssertion`, `methodThrowingException`, `methodWithoutTestAnnotation`, `ClassFoo.methodFoo`, `ClassWithoutTestableMethods`], 
        [recordingListener]).run();

    value lines = recordingListener.result.lines.sequence;
    assert(lines.size == 14,
        lines[0]?.equals("testRunStart") else false,
        lines[1]?.equals("testStart : test.ceylon.test::methodFoo") else false,
        lines[2]?.equals("testFinish : test.ceylon.test::methodFoo - success") else false,
        lines[3]?.equals("testStart : test.ceylon.test::methodThrowingAssertion") else false,
        lines[4]?.equals("testFinish : test.ceylon.test::methodThrowingAssertion - failure") else false,
        lines[5]?.equals("testStart : test.ceylon.test::methodThrowingException") else false,
        lines[6]?.equals("testFinish : test.ceylon.test::methodThrowingException - error") else false,
        lines[7]?.equals("testError : test.ceylon.test::methodWithoutTestAnnotation - should be annotated with test") else false,
        lines[8]?.equals("testStart : test.ceylon.test::ClassFoo") else false,
        lines[9]?.equals("testStart : test.ceylon.test::ClassFoo.methodFoo") else false,
        lines[10]?.equals("testFinish : test.ceylon.test::ClassFoo.methodFoo - success") else false,
        lines[11]?.equals("testFinish : test.ceylon.test::ClassFoo - success") else false,
        lines[12]?.equals("testError : test.ceylon.test::ClassWithoutTestableMethods - should have testable methods") else false,
        lines[13]?.equals("testRunFinish") else false);
}

void shouldFireEventsForIgnored() {
    createTestRunner(
        [`ignoredMethod`, `IgnoredClass`], 
        [recordingListener]).run();

    value lines = recordingListener.result.lines.sequence;
    assert(lines.size == 4,
        lines[0]?.equals("testRunStart") else false,
        lines[1]?.equals("testIgnored : test.ceylon.test::ignoredMethod - ignored") else false,
        lines[2]?.equals("testIgnored : test.ceylon.test::IgnoredClass - ignored") else false,
        lines[3]?.equals("testRunFinish") else false);
}

void shouldRecoverFromExceptions() {
    createTestRunner(
        [`methodFoo`], 
        [throwExceptionOnTestFinishListener, throwExceptionOnTestErrorListener, recordingListener]).run();

    value lines = recordingListener.result.lines.sequence;
    assert(lines.size == 6,
        lines[0]?.equals("testRunStart") else false,
        lines[1]?.equals("testStart : test.ceylon.test::methodFoo") else false,
        lines[2]?.equals("testError : test mechanism - testError") else false,
        lines[3]?.equals("testError : test mechanism - testFinish") else false,
        lines[4]?.equals("testFinish : test.ceylon.test::methodFoo - success") else false,
        lines[5]?.equals("testRunFinish") else false
    );
}

void shouldHandleExceptionOnTestRunStart() {
    value runResult = createTestRunner([`methodFoo`], [throwExceptionOnTestRunStartListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = error;
        message = "testRunStart";
    };
    assertResultContains {
        runResult;
        index = 1;
        state = success;
        source = `methodFoo`;
    };
}

void shouldHandleExceptionOnTestRunFinish() {
    value runResult = createTestRunner([`methodFoo`], [throwExceptionOnTestRunFinishListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = success;
        source = `methodFoo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = error;
        message = "testRunFinish";
    };
}

void shouldHandleExceptionOnTestStart() {
    value runResult = createTestRunner([`methodFoo`], [throwExceptionOnTestStartListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = error;
        message = "testStart";
    };
    assertResultContains {
        runResult;
        index = 1;
        state = success;
        source = `methodFoo`;
    };
}

void shouldHandleExceptionOnTestFinish() {
    value runResult = createTestRunner([`methodFoo`], [throwExceptionOnTestFinishListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = success;
        source = `methodFoo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = error;
        message = "testFinish";
    };
}

void shouldHandleExceptionDuringHandlingException() {
    value runResult = createTestRunner([`methodFoo`], [throwExceptionOnTestRunFinishListener, throwExceptionOnTestErrorListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 2;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = success;
        source = `methodFoo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = error;
        message = "testRunFinish";
    };
    assertResultContains {
        runResult;
        index = 2;
        state = error;
        message = "testError";
    };
}

object recordingListener satisfies TestListener {

    StringBuilder buffer = StringBuilder();

    shared String result => buffer.string;

    shared actual void testRunStart(TestDescription description) 
        => buffer.reset().append("testRunStart").appendNewline();

    shared actual void testRunFinish(TestRunResult result) 
        => buffer.append("testRunFinish");

    shared actual void testStart(TestDescription description) 
        => buffer.append("testStart : ``description.name``").appendNewline();

    shared actual void testFinish(TestResult result) 
        => buffer.append("testFinish : ``result.description.name`` - ``result.state``").appendNewline();

    shared actual void testIgnored(TestResult result) 
        => buffer.append("testIgnored : ``result.description.name`` - ``result.state``").appendNewline();

    shared actual void testError(TestResult result) 
        => buffer.append("testError : ``result.description.name`` - ``result.exception?.message else ""``").appendNewline();

}

object throwExceptionOnTestRunStartListener satisfies TestListener {
    shared actual void testRunStart(TestDescription description) {
        throw Exception("testRunStart");
    }
}

object throwExceptionOnTestRunFinishListener satisfies TestListener {
    shared actual void testRunFinish(TestRunResult result) {
        throw Exception("testRunFinish");
    }
}

object throwExceptionOnTestStartListener satisfies TestListener {
    shared actual void testStart(TestDescription description) {
        throw Exception("testStart");
    }
}

object throwExceptionOnTestFinishListener satisfies TestListener {
    shared actual void testFinish(TestResult result) {
        throw Exception("testFinish");
    }
}

object throwExceptionOnTestErrorListener satisfies TestListener {
    shared actual void testError(TestResult result) {
        throw Exception("testError");
    }
}