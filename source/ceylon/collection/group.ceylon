"Produces a [[Map]] grouping the given [[elements]] into 
 sequences under the group keys provided by the given 
 [[grouping function|grouping]]."
shared Map<Group,[Element+]> group<Group, Element>
        ({Element*} elements, grouping)
        given Group satisfies Object {
    
    "A function that returns the group key under which to 
     group the specified element."
    Group grouping(Element element);
    
    class Appender([Element] element) 
            => SequenceAppender<Element>(element);
    /*
     We've no idea how long the iterable is, nor how 
     selective the grouping function is, so it's really 
     hard to accurately estimate the size of the HashMap.
    */
    value map = HashMap<Group,Appender>();
    for (element in elements) {
        Group group = grouping(element);
        if (exists sb = map[group]) {
            sb.append(element);
        } else {
            map.put(group, Appender([element]));
        }
    }
    return map.mapItems((Group group, Appender sa) 
            => sa.sequence);
}
