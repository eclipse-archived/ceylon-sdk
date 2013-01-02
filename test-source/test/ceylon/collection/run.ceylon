import ceylon.test { ... }

shared void run(){
    suite("ceylon.collection",
        "Set" -> testSet,
        "Set2" -> testSet2,
        "SetRemove" -> testSetRemove,
        "Map" -> testMap,
        "Map2" -> testMap2,
        "MapRemove" -> testMapRemove,
        "List" -> testList
    );
}
