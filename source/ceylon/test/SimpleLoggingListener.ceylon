import ceylon.test.event {
    ...
}

"A [[TestListener]] which prints information about test execution to the standard output."
shared class SimpleLoggingListener(
    "A function that log the given line." void write(String line) => print(line)) satisfies TestListener {

    shared actual void testRunStart(TestRunStartEvent event) {
        writeBannerStart();
    }

    shared actual void testRunFinish(TestRunFinishEvent event) {
        writeBannerResults(event.result);
        if( event.result.results nonempty ) {
            writeSummary(event.result);
            if( event.result.isSuccess ) {
                writeBannerSuccess(event.result);
            }
            else {
                writeFailures(event.result);
                writeBannerFailed(event.result);
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

    shared default void writeBannerStart() {
        write(banner("TESTS STARTED"));
    }

    shared default void writeBannerResults(TestRunResult result) {
        write(banner("TEST RESULTS"));
        if( result.results.empty ) {
            write("There were no tests!");
        }
    }

    shared default void writeBannerSuccess(TestRunResult result) {
        write(banner("TESTS SUCCESS"));
    }

    shared default void writeBannerFailed(TestRunResult result) {
        write(banner("TESTS FAILED !"));
    }

    shared default void writeSummary(TestRunResult result) {
        write("run:     ``result.runCount``");
        write("success: ``result.successCount``");
        write("failure: ``result.failureCount``");
        write("error:   ``result.errorCount``");
        write("ignored: ``result.ignoreCount``");
        write("time:    ``result.elapsedTime/1000``s");
        write("");
    }

    shared default void writeFailures(TestRunResult result) {
        for(r in result.results) {
            if( (r.state == failure || r.state == error) && r.description.children.empty ) {
                write(r.string);
            }
        }
        write("");
    }

    shared default String banner(String title) {
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