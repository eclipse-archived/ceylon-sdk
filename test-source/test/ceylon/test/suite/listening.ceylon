import test.ceylon.test.stubs {
    ...
}
import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

test
shared void shouldFireEvents() {
    createTestRunner(
        [`foo`, `fooThrowingAssertion`, `fooThrowingException`, `fooWithoutTestAnnotation`, `Bar.bar1`], 
        [recordingListener]).run();
    
    value lines = recordingListener.result.lines.sequence;
    assertEquals(lines.size, 13);
    assertEquals(lines[0], "TestRunStartEvent");
    assertEquals(lines[1], "TestStartEvent[test.ceylon.test.stubs::Bar]");
    assertEquals(lines[2], "TestStartEvent[test.ceylon.test.stubs::Bar.bar1]");
    assertEquals(lines[3], "TestFinishEvent[test.ceylon.test.stubs::Bar.bar1 - success]");
    assertEquals(lines[4], "TestFinishEvent[test.ceylon.test.stubs::Bar - success]");
    assertEquals(lines[5], "TestStartEvent[test.ceylon.test.stubs::foo]");
    assertEquals(lines[6], "TestFinishEvent[test.ceylon.test.stubs::foo - success]");
    assertEquals(lines[7], "TestStartEvent[test.ceylon.test.stubs::fooThrowingAssertion]");
    assertEquals(lines[8], "TestFinishEvent[test.ceylon.test.stubs::fooThrowingAssertion - failure (ceylon.language.AssertionException \"assertion failed\")]");
    assertEquals(lines[9], "TestStartEvent[test.ceylon.test.stubs::fooThrowingException]");
    assertEquals(lines[10], "TestFinishEvent[test.ceylon.test.stubs::fooThrowingException - error (ceylon.language.Exception \"unexpected exception\")]");
    assertEquals(lines[11], "TestErrorEvent[test.ceylon.test.stubs::fooWithoutTestAnnotation - error (ceylon.language.Exception \"function test.ceylon.test.stubs::fooWithoutTestAnnotation should be annotated with test or testSuite\")]");
    assertEquals(lines[12], "TestRunFinishEvent");
}

test
shared void shouldFireEventsForIgnored() {
    createTestRunner(
        [`fooWithIgnore`, `BarWithIgnore.bar1`], 
        [recordingListener]).run();
    
    value lines = recordingListener.result.lines.sequence;
    assertEquals(lines.size, 6);
    assertEquals(lines[0], "TestRunStartEvent");
    assertEquals(lines[1], "TestStartEvent[test.ceylon.test.stubs::BarWithIgnore]");
    assertEquals(lines[2], "TestIgnoreEvent[test.ceylon.test.stubs::BarWithIgnore.bar1 - ignored (ceylon.test.internal.IgnoreException \"\")]");
    assertEquals(lines[3], "TestFinishEvent[test.ceylon.test.stubs::BarWithIgnore - ignored]");
    assertEquals(lines[4], "TestIgnoreEvent[test.ceylon.test.stubs::fooWithIgnore - ignored (ceylon.test.internal.IgnoreException \"ignore function foo\")]");
    assertEquals(lines[5], "TestRunFinishEvent");
}

test
shared void shouldFireEventsWithoutInstanceForToplevelTest() {
    variable Boolean isNullInStart = false;
    variable Boolean isNullInFinish = false;
    
    object instanceChecker satisfies TestListener {
        shared actual void testStart(TestStartEvent event) => isNullInStart = !(event.instance exists);
        shared actual void testFinish(TestFinishEvent event) => isNullInFinish = !(event.instance exists);
    }
    
    createTestRunner([`foo`], [instanceChecker]).run();
    
    assert(isNullInStart, 
           isNullInFinish);
}

test
shared void shouldFireEventsWithInstanceForMemberTest() {
    barInstance1 = null;
    variable Object? instanceInStart = null;
    variable Object? instanceInFinish = null; 
    
    object instanceCatcher satisfies TestListener {
        shared actual void testStart(TestStartEvent event) {
            if( event.description.name == `function Bar.bar1`.qualifiedName ) {
                instanceInStart = event.instance;
            }
        }
        shared actual void testFinish(TestFinishEvent event) {
            if( event.result.description.name == `function Bar.bar1`.qualifiedName ) {
                instanceInFinish = event.instance;
            }
        }
    }
    
    createTestRunner([`Bar.bar1`], [instanceCatcher]).run();
    
    assert(exists i1 = barInstance1,
           exists i2 = instanceInStart,
           exists i3 = instanceInFinish,
           i1 == i2,
           i2 == i3);
}

test
shared void shouldHandleMultipleExceptions() {
    createTestRunner(
        [`foo`], 
        [throwExceptionOnTestFinishListener, throwExceptionOnTestErrorListener, recordingListener]).run();
    
    value lines = recordingListener.result.lines.sequence;
    assertEquals(lines.size, 6);
    assertEquals(lines[0], "TestRunStartEvent");
    assertEquals(lines[1], "TestStartEvent[test.ceylon.test.stubs::foo]");
    assertEquals(lines[2], "TestErrorEvent[test mechanism - error (ceylon.language.Exception \"testError\")]");
    assertEquals(lines[3], "TestErrorEvent[test mechanism - error (ceylon.language.Exception \"testFinish\")]");
    assertEquals(lines[4], "TestFinishEvent[test.ceylon.test.stubs::foo - success]");
    assertEquals(lines[5], "TestRunFinishEvent");
}

test
shared void shouldHandleExceptionOnTestRunStart() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestRunStartListener]).run();
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
        source = `foo`;
    };
}

test
shared void shouldHandleExceptionOnTestRunFinish() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestRunFinishListener]).run();
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
        source = `foo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = error;
        message = "testRunFinish";
    };
}

test
shared void shouldHandleExceptionOnTestFinish() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestFinishListener]).run();
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
        source = `foo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = error;
        message = "testFinish";
    };
}

test
shared void shouldHandleExceptionDuringHandlingException() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestRunFinishListener, throwExceptionOnTestErrorListener]).run();
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
        source = `foo`;
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

test
shared void shouldPropagateExceptionOnTestStart() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestStartListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        source = `foo`;
        state = error;
        message = "testStart";
    };
}

object recordingListener satisfies TestListener {
    
    StringBuilder buffer = StringBuilder();
    
    shared String result => buffer.string.trimmed;
    
    shared actual void testRunStart(TestRunStartEvent event) { buffer.reset(); log(event); } 
    
    shared actual void testRunFinish(TestRunFinishEvent event) => log(event); 
    
    shared actual void testStart(TestStartEvent event) => log(event); 
    
    shared actual void testFinish(TestFinishEvent event) => log(event); 
    
    shared actual void testIgnore(TestIgnoreEvent event) => log(event); 
    
    shared actual void testError(TestErrorEvent event) => log(event);
    
    void log(Object event) => buffer.append(event.string).appendNewline();
    
}

object throwExceptionOnTestRunStartListener satisfies TestListener {
    shared actual void testRunStart(TestRunStartEvent event) {
        throw Exception("testRunStart");
    }
}

object throwExceptionOnTestRunFinishListener satisfies TestListener {
    shared actual void testRunFinish(TestRunFinishEvent event) {
        throw Exception("testRunFinish");
    }
}

object throwExceptionOnTestStartListener satisfies TestListener {
    shared actual void testStart(TestStartEvent event) {
        throw Exception("testStart");
    }
}

object throwExceptionOnTestFinishListener satisfies TestListener {
    shared actual void testFinish(TestFinishEvent event) {
        throw Exception("testFinish");
    }
}

object throwExceptionOnTestErrorListener satisfies TestListener {
    shared actual void testError(TestErrorEvent event) {
        throw Exception("testError");
    }
}