shared class TestResult(TestRunner runner) {
    
    variable Integer runCounter := 0;
    variable Integer successCounter := 0;
    variable Integer failureCounter := 0;
    variable Integer errorCounter := 0;
    
    shared Boolean isSuccess { 
        return runCounter == successCounter; 
    }
    
    shared Boolean isFailure { 
        return !isSuccess; 
    }
    
    shared Integer runCount { 
        return runCounter; 
    }
    
    shared Integer successCount { 
        return successCounter; 
    }
    
    shared Integer failureCount { 
        return failureCounter; 
    }
    
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