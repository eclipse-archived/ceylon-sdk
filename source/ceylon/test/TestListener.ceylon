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

shared class PrintingTestListener() satisfies TestListener {
    
    shared actual void testRunStarted(TestRunner runner) {
        print(banner("TESTS STARTED"));
    }
    
    shared actual void testRunFinished(TestRunner runner, TestResult result) {
        print(banner("TESTS RESULT"));
        if( result.runCount == 0 ) {
            print("There were no tests!");
        } else {
            print("run:     " result.runCount "");
            print("success: " result.successCount "");
            print("failure: " result.failureCount "");
            print("error:   " result.errorCount "");
            
            if (result.isSuccess) {
                print(banner("TESTS SECCESS"));
            } else {
                print(banner("TESTS FAILED"));
            }
        }
    }
    
    shared actual void testStarted(TestUnit test) {
        print(test.name);
    }
    
    String banner(String text) {
        Character ch = `=`;
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