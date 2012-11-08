import ceylon.json { ... }
import com.redhat.ceylon.sdk.test { ... }

class CollectionSuite() extends Suite("ceylon.collection") {
    shared actual Iterable<String->Void()> suite = {
        "Parse" -> testParse,
        "Print" -> testPrint
    };
}

shared void run(){
    CollectionSuite().run();
}


