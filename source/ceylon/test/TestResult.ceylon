"Holds the results of running the tests held by the given `runner`."
shared class TestResult(TestRunner runner) {
    
    variable Integer runCounter = 0;
    variable Integer successCounter = 0;
    variable Integer failureCounter = 0;
    variable Integer errorCounter = 0;
    
    "Whether all the tests succeeded."
    shared Boolean isSuccess { 
        return runCounter == successCounter; 
    }
    
    "Whether any of the tests didn't succeed.'"
    shared Boolean isFailure { 
        return !isSuccess; 
    }
    
    "The numer of tests which were started."
    shared Integer runCount { 
        return runCounter; 
    }
    
    "The number of tests which [[succeeded|success]]."
    shared Integer successCount { 
        return successCounter; 
    }
    
    "The number of tests which [[failed|failure]]."
    shared Integer failureCount { 
        return failureCounter; 
    }
    
    "The number of tests which [[errored|error]]."
    shared Integer errorCount { 
        return errorCounter; 
    }
    
    class TestResultListener() satisfies TestListener {
        
        shared actual void testStarted(TestUnit test) {
            runCounter++;
        }
        
        shared actual void testFinished(TestUnit test) {
            if( test.state == success ) {
                successCounter++;  
            } else if( test.state == failure ) {
                failureCounter++;
            } else if( test.state == error ) {
                errorCounter++;
            }
        }
        
    }
    
    runner.addTestListener(TestResultListener());
    
}