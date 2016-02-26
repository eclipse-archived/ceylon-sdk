import ceylon.test {
    ...
}
import ceylon.test.event {
    ...
}
import ceylon.test.engine.spi {
    ...
}


shared class ErrorTestExecutor(description, Throwable exception) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestExecutionContext context) {
        context.fire().testError(TestErrorEvent(TestResult(description, TestState.error, false, exception)));
    }
    
}


shared class GroupTestExecutor(description, TestExecutor[] children) satisfies TestExecutor {
    
    shared actual TestDescription description;
    
    shared actual void execute(TestExecutionContext parent) {
        value context = parent.childContext(description);
        value groupTestListener = GroupTestListener();
        
        context.registerExtension(groupTestListener);
        context.execute(
            () => context.fire().testStarted(TestStartedEvent(description)),
            {for(e in children) () => e.execute(context)},
            () => context.fire().testFinished(TestFinishedEvent(TestResult(description, groupTestListener.worstState, true, null, groupTestListener.elapsedTime)))
        );
    }
    
}


shared class GroupTestListener() satisfies TestListener {
    
    Integer startTime = system.milliseconds;
    
    variable TestState worstStateVar = TestState.skipped;
    
    shared Integer elapsedTime => system.milliseconds - startTime; 
    
    shared TestState worstState => worstStateVar;
    
    void updateWorstState(TestState state) {
        if( worstStateVar < state ) {
            worstStateVar = state;
        }
    }
    
    testFinished(TestFinishedEvent event) => updateWorstState(event.result.state);
    
    testError(TestErrorEvent event) => updateWorstState(event.result.state);
    
    testSkipped(TestSkippedEvent event) => updateWorstState(TestState.skipped);
    
    testAborted(TestAbortedEvent event) => updateWorstState(TestState.aborted);
    
}