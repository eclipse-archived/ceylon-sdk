import ceylon.collection { ... }
import ceylon.test { ... }

class CollectionSuite() extends Suite("ceylon.collection") {
    shared actual Iterable<String->Void()> suite = {
        "Set" -> testSet,
        "Set2" -> testSet2,
        "SetRemove" -> testSetRemove,
        "Map" -> testMap,
        "Map2" -> testMap2,
        "MapRemove" -> testMapRemove,
        "List" -> testList
    };
}

shared void run(){
    CollectionSuite().run();
}
