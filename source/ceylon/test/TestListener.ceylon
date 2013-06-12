"Contract for things needing to be informed about the execution of tests 
 by a [[TestRunner]]."
shared interface TestListener {
    
    shared default void testRunStarted(TestRunner runner) {
    }
    
    shared default void testRunFinished(TestRunner runner, TestResult result) {
    }
    
    shared default void testStarted(TestUnit test) {
    }
    
    shared default void testFinished(TestUnit test) {
    }
    
}

"A [[TestListener]] which prints information about test execution to the 
 standard output."
shared class PrintingTestListener() satisfies TestListener {
    
    variable SequenceBuilder<TestUnit> errAndFail = SequenceBuilder<TestUnit>();
    
    shared actual void testRunStarted(TestRunner runner) {
        print(banner("TESTS STARTED"));
    }
    
    shared actual void testRunFinished(TestRunner runner, TestResult result) {
        if( result.runCount == 0 ) {
            print(banner("NO TESTS"));
            print("There were no tests!");
        } else {
            print(banner("TESTS RESULT"));
            print("run:     `` result.runCount ``");
            print("success: `` result.successCount ``");
            print("failure: `` result.failureCount ``");
            print("error:   `` result.errorCount ``");
            
            if (errAndFail.size > 0) {
                print("errors & failures:");
                for (errorOrFailure in errAndFail.sequence) {
                    print("``errorOrFailure.state``: ``errorOrFailure.name``");
                    if (exists ex=errorOrFailure.exception) {
                        ex.printStackTrace();
                    }
                }
            }
            
            if (result.isSuccess) {
                print(banner("TESTS SUCCESS"));
            } else {
                print(banner("TESTS FAILED"));
            }
        }
        errAndFail = SequenceBuilder<TestUnit>();
    }
    
    shared actual void testStarted(TestUnit test) {
        print(test.name);
    }
    
    shared actual void testFinished(TestUnit test) {
        switch(test.state)
        case (failure, error) {
            errAndFail.append(test);
        }
        else {
            // who cares
        }
    }
    
    "Generates a banner with the given text, like this:
     
     \`\``
     ============ banner ============
     \`\``
     "
    String banner(String text) {
        Character ch = '=';
        StringBuilder sb = StringBuilder();
        Integer totalWith = 60;
        Integer bannerWidth = totalWith - text.size - 2;
        for (ii in 0..bannerWidth/2) {
            sb.appendCharacter(ch);
        }
        if (bannerWidth % 2 == 1) {
            sb.appendCharacter(ch);
        }
        sb.append(" ").append(text).append(" ");
        for (ii in 0..bannerWidth/2) {
            sb.appendCharacter(ch);
        }
        return sb.string;
    }    
    
}