import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

class GroupTestExecutor(description, TestExecutor[] children) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestRunContext context) {
        variable TestState worstState = ignored;
        void updateWorstState(TestState state) {
            if (compareStates(worstState, state) == smaller) {
                worstState = state;
            }
        }
        object updateWorstStateListener satisfies TestListener {
            shared actual void testFinish(TestFinishEvent event) => updateWorstState(event.result.state);
            shared actual void testError(TestErrorEvent event) => updateWorstState(event.result.state);
            shared actual void testIgnore(TestIgnoreEvent event) => updateWorstState(ignored);
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
        } else if (state1 == ignored && (state2 == success || state2 == failure || state2 == error)) {
            return smaller;
        } else if (state1 == success && (state2 == failure || state2 == error)) {
            return smaller;
        } else if (state1 == failure && state2 == error) {
            return smaller;
        } else {
            return larger;
        }
    }
    
}

class ErrorTestExecutor(description, Throwable exception) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestRunContext context) {
        context.fireTestError(TestErrorEvent(TestResult(description, error, exception)));
    }
    
}
