import ceylon.test {
    createTestRunner,
    error
}

void runTestBeforeAfter() {
    runTests(
        `shouldInvokeBeforeAfter`,
        `shouldInvokeBeforeAfterOnSameInstance`,
        `shouldVerifyBeforeNonVoid`,
        `shouldVerifyBeforeWithParameters`,
        `shouldVerifyBeforeWithTypeParameters`,
        `shouldVerifyAfterNonVoid`,
        `shouldVerifyAfterWithParameters`,
        `shouldVerifyAfterWithTypeParameters`,
        `shouldHandleExceptionInBeforeToplevelCallback`,
        `shouldHandleExceptionInBeforeMemberCallback`,
        `shouldHandleExceptionInAfterToplevelCallback`,
        `shouldHandleExceptionInAfterMemberCallback`,
        `shouldHandleExceptionsInCallbacks`
    );
}

void shouldInvokeBeforeAfter() {
    callbackLog.reset();

    createTestRunner([`ClassWithCallbacks`]).run();

    value lines = callbackLog.string.trimmed.lines.sequence;
    assert(lines.size == 7,
        lines[0]?.equals("toplevelBeforeTest") else false,
        lines[1]?.equals("memberInheritedBeforeTest") else false,
        lines[2]?.equals("memberBeforeTest") else false,
        lines[3]?.equals("methodWithCallbacks") else false,
        lines[4]?.equals("memberAfterTest") else false,
        lines[5]?.equals("memberInheritedAfterTest") else false,
        lines[6]?.equals("toplevelAfterTest") else false);
}

void shouldInvokeBeforeAfterOnSameInstance() {
    instanceInBefore = null;
    instanceInTest = null;
    instanceInAfter = null;

    createTestRunner([`ClassWithCallbacks`]).run();

    assert(exists i1 = instanceInBefore, 
           exists i2 = instanceInTest, 
           exists i3 = instanceInAfter, 
           i1 == i2, 
           i2 == i3);
}

void shouldVerifyBeforeNonVoid() {
    value runResult = createTestRunner([`ClassWithBeforeNonVoid`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithBeforeNonVoid.foo`;
        message = "callback test.ceylon.test::ClassWithBeforeNonVoid.before should be void";
    };
}

void shouldVerifyBeforeWithParameters() {
    value runResult = createTestRunner([`ClassWithBeforeWithParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithBeforeWithParameters.foo`;
        message = "callback test.ceylon.test::ClassWithBeforeWithParameters.before should have no parameters";
    };
}

void shouldVerifyBeforeWithTypeParameters() {
    value runResult = createTestRunner([`ClassWithBeforeWithTypeParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithBeforeWithTypeParameters.foo`;
        message = "callback test.ceylon.test::ClassWithBeforeWithTypeParameters.before should have no type parameters";
    };
}

void shouldVerifyAfterNonVoid() {
    value runResult = createTestRunner([`ClassWithAfterNonVoid`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithAfterNonVoid.foo`;
        message = "callback test.ceylon.test::ClassWithAfterNonVoid.after should be void";
    };
}

void shouldVerifyAfterWithParameters() {
    value runResult = createTestRunner([`ClassWithAfterWithParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithAfterWithParameters.foo`;
        message = "callback test.ceylon.test::ClassWithAfterWithParameters.after should have no parameters";
    };
}

void shouldVerifyAfterWithTypeParameters() {
    value runResult = createTestRunner([`ClassWithAfterWithTypeParameters`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `ClassWithAfterWithTypeParameters.foo`;
        message = "callback test.ceylon.test::ClassWithAfterWithTypeParameters.after should have no type parameters";
    };
}

void shouldHandleExceptionInBeforeToplevelCallback() {
    callbackLog.reset();
    toplevelBeforeTestThrowException = true;
    try {
        value runResult = createTestRunner([`ClassWithCallbacks`]).run();

        value lines = callbackLog.string.trimmed.lines.sequence;
        assert(lines.size == 4,
            lines[0]?.equals("toplevelBeforeTest") else false,
            lines[1]?.equals("memberAfterTest") else false,
            lines[2]?.equals("memberInheritedAfterTest") else false,
            lines[3]?.equals("toplevelAfterTest") else false);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `ClassWithCallbacks.methodWithCallbacks`;
            message = "toplevelBeforeTest";
        };
    }
    finally {
        toplevelBeforeTestThrowException = false;
    }
}

void shouldHandleExceptionInBeforeMemberCallback() {
    callbackLog.reset();
    memberBeforeTestThrowException = true;
    try {
        value runResult = createTestRunner([`ClassWithCallbacks`]).run();

        value lines = callbackLog.string.trimmed.lines.sequence;
        assert(lines.size == 6,
            lines[0]?.equals("toplevelBeforeTest") else false,
            lines[1]?.equals("memberInheritedBeforeTest") else false,
            lines[2]?.equals("memberBeforeTest") else false,
            lines[3]?.equals("memberAfterTest") else false,
            lines[4]?.equals("memberInheritedAfterTest") else false,
            lines[5]?.equals("toplevelAfterTest") else false);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `ClassWithCallbacks.methodWithCallbacks`;
            message = "memberBeforeTest";
        };
    }
    finally {
        memberBeforeTestThrowException = false;
    }
}

void shouldHandleExceptionInAfterToplevelCallback() {
    callbackLog.reset();
    toplevelAfterTestThrowException = true;
    try {
        value runResult = createTestRunner([`ClassWithCallbacks`]).run();

        value lines = callbackLog.string.trimmed.lines.sequence;
        assert(lines.size == 7,
            lines[0]?.equals("toplevelBeforeTest") else false,
            lines[1]?.equals("memberInheritedBeforeTest") else false,
            lines[2]?.equals("memberBeforeTest") else false,
            lines[3]?.equals("methodWithCallbacks") else false,
            lines[4]?.equals("memberAfterTest") else false,
            lines[5]?.equals("memberInheritedAfterTest") else false,
            lines[6]?.equals("toplevelAfterTest") else false);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `ClassWithCallbacks.methodWithCallbacks`;
            message = "toplevelAfterTest";
        };
    }
    finally {
        toplevelAfterTestThrowException = false;
    }
}

void shouldHandleExceptionInAfterMemberCallback() {
    callbackLog.reset();
    memberAfterTestThrowException = true;
    try {
        value runResult = createTestRunner([`ClassWithCallbacks`]).run();

        value lines = callbackLog.string.trimmed.lines.sequence;
        assert(lines.size == 7,
            lines[0]?.equals("toplevelBeforeTest") else false,
            lines[1]?.equals("memberInheritedBeforeTest") else false,
            lines[2]?.equals("memberBeforeTest") else false,
            lines[3]?.equals("methodWithCallbacks") else false,
            lines[4]?.equals("memberAfterTest") else false,
            lines[5]?.equals("memberInheritedAfterTest") else false,
            lines[6]?.equals("toplevelAfterTest") else false);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `ClassWithCallbacks.methodWithCallbacks`;
            message = "memberAfterTest";
        };
    }
    finally {
        memberAfterTestThrowException = false;
    }    
}

void shouldHandleExceptionsInCallbacks() {
    callbackLog.reset();
    toplevelBeforeTestThrowException = true;
    toplevelAfterTestThrowException = true;
    memberAfterTestThrowException = true;
    try {
        value runResult = createTestRunner([`ClassWithCallbacks`]).run();

        value lines = callbackLog.string.trimmed.lines.sequence;
        assert(lines.size == 4,
            lines[0]?.equals("toplevelBeforeTest") else false,
            lines[1]?.equals("memberAfterTest") else false,
            lines[2]?.equals("memberInheritedAfterTest") else false,
            lines[3]?.equals("toplevelAfterTest") else false);

        assertResultCounts {
            runResult;
            runCount = 1;
            errorCount = 1;
        };
        assertResultContains {
            runResult;
            state = error;
            source = `ClassWithCallbacks.methodWithCallbacks`;
            message = "There were 3 exceptions";
        };
    }
    finally {
        toplevelBeforeTestThrowException = false;
        toplevelAfterTestThrowException = false;
        memberAfterTestThrowException = false;
    }
}