import ceylon.test {
    ...
}
import test.ceylon.test.stubs.beforeafter {
    ...
}
import test.ceylon.test.stubs.beforeafter.bugs {
    ...
}
import test.ceylon.test.stubs.beforeafter.sub {
    ...
}
import test.ceylon.test.stubs.bugs {
    BugClassWithBeforeTestRunCallback,
    BugClassWithAfterTestRunCallback
}

test
void shouldRunCallbacks1() {
    callbackLogger.clear();

    createTestRunner([`testWithCallbacks`]).run();

    value lines = callbackLogger.string.trimmed.lines.sequence();
    assertEquals(lines, [
            "beforeTestRun1",
            "beforeTest1",
            "testWithCallbacks",
            "afterTest1",
            "afterTestRun1"]);
}

test
void shouldRunCallbacks2() {
    callbackLogger.clear();

    createTestRunner([`TestWithCallbacks`]).run();

    value lines = callbackLogger.string.trimmed.lines.sequence();
    assertEquals(lines, [
            "beforeTestRun1",
            "beforeTest1",
            "TestWithCallbacks.beforeTest2",
            "TestWithCallbacks.test2",
            "TestWithCallbacks.afterTest2",
            "afterTest1",
            "afterTestRun1"]);
}

test
void shouldRunCallbacksWithEqualInstance() {
    testWithCallbacksInstanceInBefore = null;
    testWithCallbacksInstanceInTest = null;
    testWithCallbacksInstanceInAfter = null;

    createTestRunner([`TestWithCallbacks`]).run();

    assert(exists i1 = testWithCallbacksInstanceInBefore, 
           exists i2 = testWithCallbacksInstanceInTest, 
           exists i3 = testWithCallbacksInstanceInAfter, 
           i1 == i2, 
           i2 == i3);
}

test
void shouldRunCallbacksFromAncestor() {
    callbackLogger.clear();

    createTestRunner([`BarWithCallbacks.bar`]).run();

    value lines = callbackLogger.string.trimmed.lines.sequence();
    assertEquals(lines, [
        "beforeTestRun1",
        "beforeTest1",
        "beforeTest3",
        "BarWithCallbacksInterface2.bar2Before",
        "BarWithCallbacksInterface1.bar1Before",
        "TestWithCallbacks.beforeTest2",
        "BarWithCallbacks.barBefore",
        "BarWithCallbacks.bar",
        "BarWithCallbacks.barAfter",
        "TestWithCallbacks.afterTest2",
        "BarWithCallbacksInterface1.bar1After",
        "BarWithCallbacksInterface2.bar2After",
        "afterTest3",
        "afterTest1",
        "afterTestRun1"]);
}

test
void shouldRunCallbacksFromAncestorOnExtendedInstance() {
    testWithCallbacksInstanceInBefore = null;
    testWithCallbacksInstanceInAfter = null;

    createTestRunner([`BarWithCallbacks.bar`]).run();

    assert(is BarWithCallbacks i1 = testWithCallbacksInstanceInBefore, 
           is BarWithCallbacks i2 = testWithCallbacksInstanceInAfter, 
           i1 == i2);
}

test
void shouldHandleExceptionInBeforeRunCallback() {
    callbackLogger.clear();
    beforeTestRun1Exception = true;
    try {
        value runResult = createTestRunner([`testWithCallbacks`]).run();
        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines, [
            "beforeTestRun1",
            "afterTestRun1"]);
        
        assertResultCounts {
            runResult;
            runCount = 0;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = TestState.error;
            message = "beforeTestRun1Exception";
        };
    }
    finally {
        beforeTestRun1Exception = false;
    }
}

test
void shouldHandleExceptionInBeforeToplevelCallback() {
    callbackLogger.clear();
    beforeTest1Exception = true;
    try {
        value runResult = createTestRunner([`TestWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines, [
            "beforeTestRun1",
            "beforeTest1",
            "TestWithCallbacks.afterTest2",
            "afterTest1",
            "afterTestRun1"]);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = TestState.error;
            source = `TestWithCallbacks.test2`;
            message = "beforeTest1Exception";
        };
    }
    finally {
        beforeTest1Exception = false;
    }
}

test
void shouldHandleExceptionInBeforeMemberCallback() {
    callbackLogger.clear();
    beforeTest2Exception = true;
    try {
        value runResult = createTestRunner([`TestWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines, [
            "beforeTestRun1",
            "beforeTest1",
            "TestWithCallbacks.beforeTest2",
            "TestWithCallbacks.afterTest2",
            "afterTest1",
            "afterTestRun1"]);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = TestState.error;
            source = `TestWithCallbacks.test2`;
            message = "beforeTest2Exception";
        };
    }
    finally {
        beforeTest2Exception = false;
    }
}

test
void shouldHandleExceptionInAfterToplevelCallback() {
    callbackLogger.clear();
    afterTest1Exception = true;
    try {
        value runResult = createTestRunner([`TestWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines, [
            "beforeTestRun1",
            "beforeTest1",
            "TestWithCallbacks.beforeTest2",
            "TestWithCallbacks.test2",
            "TestWithCallbacks.afterTest2",
            "afterTest1",
            "afterTestRun1"]);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = TestState.error;
            source = `TestWithCallbacks.test2`;
            message = "afterTest1Exception";
        };
    }
    finally {
        afterTest1Exception = false;
    }
}

test
void shouldHandleExceptionInAfterMemberCallback() {
    callbackLogger.clear();
    afterTest2Exception = true;
    try {
        value runResult = createTestRunner([`TestWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines, [
            "beforeTestRun1",
            "beforeTest1",
            "TestWithCallbacks.beforeTest2",
            "TestWithCallbacks.test2",
            "TestWithCallbacks.afterTest2",
            "afterTest1",
            "afterTestRun1"]);
        
        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = TestState.error;
            source = `TestWithCallbacks.test2`;
            message = "afterTest2Exception";
        };
    }
    finally {
        afterTest2Exception = false;
    }
}

test
void shouldHandleExceptionsInCallbacks() {
    callbackLogger.clear();
    beforeTest1Exception = true;
    afterTest1Exception = true;
    afterTest2Exception = true;
    try {
        value runResult = createTestRunner([`TestWithCallbacks`]).run();
        
        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines, [
            "beforeTestRun1",
            "beforeTest1",
            "TestWithCallbacks.afterTest2",
            "afterTest1",
            "afterTestRun1"]);
        
        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = TestState.error;
            source = `TestWithCallbacks.test2`;
        };
    }
    finally {
        beforeTest1Exception = false;
        afterTest1Exception = false;
        afterTest2Exception = false;
    }
}

test
void shouldVerifyBeforeNonVoid() {
    value runResult = createTestRunner([`BugBeforeNonVoid`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `BugBeforeNonVoid.f`;
        message = "before callback test.ceylon.test.stubs.beforeafter.bugs::BugBeforeNonVoid.before should be void";
    };
}

test
void shouldVerifyBeforeWithParameters() {
    value runResult = createTestRunner([`BugBeforeWithParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `BugBeforeWithParameters.f`;
        message = "function test.ceylon.test.stubs.beforeafter.bugs::BugBeforeWithParameters.before has parameter s without specified ArgumentProvider";
    };
}

test
void shouldVerifyBeforeWithTypeParameters() {
    value runResult = createTestRunner([`BugBeforeWithTypeParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `BugBeforeWithTypeParameters.f`;
        message = "before callback test.ceylon.test.stubs.beforeafter.bugs::BugBeforeWithTypeParameters.before should have no type parameters";
    };
}

test
void shouldVerifyAfterNonVoid() {
    value runResult = createTestRunner([`BugAfterNonVoid`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `BugAfterNonVoid.f`;
        message = "after callback test.ceylon.test.stubs.beforeafter.bugs::BugAfterNonVoid.after should be void";
    };
}

test
void shouldVerifyAfterWithParameters() {
    value runResult = createTestRunner([`BugAfterWithParameters`]).run();
    assertResultCounts {
        runResult;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `BugAfterWithParameters.f`;
        message = "function test.ceylon.test.stubs.beforeafter.bugs::BugAfterWithParameters.after has parameter s without specified ArgumentProvider";
    };
}

test
void shouldVerifyAfterWithTypeParameters() {
    value runResult = createTestRunner([`BugAfterWithTypeParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `BugAfterWithTypeParameters.f`;
        message = "after callback test.ceylon.test.stubs.beforeafter.bugs::BugAfterWithTypeParameters.after should have no type parameters";
    };
}

test
void shouldVerifyClassWithBeforeTestRunCallback() {
    TestRunResult runResult = createTestRunner([`class BugClassWithBeforeTestRunCallback`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `function BugClassWithBeforeTestRunCallback.f`;
        message = "class test.ceylon.test.stubs.bugs::BugClassWithBeforeTestRunCallback should not contain before test run callbacks: [beforeTestRunCallback]";
    };
}

test
void shouldVerifyClassWithAfterTestRunCallback() {
    TestRunResult runResult = createTestRunner([`class BugClassWithAfterTestRunCallback`]).run();
    
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = TestState.error;
        source = `function BugClassWithAfterTestRunCallback.f`;
        message = "class test.ceylon.test.stubs.bugs::BugClassWithAfterTestRunCallback should not contain after test run callbacks: [afterTestRunCallback]";
    };
}