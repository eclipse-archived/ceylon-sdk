import ceylon.language.meta.model {
    Function,
    Model
}
import ceylon.test {
    TestState,
    TestSource,
    TestRunResult,
    success
}

void runTests(<Function<Anything,[]>>* tests) {
    for(test in tests) {
        try {
            test();
            print("success: ``test.declaration.name``");
        }
        catch(Exception e) {
            print("failed:  ``test.declaration.name``");
            e.cause?.printStackTrace();
        }
    }
}

void assertResultCounts(TestRunResult runResult, Integer successCount = 0, Integer errorCount = 0, Integer failureCount = 0, Integer ignoreCount = 0, Integer runCount = -1) {
    try {
        assert(runResult.successCount == successCount, 
                runResult.errorCount == errorCount, 
                runResult.failureCount == failureCount, 
                runResult.ignoreCount == ignoreCount);
        
        if( runCount == -1 ) {
            assert(runResult.runCount == successCount + errorCount + failureCount);
        }
        else {
            assert(runResult.runCount == runCount);
        }
        
        if( errorCount == 0 && failureCount == 0 && successCount > 0 ) {
            assert(runResult.isSuccess);
        }
    }
    catch(Exception e) {
        printResult(runResult);
        throw e;
    }
}

void assertResultContains(TestRunResult runResult, Integer index = 0, TestState state = success, TestSource? source = null, String? message = null) {
    try {
        assert(exists r = runResult.results[index], 
                r.state == state);
        
        if( exists source ) {
            if( is Model source ) {
                assert(exists s = r.description.declaration, s == source.declaration);
            } else {
                assert(exists s = r.description.declaration, s == source);
            }
        }
        if( exists message ) {
            assert(exists e = r.exception, e.message.contains(message));
        }
        if( state == success ) {
            assert(!r.exception exists);
        }
    }
    catch(Exception e) {
        printResult(runResult);
        throw e;
    }
}

void printResult(TestRunResult runResult) {
    print("--- RUN RESULT ---
            isSuccess:    ``runResult.isSuccess``
            runCount:     ``runResult.runCount``
            successCount: ``runResult.successCount``
            failureCount: ``runResult.failureCount``
            errorCount:   ``runResult.errorCount``
            ignoreCount:  ``runResult.ignoreCount``
            ");
    
    for(result in runResult.results) {
        print("``result.description.name`` : ``result.state`` `` result.exception else "" ``  ");
    }
}