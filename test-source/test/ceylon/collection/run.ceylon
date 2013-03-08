import ceylon.test { ... }

shared void run(){
    suite("ceylon.collection",
        "Set" -> testSet,
        "Set constructor" -> testSetConstructor,
        "Set2" -> testSet2,
        "SetRemove" -> testSetRemove,
        "Map" -> testMap,
        "Map constructor" -> testMapConstructor,
        "Map2" -> testMap2,
        "MapRemove" -> testMapRemove,
        "List" -> testList,
        "List constructor" -> testListConstructor
    );
}
