import ceylon.test {
    assertEquals,
    createTestRunner,
    test,
    TestState,
    TestRunResult,
    TestSource
}
import test.ceylon.test.stubs {
    parameterized1,
    parameterized2,
    parameterized3,
    parameterized4,
    parameterized5,
    parameterized6,
    parameterizedIgnored,
    parameterizedCustomArgumentProvider,
    parameterizedButNoArgumentProvider,
    parameterizedButSeveralArgumentProviders1,
    parameterizedButSeveralArgumentProviders2,
    parameterizedButSourceVoid1,
    parameterizedButSourceVoid2,
    parameterizedButSourceEmpty1,
    parameterizedButSourceEmpty2,
    parameterizedWithParameterizedDefaultedSource,
    paramCollector,
    customArgumentProviderValue
}

test
shared void shouldRunParameterizedTest() {
    void assertResult(TestRunResult runResult, TestSource testSource) {
        assertResultCounts {
            runResult;
            successCount = 3;
        };
        assertResultContains {
            runResult;
            index = 0;
            state = TestState.success;
            source = testSource;
            variant = "(a)";
        };
        assertResultContains {
            runResult;
            index = 1;
            state = TestState.success;
            source = testSource;
            variant = "(b)";
        };
        assertResultContains {
            runResult;
            index = 2;
            state = TestState.success;
            source = testSource;
            variant = "(c)";
        };
        assertResultContains {
            runResult;
            index = 3;
            state = TestState.success;
            source = testSource;
        };
        assert (paramCollector.sequence() == ["a", "b", "c"]);
    }
    
    paramCollector.clear();
    value result1 = createTestRunner([`parameterized1`]).run();
    assertResult(result1, `parameterized1`);
    
    paramCollector.clear();
    value result2 = createTestRunner([`parameterized2`]).run();
    assertResult(result2, `parameterized2`);
}

test
shared void shouldRunParameterizedTestAllCombination1() {
    paramCollector.clear();
    
    value result = createTestRunner([`parameterized3`]).run();
    
    assertResultCounts {
        result;
        successCount = 6;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `parameterized3`;
        variant = "(a, 1)";
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.success;
        source = `parameterized3`;
        variant = "(a, 2)";
    };
    
    assert (paramCollector.sequence() == [["a", 1], ["a", 2], ["b", 1], ["b", 2], ["c", 1], ["c", 2]]);
}

test
shared void shouldRunParameterizedTestAllCombination2() {
    paramCollector.clear();
    
    value result = createTestRunner([`parameterized4`]).run();
    
    assertResultCounts {
        result;
        successCount = 12;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `parameterized4`;
        variant = "(a, 1, true)";
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.success;
        source = `parameterized4`;
        variant = "(a, 1, false)";
    };
    
    assert (paramCollector.sequence() == 
        [["a", 1, true], ["a", 1, false], ["a", 2, true], ["a", 2, false],
         ["b", 1, true], ["b", 1, false], ["b", 2, true], ["b", 2, false],
         ["c", 1, true], ["c", 1, false], ["c", 2, true], ["c", 2, false]]);
}

test
shared void shouldRunParameterizedTestAllCombination3() {
    paramCollector.clear();
    
    value result = createTestRunner([`parameterized5`]).run();
    
    assertResultCounts {
        result;
        successCount = 36;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `parameterized5`;
        variant = "(a, 1, true, 0.999)";
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.success;
        source = `parameterized5`;
        variant = "(a, 1, true, 0.888)";
    };
    
    assert (paramCollector.sequence() == 
        [["a", 1, true, 0.999], ["a", 1, true, 0.888], ["a", 1, true, 0.777], ["a", 1, false, 0.999], ["a", 1, false, 0.888], ["a", 1, false, 0.777],
         ["a", 2, true, 0.999], ["a", 2, true, 0.888], ["a", 2, true, 0.777], ["a", 2, false, 0.999], ["a", 2, false, 0.888], ["a", 2, false, 0.777],
         ["b", 1, true, 0.999], ["b", 1, true, 0.888], ["b", 1, true, 0.777], ["b", 1, false, 0.999], ["b", 1, false, 0.888], ["b", 1, false, 0.777],
         ["b", 2, true, 0.999], ["b", 2, true, 0.888], ["b", 2, true, 0.777], ["b", 2, false, 0.999], ["b", 2, false, 0.888], ["b", 2, false, 0.777],
         ["c", 1, true, 0.999], ["c", 1, true, 0.888], ["c", 1, true, 0.777], ["c", 1, false, 0.999], ["c", 1, false, 0.888], ["c", 1, false, 0.777],
         ["c", 2, true, 0.999], ["c", 2, true, 0.888], ["c", 2, true, 0.777], ["c", 2, false, 0.999], ["c", 2, false, 0.888], ["c", 2, false, 0.777]]);
}

test
shared void shouldRunParameterizedTestWithTuple() {
    paramCollector.clear();
    
    value result = createTestRunner([`parameterized6`]).run();
    
    assertResultCounts {
        result;
        successCount = 3;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `parameterized6`;
        variant = "(1, 0.9)";
    };
    assertResultContains {
        result;
        index = 1;
        state = TestState.success;
        source = `parameterized6`;
        variant = "(2, 0.8)";
    };
    
    assert (paramCollector.sequence() == [[1, 0.9], [2, 0.8], [3, 0.7]]);
}

test
shared void shouldRunParameterizedTestWithCustomArgumentProvider1() {
    paramCollector.clear();
    customArgumentProviderValue = 'a';
    
    value result = createTestRunner([`parameterizedCustomArgumentProvider`]).run();
    
    assertResultCounts {
        result;
        successCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.success;
        source = `parameterizedCustomArgumentProvider`;
    };
    
    assert (paramCollector.sequence() == ['a']);
}

test
shared void shouldRunParameterizedTestWithCustomArgumentProvider2() {
    paramCollector.clear();
    customArgumentProviderValue = { 1, 0.9, "a" };
    
    value result = createTestRunner([`parameterizedCustomArgumentProvider`]).run();
    
    assertResultCounts {
        result;
        successCount = 3;
    };
    
    assert (paramCollector.sequence() == [1, 0.9, "a"]);
}

test
shared void shouldRunParameterizedTestWithCustomArgumentProvider3() {
    try {
        customArgumentProviderValue = Exception("ops!");
        
        value result = createTestRunner([`parameterizedCustomArgumentProvider`]).run();
        
        assertResultCounts {
            result;
            runCount = 0;
            errorCount = 1;
        };
        assertResultContains {
            result;
            index = 0;
            state = TestState.error;
            source = `parameterizedCustomArgumentProvider`;
            message = "ops!";
        };
    } finally {
        customArgumentProviderValue = null;
    }
}

test
shared void shouldRunParameterizedTestVsEvents() {
    createTestRunner([`parameterized1`], [recordingListener]).run();
    
    value lines = recordingListener.result.lines.sequence();
    assertEquals(lines.size, 10);
    assertEquals(lines[0], "TestRunStartedEvent");
    assertEquals(lines[1], "TestStartedEvent[test.ceylon.test.stubs::parameterized1]");
    assertEquals(lines[2], "TestStartedEvent[test.ceylon.test.stubs::parameterized1(a)]");
    assertEquals(lines[3], "TestFinishedEvent[test.ceylon.test.stubs::parameterized1(a) - success]");
    assertEquals(lines[4], "TestStartedEvent[test.ceylon.test.stubs::parameterized1(b)]");
    assertEquals(lines[5], "TestFinishedEvent[test.ceylon.test.stubs::parameterized1(b) - success]");
    assertEquals(lines[6], "TestStartedEvent[test.ceylon.test.stubs::parameterized1(c)]");
    assertEquals(lines[7], "TestFinishedEvent[test.ceylon.test.stubs::parameterized1(c) - success]");
    assertEquals(lines[8], "TestFinishedEvent[test.ceylon.test.stubs::parameterized1 - success]");
    assertEquals(lines[9], "TestRunFinishedEvent");
}

test
shared void shouldRunParameterizedTestVsIgnore() {
    value result = createTestRunner([`parameterizedIgnored`]).run();
    
    assertResultCounts {
        result;
        runCount = 0;
        skippedCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.skipped;
        source = `parameterizedIgnored`;
    };
}

test
shared void shouldRunParameterizedWithParameterizedDefaultedSource() {
    paramCollector.clear();
    
    value result = createTestRunner([`parameterizedWithParameterizedDefaultedSource`]).run();
    
    assertResultCounts {
        result;
        successCount = 1;
    };
    
    assert (paramCollector.sequence() == ["abc"]);
}

test
shared void shouldVerifyParameterizedWithoutArgumentProvider() {
    value result = createTestRunner([`parameterizedButNoArgumentProvider`]).run();
    
    assertResultCounts {
        result;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.error;
        source = `parameterizedButNoArgumentProvider`;
        message = "function test.ceylon.test.stubs::parameterizedButNoArgumentProvider has parameter s without specified argument provider";
    };
}

test
shared void shouldVerifyParameterizedWithMultipleArgumentProvider1() {
    value result = createTestRunner([`parameterizedButSeveralArgumentProviders1`]).run();
    
    assertResultCounts {
        result;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.error;
        source = `parameterizedButSeveralArgumentProviders1`;
        message = "function test.ceylon.test.stubs::parameterizedButSeveralArgumentProviders1 has parameter s with multiple argument providers: { ParametersAnnotation, CustomArgumentProviderAnnotation }";
    };
}

test
shared void shouldVerifyParameterizedWithMultipleArgumentProvider2() {
    value result = createTestRunner([`parameterizedButSeveralArgumentProviders2`]).run();
    
    assertResultCounts {
        result;
        runCount = 0;
        errorCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.error;
        source = `parameterizedButSeveralArgumentProviders2`;
        message = "function test.ceylon.test.stubs::parameterizedButSeveralArgumentProviders2 has multiple argument providers: { ParametersAnnotation, CustomArgumentProviderAnnotation }";
    };
}

test
shared void shouldVerifyParameterizedWithSourceVoid() {
    void assertResult(TestRunResult result) {
        assertResultCounts {
            result;
            errorCount = 1;
        };
        assertResultContains {
            result;
            index = 0;
            state = TestState.error;
            message = "parameterized test failed, argument provider probably returned incompatible values";
        };
        
    }
    
    value result1 = createTestRunner([`parameterizedButSourceVoid1`]).run();
    assertResult(result1);
    
    value result2 = createTestRunner([`parameterizedButSourceVoid2`]).run();
    assertResult(result2);
}

test
shared void shouldVerifyParameterizedWithSourceEmpty() {
    void assertResult(TestRunResult result) {
        assertResultCounts {
            result;
            runCount = 0;
            errorCount = 1;
        };
        assertResultContains {
            result;
            index = 0;
            state = TestState.error;
            message = "parameterized test failed, argument provider probably doesn't return any values";
        };
    }
    
    value result1 = createTestRunner([`parameterizedButSourceEmpty1`]).run();
    assertResult(result1);
    
    value result2 = createTestRunner([`parameterizedButSourceEmpty2`]).run();
    assertResult(result2);
}