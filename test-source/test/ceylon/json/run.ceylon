import ceylon.json { ... }
import ceylon.test { ... }

class CollectionSuite() extends Suite("ceylon.collection") {
    shared actual Iterable<String->Void()> suite = {
        "Parse" -> testParse,
        "Print" -> testPrint
    };
}

shared void run(){
    CollectionSuite().run();
}


