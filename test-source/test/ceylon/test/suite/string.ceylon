import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}

test
shared void testStateString() {
    assert(success.string == "success");
    assert(failure.string == "failure");
    assert(error.string == "error");
    assert(ignored.string == "ignored");
}

test
shared void testDescriptionString() {
    value root = createTestRunner([`foo`, `Bar.bar1`]).description;
    assert(root.string == "root");
    assert((root.children[0]?.string else "") == "test.ceylon.test.stubs::Bar");
    assert((root.children[0]?.children?.get(0)?.string else "") == "test.ceylon.test.stubs::Bar.bar1");
    assert((root.children[1]?.string else "") == "test.ceylon.test.stubs::foo");
}

test
shared void testResultString() {
    value runResult = createTestRunner([`foo`, `fooThrowingException`, `fooWithIgnore`]).run();
    assert(runResult.results[0]?.string?.equals("test.ceylon.test.stubs::foo - success") else false);
    assert(runResult.results[1]?.string?.equals("test.ceylon.test.stubs::fooThrowingException - error (ceylon.language.Exception \"unexpected exception\")") else false);
    assert(runResult.results[2]?.string?.equals("test.ceylon.test.stubs::fooWithIgnore - ignored (ceylon.test.internal.IgnoreException \"ignore function foo\")") else false);  
}

test
shared void testRunResultString1() {
    value runResult = createTestRunner([]).run();
    
    value expected = """TEST RESULTS
                        There were no tests!
                        """;
    
    assert(runResult.string == expected);
}

test
shared void testRunResultString2() {
    value runResult = createTestRunner([`foo`, `Bar`]).run();
    
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

test
shared void testRunResultString3() {
    value runResult = createTestRunner([`foo`, `fooThrowingException`, `fooWithIgnore`]).run();
    
    value expected = """TEST RESULTS
                        run:     2
                        success: 1
                        failure: 0
                        error:   1
                        ignored: 1
                        """;
    
    assert(runResult.string.contains(expected), 
    runResult.string.contains("test.ceylon.test.stubs::fooThrowingException - error (ceylon.language.Exception \"unexpected exception\")"),
    runResult.string.contains("TESTS FAILED !"));
}