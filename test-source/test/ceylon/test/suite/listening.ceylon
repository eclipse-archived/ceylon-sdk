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
        [`foo`, `fooThrowingAssertion`, `fooThrowingException`, `fooWithoutTestAnnotation`, `fooWithAssumption`, `Bar.bar1`], 
        [recordingListener]).run();
    
    value lines = recordingListener.result.lines.sequence();
    value sep = runtime.name == "jvm" then "." else "::";
    assertEquals(lines.size, 15);
    assertEquals(lines[0], "TestRunStartedEvent");
    assertEquals(lines[1], "TestStartedEvent[test.ceylon.test.stubs::Bar]");
    assertEquals(lines[2], "TestStartedEvent[test.ceylon.test.stubs::Bar.bar1]");
    assertEquals(lines[3], "TestFinishedEvent[test.ceylon.test.stubs::Bar.bar1 - success]");
    assertEquals(lines[4], "TestFinishedEvent[test.ceylon.test.stubs::Bar - success]");
    assertEquals(lines[5], "TestStartedEvent[test.ceylon.test.stubs::foo]");
    assertEquals(lines[6], "TestFinishedEvent[test.ceylon.test.stubs::foo - success]");
    assertEquals(lines[7], "TestStartedEvent[test.ceylon.test.stubs::fooThrowingAssertion]");
    assertEquals(lines[8], "TestFinishedEvent[test.ceylon.test.stubs::fooThrowingAssertion - failure (ceylon.language``sep``AssertionError \"assertion failed\")]");
    assertEquals(lines[9], "TestStartedEvent[test.ceylon.test.stubs::fooThrowingException]");
    assertEquals(lines[10], "TestFinishedEvent[test.ceylon.test.stubs::fooThrowingException - error (ceylon.language``sep``Exception \"unexpected exception\")]");
    assertEquals(lines[11], "TestStartedEvent[test.ceylon.test.stubs::fooWithAssumption]");
    assertEquals(lines[12], "TestAbortedEvent[test.ceylon.test.stubs::fooWithAssumption - aborted (ceylon.test.engine``sep``TestAbortedException \"assumption failed: expected true\")]");
    assertEquals(lines[13], "TestErrorEvent[test.ceylon.test.stubs::fooWithoutTestAnnotation - error (ceylon.language``sep``Exception \"function test.ceylon.test.stubs::fooWithoutTestAnnotation should be annotated with test or testSuite\")]");
    assertEquals(lines[14], "TestRunFinishedEvent");
}

test
shared void shouldFireEventsForIgnored() {
    createTestRunner(
        [`fooWithIgnore`, `BarWithIgnore.bar1`], 
        [recordingListener]).run();
    
    value lines = recordingListener.result.lines.sequence();
    value sep = runtime.name == "jvm" then "." else "::";
    assertEquals(lines.size, 6);
    assertEquals(lines[0], "TestRunStartedEvent");
    assertEquals(lines[1], "TestStartedEvent[test.ceylon.test.stubs::BarWithIgnore]");
    assertEquals(lines[2], "TestSkippedEvent[test.ceylon.test.stubs::BarWithIgnore.bar1 - skipped (ceylon.test.engine``sep``TestSkippedException \"\")]");
    assertEquals(lines[3], "TestFinishedEvent[test.ceylon.test.stubs::BarWithIgnore - skipped]");
    assertEquals(lines[4], "TestSkippedEvent[test.ceylon.test.stubs::fooWithIgnore - skipped (ceylon.test.engine``sep``TestSkippedException \"ignore function foo\")]");
    assertEquals(lines[5], "TestRunFinishedEvent");
}

test
shared void shouldFireEventsWithoutInstanceForToplevelTest() {
    variable Boolean isNullInStart = false;
    variable Boolean isNullInFinish = false;
    
    object instanceChecker satisfies TestListener {
        shared actual void testStarted(TestStartedEvent event) => isNullInStart = !(event.instance exists);
        shared actual void testFinished(TestFinishedEvent event) => isNullInFinish = !(event.instance exists);
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
        shared actual void testStarted(TestStartedEvent event) {
            if( event.description.name == `function Bar.bar1`.qualifiedName ) {
                instanceInStart = event.instance;
            }
        }
        shared actual void testFinished(TestFinishedEvent event) {
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
        [throwExceptionOnTestFinishedListener, throwExceptionOnTestErrorListener, recordingListener]).run();
    
    value lines = recordingListener.result.lines.sequence();
    value sep = runtime.name == "jvm" then "." else "::";
    assertEquals(lines.size, 6);
    assertEquals(lines[0], "TestRunStartedEvent");
    assertEquals(lines[1], "TestStartedEvent[test.ceylon.test.stubs::foo]");
    assertEquals(lines[2], "TestErrorEvent[test mechanism - error (ceylon.language``sep``Exception \"testError\")]");
    assertEquals(lines[3], "TestErrorEvent[test mechanism - error (ceylon.language``sep``Exception \"testFinished\")]");
    assertEquals(lines[4], "TestFinishedEvent[test.ceylon.test.stubs::foo - success]");
    assertEquals(lines[5], "TestRunFinishedEvent");
}

test
shared void shouldHandleExceptionOnTestRunStarted() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestRunStartedListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = TestState.error;
        message = "testRunStarted";
    };
    assertResultContains {
        runResult;
        index = 1;
        state = TestState.success;
        source = `foo`;
    };
}

test
shared void shouldHandleExceptionOnTestRunFinished() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestRunFinishedListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = TestState.success;
        source = `foo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = TestState.error;
        message = "testRunFinished";
    };
}

test
shared void shouldHandleExceptionOnTestFinished() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestFinishedListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = TestState.success;
        source = `foo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = TestState.error;
        message = "testFinished";
    };
}

test
shared void shouldHandleExceptionDuringHandlingException() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestRunFinishedListener, throwExceptionOnTestErrorListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 2;
        successCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        state = TestState.success;
        source = `foo`;
    };
    assertResultContains {
        runResult;
        index = 1;
        state = TestState.error;
        message = "testRunFinished";
    };
    assertResultContains {
        runResult;
        index = 2;
        state = TestState.error;
        message = "testError";
    };
}

test
shared void shouldPropagateExceptionOnTestStarted() {
    value runResult = createTestRunner([`foo`], [throwExceptionOnTestStartedListener]).run();
    assertResultCounts {
        runResult;
        runCount = 1;
        errorCount = 1;
    };
    assertResultContains {
        runResult;
        index = 0;
        source = `foo`;
        state = TestState.error;
        message = "testStarted";
    };
}

test
shared void shouldNotifyListenerSpecifiedViaAnnotation() {
    bazTestListenerLog.clear();
    
    value result = createTestRunner([`bazWithCustomListener`]).run();
    
    value lines = bazTestListenerLog.string.trimmed.lines.sequence();
    assertEquals(lines.size, 2);
    assertEquals(lines[0], "TestStartedEvent[test.ceylon.test.stubs::bazWithCustomListener]");
    assertEquals(lines[1], "TestFinishedEvent[test.ceylon.test.stubs::bazWithCustomListener - success]");
    
    assertResultCounts {
        result;
        successCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `bazWithCustomListener`;
    };
}

test
shared void shouldNotifyListenerSpecifiedViaAnnotationOnlyOnceEventIfOccurMoreTimes() {
    bazTestListenerLog.clear();
    
    createTestRunner([`BazWithCustomListener`]).run();
    
    value lines = bazTestListenerLog.string.trimmed.lines.sequence();
    assertEquals(lines.size, 4);
    assertEquals(lines[0], "TestStartedEvent[test.ceylon.test.stubs::BazWithCustomListener]");
    assertEquals(lines[1], "TestStartedEvent[test.ceylon.test.stubs::BazWithCustomListener.baz1]");
    assertEquals(lines[2], "TestFinishedEvent[test.ceylon.test.stubs::BazWithCustomListener.baz1 - success]");
    assertEquals(lines[3], "TestFinishedEvent[test.ceylon.test.stubs::BazWithCustomListener - success]");
}

test
shared void shouldNotifyListenerSpecifiedViaAnnotationWithUsageOfSingleInstancePerRun() {
    bazTestListenerCounter = 0;
    createTestRunner([`bazWithCustomListener`, `BazWithCustomListener`]).run();
    assert(bazTestListenerCounter == 1);
}

test
shared void shouldNotifyListenerSpecifiedViaAnnotationWithAnonymousTestListener() {
    bazTestListenerLog.clear();
    
    value result = createTestRunner([`bazWithAnonymousTestListener`]).run();
    
    value lines = bazTestListenerLog.string.trimmed.lines.sequence();
    assertEquals(lines.size, 2);
    assertEquals(lines[0], "TestStartedEvent[test.ceylon.test.stubs::bazWithAnonymousTestListener]");
    assertEquals(lines[1], "TestFinishedEvent[test.ceylon.test.stubs::bazWithAnonymousTestListener - success]");
    
    assertResultCounts {
        result;
        successCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `bazWithAnonymousTestListener`;
    };
}

test
shared void shouldNotifyListenersWithSpecifiedOrder() {
    void assertLog(String name) {
        value lines = bazTestListenerLog.string.trimmed.lines.sequence();
        assertEquals(lines.size, 4);
        assertEquals(lines[0], "TestStartedEvent[``name``]");
        assertEquals(lines[1], "!! TestStartedEvent[``name``]");
        assertEquals(lines[2], "TestFinishedEvent[``name`` - success]");
        assertEquals(lines[3], "!! TestFinishedEvent[``name`` - success]");
    }
    
    bazTestListenerLog.clear();
    createTestRunner([`bazWithCustomOrderedListeners1`]).run();
    assertLog(`bazWithCustomOrderedListeners1`.declaration.qualifiedName);
    
    bazTestListenerLog.clear();
    createTestRunner([`bazWithCustomOrderedListeners2`]).run();
    assertLog(`bazWithCustomOrderedListeners2`.declaration.qualifiedName);
}

shared object recordingListener satisfies TestListener {
    
    StringBuilder buffer = StringBuilder();
    
    shared String result => buffer.string.trimmed;
    
    shared actual void testRunStarted(TestRunStartedEvent event) { buffer.clear(); log(event); } 
    
    shared actual void testRunFinished(TestRunFinishedEvent event) => log(event); 
    
    shared actual void testStarted(TestStartedEvent event) => log(event); 
    
    shared actual void testFinished(TestFinishedEvent event) => log(event); 
    
    shared actual void testSkipped(TestSkippedEvent event) => log(event);
    
    shared actual void testAborted(TestAbortedEvent event) => log(event); 
    
    shared actual void testError(TestErrorEvent event) => log(event);
    
    void log(Object event) => buffer.append(event.string).appendNewline();
    
}

object throwExceptionOnTestRunStartedListener satisfies TestListener {
    shared actual void testRunStarted(TestRunStartedEvent event) {
        throw Exception("testRunStarted");
    }
}

object throwExceptionOnTestRunFinishedListener satisfies TestListener {
    shared actual void testRunFinished(TestRunFinishedEvent event) {
        throw Exception("testRunFinished");
    }
}

object throwExceptionOnTestStartedListener satisfies TestListener {
    shared actual void testStarted(TestStartedEvent event) {
        throw Exception("testStarted");
    }
}

object throwExceptionOnTestFinishedListener satisfies TestListener {
    shared actual void testFinished(TestFinishedEvent event) {
        throw Exception("testFinished");
    }
}

object throwExceptionOnTestErrorListener satisfies TestListener {
    shared actual void testError(TestErrorEvent event) {
        throw Exception("testError");
    }
}
