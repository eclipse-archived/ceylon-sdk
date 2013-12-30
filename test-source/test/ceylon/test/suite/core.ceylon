import ceylon.language.meta.model {
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
            state = success;
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
            state = success;
            source = `Bar.bar1`;
        };
        assertResultContains {
            runResult;
            index = 1;
            state = success;
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
        state = failure;
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
        state = error;
        source = `fooThrowingException`;
        message = "unexpected exception";
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
            state = success;
            source = `Bar.bar1`;
        };
        assertResultContains {
            runResult;
            index = 1;
            state = success;
            source = `Bar.bar2`;
        };
        assertResultContains {
            runResult;
            index = 2;
            state = success;
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
            runCount = 10;
            successCount = 8;
            failureCount = 1;
            errorCount = 1;
            ignoreCount = 6;
        };
    }
    
    value result1 = createTestRunner([`package test.ceylon.test.stubs`]).run();
    assertResult(result1);
    
    value result2 = createTestRunner(["package test.ceylon.test.stubs"]).run();
    assertResult(result2);
    
    value result3 = createTestRunner(["test.ceylon.test.stubs"]).run();
    assertResult(result3);
}

test
shared void shouldRunTestsInModule() {
    void assertResult(TestRunResult runResult) {
        assertResultCounts {
            runResult;
            runCount = 14;
            successCount = 12;
            failureCount = 1;
            errorCount = 13;
            ignoreCount = 7;
        };
    }
    
    value result1 = createTestRunner([`module test.ceylon.test.stubs`]).run();
    assertResult(result1);
    
    value result2 = createTestRunner(["module test.ceylon.test.stubs"]).run();
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
        state = success;
        source = `Bar.bar1`;
        name = "test.ceylon.test.stubs::BarExtended.bar1";
    };
    assertResultContains {
        runResult;
        index = 1;
        state = success;
        source = `Bar.bar2`;
        name = "test.ceylon.test.stubs::BarExtended.bar2";
    };
    assertResultContains {
        runResult;
        index = 2;
        state = success;
        source = `BarExtended.bar3`;
        name = "test.ceylon.test.stubs::BarExtended.bar3";
    };
    assertResultContains {
        runResult;
        index = 3;
        state = success;
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
        state = success;
        source = `bazWithCustomExecutor`;
    };
}

test
shared void shouldRunTestWithCustomListener() {
    bazTestListenerLog.reset();
    
    value result = createTestRunner([`bazWithCustomListener`]).run();
    
    value lines = bazTestListenerLog.string.trimmed.lines.sequence;
    assertEquals(lines.size, 2);
    assertEquals(lines[0], "TestStartEvent[test.ceylon.test.stubs::bazWithCustomListener]");
    assertEquals(lines[1], "TestFinishEvent[test.ceylon.test.stubs::bazWithCustomListener - success]");
    
    assertResultCounts {
        result;
        successCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = success;
        source = `bazWithCustomListener`;
    };
}

void assertResultCounts(TestRunResult runResult, Integer successCount = 0, Integer errorCount = 0, Integer failureCount = 0, Integer ignoreCount = 0, Integer runCount = -1) {
    try {
        assert(runResult.successCount == successCount, 
        runResult.errorCount == errorCount, 
        runResult.failureCount == failureCount, 
        runResult.ignoreCount == ignoreCount);
        
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
    catch(Exception e) {
        print(runResult);
        throw e;
    }
}

void assertResultContains(TestRunResult runResult, Integer index = 0, TestState state = success, TestSource? source = null, String? name = null, String? message = null) {
    try {
        assert(exists r = runResult.results[index], 
        r.state == state);
        
        if( exists source ) {
            if( is Model source ) {
                assert(exists s = r.description.declaration, s == source.declaration);
            } else {
                assert(exists s = r.description.declaration, s == source);
            }
        }
        if( exists name ) {
            assert(r.description.name == name);
        }
        if( exists message ) {
            assert(exists e = r.exception, e.message.contains(message));
        }
        if( state == success ) {
            assert(!r.exception exists);
        }
    }
    catch(Exception e) {
        print(runResult);
        throw e;
    }
}