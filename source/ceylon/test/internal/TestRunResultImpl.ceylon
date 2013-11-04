import ceylon.test {
    TestDescription,
    TestListener,
    TestResult,
    TestRunResult,
    success,
    failure,
    error,
    ignored
}

class TestRunResultImpl() satisfies TestRunResult {

    SequenceBuilder<TestResult> resultsBuilder = SequenceBuilder<TestResult>();

    variable Integer runCounter = 0;
    variable Integer successCounter = 0;
    variable Integer errorCounter = 0;
    variable Integer failureCounter = 0;
    variable Integer ignoreCounter = 0;
    variable Integer startTimeMilliseconds = 0;
    variable Integer endTimeMilliseconds = 0;

    shared actual Integer runCount => runCounter;
    shared actual Integer successCount => successCounter;
    shared actual Integer errorCount => errorCounter;
    shared actual Integer failureCount => failureCounter;
    shared actual Integer ignoreCount => ignoreCounter;

    shared actual Boolean isSuccess => successCount != 0 && errorCount == 0 && failureCount == 0;

    shared actual Integer startTime => startTimeMilliseconds;
    shared actual Integer endTime => endTimeMilliseconds;
    shared actual Integer elapsedTime => endTime - startTime;

    shared actual TestResult[] results => resultsBuilder.sequence;

    shared actual String string {
        value b = StringBuilder();
        b.append("TEST RESULTS").appendNewline();
        if( results.empty ) {
            b.append("There were no tests!").appendNewline();
        } 
        else {
            b.append("run:     ``runCount``").appendNewline();
            b.append("success: ``successCount``").appendNewline();
            b.append("failure: ``failureCount``").appendNewline();
            b.append("error:   ``errorCount``").appendNewline();
            b.append("ignored: ``ignoreCount``").appendNewline();
            b.append("time:    ``elapsedTime/1000``s").appendNewline();
            b.appendNewline();
            if( isSuccess ) {
                b.append("TESTS SUCCESS").appendNewline();
            }
            else {
                for(result in results) {
                    if( (result.state == failure || result.state == error) && result.description.children.empty ) {
                        b.append(result.string).appendNewline();
                    }
                }
                b.appendNewline();
                b.append("TESTS FAILED !").appendNewline();
            }
        }
        return b.string;
    }

    shared object listener satisfies TestListener {

        shared actual void testRunStart(TestDescription description) => startTimeMilliseconds = system.milliseconds;

        shared actual void testRunFinish(TestRunResult result) => endTimeMilliseconds = system.milliseconds;

        shared actual void testFinish(TestResult result) => handleResult(result, true);

        shared actual void testError(TestResult result) => handleResult(result, false);

        shared actual void testIgnored(TestResult result) => handleResult(result, false);

        void handleResult(TestResult result, Boolean wasRun) {
            resultsBuilder.append(result);
            if( result.state == success && result.description.children.empty ) {
                successCounter++;
                runCounter += wasRun then 1 else 0;
            }
            else if( result.state == failure && result.exception exists ) {
                failureCounter++; 
                runCounter += wasRun then 1 else 0;
            }
            else if( result.state == error && result.exception exists ) {
                errorCounter++;
                runCounter += wasRun then 1 else 0;
            }
            else if( result.state == ignored ) {
                ignoreCounter++;
            }
        }

    }

}