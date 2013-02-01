doc "Contract for things needing to be informed about the execution of tests 
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

doc "A [[TestListener]] which prints information about test execution to the 
     standard output."
shared class PrintingTestListener() satisfies TestListener {
    
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
            
            if (result.isSuccess) {
                print(banner("TESTS SUCCESS"));
            } else {
                print(banner("TESTS FAILED"));
            }
        }
    }
    
    shared actual void testStarted(TestUnit test) {
        print(test.name);
    }
    
    doc "Generates a banner with the given text, like this:
         
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