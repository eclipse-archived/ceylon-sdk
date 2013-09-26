import ceylon.test {
    createTestRunner,
    success,
    failure,
    error,
    ignored,
    TestDescription,
    TestRunResult
}

void runTestRunning() {
    runTests(
        `shouldInvokeToplevelMethod`,
        `shouldInvokeToplevelMethod2`,
        `shouldInvokeMemberMethod`,
        `shouldInvokeMemberMethod2`,
        `shouldInvokeMemberMethod3`,
        `shouldInvokeMemberMethod4`,
        `shouldInvokeMemberMethod5`,
        `shouldInvokeMethodThrowingAssertion`,
        `shouldInvokeMethodThrowingException`,
        `shouldIgnoreTestMethod`,
        `shouldIgnoreTestClass`,
        `shouldIgnoreTestClass2`,
        `shouldInvokeTestsInPackage`,
        `shouldInvokeTestsInPackage2`,
        `shouldInvokeTestsInModule`,
        `shouldInvokeTestsInModule2`,
        `shouldInvokeMemberMethodsOnDiferentInstances`,
        `shouldMeasureTime`
    );
}

void shouldInvokeToplevelMethod() {
    value runResult = createTestRunner([`methodFoo`]).run();
    assertResultMethodFoo(runResult);}

void shouldInvokeToplevelMethod2() {
    value runResult = createTestRunner(["function test.ceylon.test::methodFoo"]).run();
    assertResultMethodFoo(runResult);
}

void assertResultMethodFoo(TestRunResult runResult) {
    assertResultCounts {
        runResult;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = success;
        source = `methodFoo`;
    };
}

void shouldInvokeMemberMethod() {
    value runResult = createTestRunner{
            sources=[`ClassFoo`]; 
            comparator = (TestDescription d1, TestDescription d2)=>d1.name.compare(d2.name); 
        }.run();
    assertResultClassFoo(runResult);
}

void shouldInvokeMemberMethod2() {
    value runResult = createTestRunner{
        sources=["class test.ceylon.test::ClassFoo"]; 
        comparator = (TestDescription d1, TestDescription d2)=>d1.name.compare(d2.name); 
    }.run();
    assertResultClassFoo(runResult);
}

void assertResultClassFoo(TestRunResult runResult) {
    assertResultCounts {
        runResult;
        successCount = 2;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = success;
        source = `ClassFoo.methodBar`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = success;
        source = `ClassFoo.methodFoo`;
    };
    assertResultContains {
        runResult;
        index = 2;
        state = success;
        source = `ClassFoo`;
    };
}

void shouldInvokeMemberMethod3() {
    value runResult = createTestRunner([`ClassFoo.methodFoo`]).run();
    assertResultClassFooMethodFoo(runResult);
}

void shouldInvokeMemberMethod4() {
    value runResult = createTestRunner([`function ClassFoo.methodFoo`]).run();
    assertResultClassFooMethodFoo(runResult);
}

void shouldInvokeMemberMethod5() {
    value runResult = createTestRunner(["function test.ceylon.test::ClassFoo.methodFoo"]).run();
    assertResultClassFooMethodFoo(runResult);
}

void assertResultClassFooMethodFoo(TestRunResult runResult) {
    assertResultCounts {
        runResult;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = success;
        source = `ClassFoo.methodFoo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = success;
        source = `ClassFoo`;
    };
}

void shouldInvokeMethodThrowingAssertion() {
    value runResult = createTestRunner([`methodThrowingAssertion`]).run();
    assertResultCounts {
        runResult;
        failureCount = 1;
    };
    assertResultContains {
        runResult;
        state = failure;
        source = `methodThrowingAssertion`;
        message = "Assertion failed";
    };
}

void shouldInvokeMethodThrowingException() {
    value runResult = createTestRunner([`methodThrowingException`]).run();
    assertResultCounts {
        runResult;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        state = error;
        source = `methodThrowingException`;
        message = "unexpected exception";
    };
}

void shouldIgnoreTestMethod() {
    value runResult = createTestRunner([`ignoredMethod`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        ignoreCount = 1;
    };
    assertResultContains {
        runResult;
        state = ignored;
        source = `ignoredMethod`;
        message = "ignored method";
    };
}

void shouldIgnoreTestClass() {
    value runResult = createTestRunner([`IgnoredClass`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        ignoreCount = 1;
    };
    assertResultContains {
        runResult;
        state = ignored;
        source = `IgnoredClass`;
        message = "ignored class";
    };
}

void shouldIgnoreTestClass2() {
    value runResult = createTestRunner([`IgnoredClass.methodFoo`]).run();
    assertResultCounts {
        runResult;
        runCount = 0;
        ignoreCount = 1;
    };
    assertResultContains {
        runResult;
        state = ignored;
        source = `IgnoredClass`;
        message = "ignored class";
    };
}

void shouldInvokeTestsInPackage() {
    value runResult = createTestRunner([`package test.ceylon.test`]).run();
    assertResultPackage(runResult);
}

void shouldInvokeTestsInPackage2() {
    value runResult = createTestRunner(["package test.ceylon.test"]).run();
    assertResultPackage(runResult);
}

void shouldInvokeTestsInModule() {
    value runResult = createTestRunner([`module test.ceylon.test`]).run();
    assertResultPackage(runResult);
}

void shouldInvokeTestsInModule2() {
    value runResult = createTestRunner(["module test.ceylon.test"]).run();
    assertResultPackage(runResult);
}

void assertResultPackage(TestRunResult runResult) {
    assertResultCounts {
        runResult;
        runCount = 6;
        successCount = 4;
        failureCount = 1;
        errorCount = 13;
        ignoreCount = 2;
    };
}

void shouldInvokeMemberMethodsOnDiferentInstances() {
    instance1 = null;
    instance2 = null;

    createTestRunner([`ClassFoo`]).run();

    assert(exists i1 = instance1, 
           exists i2 = instance2, 
           i1 != i2);
}

void shouldMeasureTime() {
    value startTime = process.milliseconds;
    value runResult = createTestRunner([`methodFoo`, `ClassFoo.methodFoo`, `ignoredMethod`, `methodWithoutTestAnnotation`]).run();
    value endTime = process.milliseconds;

    assert(
        runResult.startTime >= startTime,
        runResult.endTime <= endTime,
        runResult.elapsedTime == runResult.endTime - runResult.startTime,
        (runResult.results[0]?.elapsedTime else -1) > 0,
        (runResult.results[1]?.elapsedTime else -1) > 0,
        (runResult.results[2]?.elapsedTime else -1) > 0,
        (runResult.results[3]?.elapsedTime else -1) == 0,
        (runResult.results[4]?.elapsedTime else -1) == 0
     );
}