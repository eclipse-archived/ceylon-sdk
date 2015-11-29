import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

shared class GroupTestExecutor(description, TestExecutor[] children) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestRunContext context) {
        variable TestState worstState = TestState.ignored;
        void updateWorstState(TestState state) {
            if (compareStates(worstState, state) == smaller) {
                worstState = state;
            }
        }
        object updateWorstStateListener satisfies TestListener {
            shared actual void testFinish(TestFinishEvent event) => updateWorstState(event.result.state);
            shared actual void testError(TestErrorEvent event) => updateWorstState(event.result.state);
            shared actual void testIgnore(TestIgnoreEvent event) => updateWorstState(TestState.ignored);
            shared actual void testAborted(TestAbortedEvent event) => updateWorstState(TestState.aborted);
        }
        
        context.addTestListener(updateWorstStateListener);
        try {
            context.fireTestStart(TestStartEvent(description));
            value startTime = system.milliseconds;
            children*.execute(context);
            value endTime = system.milliseconds;
            context.fireTestFinish(TestFinishEvent(TestResult(description, worstState, null, endTime - startTime)));
        }
        finally {
            context.removeTestListener(updateWorstStateListener);
        }
    }
    
    Comparison compareStates(TestState state1, TestState state2) {
        if (state1 == state2) {
            return equal;
        } else if (state1 == TestState.ignored && (state2 == TestState.success || state2 == TestState.failure || state2 == TestState.error || state2 == TestState.aborted)) {
            return smaller;
        } else if (state1 == TestState.aborted && (state2 == TestState.success || state2 == TestState.failure || state2 == TestState.error)) {
            return smaller;
        } else if (state1 == TestState.success && (state2 == TestState.failure || state2 == TestState.error)) {
            return smaller;
        } else if (state1 == TestState.failure && state2 == TestState.error) {
            return smaller;
        } else {
            return larger;
        }
    }
    
}

shared class ErrorTestExecutor(description, Throwable exception) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestRunContext context) {
        context.fireTestError(TestErrorEvent(TestResult(description, TestState.error, exception)));
    }
    
}
