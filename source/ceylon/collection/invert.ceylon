"Invert a [[Map]], producing a map from items to sequences 
 of keys. Since various keys in the [[original map|map]] may 
 map to the same item, the resulting map contains a sequence 
 of keys for each distinct item."
Map<Item,[Key+]> invert<Key,Item>(Map<Key,Item> map) 
        given Key satisfies Object
        given Item satisfies Object {
    
    class Appender([Key] element) 
            => SequenceAppender<Key>(element);
    
    value result = HashMap<Item,Appender>();
    for (key->item in map) {
        if (exists sb = result[item]) {
            sb.append(key);
        }
        else {
            result.put(item, Appender([key]));
        }
    }
    return result.mapItems((Item item, Appender sa) 
            => sa.sequence);
}