import java.lang {
    JString=String
}

"A [[Map]] with keys of type `java.lang::String` that wraps 
 a `Map` with keys of type `String`.

     JavaMap(JavaStringMap(ceylonMap))"
shared class JavaStringMap<Item>(Map<String,Item> map)
        satisfies Map<JString,Item> {

    shared actual default JavaStringMap<Item> clone() 
            => JavaStringMap(map.clone());
    
    defines(Object key)
    // don't forward non-Strings; otherwise, what to do
    // when the arg is java.lang.String?
        => if (is JString key)
        then map.defines(key.string)
        else false;
    
    get(Object key)
    // don't forward non-Strings; otherwise, what to do
    // when the arg is java.lang.String?
        => if (is JString key)
        then map[key.string]
        else null;
    
    iterator()
        => { for (key->item in map)
                javaString(key)->item
           }.iterator();
    
    size => map.size;
    
    empty => map.empty;
    
    equals(Object that)
        => (super of Map<JString, Item>).equals(that);
    
    hash => (super of Map<JString, Item>).hash;
    
}