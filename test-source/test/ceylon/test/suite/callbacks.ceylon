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

test
shared void shouldRunCallbacks1() {
    callbackLogger.clear();

    createTestRunner([`fooWithCallbacks`]).run();

    value lines = callbackLogger.string.trimmed.lines.sequence();
    assertEquals(lines.size, 3);
    assertEquals(lines[0], "fooToplevelBefore");
    assertEquals(lines[1], "fooWithCallbacks");
    assertEquals(lines[2], "fooToplevelAfter");
}

test
shared void shouldRunCallbacks2() {
    callbackLogger.clear();

    createTestRunner([`FooWithCallbacks`]).run();

    value lines = callbackLogger.string.trimmed.lines.sequence();
    assertEquals(lines.size, 5);
    assertEquals(lines[0], "fooToplevelBefore");
    assertEquals(lines[1], "FooWithCallbacks.fooBefore");
    assertEquals(lines[2], "FooWithCallbacks.foo");
    assertEquals(lines[3], "FooWithCallbacks.fooAfter");
    assertEquals(lines[4], "fooToplevelAfter");
}

test
shared void shouldRunCallbacksWithEqualInstance() {
    fooWithCallbacksInstanceInBefore = null;
    fooWithCallbacksInstanceInTest = null;
    fooWithCallbacksInstanceInAfter = null;

    createTestRunner([`FooWithCallbacks`]).run();

    assert(exists i1 = fooWithCallbacksInstanceInBefore, 
           exists i2 = fooWithCallbacksInstanceInTest, 
           exists i3 = fooWithCallbacksInstanceInAfter, 
           i1 == i2, 
           i2 == i3);
}

test
shared void shouldRunCallbacksFromAncestor() {
    callbackLogger.clear();

    createTestRunner([`BarWithCallbacks.bar`]).run();

    value lines = callbackLogger.string.trimmed.lines.sequence();
    assertEquals(lines.size, 13);
    assertEquals(lines[0], "fooToplevelBefore");
    assertEquals(lines[1], "barToplevelBefore");
    assertEquals(lines[2], "BarWithCallbacksInterface2.bar2Before");
    assertEquals(lines[3], "BarWithCallbacksInterface1.bar1Before");
    assertEquals(lines[4], "FooWithCallbacks.fooBefore");
    assertEquals(lines[5], "BarWithCallbacks.barBefore");
    assertEquals(lines[6], "BarWithCallbacks.bar");
    assertEquals(lines[7], "BarWithCallbacks.barAfter");
    assertEquals(lines[8], "FooWithCallbacks.fooAfter");
    assertEquals(lines[9], "BarWithCallbacksInterface1.bar1After");
    assertEquals(lines[10], "BarWithCallbacksInterface2.bar2After");
    assertEquals(lines[11], "barToplevelAfter");
    assertEquals(lines[12], "fooToplevelAfter");
}

test
shared void shouldRunCallbacksFromAncestorOnExtendedInstance() {
    fooWithCallbacksInstanceInBefore = null;
    fooWithCallbacksInstanceInAfter = null;

    createTestRunner([`BarWithCallbacks.bar`]).run();

    assert(is BarWithCallbacks i1 = fooWithCallbacksInstanceInBefore, 
           is BarWithCallbacks i2 = fooWithCallbacksInstanceInAfter, 
           i1 == i2);
}

test
shared void shouldHandleExceptionInBeforeToplevelCallback() {
    callbackLogger.clear();
    fooToplevelBeforeException = true;
    try {
        value runResult = createTestRunner([`FooWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines.size, 3);
        assertEquals(lines[0], "fooToplevelBefore");
        assertEquals(lines[1], "FooWithCallbacks.fooAfter");
        assertEquals(lines[2], "fooToplevelAfter");

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `FooWithCallbacks.foo`;
            message = "fooToplevelBeforeException";
        };
    }
    finally {
        fooToplevelBeforeException = false;
    }
}

test
shared void shouldHandleExceptionInBeforeMemberCallback() {
    callbackLogger.clear();
    fooMemberBeforeException = true;
    try {
        value runResult = createTestRunner([`FooWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines.size, 4);
        assertEquals(lines[0], "fooToplevelBefore");
        assertEquals(lines[1], "FooWithCallbacks.fooBefore");
        assertEquals(lines[2], "FooWithCallbacks.fooAfter");
        assertEquals(lines[3], "fooToplevelAfter");

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `FooWithCallbacks.foo`;
            message = "fooMemberBeforeException";
        };
    }
    finally {
        fooMemberBeforeException = false;
    }
}

test
shared void shouldHandleExceptionInAfterToplevelCallback() {
    callbackLogger.clear();
    fooToplevelAfterException = true;
    try {
        value runResult = createTestRunner([`FooWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines.size, 5);
        assertEquals(lines[0], "fooToplevelBefore");
        assertEquals(lines[1], "FooWithCallbacks.fooBefore");
        assertEquals(lines[2], "FooWithCallbacks.foo");
        assertEquals(lines[3], "FooWithCallbacks.fooAfter");
        assertEquals(lines[4], "fooToplevelAfter");

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `FooWithCallbacks.foo`;
            message = "fooToplevelAfterException";
        };
    }
    finally {
        fooToplevelAfterException = false;
    }
}

test
shared void shouldHandleExceptionInAfterMemberCallback() {
    callbackLogger.clear();
    fooMemberAfterException = true;
    try {
        value runResult = createTestRunner([`FooWithCallbacks`]).run();

        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines.size, 5);
        assertEquals(lines[0], "fooToplevelBefore");
        assertEquals(lines[1], "FooWithCallbacks.fooBefore");
        assertEquals(lines[2], "FooWithCallbacks.foo");
        assertEquals(lines[3], "FooWithCallbacks.fooAfter");
        assertEquals(lines[4], "fooToplevelAfter");
        
        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `FooWithCallbacks.foo`;
            message = "fooMemberAfterException";
        };
    }
    finally {
        fooMemberAfterException = false;
    }
}

test
shared void shouldHandleExceptionsInCallbacks() {
    callbackLogger.clear();
    fooToplevelBeforeException = true;
    fooToplevelAfterException = true;
    fooMemberAfterException = true;
    try {
        value runResult = createTestRunner([`FooWithCallbacks`]).run();
        
        value lines = callbackLogger.string.trimmed.lines.sequence();
        assertEquals(lines.size, 3);
        assertEquals(lines[0], "fooToplevelBefore");
        assertEquals(lines[1], "FooWithCallbacks.fooAfter");
        assertEquals(lines[2], "fooToplevelAfter");
        
        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `FooWithCallbacks.foo`;
            message = "There were 3 exceptions";
        };
    }
    finally {
        fooToplevelBeforeException = false;
        fooToplevelAfterException = false;
        fooMemberAfterException = false;
    }
}

test
shared void shouldVerifyBeforeNonVoid() {
    value runResult = createTestRunner([`BugBeforeNonVoid`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugBeforeNonVoid.f`;
        message = "before callback test.ceylon.test.stubs.beforeafter.bugs::BugBeforeNonVoid.before should be void";
    };
}

test
shared void shouldVerifyBeforeWithParameters() {
    value runResult = createTestRunner([`BugBeforeWithParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugBeforeWithParameters.f`;
        message = "before callback test.ceylon.test.stubs.beforeafter.bugs::BugBeforeWithParameters.before should have no parameters";
    };
}

test
shared void shouldVerifyBeforeWithTypeParameters() {
    value runResult = createTestRunner([`BugBeforeWithTypeParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugBeforeWithTypeParameters.f`;
        message = "before callback test.ceylon.test.stubs.beforeafter.bugs::BugBeforeWithTypeParameters.before should have no type parameters";
    };
}

test
shared void shouldVerifyAfterNonVoid() {
    value runResult = createTestRunner([`BugAfterNonVoid`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugAfterNonVoid.f`;
        message = "after callback test.ceylon.test.stubs.beforeafter.bugs::BugAfterNonVoid.after should be void";
    };
}

test
shared void shouldVerifyAfterWithParameters() {
    value runResult = createTestRunner([`BugAfterWithParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugAfterWithParameters.f`;
        message = "after callback test.ceylon.test.stubs.beforeafter.bugs::BugAfterWithParameters.after should have no parameters";
    };
}

test
shared void shouldVerifyAfterWithTypeParameters() {
    value runResult = createTestRunner([`BugAfterWithTypeParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `BugAfterWithTypeParameters.f`;
        message = "after callback test.ceylon.test.stubs.beforeafter.bugs::BugAfterWithTypeParameters.after should have no type parameters";
    };
}