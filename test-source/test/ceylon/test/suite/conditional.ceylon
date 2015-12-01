import ceylon.test {
    ...
}

import test.ceylon.test.stubs {
    ...
}

test
shared void shouldSkipTestAccordingToCondition() {
    bazTestConditionCounter = 0;
    bazTestConditionResult = false;
    
    value result = createTestRunner([`bazWithTestCondition`]).run();
    
    assertEquals(bazTestConditionCounter, 1);
    assertResultCounts {
        result;
        skippedCount = 1;
    };
    assertResultContains {
        result;
        index = 0;
        state = TestState.skipped;
        source = `bazWithTestCondition`;
    };   
}

test
shared void shouldHandleExceptionInTestCondition() {
    try {
        bazTestConditionResult = null;
        
        value result = createTestRunner([`bazWithTestCondition`]).run();
        
        assertResultCounts {
            result;
            runCount = 0;
            errorCount = 1;
        };
        assertResultContains {
            result;
            index = 0;
            state = TestState.error;
            source = `bazWithTestCondition`;
        };   
    } finally {
        bazTestConditionResult = true;
    }
}