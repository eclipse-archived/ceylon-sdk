import ceylon.test {
    createTestRunner,
    success,
    failure,
    error,
    ignored
}

void runTestString() {
    runTests(
        `testStateString`,
        `testDescriptionString`,
        `testResultString`,
        `testRunResultString1`,
        `testRunResultString2`,
        `testRunResultString3`);
}

void testStateString() {
    assert(success.string == "success");
    assert(failure.string == "failure");
    assert(error.string == "error");
    assert(ignored.string == "ignored");
}

void testDescriptionString() {
    value root = createTestRunner([`methodFoo`, `ClassFoo.methodFoo`]).description;
    assert(root.string == "root");
    assert((root.children[0]?.string else "") == "test.ceylon.test::methodFoo");
    assert((root.children[1]?.string else "") == "test.ceylon.test::ClassFoo");
    assert((root.children[1]?.children?.get(0)?.string else "") == "test.ceylon.test::ClassFoo.methodFoo");
}

void testResultString() {
    value runResult = createTestRunner([`methodFoo`, `methodThrowingException`, `ignoredMethod`]).run();
    assert(runResult.results[0]?.string?.equals("test.ceylon.test::methodFoo - success") else false);
    assert(runResult.results[1]?.string?.equals("test.ceylon.test::methodThrowingException - error (ceylon.language.Exception \"unexpected exception\")") else false);
    assert(runResult.results[2]?.string?.equals("test.ceylon.test::ignoredMethod - ignored (ceylon.test.internal.IgnoreException \"ignored method\")") else false);  
}

void testRunResultString1() {
    value runResult = createTestRunner([]).run();

    value expected = """TEST RESULTS
                        There were no tests!
                     """;

    assert(runResult.string == expected);
}

void testRunResultString2() {
    value runResult = createTestRunner([`methodFoo`, `ClassFoo`]).run();

    value expected = """TEST RESULTS
                        run:     3
                        success: 3
                        failure: 0
                        error:   0
                        ignored: 0
                    """;

    assert(runResult.string.contains(expected), 
           runResult.string.contains("TESTS SUCCESS"));
}

void testRunResultString3() {
    value runResult = createTestRunner([`methodFoo`, `methodThrowingException`, `ignoredMethod`]).run();
    
    value expected = """TEST RESULTS
                        run:     2
                        success: 1
                        failure: 0
                        error:   1
                        ignored: 1
                     """;

    assert(runResult.string.contains(expected), 
           runResult.string.contains("test.ceylon.test::methodThrowingException - error (ceylon.language.Exception \"unexpected exception\")"),
           runResult.string.contains("TESTS FAILED !"));
}