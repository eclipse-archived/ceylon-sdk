import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}
import ceylon.test.engine {
    DefaultTestVariantProvider
}

test
void testStateString() {
    assert(TestState.success.string == "success");
    assert(TestState.failure.string == "failure");
    assert(TestState.error.string == "error");
    assert(TestState.skipped.string == "skipped");
    assert(TestState.aborted.string == "aborted");
}

test
void testDescriptionString() {
    value root = createTestRunner([`foo`, `Bar.bar1`]).description;
    assert(root.string == "root");
    assert((root.children[0]?.string else "") == "test.ceylon.test.stubs::Bar");
    assert((root.children[0]?.children?.get(0)?.string else "") == "test.ceylon.test.stubs::Bar.bar1");
    assert((root.children[1]?.string else "") == "test.ceylon.test.stubs::foo");
}

test
void testResultString() {
    value sep = runtime.name == "jvm" then "." else "::";
    value runResult = createTestRunner([`foo`, `fooThrowingException`, `fooWithIgnore`]).run();
    assert(runResult.results[0]?.string?.equals("test.ceylon.test.stubs::foo - success") else false);
    assert(runResult.results[1]?.string?.equals("test.ceylon.test.stubs::fooThrowingException - error (ceylon.language``sep``Exception \"unexpected exception\")") else false);
    assert(runResult.results[2]?.string?.equals("test.ceylon.test.stubs::fooWithIgnore - skipped (ceylon.test.engine``sep``TestSkippedException \"ignore function foo\")") else false);  
}

test
void testRunResultString1() {
    value runResult = createTestRunner([]).run();
    
    value expected = """TEST RESULTS
                        There were no tests!
                        """;
    
    assert(runResult.string == expected);
}

test
void testRunResultString2() {
    value runResult = createTestRunner([`foo`, `Bar`]).run();
    
    value expected = """TEST RESULTS
                        run:      3
                        success:  3
                        failure:  0
                        error:    0
                        skipped:  0
                        aborted:  0
                        excluded: 0
                        """;
    
    assert(runResult.string.contains(expected), 
    runResult.string.contains("TESTS SUCCESS"));
}

test
void testRunResultString3() {
    value runResult = createTestRunner([`foo`, `fooThrowingException`, `fooWithIgnore`]).run();
    
    value expected = """TEST RESULTS
                        run:      2
                        success:  1
                        failure:  0
                        error:    1
                        skipped:  1
                        aborted:  0
                        excluded: 0
                        """;
    
    value sep = runtime.name == "jvm" then "." else "::";
    assert(runResult.string.contains(expected), 
    runResult.string.contains("test.ceylon.test.stubs::fooThrowingException - error (ceylon.language``sep``Exception \"unexpected exception\")"),
    runResult.string.contains("TESTS FAILED !"));
}

test
void testVariantProvider() {
    value description = TestDescription("test");
    value variantProvider = DefaultTestVariantProvider();
    void assertVariant(Anything[] args, String expected) {
        assertEquals(variantProvider.variant(description, 0, args), expected);
    }
    
    assertAll([
        () => assertVariant([], "()"),
        () => assertVariant([1], "(1)"),
        () => assertVariant([123, 0.987], "(123, 0.987)"),
        () => assertVariant([""], "(\"\")"),
        () => assertVariant(["abc"], "(\"abc\")"),
        () => assertVariant(['x'], "('x')"),
        () => assertVariant([null], "(<null>)"), 
        () => assertVariant([true, false], "(true, false)")
    ]);
}