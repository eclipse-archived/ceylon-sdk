import ceylon.test { ... }

class ProcessSuite() extends Suite("ceylon.process") {
    shared actual Iterable<String->Void()> suite = {};
}

doc "Run the module `test.ceylon.process`."
void run() {
    ProcessSuite().run();
}