"A [[MutableSet]] implemented using a red/black tree. 
 Elements of the set are maintained in a sorted order, from
 smallest to largest, as determined by the given
 [[comparator function|compare]]."
see (`function naturalOrderTreeSet`)
by ("Gavin King")
shared class TreeSet<Element>(compare, elements={})
        satisfies MutableSet<Element>
                  & SortedSet<Element>
                  & Ranged<Element,TreeSet<Element>>
        given Element satisfies Object {
     
     "A comparator function used to sort the elements."
     Comparison compare(Element x, Element y);
     
     "The initial elements of the set."
     {Element*} elements;
     
     object present {}
     
     variable value map = TreeMap(compare, 
             elements map (Element e) => e->present);

     add(Element element) => !map.put(element, present) exists;
     
     remove(Element element) => map.remove(element) exists;
     
     clear() => map.clear();
     
     shared actual TreeSet<Element> clone() {
         value clone = TreeSet(compare);
         clone.map = map.clone();
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
     
     first => map.first?.key;
     last => map.last?.key;
     
     higherElements(Element element)
             => map.higherEntries(element)
                     map (Element->Object entry)
                             => entry.key;
     
     lowerElements(Element element)
             => map.lowerEntries(element)
                     map (Element->Object entry)
                             =>entry.key;
     
     segment(Element from, Integer length) 
             => TreeSet(compare, higherElements(from).taking(length));
     
     shared actual TreeSet<Element> span(Element from, Element to) {
         {Element*} elements;
         if (compare(from, to)==larger) {
             elements = lowerElements(from)
                     takingWhile (Element elem) 
                             => compare(elem, to)!=smaller;
         }
         else {
             elements = higherElements(from)
                     takingWhile (Element elem) 
                             => compare(elem, to)!=larger;
         }
         return TreeSet(compare, elements);
     }
     
     spanFrom(Element from) 
             => TreeSet(compare, higherElements(from));
     
     spanTo(Element to) 
             => TreeSet(compare, takingWhile((Element elem) 
                     => compare(elem, to)!=larger));
     
     equals(Object that) => (super of Set<Element>).equals(that);
     hash => (super of Set<Element>).hash;
     
}

"Create a [[TreeSet] with [[comparable|Comparable]]] keys,
 sorted by the natural ordering of the keys."
shared TreeSet<Element> naturalOrderTreeSet<Element>({<Element>*} entries)
        given Element satisfies Comparable<Element>
        => TreeSet((Element x, Element y) => x<=>y, entries);
