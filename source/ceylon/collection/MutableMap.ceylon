"A [[Map]] supporting addition of new entries and removal of
 existing entries."
see (`interface MutableList`, `interface MutableSet`)
by("Stéphane Épardaud")
shared interface MutableMap<Key, Item>
    satisfies Map<Key, Item>
        given Key satisfies Object 
        given Item satisfies Object {
    
    "Add an entry to this map, overwriting any existing entry for 
     the given `key`, and returning the previous value associated 
     with the given `key`, if any, or null."
    shared formal Item? put(Key key, Item item);
    
    "Add the given entries to this map, overwriting any existing
     entries with the same keys."
    shared formal void putAll({<Key->Item>*} entries);
    
    "Remove the entry associated with the given `key`, if any, from 
     this map, returning the value no longer associated with the 
     given `key`, if any, or null."
    shared formal Item? remove(Key key);
    
    "Remove every entry from this map, leaving an empty map."
    shared formal void clear();
}