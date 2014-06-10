"Invert a [[Map]], producing a map from items to sequences 
 of keys. Since various keys in the [[original map|map]] may 
 map to the same item, the resulting map contains a sequence 
 of keys for each distinct item."
Map<Item,[Key+]> invert<Key,Item>(Map<Key,Item> map) 
        given Key satisfies Object
        given Item satisfies Object {
    
    value result = HashMap<Item,ArrayList<Key>>();
    for (key->item in map) {
        if (exists sb = result[item]) {
            sb.add(key);
        }
        else {
            value list = ArrayList<Key>();
            list.add(key);
            result.put(item, list);
        }
    }
    [Key+] mapping(Item item, ArrayList<Key> sa) {
        assert(is [Key+] result = sa.sequence());
        return result;
    }
    return result.mapItems(mapping);
}
