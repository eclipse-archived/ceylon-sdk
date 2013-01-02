doc "Configure a [[TestRunner]] with the given tests and run it"
shared void suite(String suiteName, String->Void()... tests) {
    value runner = TestRunner();
    for (name -> test in tests) {
        runner.addTest(name, test);
    }
    runner.run();
}