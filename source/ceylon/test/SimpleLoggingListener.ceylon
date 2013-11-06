"A [[TestListener]] which prints information about test execution to the standard output."
shared class SimpleLoggingListener() satisfies TestListener {

    shared actual void testRunStart(TestDescription description) {
        print(banner("TESTS STARTED"));
    }

    shared actual void testRunFinish(TestRunResult result) {
        print(banner("TEST RESULTS"));
        if( result.results.empty ) {
            print("There were no tests!");
        }
        else {
            print("run:     ``result.runCount``");
            print("success: ``result.successCount``");
            print("failure: ``result.failureCount``");
            print("error:   ``result.errorCount``");
            print("ignored: ``result.ignoreCount``");
            print("time:    ``result.elapsedTime/1000``s");
            print("");
            if( result.isSuccess ) {
                print(banner("TESTS SUCCESS"));
            }
            else {
                for(r in result.results) {
                    if( (r.state == failure || r.state == error) && r.description.children.empty ) {
                        print(r.string);
                    }
                }
                print("");
                print(banner("TESTS FAILED !"));
            }
        }
    }

    shared actual void testStart(TestDescription description) {
        print("running: ``description.name``");
    }

    shared actual void testFinish(TestResult result) {
        if( result.state == error || result.state == failure ) {
            if( exists e = result.exception ) {
                e.printStackTrace();
            }
        }
    }
    
    shared actual void testError(TestResult result) {
        if( result.state == error || result.state == failure ) {
            if( exists e = result.exception ) {
                e.printStackTrace();
            }
        }
    }

    String banner(String title) {
        StringBuilder sb = StringBuilder();
        Integer totalWith = 60;
        Integer bannerWidth = totalWith - title.size - 2;
        for (i in 0..bannerWidth/2) {
            sb.appendCharacter('=');
        }
        if (bannerWidth % 2 == 1) {
            sb.appendCharacter('=');
        }
        sb.append(" ").append(title).append(" ");
        for (i in 0..bannerWidth/2) {
            sb.appendCharacter('=');
        }
        return sb.string;
    }

}