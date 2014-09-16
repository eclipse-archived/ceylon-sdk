"A [[Map]] that maintains its entries in sorted order."
by ("Gavin King")
shared interface SortedMap<Key,out Item>
        satisfies Map<Key,Item> 
                  & Ranged<Key,Key->Item,SortedMap<Key,Item>>
        given Key satisfies Object {
    
    "The entries with keys larger than the given [[key]],
     sorted by key in ascending order"
    shared formal {<Key->Item>*} higherEntries(Key key);
    
    "The entries with keys smaller than the given [[key]],
     sorted by key _in descending order_."
    shared formal {<Key->Item>*} lowerEntries(Key key);
    
}