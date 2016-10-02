import ceylon.collection {
    MutableMap
}

import java.lang {
    JString=String
}

"A [[MutableMap]] with keys of type `ceylon.language::String` that
 wraps a `MutableMap` with keys of type `java.lang::String`.

 This class can be used to wrap a `java.util::Map` if the
 Java map is first wrapped with [[CeylonMutableMap]]:

        CeylonStringMutableMap(CeylonMutableMap(javaMap))
"
shared class CeylonStringMutableMap<Item>
    (MutableMap<JString, Item> map)
        extends CeylonStringMap<Item>(map)
        satisfies MutableMap<String, Item> {

    shared actual
    void clear()
        =>  map.clear();

    shared actual
    CeylonStringMutableMap<Item> clone()
        =>  CeylonStringMutableMap(map.clone());

    shared actual
    Item? put(String key, Item item)
        =>  map.put(javaString(key), item);

    shared actual
    Item? remove(String key)
        =>  map.remove(javaString(key));
}
