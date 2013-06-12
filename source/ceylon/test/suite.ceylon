"Configure a [[TestRunner]] with the given tests and run it"
shared void suite(String suiteName, <String->Anything()>* tests) {
    value runner = TestRunner();
    runner.addTestListener(PrintingTestListener());
    for (name -> test in tests) {
        runner.addTest(name, test);
    }
    runner.run();
}
