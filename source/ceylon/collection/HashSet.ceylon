import ceylon.collection { MutableSet }

interface None of none {}
object none satisfies None {}

"A [[MutableSet]] implemented as a hash set stored in an 
 [[Array]] of singly linked lists. Each element is assigned 
 an index of the array according to its hash code. The hash 
 code of an element is defined by [[Object.hash]].
 
 The [[stability]] of a `HashSet` controls its iteration
 order:
 
 - A [[linked]] set has a stable and meaningful order of 
   iteration. The elements of the set form a linked list, 
   where new elements are added to the end of the linked 
   list. Iteration of the set follows this linked list, from 
   least recently added elements to most recently added 
   elements.
 - An [[unlinked]] set has an unstable iteration order that 
   may change when the set is modified. The order itself is 
   not meaningful to a client.
 
 The management of the backing array is controlled by the
 given [[hashtable]]."

by ("Stéphane Épardaud", "Gavin King")
shared class HashSet<Element>
        (stability=linked, hashtable = Hashtable(), elements = {})
        satisfies MutableSet<Element>
        given Element satisfies Object {
    
    "Determines whether this is a linked hash set with a
     stable iteration order."
    Stability stability;
    
    "The initial elements of the set."
    {Element*} elements;
    
    "Performance-related settings for the backing array."
    Hashtable hashtable;
    
    function toEntries({Element*} elements) => { for (element in elements) element->none };
    
    variable value map = HashMap {
        stability = stability;
        hashtable = hashtable;
        entries = toEntries(elements);
    };
    
    shared actual Boolean add(Element element) => !(map.put(element, none) exists);
    
    shared actual Boolean addAll({Element*} elements) {
        Integer previousSize = size;
        map.putAll(toEntries(elements));
        return size > previousSize;
    }
    
    shared actual Boolean remove(Element element) => map.remove(element) exists;
    
    shared actual void clear() => map.clear();
    
    // Read
    
    size => map.size;
    
    shared actual Iterator<Element> iterator() {
        value mapIt = map.iterator();
        object it satisfies Iterator<Element> {
            
            shared actual Element|Finished next() {
                value entry = mapIt.next();
                switch(entry)
                case (is Element->None) {
                    return entry.key;
                } case (is Finished) {
                    return entry;
                }
            }
            
        }
        return it;
    }
    
    shared actual Integer count(Boolean selecting(Element element))
            => map.count((Element->None entry) => selecting(entry.key));
    
    shared actual Integer hash => map.hash;
    
    shared actual Boolean equals(Object that) {
        if(is Set<Object> that, size == that.size){
            return map.definesEvery(that);
        }
        return false;
    }
    
    shared actual HashSet<Element> clone() {
        value clone = HashSet<Element>();
        clone.map = HashMap {
            stability = stability;
            hashtable = hashtable;
            entries = map;
        };
        return clone;
    }
    
    shared actual Boolean contains(Object element) {
        return map.defines(element);
    }
    
    shared actual HashSet<Element> complement<Other>
            (Set<Other> set) 
            given Other satisfies Object {
        value ret = HashSet<Element>();
        for(elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> exclusiveUnion<Other>
            (Set<Other> set) 
            given Other satisfies Object {
        value ret = HashSet<Element|Other>();
        for(elem in this){
            if(!set.contains(elem)){
                ret.add(elem);
            }
        }
        for(elem in set){
            if(!contains(elem)){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element&Other> intersection<Other>
            (Set<Other> set) 
            given Other satisfies Object {
        value ret = HashSet<Element&Other>();
        for(elem in this){
            if(set.contains(elem), is Other elem){
                ret.add(elem);
            }
        }
        return ret;
    }
    
    shared actual HashSet<Element|Other> union<Other>
            (Set<Other> set) 
            given Other satisfies Object {
        value ret = HashSet<Element|Other>();
        ret.addAll(this);
        ret.addAll(set);
        return ret;
    }
    
    shared actual Element? first => map.first?.key;
    
    shared actual Element? last => map.last?.key;
}
