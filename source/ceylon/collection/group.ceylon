import ceylon.collection { HashMap }

"Groups the given elements into sequences in a [[Map]], 
 under the keys provided by the given grouping function."
shared Map<Group, [Element+]> group<Group, Element>({Element*} elements,
    "A function that returns the key under 
     which to group the specified element."
    Group grouping(Element element))
        given Group satisfies Object {
    
    class Appender([Element] element) 
            => SequenceAppender<Element>(element);
    
    /*
     We've no idea how long the iterable is, nor how 
     selective the grouping function is, so it's really 
     hard to accurately estimate the size of the HashMap.
    */
    value map = HashMap<Group, Appender>() ;
    
    for (element in elements) {
        Group group = grouping(element);
        if (exists sb = map.get(group)) {
            sb.append(element);
        } else {
            map.put(group, Appender([element]));
        }
    }
    
    return map.mapItems((Group group, Appender sa) => sa.sequence);
    
}