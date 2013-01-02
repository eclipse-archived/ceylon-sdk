import ceylon.test { ... }

class CeylonTestSuite() extends Suite("ceylon.test") {
    shared actual Iterable<String->Void()> suite = {};
}

doc "Run the module `test.ceylon.test`."
void run() {
    CeylonTestSuite().run();
}