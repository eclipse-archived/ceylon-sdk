
shared class TreeMap<Key, Item>({<Key->Item>*} entries) 
        satisfies MutableMap<Key, Item> 
        given Key satisfies Comparable<Key>
        given Item satisfies Object {
    
    value redBlackTree = RedBlackTree<Key,Item>();
    for (key->item in entries) {
        redBlackTree.put(key, item);
    }
    
    shared actual void clear() 
            => redBlackTree.clear();
    
    shared actual MutableMap<Key,Item> clone 
            => nothing;
    
    shared actual <Item&Object>? get(Object key) {
        if (is Key key) {
            return redBlackTree.get(key);
        }
        else {
            return null;
        }
    }
    
    shared actual Iterator<Key->Item> iterator() 
            => redBlackTree.iterator();
    
    put(Key key, Item item) => redBlackTree.put(key, item);
    
    shared actual void putAll({<Key->Item>*} entries) {
        for (key->item in entries) {
            put(key, item);
        }
    }
    
    remove(Key key) => redBlackTree.remove(key);
    
    equals(Object that) => (super of Map<Key,Item>).equals(that);
    hash => (super of Map<Key,Item>).hash;
    
}

void tryIt() {
    value treeMap = TreeMap<Integer, String>{200->"", 10->"wwwww", 5->"ddddd"};
    treeMap.put(1, "hello");
    treeMap.put(2, "world");
    treeMap.put(3, "goodbye");
    treeMap.put(-1, "gavin");
    for (e in treeMap) {
        print(e);
    }
    print(treeMap);
}