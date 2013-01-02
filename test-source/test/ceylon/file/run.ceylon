import ceylon.test { ... }

class FileSuite() extends Suite("ceylon.file") {
    shared actual Iterable<String->Void()> suite = {};
}

doc "Run the module `test.ceylon.file`."
void run() {
    FileSuite().run();
}