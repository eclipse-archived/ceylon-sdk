import ceylon.collection { ... }

by "Stéphane Épardaud"
doc "Represents a JSON Array"
shared class Array(String|Boolean|Integer|Float|Object|Array|Nothing... values) satisfies Iterable<String|Boolean|Integer|Float|Object|Array|Nothing> {
    MutableList<String|Boolean|Integer|Float|Object|Array|NullInstance> list = LinkedList<String|Boolean|Integer|Float|Object|Array|NullInstance>();
    
    for(val in values){
        if(exists val){
            list.add(val);
        }else{
            list.add(nullInstance);
        }
    }
    
    doc "Adds a new value at the end of this array"
    shared void add(String|Boolean|Integer|Float|Object|Array|Nothing val){
        if(exists val){
            list.add(val);
        }else{
            list.add(nil);
        }
    }
    
    doc "Gets the value at the given index, or `null` if it does not exist"
    shared String|Boolean|Integer|Float|Object|Array|Nothing get(Integer index){
        value val = list[index];
        if(is NullInstance val){
            return null;
        }
        switch(val)
        case (is String|Boolean|Integer|Float|Object|Array) {
            return val;
        }else{
            // key does not exist
            return null;
        }
    }
    
    doc "Returns the number of elements in this array"
    shared Integer size {
        return list.size;
    }

    doc "Returns true if this array is empty"
    shared actual Boolean empty {
        return size == 0;
    }
    
    doc "Returns an iterator for this array"
    shared actual Iterator<String|Boolean|Integer|Float|Object|Array|Nothing> iterator {
        object it satisfies Iterator<String|Boolean|Integer|Float|Object|Array|Nothing> {
            variable Integer index := 0;
            shared actual String|Boolean|Integer|Float|Object|Array|Nothing|Finished next() {
                if(index < size){
                    return get(index++);
                }
                return exhausted;
            }
        }
        return it;
    }
}