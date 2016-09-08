import java.lang {
    JString=String
}

"A [[Map]] with keys of type `String` that wraps a [[Map]] 
 with keys of type `java.lang::String`.

 This class can be used to wrap a `java.util::Map` if the
 Java map is first wrapped with [[CeylonMap]]:

     CeylonStringMap(CeylonMap(javaMap))
"
shared
class CeylonStringMap<out Item>(Map<JString, Item> map)
        satisfies Map<String, Item> {

    shared actual default CeylonStringMap<Item> clone()
        => CeylonStringMap(map.clone());

    defines(Object key)
        // don't forward non-Strings; otherwise, what to do
        // when the arg is java.lang.String?
        => if (is String key)
           then map.defines(javaString(key))
           else false;

    get(Object key)
        // don't forward non-Strings; otherwise, what to do
        // when the arg is java.lang.String?
        => if (is String key)
           then map[javaString(key)]
           else null;

    iterator()
        => { for (key->item in map)
                key.string->item
           }.iterator();

    empty => map.empty;
            
    size => map.size;

    equals(Object that)
        => (super of Map<String, Item>).equals(that);

    hash => (super of Map<String, Item>).hash;
}
