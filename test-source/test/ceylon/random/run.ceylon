shared
void run() {
    LCGRandomTests().runTests();
}

void executeTests({<String -> Anything()>*} tests) {
    for (testName -> test in tests) {
        print("Running test: ``testName``");
        try {
            test();
        }
        catch (Throwable t) {
            print("Test failed with message: ``t.message``");
        }
    }
}