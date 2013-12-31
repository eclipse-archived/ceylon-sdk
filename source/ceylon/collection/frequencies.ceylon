"Produces a [[Map]] containing the frequency in which each
 element occurs among the given elements."
shared Map<Element,Integer> frequences<Element>({Element*} elements)
        given Element satisfies Object {
    
    /*
     We've no idea how long the iterable is, nor how 
     selective the grouping function is, so it's really 
     hard to accurately estimate the size of the HashMap.
    */
    value map = HashMap<Element, Integer>() ;
    
    for (element in elements) {
        if (exists count = map[element]) {
            map.put(element,count+1);
        }
        else {
            map.put(element, 1);
        }
    }
    
    return map;
    
}
