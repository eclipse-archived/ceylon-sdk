doc "Creates a `Map` that contains the `Iterable`'s
     elements, grouped in `Sequence`s under the
     keys provided by the grouping function."
shared Map<Group, {Element+}> group<Group, Element>({Element*} elements,
    "A function that returns the key under which to group the 
     specified element."
    Group grouping(Element element)) given Group satisfies Object {
    
    /*
    We've no idea how long the iterable is, nor how selective the grouping 
    function is, so it's really had to accurately estimate the size of the
    HashMap.
    */
    value map = HashMap<Group, SequenceBuilder<Element>>() ;
    
    for (Element element in elements) {
        Group group = grouping(element);
        
        value sb = map.get(group);
        if (is SequenceBuilder<Element> sb) {
            sb.append(element);
        } else {
            map.put(group, SequenceBuilder<Element>().append(element));
        }
    }
    
    Sequence<Element> fn(Group key, SequenceBuilder<Element> item) {
        value sequence = item.sequence;
        assert(nonempty sequence);
        return sequence;
    }
    
    return map.mapItems(fn);
    
}