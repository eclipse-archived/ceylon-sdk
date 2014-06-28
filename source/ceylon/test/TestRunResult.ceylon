"Represents a summary result of the test run."
shared interface TestRunResult {
    
    "Determine if all executed tests succeeded."
    shared formal Boolean isSuccess;
    
    "The number of executed tests."
    shared formal Integer runCount;
    
    "The number of tests that finished [[successfully|success]]."
    shared formal Integer successCount;
    
    "The number of tests that finished with [[failure]]."
    shared formal Integer failureCount;
    
    "The number of tests that finished with [[error]]."
    shared formal Integer errorCount;
    
    "The number of [[ignored]] tests during the test run."
    shared formal Integer ignoreCount;
    
    "The time in milliseconds when the test run started."
    shared formal Integer startTime;
    
    "The time in milliseconds when the test run finished."
    shared formal Integer endTime;
    
    "The total elapsed time in miliseconds."
    shared formal Integer elapsedTime;
    
    "The detailed results of each test."
    shared formal TestResult[] results;
}
