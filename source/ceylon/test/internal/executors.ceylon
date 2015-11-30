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
            if( worstState < state ) {
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
    
}

shared class ErrorTestExecutor(description, Throwable exception) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestRunContext context) {
        context.fireTestError(TestErrorEvent(TestResult(description, TestState.error, exception)));
    }
    
}
