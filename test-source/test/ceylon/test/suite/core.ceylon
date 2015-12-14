import ceylon.language.meta.model {
    ...
}
import ceylon.language.meta.declaration {
    ...
}
import ceylon.test {
    ...
}
import test.ceylon.test.stubs {
    ...
}
import test.ceylon.test.stubs.ignored {
    ...
}

test
shared void shouldRunTest1() {
    void assertResultTestFoo(TestRunResult runResult) {
        assertResultCounts {
            runResult;
            successCount = 1;
        };
        assertResultContains {
            runResult;
            index = 0;
            state = TestState.success;
            source = `foo`;
        };
    }
    
    value result1 = createTestRunner([`foo`]).run();
    assertResultTestFoo(result1);
    
    value result2 = createTestRunner([`function foo`]).run();
    assertResultTestFoo(result2);
    
    value result3 = createTestRunner(["function test.ceylon.test.stubs::foo"]).run();
    assertResultTestFoo(result3);
    
    value result4 = createTestRunner(["test.ceylon.test.stubs::foo"]).run();
    assertResultTestFoo(result4);
}

test
shared void shouldRunTest2() {
    void assertResultTestBar(TestRunResult runResult) {
        assertResultCounts {
            runResult;
            successCount = 1;
        };
        assertResultContains {
            runResult;
            index = 0;
            state = TestState.success;
            source = `Bar.bar1`;
        };
        assertResultContains {
            runResult;
            index = 1;
            state = TestState.success;
            source = `Bar`;
        };
    }
    
    value result1 = createTestRunner([`Bar.bar1`]).run();
    assertResultTestBar(result1);
    
    value result2 = createTestRunner([`function Bar.bar1`]).run();
    assertResultTestBar(result2);
    
    value result3 = createTestRunner(["function test.ceylon.test.stubs::Bar.bar1"]).run();
    assertResultTestBar(result3);
    
    value result4 = createTestRunner(["test.ceylon.test.stubs::Bar.bar1"]).run();
    assertResultTestBar(result4);
}

test
shared void shouldRunTestThrowingAssertion() {
    value result = createTestRunner([`fooThrowingAssertion`]).run();
    assertResultCounts {
        result;
        failureCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.failure;
        source = `fooThrowingAssertion`;
        message = "assertion failed";
    };
}

test
shared void shouldRunTestThrowingException() {
    value result = createTestRunner([`fooThrowingException`]).run();
    assertResultCounts {
        result;
        errorCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.error;
        source = `fooThrowingException`;
        message = "unexpected exception";
    };
}

test
shared void shouldRunTestThrowingIgnoreException() {
    value result = createTestRunner([`fooThrowingIgnoreException`]).run();
    assertResultCounts {
        result;
        skippedCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.skipped;
        source = `fooThrowingIgnoreException`;
        message = "ignore it!";
    };
}

test
shared void shouldRunTestWithAssumption() {
    value result = createTestRunner([`fooWithAssumption`]).run();
    assertResultCounts {
        result;
        abortedCount = 1;
    };
    assertResultContains {
        result;
        state = TestState.aborted;
        source = `fooWithAssumption`;
    };
}

test
shared void shouldRunTestsInClass() {
    void assertResultTestsBar(TestRunResult runResult) {
        assertResultCounts {
            runResult;
            successCount = 2;
        };
        assertResultContains {
            runResult;
            index = 0;
            state = TestState.success;
            source = `Bar.bar1`;
        };
        assertResultContains {
            runResult;
            index = 1;
            state = TestState.success;
            source = `Bar.bar2`;
        };
        assertResultContains {
            runResult;
            index = 2;
            state = TestState.success;
            source = `Bar`;
        };
    }
    
    value result1 = createTestRunner([`Bar`]).run();
    assertResultTestsBar(result1);
    
    value result2 = createTestRunner([`class Bar`]).run();
    assertResultTestsBar(result2);
    
    value result3 = createTestRunner(["class test.ceylon.test.stubs::Bar"]).run();
    assertResultTestsBar(result3);
    
    value result4 = createTestRunner(["test.ceylon.test.stubs::Bar"]).run();
    assertResultTestsBar(result4);
}

test
shared void shouldRunTestsInPackage() {
    void assertResult(TestRunResult runResult) {
        assertResultCounts {
            runResult;
            runCount = 15;
            successCount = 13;
            failureCount = 1;
            errorCount = 1;
            skippedCount = 7;
            abortedCount = 1;
        };
    }
    
    function filter(TestDescription d) {
        return !d.name.contains("parameterized");
    }
    
    value result1 = createTestRunner([`package test.ceylon.test.stubs`], [], filter).run();
    assertResult(result1);
    
    value result2 = createTestRunner(["package test.ceylon.test.stubs"], [], filter).run();
    assertResult(result2);
    
    value result3 = createTestRunner(["test.ceylon.test.stubs"], [], filter).run();
    assertResult(result3);
}

test
shared void shouldRunTestsInModule() {
    void assertResult(TestRunResult runResult) {
        assertResultCounts {
            runResult;
            runCount = 21;
            successCount = 17;
            failureCount = 1;
            errorCount = 11;
            skippedCount = 8;
            abortedCount = 1;
        };
    }
    
    function filter(TestDescription d) {
        return !d.name.contains("parameterized");
    }
    
    value result1 = createTestRunner([`module test.ceylon.test.stubs`], [], filter).run();
    assertResult(result1);
    
    value result2 = createTestRunner(["module test.ceylon.test.stubs"], [], filter).run();
    assertResult(result2);
}

test
shared void shouldRunTestsFromAncestor() {
    value runResult = createTestRunner([`BarExtended`]).run();
    assertResultCounts {
        runResult;
        successCount = 3;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = TestState.success;
        source = `Bar.bar1`;
        name = "test.ceylon.test.stubs::BarExtended.bar1";
    };
    assertResultContains {
        runResult;
        index = 1;
        state = TestState.success;
        source = `Bar.bar2`;
        name = "test.ceylon.test.stubs::BarExtended.bar2";
    };
    assertResultContains {
        runResult;
        index = 2;
        state = TestState.success;
        source = `BarExtended.bar3`;
        name = "test.ceylon.test.stubs::BarExtended.bar3";
    };
    assertResultContains {
        runResult;
        index = 3;
        state = TestState.success;
        source = `BarExtended`;
        name = "test.ceylon.test.stubs::BarExtended";
    };
}

test
shared void shouldRunTestsFromAncestorOnExtendedInstance() {
    barInstance1 = null;
    barInstance2 = null;
    
    createTestRunner([`BarExtended`]).run();
    
    assert(is BarExtended i1 = barInstance1,
           is BarExtended i2 = barInstance2, 
           i1 != i2);    
}

test
shared void shouldRunTestsFromAnonymousClasses() {
    void assertResultTestBar(TestRunResult runResult) {
        assertResultCounts {
            runResult;
            successCount = 1;
        };
        assertResultContains {
            runResult;
            index = 0;
            state = TestState.success;
            source = `\Ibar.bar1`;
        };
        assertResultContains {
            runResult;
            index = 1;
            state = TestState.success;
            source = `class bar`;
        };
    }
    
    value result1 = createTestRunner([`class bar`]).run();
    assertResultTestBar(result1);
    
    value result2 = createTestRunner(["test.ceylon.test.stubs::bar"]).run();
    assertResultTestBar(result2);
    
    value result3 = createTestRunner(["class test.ceylon.test.stubs::bar"]).run();
    assertResultTestBar(result3);
    
    value result4 = createTestRunner(["test.ceylon.test.stubs::bar.bar1"]).run();
    assertResultTestBar(result4);
    
    value result5 = createTestRunner(["function test.ceylon.test.stubs::bar.bar1"]).run();
    assertResultTestBar(result5);
    
    value result6 = createTestRunner([`\Ibar.bar1`]).run();
    assertResultTestBar(result6);
    
    value result7 = createTestRunner([`function bar.bar1`]).run();
    assertResultTestBar(result7);
}

test
shared void shouldRunTestsInClassWithDefaultConstructor() {
    value result = createTestRunner([`class Qux`]).run();

    assertResultCounts {
        result;
        successCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `Qux.qux1`;
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.success;
        source = `class Qux`;
    };
}

test
shared void shouldRunTestsAndMeasureTime() {
    value startTime = system.milliseconds;
    value runResult = createTestRunner([`foo`, `Bar.bar1`, `fooWithIgnore`, `fooWithoutTestAnnotation`]).run();
    value endTime = system.milliseconds;
    
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

test
shared void shouldRunTestsWithUniqueInstances() {
    barInstance1 = null;
    barInstance2 = null;
    
    createTestRunner([`Bar`]).run();
    
    assert(exists i1 = barInstance1, 
    exists i2 = barInstance2, 
    i1 != i2);
}

test
shared void shouldRunTestWithCustomExecutor() {
    bazTestExecutorCounter = 0;
    bazTestInvocationCounter = 0;
    
    value result = createTestRunner([`bazWithCustomExecutor`]).run();
    
    assert(bazTestExecutorCounter == 1);
    assert(bazTestInvocationCounter == 1);
    
    assertResultCounts {
        result;
        successCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `bazWithCustomExecutor`;
    };
}

test
shared void shouldCompareTestState() {
    assert(TestState.error > TestState.failure,
           TestState.failure > TestState.success,
           TestState.aborted > TestState.skipped);
}

void assertResultCounts(TestRunResult runResult, Integer successCount = 0, Integer errorCount = 0, Integer failureCount = 0, Integer skippedCount = 0, Integer abortedCount = 0, Integer runCount = -1) {
    try {
        assert(runResult.successCount == successCount, 
               runResult.errorCount == errorCount, 
               runResult.failureCount == failureCount, 
               runResult.skippedCount == skippedCount,
               runResult.abortedCount == abortedCount);
        
        if( runCount == -1 ) {
            assert(runResult.runCount == successCount + errorCount + failureCount);
        }
        else {
            assert(runResult.runCount == runCount);
        }
        
        if( errorCount == 0 && failureCount == 0 && successCount > 0 ) {
            assert(runResult.isSuccess);
        }
    }
    catch(Throwable e) {
        print(runResult);
        throw e;
    }
}

void assertResultContains(TestRunResult runResult, Integer index = 0, TestState state = TestState.success, TestSource? source = null, String? name = null, String? message = null, String? variant = null) {
    try {
        assert(exists r = runResult.results[index], 
        r.state == state);
        
        if( exists source ) {
            if( is FunctionDeclaration source ) {
                assert(exists d = r.description.functionDeclaration, d == source);
            }
            else if( is ClassDeclaration source ) {
                assert(exists d = r.description.classDeclaration, d == source);
            }
            else if( is FunctionModel<> source ) {
                assert(exists d = r.description.functionDeclaration, d == source.declaration);
            }
            else if( is ClassModel<> source ) {
                assert(exists d = r.description.classDeclaration, d == source.declaration);
            }
        }
        if( exists name ) {
            assert(r.description.name == name);
        }
        if( exists message ) {
            assert(exists e = r.exception, e.message.contains(message));
        }
        if( exists variant ) {
            assert(exists v = r.description.variant, v == variant);
        }
        if( state == TestState.success ) {
            assert(!r.exception exists);
        }
    }
    catch(Throwable e) {
        print(runResult);
        throw e;
    }
}
