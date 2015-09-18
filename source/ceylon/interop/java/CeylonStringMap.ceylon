import java.lang {
    JString=String
}

"A [[Map]] with keys of type `ceylon.language::String` that
 wraps a `Map` with keys of type `java.lang.String`.

 This class can be used to wrap a `java.util::Map` if the
 Java map is first wrapped with [[CeylonMap]]:

        CeylonStringMap(CeylonMap(javaMap))
"
shared
class CeylonStringMap<out Item>(Map<JString, Item> map)
        satisfies Map<String, Item> {

    shared actual default
    CeylonStringMap<Item> clone()
        =>  CeylonStringMap(map.clone());

    shared actual
    Boolean defines(Object key)
        // don't forward non-Strings; otherwise, what to do
        // when the arg is java.lang.String?
        =>  if (is String key)
            then map.defines(javaString(key))
            else false;

    shared actual
    Item? get(Object key)
        // don't forward non-Strings; otherwise, what to do
        // when the arg is java.lang.String?
        =>  if (is String key)
            then map.get(javaString(key))
            else null;

    shared actual
    Iterator<String->Item> iterator()
        =>  { for (key->item in map)
                key.string->item
            }.iterator();

    shared actual
    Integer size
        =>  map.size;

    shared actual
    Boolean equals(Object that)
        =>  (super of Map<String, Item>).equals(that);

    shared actual
    Integer hash
        =>  (super of Map<String, Item>).hash;
}
