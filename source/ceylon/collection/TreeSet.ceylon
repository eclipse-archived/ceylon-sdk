"A [[MutableSet]] implemented using a red/black tree. 
 Elements of the set are maintained in a sorted order, from
 smallest to largest, as determined by the given
 [[comparator function|compare]]."
//see (`function naturalOrderTreeSet`)
by ("Gavin King")
shared class TreeSet<Element>(compare, elements={})
        satisfies MutableSet<Element>
        given Element satisfies Object {
     
     "A comparator function used to sort the elements."
     Comparison compare(Element x, Element y);
     
     "The initial elements of the set."
     {Element*} elements;
     
     object present {}
     
     variable value map = TreeMap(compare, elements.map((Element e)=>e->present));

     add(Element element) => map.put(element, present) exists;
     
     remove(Element element) => map.remove(element) exists;
     
     clear() => map.clear();
     
     shared actual Boolean addAll({Element*} elements) {
         variable value result = false;
         for (element in elements) {
             if (add(element)) {
                 result = true;
             }
         }
         return result;
     }
     
     shared actual TreeSet<Element> clone {
         value clone = TreeSet(compare);
         clone.map = map.clone;
         return clone;
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
     
     iterator()
             => map.map((Element->Object entry) => entry.key)
                  .iterator();
     
     equals(Object that) => (super of Set<Element>).equals(that);
     hash => (super of Set<Element>).hash;
     
}