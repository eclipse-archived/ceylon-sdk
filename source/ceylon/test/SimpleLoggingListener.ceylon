import ceylon.test.event {
    ...
}

"A [[TestListener]] which prints information about test execution to the standard output."
shared class SimpleLoggingListener(
    "A function that log the given line." void write(String line) => print(line)) satisfies TestListener {

    shared actual void testRunStart(TestRunStartEvent event) {
        write(banner("TESTS STARTED"));
    }

    shared actual void testRunFinish(TestRunFinishEvent event) {
        write(banner("TEST RESULTS"));
        if( event.result.results.empty ) {
            write("There were no tests!");
        }
        else {
            write("run:     ``event.result.runCount``");
            write("success: ``event.result.successCount``");
            write("failure: ``event.result.failureCount``");
            write("error:   ``event.result.errorCount``");
            write("ignored: ``event.result.ignoreCount``");
            write("time:    ``event.result.elapsedTime/1000``s");
            write("");
            if( event.result.isSuccess ) {
                write(banner("TESTS SUCCESS"));
            }
            else {
                for(r in event.result.results) {
                    if( (r.state == failure || r.state == error) && r.description.children.empty ) {
                        write(r.string);
                    }
                }
                write("");
                write(banner("TESTS FAILED !"));
            }
        }
    }

    shared actual void testStart(TestStartEvent event) {
        write("running: ``event.description.name``");
    }

    shared actual void testFinish(TestFinishEvent event) {
        if( event.result.state == error || event.result.state == failure ) {
            if( exists e = event.result.exception ) {
                e.printStackTrace();
            }
        }
    }

    shared actual void testError(TestErrorEvent event) {
        if( event.result.state == error || event.result.state == failure ) {
            if( exists e = event.result.exception ) {
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