doc "A collection of tests that can be run."
shared abstract class Suite(String name) {

    variable Integer failureCount := 0;
    variable Integer errorCount := 0;
    variable Integer passCount := 0;
    variable Integer runCount := 0;

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

    void printResults() {
        print(banner("TEST RESULTS"));
        print("run:     " runCount "");
        print("passed:  " passCount "");
        print("failed:  " failureCount "");
        print("errored: " errorCount "");
        if (failureCount > 0
            || errorCount > 0
            || runCount == 0) {
            print(banner("TESTS FAILED"));
            if (runCount == 0) {
                print("There were no tests!");
            }
        } else {
            print(banner("TESTS PASSED"));
        }
    }

    void runTest(void test()) {
        try {
            test();
            passCount += 1;
        } catch (AssertionFailed e) {
            failureCount += 1;
            print("*** Failure! " e.message "");
            e.printStackTrace();
        } catch (Exception e) {
            errorCount += 1;
            print("*** Error! " e.message "");
            e.printStackTrace();
        } finally {
            runCount += 1;
        }
    }

    doc "The tests to be run. Entry keys are a test description, items are the
         test function."
    shared formal Iterable<Entry<String, Callable<Void,<>>>> suite;

    doc "Run the Tests."
    shared void run() {
        print(banner(name));
        for (Entry<String, Callable<Void,<>>> entry in suite) {
            print(banner("Test: " entry.key ""));
            runTest(entry.item);
        }
        printResults();
    }
}
