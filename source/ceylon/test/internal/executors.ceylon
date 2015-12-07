import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}

shared class GroupTestExecutor(description, TestExecutor[] children) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestRunContext context) {
        value worstStateListener = WorstStateListener();
        context.addTestListener(worstStateListener);
        try {
            context.fireTestStarted(TestStartedEvent(description));
            value startTime = system.milliseconds;
            children*.execute(context);
            value endTime = system.milliseconds;
            context.fireTestFinished(TestFinishedEvent(TestResult(description, worstStateListener.result, true, null, endTime - startTime)));
        }
        finally {
            context.removeTestListener(worstStateListener);
        }
    }
    
}

shared class ErrorTestExecutor(description, Throwable exception) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestRunContext context) {
        context.fireTestError(TestErrorEvent(TestResult(description, TestState.error, false, exception)));
    }
    
}

shared class WorstStateListener() satisfies TestListener {
    
    variable TestState worstState = TestState.skipped;
    
    shared TestState result => worstState;
    
    void updateWorstState(TestState state) {
        if( worstState < state ) {
            worstState = state;
        }
    }
    
    testFinished(TestFinishedEvent event) => updateWorstState(event.result.state);
    
    testError(TestErrorEvent event) => updateWorstState(event.result.state);
    
    testSkipped(TestSkippedEvent event) => updateWorstState(TestState.skipped);
    
    testAborted(TestAbortedEvent event) => updateWorstState(TestState.aborted);
    
}